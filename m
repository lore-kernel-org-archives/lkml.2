Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab2KTG05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 01:26:57 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:60720 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab2KTG04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 01:26:56 -0500
Message-ID: <50AB22A4.2000400@linux.vnet.ibm.com>
Date: Tue, 20 Nov 2012 14:26:44 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Denys Fedoryshchenko <denys@visp.net.lb>
CC: tomas.winkler@intel.com, linux-kernel@vger.kernel.org
Subject: Re: Intel management, circular locking warning
References: <217a860b36a4d202a71a281003af2788@visp.net.lb>
In-Reply-To: <217a860b36a4d202a71a281003af2788@visp.net.lb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12112006-2000-0000-0000-000009F2AFF0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 07:03 PM, Denys Fedoryshchenko wrote:
> Hi
> 
> Just tried to run latest 3.6.6 32bit kernel on my server farm and got
> circular locking warning:
> Please let me know if you need more information.

Hi, Denys

You can take a try on below patch, it should do some help,
please let me know the result.

Regards,
Michael Wang



diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 98f1430..d9a74e6 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -120,6 +120,8 @@ static void mei_reset_iamthif_params(struct mei_device *dev)
        dev->iamthif_timer = 0;
 }
 
+static struct lock_class_key mei_device_key;
+
 /**
  * init_mei_device - allocates and initializes the mei device structure
  *
@@ -140,6 +142,7 @@ struct mei_device *mei_device_init(struct pci_dev *pdev)
        INIT_LIST_HEAD(&dev->wd_cl.link);
        INIT_LIST_HEAD(&dev->iamthif_cl.link);
        mutex_init(&dev->device_lock);
+       lockdep_set_class(&dev->device_lock, &mei_device_key);
        init_waitqueue_head(&dev->wait_recvd_msg);
        init_waitqueue_head(&dev->wait_stop_wd);
        dev->dev_state = MEI_DEV_INITIALIZING;

> 
> [    4.359176]
> [    4.359316] ======================================================
> [    4.359461] [ INFO: possible circular locking dependency detected ]
> [    4.359612] 3.6.6-build-0063 #21 Not tainted
> [    4.359763] -------------------------------------------------------
> [    4.359916] watchdog/1375 is trying to acquire lock:
> [    4.360060]  (&dev->device_lock){+.+.+.}, at: [<f8790075>]
> mei_wd_ops_start+0x2d/0x75 [mei]
> [    4.360530]
> [    4.360530] but task is already holding lock:
> [    4.360770]  (&wdd->lock){+.+...}, at: [<c02c9661>]
> watchdog_start+0x19/0x53
> [    4.361113]
> [    4.361113] which lock already depends on the new lock.
> [    4.361113]
> [    4.361454]
> [    4.361454] the existing dependency chain (in reverse order) is:
> [    4.361701]
> [    4.361701] -> #2 (&wdd->lock){+.+...}:
> [    4.361841]        [<c01608b4>] lock_acquire+0x71/0x85
> [    4.361845]        [<c0360eb8>] __mutex_lock_common+0x44/0x2e2
> [    4.361848]        [<c03611d8>] mutex_lock_nested+0x20/0x22
> [    4.361850]        [<c02c9661>] watchdog_start+0x19/0x53
> [    4.361851]        [<c02c9808>] watchdog_open+0x5c/0xa1
> [    4.361853]        [<c0294000>] misc_open+0xf5/0x14f
> [    4.361855]        [<c01ad941>] chrdev_open+0x106/0x124
> [    4.361857]        [<c01a93fd>] do_dentry_open.clone.16+0x12a/0x1c6
> [    4.361859]        [<c01a94b1>] finish_open+0x18/0x22
> [    4.361860]        [<c01b4d34>] do_last.clone.35+0x6fb/0x865
> [    4.361862]        [<c01b4f37>] path_openat+0x99/0x2c3
> [    4.361864]        [<c01b5380>] do_filp_open+0x26/0x67
> [    4.361865]        [<c01a9efb>] do_sys_open+0x5b/0xe6
> [    4.361867]        [<c01a9fac>] sys_open+0x26/0x2c
> [    4.361868]        [<c0362e31>] syscall_call+0x7/0xb
> [    4.361870]
> [    4.361870] -> #1 (misc_mtx){+.+.+.}:
> [    4.361871]        [<c01608b4>] lock_acquire+0x71/0x85
> [    4.361873]        [<c0360eb8>] __mutex_lock_common+0x44/0x2e2
> [    4.361876]        [<c03611d8>] mutex_lock_nested+0x20/0x22
> [    4.361877]        [<c02941aa>] misc_register+0x1f/0xfd
> [    4.361879]        [<c02c9ba7>] watchdog_dev_register+0x22/0xef
> [    4.361880]        [<c02c952f>] watchdog_register_device+0xa0/0x165
> [    4.361883]        [<f87904ff>] mei_watchdog_register+0x13/0x41 [mei]
> [    4.361885]        [<f878d169>]
> mei_interrupt_thread_handler+0x2fd/0x12b8 [mei]
> [    4.361887]        [<c016c553>] irq_thread_fn+0x13/0x25
> [    4.361888]        [<c016c2f8>] irq_thread+0x9e/0x138
> [    4.361891]        [<c0140725>] kthread+0x59/0x5e
> [    4.361892]        [<c0363aba>] kernel_thread_helper+0x6/0xd
> [    4.361894]
> [    4.361894] -> #0 (&dev->device_lock){+.+.+.}:
> [    4.361895]        [<c016026e>] __lock_acquire+0x9a3/0xc27
> [    4.361897]        [<c01608b4>] lock_acquire+0x71/0x85
> [    4.361898]        [<c0360eb8>] __mutex_lock_common+0x44/0x2e2
> [    4.361900]        [<c03611d8>] mutex_lock_nested+0x20/0x22
> [    4.361902]        [<f8790075>] mei_wd_ops_start+0x2d/0x75 [mei]
> [    4.361904]        [<c02c967f>] watchdog_start+0x37/0x53
> [    4.361905]        [<c02c9808>] watchdog_open+0x5c/0xa1
> [    4.361907]        [<c0294000>] misc_open+0xf5/0x14f
> [    4.361908]        [<c01ad941>] chrdev_open+0x106/0x124
> [    4.361909]        [<c01a93fd>] do_dentry_open.clone.16+0x12a/0x1c6
> [    4.361910]        [<c01a94b1>] finish_open+0x18/0x22
> [    4.361912]        [<c01b4d34>] do_last.clone.35+0x6fb/0x865
> [    4.361914]        [<c01b4f37>] path_openat+0x99/0x2c3
> [    4.361915]        [<c01b5380>] do_filp_open+0x26/0x67
> [    4.361916]        [<c01a9efb>] do_sys_open+0x5b/0xe6
> [    4.361918]        [<c01a9fac>] sys_open+0x26/0x2c
> [    4.361919]        [<c0362e31>] syscall_call+0x7/0xb
> [    4.361919]
> [    4.361919] other info that might help us debug this:
> [    4.361919]
> [    4.361921] Chain exists of:
> [    4.361921]   &dev->device_lock --> misc_mtx --> &wdd->lock
> [    4.361921]
> [    4.361921]  Possible unsafe locking scenario:
> [    4.361921]
> [    4.361922]        CPU0                    CPU1
> [    4.361922]        ----                    ----
> [    4.361923]   lock(&wdd->lock);
> [    4.361924]                                lock(misc_mtx);
> [    4.361924]                                lock(&wdd->lock);
> [    4.361925]   lock(&dev->device_lock);
> [    4.361926]
> [    4.361926]  *** DEADLOCK ***
> [    4.361926]
> [    4.361926] 2 locks held by watchdog/1375:
> [    4.361929]  #0:  (misc_mtx){+.+.+.}, at: [<c0293f28>]
> misc_open+0x1d/0x14f
> [    4.361931]  #1:  (&wdd->lock){+.+...}, at: [<c02c9661>]
> watchdog_start+0x19/0x53
> [    4.361932]
> [    4.361932] stack backtrace:
> [    4.361933] Pid: 1375, comm: watchdog Not tainted 3.6.6-build-0063 #21
> [    4.361933] Call Trace:
> [    4.361936]  [<c015ec57>] print_circular_bug+0x1ac/0x1b6
> [    4.361937]  [<c016026e>] __lock_acquire+0x9a3/0xc27
> [    4.361940]  [<c015f736>] ? mark_lock+0x26/0x1bb
> [    4.361941]  [<c01608b4>] lock_acquire+0x71/0x85
> [    4.361943]  [<f8790075>] ? mei_wd_ops_start+0x2d/0x75 [mei]
> [    4.361945]  [<c0360eb8>] __mutex_lock_common+0x44/0x2e2
> [    4.361947]  [<f8790075>] ? mei_wd_ops_start+0x2d/0x75 [mei]
> [    4.361949]  [<c036114c>] ? __mutex_lock_common+0x2d8/0x2e2
> [    4.361951]  [<c0160c8d>] ? trace_hardirqs_on_caller+0x10e/0x13f
> [    4.361953]  [<c03611d8>] mutex_lock_nested+0x20/0x22
> [    4.361955]  [<f8790075>] ? mei_wd_ops_start+0x2d/0x75 [mei]
> [    4.361957]  [<f8790075>] mei_wd_ops_start+0x2d/0x75 [mei]
> [    4.361959]  [<c02c967f>] watchdog_start+0x37/0x53
> [    4.361960]  [<c02c9808>] watchdog_open+0x5c/0xa1
> [    4.361962]  [<c0294000>] misc_open+0xf5/0x14f
> [    4.361963]  [<c01ad941>] chrdev_open+0x106/0x124
> [    4.361964]  [<c01ad83b>] ? cdev_put+0x1a/0x1a
> [    4.361966]  [<c01a93fd>] do_dentry_open.clone.16+0x12a/0x1c6
> [    4.361967]  [<c01a94b1>] finish_open+0x18/0x22
> [    4.361969]  [<c01b4d34>] do_last.clone.35+0x6fb/0x865
> [    4.361970]  [<c01b2f73>] ? inode_permission+0x3f/0x41
> [    4.361972]  [<c01b4f37>] path_openat+0x99/0x2c3
> [    4.361974]  [<c01b5380>] do_filp_open+0x26/0x67
> [    4.361977]  [<c01be06c>] ? alloc_fd+0xb7/0xc2
> [    4.361979]  [<c01a9efb>] do_sys_open+0x5b/0xe6
> [    4.361980]  [<c01a9fac>] sys_open+0x26/0x2c
> [    4.361981]  [<c0362e31>] syscall_call+0x7/0xb
> 
> 
> 
> ---
> Denys Fedoryshchenko, Network Engineer, Virtual ISP S.A.L.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

