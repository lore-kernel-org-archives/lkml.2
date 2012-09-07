Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553Ab2IGDcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 23:32:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46932 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758843Ab2IGDch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 23:32:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120906154459.8b3b73fa.akpm@linux-foundation.org>
References: <1344052890-31935-1-git-send-email-ming.lei@canonical.com>
	<1344052890-31935-13-git-send-email-ming.lei@canonical.com>
	<20120906154459.8b3b73fa.akpm@linux-foundation.org>
Date: Fri, 7 Sep 2012 11:32:36 +0800
Message-ID: <CACVXFVMD1MCGrmHLFU5whCf1R3feoyj+FTAMm71HNME_gF2jDg@mail.gmail.com>
Subject: Re: [RFC PATCH v1 12/15] firmware: introduce device_cache/uncache_fw_images
From: Ming Lei <ming.lei@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 6:44 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sat,  4 Aug 2012 12:01:27 +0800
> Ming Lei <ming.lei@canonical.com> wrote:
>
>> This patch introduces the three helpers below:
>>
>>       void device_cache_fw_images(void)
>>       void device_uncache_fw_images(void)
>>       void device_uncache_fw_images_delay(unsigned long)
>
> CONFIG_PM=n:
>
> drivers/base/firmware_class.c:1147: warning: 'device_cache_fw_images' defined but not used
> drivers/base/firmware_class.c:1212: warning: 'device_uncache_fw_images_delay' defined but not used

Thanks for your report.

>
> the fix is not trivial - this patch added quite a lot of code and data
> structure bloat which will never be used on CONFIG_PM=n kernels.

The below patch should fix the warning.

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 95f6851..6e21080 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -96,7 +96,9 @@ struct firmware_cache {
 	/* firmware_buf instance will be added into the below list */
 	spinlock_t lock;
 	struct list_head head;
+	int state;

+#ifdef CONFIG_PM_SLEEP
 	/*
 	 * Names of firmware images which have been cached successfully
 	 * will be added into the below list so that device uncache
@@ -106,13 +108,12 @@ struct firmware_cache {
 	spinlock_t name_lock;
 	struct list_head fw_names;

-	int state;
-
 	wait_queue_head_t wait_queue;
 	int cnt;
 	struct delayed_work work;

 	struct notifier_block   pm_notify;
+#endif
 };

 struct firmware_buf {
@@ -622,6 +623,7 @@ static void fw_set_page_data(struct firmware_buf
*buf, struct firmware *fw)
 		 (unsigned int)buf->size);
 }

+#ifdef CONFIG_PM_SLEEP
 static void fw_name_devm_release(struct device *dev, void *res)
 {
 	struct fw_name_devm *fwn = res;
@@ -670,6 +672,12 @@ static int fw_add_devm_name(struct device *dev,
const char *name)

 	return 0;
 }
+#else
+static int fw_add_devm_name(struct device *dev, const char *name)
+{
+	return 0;
+}
+#endif

 static void _request_firmware_cleanup(const struct firmware **firmware_p)
 {
@@ -1046,6 +1054,7 @@ int uncache_firmware(const char *fw_name)
 	return -EINVAL;
 }

+#ifdef CONFIG_PM_SLEEP
 static struct fw_cache_entry *alloc_fw_cache_entry(const char *name)
 {
 	struct fw_cache_entry *fce;
@@ -1258,7 +1267,6 @@ static void
device_uncache_fw_images_delay(unsigned long delay)
 			msecs_to_jiffies(delay));
 }

-#ifdef CONFIG_PM
 static int fw_pm_notify(struct notifier_block *notify_block,
 			unsigned long mode, void *unused)
 {
@@ -1285,13 +1293,6 @@ static int fw_pm_notify(struct notifier_block
*notify_block,

 	return 0;
 }
-#else
-static int fw_pm_notify(struct notifier_block *notify_block,
-			unsigned long mode, void *unused)
-{
-	return 0;
-}
-#endif

 /* stop caching firmware once syscore_suspend is reached */
 static int fw_suspend(void)
@@ -1303,16 +1304,23 @@ static int fw_suspend(void)
 static struct syscore_ops fw_syscore_ops = {
 	.suspend = fw_suspend,
 };
+#else
+static int fw_cache_piggyback_on_request(const char *name)
+{
+	return 0;
+}
+#endif

 static void __init fw_cache_init(void)
 {
 	spin_lock_init(&fw_cache.lock);
 	INIT_LIST_HEAD(&fw_cache.head);
+	fw_cache.state = FW_LOADER_NO_CACHE;

+#ifdef CONFIG_PM_SLEEP
 	spin_lock_init(&fw_cache.name_lock);
 	INIT_LIST_HEAD(&fw_cache.fw_names);
 	fw_cache.cnt = 0;
-	fw_cache.state = FW_LOADER_NO_CACHE;

 	init_waitqueue_head(&fw_cache.wait_queue);
 	INIT_DELAYED_WORK(&fw_cache.work,
@@ -1322,6 +1330,7 @@ static void __init fw_cache_init(void)
 	register_pm_notifier(&fw_cache.pm_notify);

 	register_syscore_ops(&fw_syscore_ops);
+#endif
 }

 static int __init firmware_class_init(void)
@@ -1332,8 +1341,10 @@ static int __init firmware_class_init(void)

 static void __exit firmware_class_exit(void)
 {
+#ifdef CONFIG_PM_SLEEP
 	unregister_syscore_ops(&fw_syscore_ops);
 	unregister_pm_notifier(&fw_cache.pm_notify);
+#endif
 	class_unregister(&firmware_class);
 }


Thanks,
--
Ming Lei
