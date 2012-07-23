Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab2GWTDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 15:03:48 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56270 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705Ab2GWTDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 15:03:46 -0400
Message-ID: <500D9EBC.204@linaro.org>
Date: Mon, 23 Jul 2012 11:58:04 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: xen-devel@lists.xensource.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [Xen-devel] Was: Re: [GIT PULL] timer changes for v3.6, Is: Regression
 introduced by 1e75fa8be9fb61e1af46b5b3b176347a4c958ca1
References: <20120722133441.GA6874@gmail.com> <20120723144917.GF793@phenom.dumpdata.com> <500D8CDD.3060309@linaro.org> <20120723182431.GD21870@phenom.dumpdata.com>
In-Reply-To: <20120723182431.GD21870@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072318-6078-0000-0000-00000D7ADC30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2012 11:24 AM, Konrad Rzeszutek Wilk wrote:
> On Mon, Jul 23, 2012 at 10:41:49AM -0700, John Stultz wrote:
>> On 07/23/2012 07:49 AM, Konrad Rzeszutek Wilk wrote:
>>> I hadn't looked in details of the patch, but this commit:
>>>
>>> commit 1e75fa8be9fb61e1af46b5b3b176347a4c958ca1
>>> Author: John Stultz <john.stultz@linaro.org>
>>> Date:   Fri Jul 13 01:21:53 2012 -0400
>>>
>>>      time: Condense timekeeper.xtime into xtime_sec
>>>
>>> causes 32-bit (and only 32-bit) bootup time crashes on Xen guests. I couldn't
>>> do a git revert on top of Linus's tree (had a bunch of conflicts), but with
>>> git bisection it narrowed down to that patch.
>>>
>>> I could also bootup with git commit 55acdddbac1725b80df0c41970505e8a41c84956
>>> (the smp-hotplug-for-linus merge), but with git commit
>>> 3992c0321258bdff3666cbaf5225f538ad61a548 (timers-core-for-linus merge aka this pull)
>>> it went belly up.
>>>
>>> This is the guest config:
>>>
>>> extra="console=hvc0 debug earlyprintk=xen memblock=debug"
>>> kernel="/mnt/lab/bootstrap-i386/vmlinuz"
>>> ramdisk="/mnt/lab/bootstrap-i386/initramfs.cpio.gz"
>>> mem=10248
>>> vcpus=1
>>> name="bootstrap-i386"
>>> on_crash="preserve"
>>>
>>> Attached is the crash log and I am also attaching the .config file and bisect log.
>>>
>>> John, any thoughts? Is Xen clock timer (arch/x86/xen/time.c) code missing something obvious?
>> Thanks for the testing and the report!  I'll take a closer look here
>> and see.
>>
>>> Using config file "/test.xm".
>>> Started domain bootstrap-i386 (id=4)
>>> [    0.000000] console [hvc0] enabled, bootconsole disabled
>>> [    0.000000] Xen: using vcpuop timer interface
>>> [    0.000000] installing Xen timer for CPU 0
>>> [    0.000000] ------------[ cut here ]------------
>>> [    0.000000] WARNING: at /home/konrad/linux/kernel/time/clockevents.c:209 clockevents_program_event+0x176/0x190()
>>> [    0.000000] Modules linked in:
>>> [    0.000000] Pid: 0, comm: swapper/0 Not tainted 3.5.0upstream-00242-g3992c03 #1
>>> [    0.000000] Call Trace:
>>> [    0.000000]  [<c1067aed>] warn_slowpath_common+0x6d/0xa0
>>> [    0.000000]  [<c10aa846>] ? clockevents_program_event+0x176/0x190
>>> [    0.000000]  [<c10aa846>] ? clockevents_program_event+0x176/0x190
>>> [    0.000000]  [<c1067b3d>] warn_slowpath_null+0x1d/0x20
>>> [    0.000000]  [<c10aa846>] clockevents_program_event+0x176/0x190
>>> [    0.000000]  [<c10aaa36>] tick_setup_periodic+0x66/0xa0
>>> [    0.000000]  [<c10aade7>] tick_notify+0x377/0x3d0
>>> [    0.000000]  [<c1511043>] notifier_call_chain+0x43/0x60
>>> [    0.000000]  [<c108985a>] raw_notifier_call_chain+0x1a/0x20
>>> [    0.000000]  [<c10aa1f8>] clockevents_register_device+0x88/0xf0
>>> [    0.000000]  [<c102fb12>] xen_setup_cpu_clockevents+0x22/0x40
>>> [    0.000000]  [<c16bba3a>] xen_time_init+0xb7/0xbf
>>> [    0.000000]  [<c16bcf1c>] x86_late_time_init+0x9/0x10
>>> [    0.000000]  [<c16b7a7f>] start_kernel+0x286/0x317
>>> [    0.000000]  [<c16b766a>] ? kernel_init+0x1cd/0x1cd
>>> [    0.000000]  [<c16b72e6>] i386_start_kernel+0xa9/0xb0
>>> [    0.000000]  [<c16ba609>] xen_start_kernel+0x5c9/0x5d1
>> Is this WARN_ON new, as well as the oops?
> Yes. I don't see the WARN_ON if I boot the kernel with one git commit
> earlier (fee84c43e6afc42295ae8058cbbef9ea5633926c] time: Explicitly use u32 instead of int for shift values).
>
> I do see all the time this WARN_ON and the crash (and also the huge jump in
> time reported), when building with git commit 1e75fa8be9fb61e1af46b5b3b176347a4c958ca1] time: Condense timekeeper.xtime into xtime_sec):
>
> [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
> [    0.000000] Detected 2899.988 MHz processor.
> [1266874889.140126] Calibrating delay loop (skipped), value calculated using timer frequency.. 5799.97 BogoMIPS (lpj=2899988)
> [1266874889.140126] pid_max: default: 32768 minimum: 301

Does the following resolve it? If not I have a debug patch I'll send you 
to try to chase this down.

thanks
-john


diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index f045cc5..cf364db 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -108,13 +108,13 @@ static struct timespec tk_xtime(struct timekeeper *tk)
  static void tk_set_xtime(struct timekeeper *tk, const struct timespec *ts)
  {
  	tk->xtime_sec = ts->tv_sec;
-	tk->xtime_nsec = ts->tv_nsec << tk->shift;
+	tk->xtime_nsec = (u64)ts->tv_nsec << tk->shift;
  }
  
  static void tk_xtime_add(struct timekeeper *tk, const struct timespec *ts)
  {
  	tk->xtime_sec += ts->tv_sec;
-	tk->xtime_nsec += ts->tv_nsec << tk->shift;
+	tk->xtime_nsec += (u64)ts->tv_nsec << tk->shift;
  }
  
  /**

