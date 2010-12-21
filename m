Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab0LUOWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 09:22:33 -0500
Received: from mail-iy0-f194.google.com ([209.85.210.194]:55183 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab0LUOWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 09:22:31 -0500
X-Greylist: delayed 922 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Dec 2010 09:22:31 EST
MIME-Version: 1.0
X-Originating-IP: [109.186.66.170]
In-Reply-To: <1292870624-25450-1-git-send-email-felipe.contreras@nokia.com>
References: <1292870624-25450-1-git-send-email-felipe.contreras@nokia.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 21 Dec 2010 16:06:48 +0200
Message-ID: <AANLkTikisHaAMZphRJVYdcokVbaZXVF9COrwkdGTDg__@mail.gmail.com>
Subject: Re: [PATCH v2] staging: tidspbridge: protect dmm_map properly
To: Felipe Contreras <felipe.contreras@nokia.com>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Nishanth Menon <nm@ti.com>, Ameya Palande <ameya.palande@nokia.com>,
        Hari Kanigeri <h-kanigeri2@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Mon, Dec 20, 2010 at 8:43 PM, Felipe Contreras
<felipe.contreras@nokia.com> wrote:
> We need to protect not only the dmm_map list, but the individual
> map_obj's, otherwise, we might be building the scatter-gather list with
> garbage.

Thanks for reporting this !

> So, use the existing proc_lock for that.

I don't like this.

You are taking this lock over the entire proc_begin_dma() and
proc_end_dma() functions, and by that artificially imposing sequential
behavior of their execution (system-wide).

I strongly prefer protecting the dmm map object itself, and not the
code that uses it, in order to avoid redundant bottlenecks.

Something like the patch below should fix the panics without globally
locking the dma functions (UNTESTED! I still want to have a gst-dsp
setup like yours so I can reproduce the issues you see. If needed,
I'll get to it).

Please note: the code below assumes that applications calls
proc_end_dma() for every proc_begin_dma().  This is anyway mandatory,
because otherwise we are risking data corruptions, but we know older
applications (e.g. probably TI samples) don't do that (since the
dspbridge's DMA API is relatively new). If we want/need to support
those older applications with this patch, it's a 2-liner change.

But there is another issue. I'm not quite sure how gst-dsp is using
the bridge DMA API, but those panics may suggest that there are
additional races here: if the application unmaps a memory region,
before the DMA operation completes (i.e. proc_end_dma() completed
execution), the application will face:

1. errors: when proc_end_dma() does get invoked, the map_obj will
already be destroyed, and find_containing_mapping() will simply fail

2. data corruptions: as a result of (1), dma_unmap_sg() will not be
called, and that may result in data corruptions and generally is very
bad

We can treat this as an application error, but we don't have to, and
it will actually be very clean if we won't.

Given the below patch, it should be quite easy to solve those
additional races too, e.g., by adding a boolean 'dying' flag to each
map_obj, which would (on un_map) mark an object as not available for a
new DMA operation (proc_start_dma), but it'd still wait until all of
its referenced are removed (proc_end_dma), and only then it will be
finally removed from the list.

Such a change will only work with applications that calls
proc_end_dma() for each proc_start_dma(). How is gst-dsp in that
respect ? do we want to keep supporting older applications which don't
do that ? if we want, we can still support both old and new API with
some ioctl games (introduce new ioctl commands which will work the new
way, and keep the old ones around, maybe only mark them as
deprecated).

Thanks,
Ohad.

---
 .../staging/tidspbridge/include/dspbridge/drv.h    |    2 +
 drivers/staging/tidspbridge/rmgr/proc.c            |   39 ++++++++++++++++++--
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/drv.h
b/drivers/staging/tidspbridge/include/dspbridge/drv.h
index c1f363e..cad0626 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/drv.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/drv.h
@@ -25,6 +25,7 @@

 #include <dspbridge/drvdefs.h>
 #include <linux/idr.h>
+#include <linux/atomic.h>

 #define DRV_ASSIGN     1
 #define DRV_RELEASE    0
@@ -106,6 +107,7 @@ struct dmm_map_object {
 	u32 num_usr_pgs;
 	struct page **pages;
 	struct bridge_dma_map_info dma_info;
+	atomic_t refcnt;
 };

 /* Used for DMM reserved memory accounting */
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c
b/drivers/staging/tidspbridge/rmgr/proc.c
index b47d7aa..4aabfcc 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -112,6 +112,26 @@ static s32 get_envp_count(char **envp);
 static char **prepend_envp(char **new_envp, char **envp, s32 envp_elems,
 			   s32 cnew_envp, char *sz_var);

+/*
+ * Grab the dmm_map_object's reference count. This operation is valid only
+ * when map_obj is ALREADY grabbed, e.g., it is still in the dmm_map list
+ * and list's lock is taken
+ */
+static inline void map_obj_get(struct dmm_map_object *map_obj)
+{
+	atomic_inc(&map_obj->refcnt);
+}
+
+/* Ungrab map_obj and destroy it, if it was the last reference */
+static inline void map_obj_put(struct dmm_map_object *map_obj)
+{
+	if (atomic_dec_and_test(&map_obj->refcnt)) {
+		kfree(map_obj->dma_info.sg);
+		kfree(map_obj->pages);
+		kfree(map_obj);
+	}
+}
+
 /* remember mapping information */
 static struct dmm_map_object *add_mapping_info(struct process_context *pr_ctxt,
 				u32 mpu_addr, u32 dsp_addr, u32 size)
@@ -143,6 +163,8 @@ static struct dmm_map_object
*add_mapping_info(struct process_context *pr_ctxt,
 	map_obj->dsp_addr = dsp_addr;
 	map_obj->size = size;
 	map_obj->num_usr_pgs = num_usr_pgs;
+	/* dmm map objects are initially grabbed */
+	atomic_set(&map_obj->refcnt, 1);

 	spin_lock(&pr_ctxt->dmm_map_lock);
 	list_add(&map_obj->link, &pr_ctxt->dmm_map_list);
@@ -181,9 +203,7 @@ static void remove_mapping_information(struct
process_context *pr_ctxt,
 		if (match_exact_map_obj(map_obj, dsp_addr, size)) {
 			pr_debug("%s: match, deleting map info\n", __func__);
 			list_del(&map_obj->link);
-			kfree(map_obj->dma_info.sg);
-			kfree(map_obj->pages);
-			kfree(map_obj);
+			map_obj_put(map_obj);
 			goto out;
 		}
 		pr_debug("%s: candidate didn't match\n", __func__);
@@ -203,6 +223,11 @@ static int match_containing_map_obj(struct
dmm_map_object *map_obj,
 		mpu_addr + size <= map_obj_end;
 }

+/*
+ * Find a dmm map object that contains the given memory block,
+ * and increase its reference count to prevent its destruction
+ * until released
+ */
 static struct dmm_map_object *find_containing_mapping(
 				struct process_context *pr_ctxt,
 				u32 mpu_addr, u32 size)
@@ -220,6 +245,7 @@ static struct dmm_map_object *find_containing_mapping(
 						map_obj->size);
 		if (match_containing_map_obj(map_obj, mpu_addr, size)) {
 			pr_debug("%s: match!\n", __func__);
+			map_obj_get(map_obj);
 			goto out;
 		}

@@ -793,6 +819,8 @@ int proc_begin_dma(void *hprocessor, void
*pmpu_addr, u32 ul_size,
 		pr_err("%s: InValid address parameters %p %x\n",
 			       __func__, pmpu_addr, ul_size);
 		status = -EFAULT;
+		/* release the reference count we took in the find above */
+		map_obj_put(map_obj);
 	}

 err_out:
@@ -834,6 +862,11 @@ int proc_end_dma(void *hprocessor, void
*pmpu_addr, u32 ul_size,
 		goto err_out;
 	}

+	/* release first the reference count we took in the find above */
+	map_obj_put(map_obj);
+	/* now release the reference count that was taken in proc_begin_dma */
+	map_obj_put(map_obj);
+
 err_out:
 	return status;
 }
-- 
1.7.1
