Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965140Ab2JXHsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 03:48:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:14379 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934459Ab2JXHsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 03:48:03 -0400
X-IronPort-AV: E=Sophos;i="4.80,639,1344182400"; 
   d="scan'208";a="6058766"
Message-ID: <508797B1.5050407@cn.fujitsu.com>
Date: Wed, 24 Oct 2012 15:24:33 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: yinghai@kernel.org, bhelgaas@google.com, lenb@kernel.org,
        jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com, mihailm@parallels.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] Use kacpi_hotplug_wq to handle container hotplug
 event.
References: <1351058750-4275-1-git-send-email-tangchen@cn.fujitsu.com> <1351058750-4275-2-git-send-email-tangchen@cn.fujitsu.com> <508790AC.5080001@jp.fujitsu.com>
In-Reply-To: <508790AC.5080001@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/24 15:25:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/24 15:25:19,
	Serialize complete at 2012/10/24 15:25:19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 02:54 PM, Yasuaki Ishimatsu wrote:
> Hi Tang,
> 
> 2012/10/24 15:05, Tang Chen wrote:
>> As the comments in __acpi_os_execute() said:
>>
>> 	We can't run hotplug code in keventd_wq/kacpid_wq/kacpid_notify_wq
>> 	because the hotplug code may call driver .remove() functions,
>> 	which invoke flush_scheduled_work/acpi_os_wait_events_complete
>> 	to flush these workqueues.
>>
>> we should keep the hotplug code in kacpi_hotplug_wq.
>>
>> But we have the following call series in kernel now:
>> 	acpi_ev_queue_notify_request()
>> 	|-->  acpi_os_execute()
>> 	     |-->  __acpi_os_execute(type, function, context, 0)
>>
>> The last parameter 0 makes the container_notify_cb() executed in
>> kacpi_notify_wq or kacpid_wq. So, we need to put the real hotplug code
>> into kacpi_hotplug_wq.
> 
> I cannot understand the purpose of the patch.
> Is the patch a bug fix patch? If yes, what problem happens?

Hi Yasuaki-san,

Actually, it is a problem. But container hot-remove was not implemented
in container_notify_cb(), so this problem would never be triggered. So I
cannot say it is a bug in kernel.

The problem is here:

acpi_pci_root_remove() will finally call acpi_os_wait_events_complete():

void acpi_os_wait_events_complete(void)
{
        flush_workqueue(kacpid_wq);
        flush_workqueue(kacpi_notify_wq);
}

which means it will flush kacpid_wq and kacpi_notify_wq. So the current
work should not be in these 2 workqueue, otherwise it will cause
deadlock: the worker will wait for itself to complete.

But unfortunately, in the beginning, we have:

	acpi_ev_queue_notify_request()
	|-->  acpi_os_execute()
	     |-->  __acpi_os_execute(type, function, context, 0)

Please refer to the code, you will see the last parameter 0 will make
the hotplug call serial in kacpid_wq or kacpi_notify_wq. And it is hard
coded in kernel. I don't know why and I don't how to fix it.

So I made this patch, and want to see what you guys think about it. :)


The deadlock call trace is like below:


