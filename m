Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab0DWVA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 17:00:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:35328 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab0DWVA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 17:00:56 -0400
Date: Fri, 23 Apr 2010 13:58:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 5/9] PM: suspend_block: Add debugfs file
Message-Id: <20100423135853.478af057.randy.dunlap@oracle.com>
In-Reply-To: <1271984938-13920-6-git-send-email-arve@android.com>
References: <1271984938-13920-1-git-send-email-arve@android.com>
	<1271984938-13920-2-git-send-email-arve@android.com>
	<1271984938-13920-3-git-send-email-arve@android.com>
	<1271984938-13920-4-git-send-email-arve@android.com>
	<1271984938-13920-5-git-send-email-arve@android.com>
	<1271984938-13920-6-git-send-email-arve@android.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090205.4BD20A5C.0045:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Apr 2010 18:08:54 -0700 Arve Hjønnevåg wrote:

> Report active and inactive suspend blockers in
> /sys/kernel/debug/suspend_blockers.


This looks more like user interface information than it does debug information.
If that's correct, it shouldn't be in debugfs.


> Signed-off-by: Arve Hjønnevåg <arve@android.com>
> ---
>  kernel/power/suspend_blocker.c |   44 ++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 42 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/power/suspend_blocker.c b/kernel/power/suspend_blocker.c
> index 868e8f1..047e910 100644
> --- a/kernel/power/suspend_blocker.c
> +++ b/kernel/power/suspend_blocker.c
> @@ -17,6 +17,7 @@
>  #include <linux/rtc.h>
>  #include <linux/suspend.h>
>  #include <linux/suspend_blocker.h>
> +#include <linux/debugfs.h>
>  #include "power.h"
>  
>  enum {
> @@ -41,6 +42,7 @@ struct workqueue_struct *suspend_work_queue;
>  struct suspend_blocker main_suspend_blocker;
>  static suspend_state_t requested_suspend_state = PM_SUSPEND_MEM;
>  static bool enable_suspend_blockers;
> +static struct dentry *suspend_blocker_stats_dentry;
>  
>  #define pr_info_time(fmt, args...) \
>  	do { \
> @@ -54,6 +56,21 @@ static bool enable_suspend_blockers;
>  			tm.tm_hour, tm.tm_min, tm.tm_sec, ts.tv_nsec); \
>  	} while (0);
>  
> +static int suspend_blocker_stats_show(struct seq_file *m, void *unused)
> +{
> +	unsigned long irqflags;
> +	struct suspend_blocker *blocker;
> +
> +	seq_puts(m, "name\tactive\n");
> +	spin_lock_irqsave(&list_lock, irqflags);
> +	list_for_each_entry(blocker, &inactive_blockers, link)
> +		seq_printf(m, "\"%s\"\t0\n", blocker->name);
> +	list_for_each_entry(blocker, &active_blockers, link)
> +		seq_printf(m, "\"%s\"\t1\n", blocker->name);
> +	spin_unlock_irqrestore(&list_lock, irqflags);
> +	return 0;
> +}
> +
>  static void print_active_blockers_locked(void)
>  {
>  	struct suspend_blocker *blocker;
> @@ -101,8 +118,8 @@ static DECLARE_WORK(suspend_work, suspend_worker);
>  /**
>   * suspend_blocker_init() - Initialize a suspend blocker
>   * @blocker:	The suspend blocker to initialize.
> - * @name:	The name of the suspend blocker to show in debug messages.
> - *
> + * @name:	The name of the suspend blocker to show in debug messages and
> + *		/sys/kernel/debug/suspend_blockers.
>   * The suspend blocker struct and name must not be freed before calling
>   * suspend_blocker_destroy.
>   */
> @@ -240,6 +257,19 @@ int request_suspend_state(suspend_state_t state)
>  	return 0;
>  }
>  
> +static int suspend_blocker_stats_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, suspend_blocker_stats_show, NULL);
> +}
> +
> +static const struct file_operations suspend_blocker_stats_fops = {
> +	.owner = THIS_MODULE,
> +	.open = suspend_blocker_stats_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = single_release,
> +};
> +
>  static int __init suspend_block_init(void)
>  {
>  	suspend_work_queue = create_singlethread_workqueue("suspend");
> @@ -251,4 +281,14 @@ static int __init suspend_block_init(void)
>  	return 0;
>  }
>  
> +static int __init suspend_block_postcore_init(void)
> +{
> +	if (!suspend_work_queue)
> +		return 0;
> +	suspend_blocker_stats_dentry = debugfs_create_file("suspend_blockers",
> +			S_IRUGO, NULL, NULL, &suspend_blocker_stats_fops);
> +	return 0;
> +}
> +
>  core_initcall(suspend_block_init);
> +postcore_initcall(suspend_block_postcore_init);
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
