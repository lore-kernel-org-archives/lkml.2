Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab0L0KaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 05:30:07 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46505 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab0L0KaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 05:30:06 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.188.89]
In-Reply-To: <AANLkTi=9AL3aWUsMeih+Gb-sMov=MgBZ1eTp8wb=q1hZ@mail.gmail.com>
References: <1292870624-25450-1-git-send-email-felipe.contreras@nokia.com>
 <AANLkTikisHaAMZphRJVYdcokVbaZXVF9COrwkdGTDg__@mail.gmail.com> <AANLkTi=9AL3aWUsMeih+Gb-sMov=MgBZ1eTp8wb=q1hZ@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 27 Dec 2010 12:29:44 +0200
Message-ID: <AANLkTinX8t=3b48e2sxPU-V_G-nGm_1DyEg6B-CeqXDa@mail.gmail.com>
Subject: Re: [PATCH v2] staging: tidspbridge: protect dmm_map properly
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-main <linux-kernel@vger.kernel.org>,
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

On Tue, Dec 21, 2010 at 6:44 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> Wouldn't you want the proc_*_dma() operations to finish before
> unmaping the pages?

Yes, but that's not what your patch is doing exactly: it serializes
the execution of proc_begin_dma(), proc_end_dma(), proc_map() and
proc_un_map() using a single global mutex and by that prevents their
concurrent execution (system-wide).

I understand your intention: you don't want proc_un_map() to kick in
in the middle of a proc_*_dma() operation. That's fine, but the patch
has a side effect, which serializes the DMA operations themselves, and
prevents their concurrent execution (even if they are for separate
memory addresses, or invoked by different processes, etc...).

Looking ahead, this DMM code is going to be extracted into an
independent module, where it will be shared between dspbridge and
syslink (the IPC framework for OMAP4 and forth): both projects use
this DMM concept, and it won't make sense for syslink to duplicate the
code. So even if today's dspbridge use cases doesn't have a lot of
concurrency, and performance is satisfying even in light of your
patch, we still want the code to be ready for more demanding use cases
(several remote processors, several multimedia processes running on
the host, several concurrent multimedia streams, etc...). If we use
coarse-grained locking now, it will just make it harder to remove it
later when scalability issues will show up (see the BKL removal
efforts...).

So I prefer we don't add any locking to the proc_*_dma() API at all.
Instead, let's just take a reference count every time a map_obj is
found (and therefore is about to be used), and release it after it is
used. And now, inside proc_un_map(), if we notice that our map_obj is
still being used, it means the application called us prematurely and
we can't proceed. Something like (revised the patch from my previous
email):

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
index b47d7aa..d060692 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -112,9 +112,37 @@ static s32 get_envp_count(char **envp);
 static char **prepend_envp(char **new_envp, char **envp, s32 envp_elems,
 			   s32 cnew_envp, char *sz_var);

+/* Increase map_obj's reference count */
+static inline void map_obj_get(struct dmm_map_object *map_obj)
+{
+	atomic_inc(&map_obj->refcnt);
+}
+
+/* Decrease map_obj's reference count */
+static inline void map_obj_put(struct dmm_map_object *map_obj)
+{
+	atomic_dec(&map_obj->refcnt);
+}
+
+/**
+ * is_map_obj_used() - check out whether a given map_obj is still being used
+ * @map_obj:	a dmm map object
+ *
+ * Returns 'true' if a given map_obj is being used, or 'false' otherwise.
+ *
+ * This function must be used while the dmm map list spinlock is taken,
+ * otherwise it is not safe to use its answer (if the list is not locked,
+ * someone can find and start using a map_obj immediately after this functions
+ * replys 'false'.
+ */
+static inline bool is_map_obj_used(struct dmm_map_object *map_obj)
+{
+	return atomic_read(&map_obj->refcnt) ? true : false;
+}
+
 /* remember mapping information */