[  302.383606] =============================================
[  302.448094] [ INFO: possible recursive locking detected ]
[  302.512578] 3.6.0-rc5-luyh-hostbridge-hotplug+ #13 Not tainted
[  302.582252] ---------------------------------------------
[  302.646736] kworker/0:2/1412 is trying to acquire lock:
[  302.709143]  (kacpi_notify){++++.+}, at: [<ffffffff81091300>]
flush_workqueue+0x0/0x5c0
[  302.805222]
[  302.805222] but task is already holding lock:
[  302.874898]  (kacpi_notify){++++.+}, at: [<ffffffff81090528>]
process_one_work+0x1b8/0x680
[  302.974083]
[  302.974083] other info that might help us debug this:
[  303.052067]  Possible unsafe locking scenario:
[  303.052067]
[  303.122785]        CPU0
[  303.151965]        ----
[  303.181150]   lock(kacpi_notify);
[  303.220935]   lock(kacpi_notify);
[  303.260721]
[  303.260721]  *** DEADLOCK ***
[  303.260721]
[  303.331434]  May be due to missing lock nesting notation
[  303.331434]
[  303.412529] 4 locks held by kworker/0:2/1412:
[  303.464553]  #0:  (kacpi_notify){++++.+}, at: [<ffffffff81090528>]
process_one_work+0x1b8/0x680
[  303.569042]  #1:  ((&dpc->work)#2){+.+.+.}, at: [<ffffffff81090528>]
process_one_work+0x1b8/0x680
[  303.675718]  #2:  (&__lockdep_no_validate__){......}, at:
[<ffffffff8143cca7>] device_release_driver+0x27/0x50
[  303.795782]  #3:  (pci_acpi_pm_notify_mtx){+.+.+.}, at:
[<ffffffff81385443>] remove_pm_notifier+0x33/0x90
[  303.910662]
[  303.910662] stack backtrace:
[  303.962687] Pid: 1412, comm: kworker/0:2 Not tainted
3.6.0-rc5-luyh-hostbridge-hotplug+ #13
[  304.062470] Call Trace:
[  304.091666]  [<ffffffff810da704>] print_deadlock_bug+0xf4/0x100
[  304.162384]  [<ffffffff810dc6a9>] validate_chain+0x549/0x7e0
[  304.229987]  [<ffffffff810dcc36>] __lock_acquire+0x2f6/0x4f0
[  304.297587]  [<ffffffff810dba65>] ? debug_check_no_locks_freed+0xa5/0xf0
[  304.377650]  [<ffffffff810dcecd>] lock_acquire+0x9d/0x190
[  304.442141]  [<ffffffff81091300>] ? flush_workqueue_prep_cwqs+0x260/0x260
[  304.523242]  [<ffffffff810d8759>] ? lockdep_init_map+0x59/0x150
[  304.593963]  [<ffffffff810914af>] flush_workqueue+0x1af/0x5c0
[  304.662605]  [<ffffffff81091300>] ? flush_workqueue_prep_cwqs+0x260/0x260
[  304.743713]  [<ffffffff810a6ab8>] ? complete+0x28/0x60
[  304.805084]  [<ffffffff810a6ab8>] ? complete+0x28/0x60
[  304.866457]  [<ffffffff810db925>] ? trace_hardirqs_on_caller+0x105/0x190
[  304.946515]  [<ffffffff810a6ab8>] ? complete+0x28/0x60
[  305.007891]  [<ffffffff81385443>] ? remove_pm_notifier+0x33/0x90
[  305.079649]  [<ffffffff813854e0>] ?
pci_acpi_remove_bus_pm_notifier+0x20/0x20
[  305.164905]  [<ffffffff813a340e>] acpi_os_wait_events_complete+0x21/0x23
[  305.244970]  [<ffffffff813b7b3c>] acpi_remove_notify_handler+0x47/0x183
[  305.323994]  [<ffffffff813854e0>] ?
pci_acpi_remove_bus_pm_notifier+0x20/0x20
[  305.409251]  [<ffffffff81385481>] remove_pm_notifier+0x71/0x90
[  305.478931]  [<ffffffff813854d5>]
pci_acpi_remove_bus_pm_notifier+0x15/0x20
[  305.562111]  [<ffffffff813aac25>] acpi_pci_root_remove+0x83/0xec
[  305.633869]  [<ffffffff813a69fc>] acpi_device_remove+0x90/0xb2
[  305.703548]  [<ffffffff8143cb2c>] __device_release_driver+0x7c/0xf0
[  305.778422]  [<ffffffff8143ccaf>] device_release_driver+0x2f/0x50
[  305.851219]  [<ffffffff813a79b5>] acpi_bus_remove+0x32/0x4d
[  305.917785]  [<ffffffff813a7a57>] acpi_bus_trim+0x87/0xee
[  305.982276]  [<ffffffff813d888c>] container_notify_cb+0x1c5/0x221
[  306.055075]  [<ffffffff813b6386>] acpi_ev_notify_dispatch+0x41/0x5f
[  306.129951]  [<ffffffff813a3437>] acpi_os_execute_deferred+0x27/0x34
[  306.205861]  [<ffffffff81090589>] process_one_work+0x219/0x680
[  306.275543]  [<ffffffff81090528>] ? process_one_work+0x1b8/0x680
[  306.347299]  [<ffffffff813a3410>] ?
acpi_os_wait_events_complete+0x23/0x23
[  306.429436]  [<ffffffff810923be>] worker_thread+0x12e/0x320
[  306.496001]  [<ffffffff81092290>] ? manage_workers+0x110/0x110
[  306.565680]  [<ffffffff81098396>] kthread+0xc6/0xd0
[  306.623937]  [<ffffffff8167c3c4>] kernel_thread_helper+0x4/0x10
[  306.694656]  [<ffffffff81671e30>] ? retint_restore_args+0x13/0x13
[  306.767451]  [<ffffffff810982d0>] ? __init_kthread_worker+0x70/0x70
[  306.842323]  [<ffffffff8167c3c0>] ? gs_change+0x13/0x13



