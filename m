Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab0CVSn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:43:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835Ab0CVSnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:43:55 -0400
Date: Mon, 22 Mar 2010 14:43:17 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dave Wysochanski <dwysocha@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>, Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [patch 114/123] dm ioctl: only issue uevent on resume if state
 changed
Message-ID: <20100322184314.GA7534@redhat.com>
References: <20100313001618.GA9811@kroah.com>
 <20100313001515.103664129@kvm.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100313001515.103664129@kvm.kroah.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12 2010 at  7:13pm -0500,
Greg KH <gregkh@suse.de> wrote:

> 2.6.33-stable review patch.  If anyone has any objections, please let me know.
> 
> -----------------
> 
> From: Mike Snitzer <snitzer@redhat.com>
> 
> commit 0f3649a9e305ea22eb196a84a2d7520afcaa6060 upstream.
> 
> Only issue a uevent on a resume if the state of the device changed,
> i.e. if it was suspended and/or its table was replaced.
> 
> Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Alasdair G Kergon <agk@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/md/dm-ioctl.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -897,16 +897,17 @@ static int do_resume(struct dm_ioctl *pa
>  			set_disk_ro(dm_disk(md), 1);
>  	}
>  
> -	if (dm_suspended_md(md))
> +	if (dm_suspended_md(md)) {
>  		r = dm_resume(md);
> +		if (!r)
> +			dm_kobject_uevent(md, KOBJ_CHANGE, param->event_nr);
> +	}
>  
>  	if (old_map)
>  		dm_table_destroy(old_map);
>  
> -	if (!r) {
> -		dm_kobject_uevent(md, KOBJ_CHANGE, param->event_nr);
> +	if (!r)
>  		r = __dev_status(md, param);
> -	}
>  
>  	dm_put(md);
>  	return r;
> 
> 


Hi Greg,

The following upstream dm-ioctl patch also needs to go to stable now
that the above patch was included in 2.6.33.y.

Regards,
Mike

---
commit 3abf85b5b5851b5f28d3d8a920ebb844edd08352
Author: Peter Rajnoha <prajnoha@redhat.com>
Date:   Sat Mar 6 02:32:31 2010 +0000

    dm ioctl: introduce flag indicating uevent was generated
    
    Set a new DM_UEVENT_GENERATED_FLAG when returning from ioctls to
    indicate that a uevent was actually generated.  This tells the userspace
    caller that it may need to wait for the event to be processed.
    
    Signed-off-by: Peter Rajnoha <prajnoha@redhat.com>
    Signed-off-by: Alasdair G Kergon <agk@redhat.com>

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index e3cf568..d7500e1 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -285,7 +285,8 @@ retry:
 	up_write(&_hash_lock);
 }
 
-static int dm_hash_rename(uint32_t cookie, const char *old, const char *new)
+static int dm_hash_rename(uint32_t cookie, uint32_t *flags, const char *old,
+			  const char *new)
 {
 	char *new_name, *old_name;
 	struct hash_cell *hc;
@@ -344,7 +345,8 @@ static int dm_hash_rename(uint32_t cookie, const char *old, const char *new)
 		dm_table_put(table);
 	}
 
-	dm_kobject_uevent(hc->md, KOBJ_CHANGE, cookie);
+	if (!dm_kobject_uevent(hc->md, KOBJ_CHANGE, cookie))
+		*flags |= DM_UEVENT_GENERATED_FLAG;
 
 	dm_put(hc->md);
 	up_write(&_hash_lock);
@@ -736,10 +738,10 @@ static int dev_remove(struct dm_ioctl *param, size_t param_size)
 	__hash_remove(hc);
 	up_write(&_hash_lock);
 
-	dm_kobject_uevent(md, KOBJ_REMOVE, param->event_nr);
+	if (!dm_kobject_uevent(md, KOBJ_REMOVE, param->event_nr))
+		param->flags |= DM_UEVENT_GENERATED_FLAG;
 
 	dm_put(md);
-	param->data_size = 0;
 	return 0;
 }
 
@@ -773,7 +775,9 @@ static int dev_rename(struct dm_ioctl *param, size_t param_size)
 		return r;
 
 	param->data_size = 0;
-	return dm_hash_rename(param->event_nr, param->name, new_name);
+
+	return dm_hash_rename(param->event_nr, &param->flags, param->name,
+			      new_name);
 }
 
 static int dev_set_geometry(struct dm_ioctl *param, size_t param_size)
@@ -899,8 +903,8 @@ static int do_resume(struct dm_ioctl *param)
 
 	if (dm_suspended_md(md)) {
 		r = dm_resume(md);
-		if (!r)
-			dm_kobject_uevent(md, KOBJ_CHANGE, param->event_nr);
+		if (!r && !dm_kobject_uevent(md, KOBJ_CHANGE, param->event_nr))
+			param->flags |= DM_UEVENT_GENERATED_FLAG;
 	}
 
 	if (old_map)
@@ -1477,6 +1481,7 @@ static int validate_params(uint cmd, struct dm_ioctl *param)
 {
 	/* Always clear this flag */
 	param->flags &= ~DM_BUFFER_FULL_FLAG;
+	param->flags &= ~DM_UEVENT_GENERATED_FLAG;
 
 	/* Ignores parameters */
 	if (cmd == DM_REMOVE_ALL_CMD ||
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7199846..d21e128 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2618,18 +2618,19 @@ out:
 /*-----------------------------------------------------------------
  * Event notification.
  *---------------------------------------------------------------*/
-void dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
+int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
 		       unsigned cookie)
 {
 	char udev_cookie[DM_COOKIE_LENGTH];
 	char *envp[] = { udev_cookie, NULL };
 
 	if (!cookie)
-		kobject_uevent(&disk_to_dev(md->disk)->kobj, action);
+		return kobject_uevent(&disk_to_dev(md->disk)->kobj, action);
 	else {
 		snprintf(udev_cookie, DM_COOKIE_LENGTH, "%s=%u",
 			 DM_COOKIE_ENV_VAR_NAME, cookie);
-		kobject_uevent_env(&disk_to_dev(md->disk)->kobj, action, envp);
+		return kobject_uevent_env(&disk_to_dev(md->disk)->kobj,
+					  action, envp);
 	}
 }
 
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 8dadaa5..bad1724 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -125,8 +125,8 @@ void dm_stripe_exit(void);
 int dm_open_count(struct mapped_device *md);
 int dm_lock_for_deletion(struct mapped_device *md);
 
-void dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
-		       unsigned cookie);
+int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
+		      unsigned cookie);
 
 int dm_io_init(void);
 void dm_io_exit(void);
diff --git a/include/linux/dm-ioctl.h b/include/linux/dm-ioctl.h
index aa95508..2c445e1 100644
--- a/include/linux/dm-ioctl.h
+++ b/include/linux/dm-ioctl.h
@@ -266,9 +266,9 @@ enum {
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	16
+#define DM_VERSION_MINOR	17
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2009-11-05)"
+#define DM_VERSION_EXTRA	"-ioctl (2010-03-05)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
@@ -316,4 +316,9 @@ enum {
  */
 #define DM_QUERY_INACTIVE_TABLE_FLAG	(1 << 12) /* In */
 
+/*
+ * If set, a uevent was generated for which the caller may need to wait.
+ */
+#define DM_UEVENT_GENERATED_FLAG	(1 << 13) /* Out */
+
 #endif				/* _LINUX_DM_IOCTL_H */
