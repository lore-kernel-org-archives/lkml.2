Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab0JEQdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 12:33:53 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:30421
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751721Ab0JEQdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 12:33:52 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bhz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L9TSO1-01-IC8-02
X-M-MSG: 
Date: Tue, 5 Oct 2010 18:33:38 +0200
From: Robert Richter <robert.richter@amd.com>
To: Maynard Johnson <maynardj@us.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        William Cohen <wcohen@redhat.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH] oprofile: disable write access to oprofilefs while
 profiler is running
Message-ID: <20101005163338.GI13563@erda.amd.com>
References: <1286275017-32497-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1286275017-32497-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.10.10 06:36:57, Robert Richter wrote:
> Oprofile counters are setup when profiling is disabled. Thus, writing
> to oprofilefs has no immediate effect. Changes are updated only after
> oprofile is reenabled.
> 
> To keep userland and kernel states synchronized, we now allow
> configuration of oprofile only if profiling is disabled.  In this case
> it checks if the profiler is running and then disables write access to
> oprofilefs by returning -EBUSY. The change should be backward
> compatible with current oprofile userland daemon.
> 
> Cc: Maynard Johnson <maynardj@us.ibm.com>
> Cc: William Cohen <wcohen@redhat.com>
> Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  drivers/oprofile/oprof.c          |   19 +++++--------------
>  drivers/oprofile/oprof.h          |    2 +-
>  drivers/oprofile/oprofile_files.c |    7 +++++--
>  drivers/oprofile/oprofilefs.c     |    8 ++++++--
>  4 files changed, 17 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
> index b4a6857..a7ab09e 100644
> --- a/drivers/oprofile/oprof.c
> +++ b/drivers/oprofile/oprof.c
> @@ -225,26 +225,17 @@ post_sync:
>  	mutex_unlock(&start_mutex);
>  }
>  
> -int oprofile_set_backtrace(unsigned long val)
> +int oprofile_set_ulong(unsigned long *addr, unsigned long val)
>  {
> -	int err = 0;
> +	int err = -EBUSY;
>  
>  	mutex_lock(&start_mutex);
> -
>  	if (oprofile_started) {

I did a late change which I never should do. It should be:

	if (!oprofile_started) ...

The concept remains the same.

Updated patch below.

Sorry,

-Robert

> -		err = -EBUSY;
> -		goto out;
> -	}
> -
> -	if (!oprofile_ops.backtrace) {
> -		err = -EINVAL;
> -		goto out;
> +		*addr = val;
> +		err = 0;
>  	}
> -
> -	oprofile_backtrace_depth = val;
> -
> -out:
>  	mutex_unlock(&start_mutex);
> +
>  	return err;
>  }

--

>From 2d5710a2850eec24c54a1338ae5986963928cf8a Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Mon, 4 Oct 2010 21:09:36 +0200
Subject: [PATCH] oprofile: disable write access to oprofilefs while profiler is running

Oprofile counters are setup when profiling is disabled. Thus, writing
to oprofilefs has no immediate effect. Changes are updated only after
oprofile is reenabled.

To keep userland and kernel states synchronized, we now allow
configuration of oprofile only if profiling is disabled.  In this case
it checks if the profiler is running and then disables write access to
oprofilefs by returning -EBUSY. The change should be backward
compatible with current oprofile userland daemon.

Cc: Maynard Johnson <maynardj@us.ibm.com>
Cc: William Cohen <wcohen@redhat.com>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/oprof.c          |   21 ++++++---------------
 drivers/oprofile/oprof.h          |    2 +-
 drivers/oprofile/oprofile_files.c |    7 +++++--
 drivers/oprofile/oprofilefs.c     |    8 ++++++--
 4 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index b4a6857..f9bda64 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -225,26 +225,17 @@ post_sync:
 	mutex_unlock(&start_mutex);
 }
 
-int oprofile_set_backtrace(unsigned long val)
+int oprofile_set_ulong(unsigned long *addr, unsigned long val)
 {
-	int err = 0;
+	int err = -EBUSY;
 
 	mutex_lock(&start_mutex);
-
-	if (oprofile_started) {
-		err = -EBUSY;
-		goto out;
+	if (!oprofile_started) {
+		*addr = val;
+		err = 0;
 	}
-
-	if (!oprofile_ops.backtrace) {
-		err = -EINVAL;
-		goto out;
-	}
-
-	oprofile_backtrace_depth = val;
-
-out:
 	mutex_unlock(&start_mutex);
+
 	return err;
 }
 
diff --git a/drivers/oprofile/oprof.h b/drivers/oprofile/oprof.h
index 47e12cb..177b73d 100644
--- a/drivers/oprofile/oprof.h
+++ b/drivers/oprofile/oprof.h
@@ -37,7 +37,7 @@ void oprofile_create_files(struct super_block *sb, struct dentry *root);
 int oprofile_timer_init(struct oprofile_operations *ops);
 void oprofile_timer_exit(void);
 
-int oprofile_set_backtrace(unsigned long depth);
+int oprofile_set_ulong(unsigned long *addr, unsigned long val);
 int oprofile_set_timeout(unsigned long time);
 
 #endif /* OPROF_H */
diff --git a/drivers/oprofile/oprofile_files.c b/drivers/oprofile/oprofile_files.c
index bbd7516..ccf099e 100644
--- a/drivers/oprofile/oprofile_files.c
+++ b/drivers/oprofile/oprofile_files.c
@@ -79,14 +79,17 @@ static ssize_t depth_write(struct file *file, char const __user *buf, size_t cou
 	if (*offset)
 		return -EINVAL;
 
+	if (!oprofile_ops.backtrace)
+		return -EINVAL;
+
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
 	if (retval)
 		return retval;
 
-	retval = oprofile_set_backtrace(val);
-
+	retval = oprofile_set_ulong(&oprofile_backtrace_depth, val);
 	if (retval)
 		return retval;
+
 	return count;
 }
 
diff --git a/drivers/oprofile/oprofilefs.c b/drivers/oprofile/oprofilefs.c
index 789a1a8..1944621 100644
--- a/drivers/oprofile/oprofilefs.c
+++ b/drivers/oprofile/oprofilefs.c
@@ -91,16 +91,20 @@ static ssize_t ulong_read_file(struct file *file, char __user *buf, size_t count
 
 static ssize_t ulong_write_file(struct file *file, char const __user *buf, size_t count, loff_t *offset)
 {
-	unsigned long *value = file->private_data;
+	unsigned long value;
 	int retval;
 
 	if (*offset)
 		return -EINVAL;
 
-	retval = oprofilefs_ulong_from_user(value, buf, count);
+	retval = oprofilefs_ulong_from_user(&value, buf, count);
+	if (retval)
+		return retval;
 
+	retval = oprofile_set_ulong(file->private_data, value);
 	if (retval)
 		return retval;
+
 	return count;
 }
 
-- 
1.7.2.2



-- 
Advanced Micro Devices, Inc.
Operating System Research Center