[  519.588281] INFO: task kworker/0:0:4 blocked for more than 120 seconds.
[  519.667375] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  519.761130] kworker/0:0     D ffff8801bdcb7b60  5608     4      2
0x00000000
[  519.846044]  ffff8801bdcb7a50 0000000000000046 ffff8801bdcb7a50
ffff8801bdcb7fd8
[  519.935363]  ffff8801bdcb6000 ffff8801bdcb6010 ffff8801bdcb6000
ffff8801bdcb6000
[  520.024650]  ffff8801bdcb7fd8 ffff8801bdcb6000 ffffffff81c13420
ffff8801bde18000
[  520.114003] Call Trace:
[  520.143402]  [<ffffffff8166ff49>] schedule+0x29/0x70
[  520.202939]  [<ffffffff8166dd55>] schedule_timeout+0x235/0x2d0
[  520.272834]  [<ffffffff810d9377>] ? __lock_acquired+0x347/0x380
[  520.343789]  [<ffffffff8166fd0f>] ? wait_for_common+0x4f/0x180
[  520.413583]  [<ffffffff8166fde3>] ? wait_for_common+0x123/0x180
[  520.484526]  [<ffffffff8166fdeb>] wait_for_common+0x12b/0x180
[  520.553422]  [<ffffffff810b0b60>] ? try_to_wake_up+0x2f0/0x2f0
[  520.623342]  [<ffffffff810db9bd>] ? trace_hardirqs_on+0xd/0x10
[  520.693270]  [<ffffffff8166ff1d>] wait_for_completion+0x1d/0x20
[  520.764219]  [<ffffffff81091587>] flush_workqueue+0x287/0x5c0
[  520.833087]  [<ffffffff81091300>] ? flush_workqueue_prep_cwqs+0x260/0x260
[  520.914421]  [<ffffffff813a340e>] acpi_os_wait_events_complete+0x21/0x23
[  520.994730]  [<ffffffff813a3430>] acpi_os_execute_deferred+0x20/0x34
[  521.070882]  [<ffffffff81090589>] process_one_work+0x219/0x680
[  521.140790]  [<ffffffff81090528>] ? process_one_work+0x1b8/0x680
[  521.212780]  [<ffffffff810922e9>] ? worker_thread+0x59/0x320
[  521.280609]  [<ffffffff813a3410>] ?
acpi_os_wait_events_complete+0x23/0x23
[  521.362994]  [<ffffffff810923be>] worker_thread+0x12e/0x320
[  521.429815]  [<ffffffff81092290>] ? manage_workers+0x110/0x110
[  521.499739]  [<ffffffff81098396>] kthread+0xc6/0xd0
[  521.558261]  [<ffffffff8167c3c4>] kernel_thread_helper+0x4/0x10
[  521.629217]  [<ffffffff81671e30>] ? retint_restore_args+0x13/0x13
[  521.702220]  [<ffffffff810982d0>] ? __init_kthread_worker+0x70/0x70
[  521.777303]  [<ffffffff8167c3c0>] ? gs_change+0x13/0x13
[  521.839913] INFO: lockdep is turned off.