-static struct dmm_map_object *add_mapping_info(struct process_context *pr_ctxt,
-				u32 mpu_addr, u32 dsp_addr, u32 size)
+static struct dmm_map_object *create_mapping_info(u32 mpu_addr, u32 dsp_addr,
+								u32 size)
 {
 	struct dmm_map_object *map_obj;

@@ -144,11 +172,15 @@ static struct dmm_map_object
*add_mapping_info(struct process_context *pr_ctxt,
 	map_obj->size = size;
 	map_obj->num_usr_pgs = num_usr_pgs;

+	return map_obj;
+}
+
+static void add_mapping_info(struct process_context *pr_ctxt,
+					struct dmm_map_object *map_obj)
+{
 	spin_lock(&pr_ctxt->dmm_map_lock);
 	list_add(&map_obj->link, &pr_ctxt->dmm_map_list);
 	spin_unlock(&pr_ctxt->dmm_map_lock);
-
-	return map_obj;
 }

 static int match_exact_map_obj(struct dmm_map_object *map_obj,
@@ -162,10 +194,18 @@ static int match_exact_map_obj(struct
dmm_map_object *map_obj,
 		map_obj->size == size;
 }

-static void remove_mapping_information(struct process_context *pr_ctxt,
+static void free_mapping_info(struct dmm_map_object *map_obj)
+{
+	kfree(map_obj->dma_info.sg);
+	kfree(map_obj->pages);
+	kfree(map_obj);
+}
+
+static int remove_mapping_information(struct process_context *pr_ctxt,
 						u32 dsp_addr, u32 size)
 {
 	struct dmm_map_object *map_obj;
+	int ret = 0;

 	pr_debug("%s: looking for virt 0x%x size 0x%x\n", __func__,
 							dsp_addr, size);
@@ -180,10 +220,12 @@ static void remove_mapping_information(struct
process_context *pr_ctxt,

 		if (match_exact_map_obj(map_obj, dsp_addr, size)) {
 			pr_debug("%s: match, deleting map info\n", __func__);
+			if (is_map_obj_used(map_obj)) {
+				ret = -EBUSY;
+				goto out;
+			}
 			list_del(&map_obj->link);
-			kfree(map_obj->dma_info.sg);
-			kfree(map_obj->pages);
-			kfree(map_obj);
+			free_mapping_info(map_obj);
 			goto out;
 		}
 		pr_debug("%s: candidate didn't match\n", __func__);
@@ -192,6 +234,7 @@ static void remove_mapping_information(struct
process_context *pr_ctxt,
 	pr_err("%s: failed to find given map info\n", __func__);
 out:
 	spin_unlock(&pr_ctxt->dmm_map_lock);
+	return ret;
 }

 static int match_containing_map_obj(struct dmm_map_object *map_obj,
@@ -203,6 +246,11 @@ static int match_containing_map_obj(struct
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
@@ -220,6 +268,7 @@ static struct dmm_map_object *find_containing_mapping(
 						map_obj->size);
 		if (match_containing_map_obj(map_obj, mpu_addr, size)) {
 			pr_debug("%s: match!\n", __func__);
+			map_obj_get(map_obj);
 			goto out;
 		}

@@ -795,6 +844,9 @@ int proc_begin_dma(void *hprocessor, void
*pmpu_addr, u32 ul_size,
 		status = -EFAULT;
 	}

+	/* release the reference count we took in the find above */
+	map_obj_put(map_obj);
+
 err_out:

 	return status;
@@ -831,9 +883,11 @@ int proc_end_dma(void *hprocessor, void
*pmpu_addr, u32 ul_size,
 		pr_err("%s: InValid address parameters %p %x\n",
 		       __func__, pmpu_addr, ul_size);
 		status = -EFAULT;
-		goto err_out;
 	}

+	/* release the reference count we took in the find above */
+	map_obj_put(map_obj);
+
 err_out:
 	return status;
 }
@@ -1356,7 +1410,7 @@ int proc_map(void *hprocessor, void *pmpu_addr,
u32 ul_size,
 	u32 size_align;
 	int status = 0;
 	struct proc_object *p_proc_object = (struct proc_object *)hprocessor;
-	struct dmm_map_object *map_obj;
+	struct dmm_map_object *map_obj = NULL;
 	u32 tmp_addr = 0;

 #ifdef CONFIG_TIDSPBRIDGE_CACHE_LINE_CHECK
@@ -1394,8 +1448,7 @@ int proc_map(void *hprocessor, void *pmpu_addr,
u32 ul_size,
 		/* Mapped address = MSB of VA | LSB of PA */
 		tmp_addr = (va_align | ((u32) pmpu_addr & (PG_SIZE4K - 1)));
 		/* mapped memory resource tracking */
-		map_obj = add_mapping_info(pr_ctxt, pa_align, tmp_addr,
-						size_align);
+		map_obj = create_mapping_info(pa_align, tmp_addr, size_align);
 		if (!map_obj)
 			status = -ENOMEM;
 		else
@@ -1406,10 +1459,15 @@ int proc_map(void *hprocessor, void
*pmpu_addr, u32 ul_size,
 	if (!status) {
 		/* Mapped address = MSB of VA | LSB of PA */
 		*pp_map_addr = (void *) tmp_addr;
+		/* Actually add the new map_obj and make it usable */
+		add_mapping_info(pr_ctxt, map_obj);
 	} else {
-		remove_mapping_information(pr_ctxt, tmp_addr, size_align);
+		/* if a map_obj was created, let it go */
+		if (map_obj)
+			free_mapping_info(map_obj);
 		dmm_un_map_memory(dmm_mgr, va_align, &size_align);
 	}
+
 	mutex_unlock(&proc_lock);

 	if (status)
@@ -1715,6 +1773,24 @@ int proc_un_map(void *hprocessor, void *map_addr,

 	/* Critical section */
 	mutex_lock(&proc_lock);
+
+	/*
+	 * Remove the map_obj first, so it won't be used after the region is
+	 * unmapped.
+	 *
+	 * Note: if the map_obj is still in use, the application messed up and
+	 * called proc_un_map() before its proc_*_dma() operations completed.
+	 * In this case we just return and error and let the application
+	 * deal with it (e.g. by calling us again).
+	 */
+	status = remove_mapping_information(pr_ctxt, (u32) map_addr,
+								size_align);
+	if (status == -EBUSY) {
+		dev_err(bridge, "%s: map_obj is still in use (addr: 0x%p)\n",
+							__func__, map_addr);
+		goto unlock_proc;
+	}
+
 	/*
 	 * Update DMM structures. Get the size to unmap.
 	 * This function returns error if the VA is not mapped
@@ -1726,17 +1802,11 @@ int proc_un_map(void *hprocessor, void *map_addr,
 		    (p_proc_object->hbridge_context, va_align, size_align);
 	}

+unlock_proc:
 	mutex_unlock(&proc_lock);
 	if (status)
 		goto func_end;

-	/*
-	 * A successful unmap should be followed by removal of map_obj
-	 * from dmm_map_list, so that mapped memory resource tracking
-	 * remains uptodate
-	 */
-	remove_mapping_information(pr_ctxt, (u32) map_addr, size_align);
-
 func_end:
 	dev_dbg(bridge, "%s: hprocessor: 0x%p map_addr: 0x%p status: 0x%x\n",
 		__func__, hprocessor, map_addr, status);


Additionally, the patch has two other changes:
- proc_map: don't register a new map_obj to the dmm_map_list before
the mapping is successful. This prevents a similar race, where
proc_*_dma() can find a memory region before it is really mapped.
- proc_un_map: before unmapping a memory region, first remove it from
the dmm_map_list. The motivation is the same: we want to make sure the
map_obj can't be found by proc_*_dma() after we unmap its region.

Currently, in this patch, if proc_un_map() realizes the map_obj is
still in use, it just returns an error. IMHO this is the right thing
to do, because if it happened it is clear that the application is
misusing the bridge API, by calling proc_un_map() without waiting for
the DMA operation to complete.

This way applications will have to fix themselves, because otherwise
they face another race which isn't fixable by the kernel: if
proc_un_map() is fast enough, it can manage to actually unmap the
memory region before proc_begin_dma() manage to do any progress at
all, and in this case, proc_begin_dma()'s cache operation will not
take place at all and then the user's data will surely be corrupted.
Obviously, that can only be fixed in the application itself, so we
better catch those races and fix them in the application.

Having said that, it's still possible to preserve the current bridge
behavior, and instead of letting proc_un_map() return a failure when
the obj_map is still in use, we can make it sleep until the map_obj's
ref count is dropped to zero (using wait and complete).. Not sure we
want that, though... I prefer application to know if something as bad
as that has happened...

> I have actually documented how I create it:
> http://felipec.wordpress.com/2010/10/08/my-arm-development-notes/
>
> I even provided a tarball with all the GStreamer stuff you can extract
> to /opt/gst and use on any system (with a reasonable glibc):
> http://people.freedesktop.org/~felipec/arm-gst-dev.tar.gz

Thanks! Also thanks for the other bits of information you gave
throughout your reply.

>
> The actual test I'm using to trigger this issue is way more
> complicated, but I could try to simplify it.

Hopefully it's not necessary. I managed to reproduced the panic by
adding manual delays to the code, but anyway it looks like we
understand the bug good enough, so it might not be needed to duplicate
the exact test you had.

> That sounds very dangerous.

I agree. Let's drop that other proposal.

Thanks,
Ohad.
