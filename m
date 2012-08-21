Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab2HUBcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 21:32:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:10471 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab2HUBcF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 21:32:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,799,1336374000"; 
   d="scan'208";a="207004673"
Date: Tue, 21 Aug 2012 09:31:23 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org
Subject: Re: BUG: NULL pointer dereference in shmem_evict_inode()
Message-ID: <20120821013123.GA12104@localhost>
References: <20120821010403.GA12018@localhost>
 <5032E021.2030400@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <5032E021.2030400@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 06:10:57PM -0700, John Stultz wrote:
> On 08/20/2012 06:04 PM, Fengguang Wu wrote:
> >Hi John,
> >
> >The below oops happens in v3.5..v3.6-rc2 and it's bisected down to commit
> >2a8c0883c ("time: Move xtime_nsec adjustment underflow handling timekeeping_adjust").
> >
> >However linux-next is working fine. Do you have any fixes not yet sent to Linus?
> Yea, there's a fix pending in tip/timers/urgent
> (4e8b14526ca7fb046a81c94002c1c43b6fdf0e9b) to catch crazy values
> from settimeofday or the cmos clock that might overflow a ktime_t.

That's great!

> Out of curiosity, how are you triggering/reproducing this?

I boot test lots of randconfig kernels in kvm, and this oops shows up
several times in one ranconfig and some of the test boxes. I find it
pretty hard to reproduce, but managed to bisect it down by counting
1000 good boots as bisect success and running dozens of KVM instances
in parallel in several test boxes to speed up the progress. Here is one step:

2012-08-20-02:51:57 detecting boot state #9 ....12345...OK 6...OK 7.OK 8OK .OK 9OK 10....OK 11....OK 12OK 13.OK .OK 1415..OK 16OK 1718OK 19...OK .20.OK 21OK 22...OK 23OK 24OK .25..OK 26..OK 27OK 28....OK 29.OK 30..OK 31..OK 32OK 33....OK 34.OK 35.OK 36OK 37..OK .OK 38OK 39...OK .40OK 41.OK .OK 42..OK 43OK 44OK 45..OK 46.OK 47OK 48..OK 49..OK 50.OK 5152.OK 53.OK 54OK 55..OK 56..OK 57.OK 58OK 59...OK 60OK .OK 61.OK 62OK 63.OK 64OK .OK 65.OK .66OK .67.OK 68.OK 69OK 70.OK 71OK 72OK 73...OK 74..OK 75.OK 76OK 77OK 78OK 79OK 80.OK 81..OK 82...OK .OK 83.OK 8485OK 86.OK 87.OK .88....OK 89OK 90OK 91OK 92OK 93.OK 94.OK 95.OK 96...OK .97.OK 98OK 99.OK .100OK .101OK 102....OK 103.OK 104OK 105....OK 106OK 107.OK 108..OK 109.OK .OK 110OK 111...OK 112.OK 113.OK 114.OK 115116.OK 117OK 118OK 119120.OK .121..OK 122..OK 123.OK 124OK 125OK 126OK 127..OK 128.OK 129.OK 130.OK 131OK .OK 132OK 133134OK 135..OK 136.OK 137...OK 138.OK 139OK 140OK 141.OK 142.OK 143.....OK 144.OK 145OK 146OK 147.OK 148OK 149150.OK 151..OK 152OK 153.OK 154OK .OK 155156.OK 157.....OK 158OK 159.OK 160OK 161.OK 162.OK 163.......OK 164OK .OK 165166OK 167OK 168OK 169..OK 170...OK 171.OK 172OK 173.OK 174OK 175OK 176...OK 177..OK 178179OK 180OK 181OK 182OK 183.OK 184185..OK 186...OK 187OK 188OK .OK 189OK .190OK 191192......OK 193OK 194OK 195OK .196OK 197OK 198OK 199..OK 200...OK 201OK 202OK 203204OK 205206OK 207...OK 208...OK 209OK 210OK 211.OK 212OK .213...OK 214..OK .OK 215OK 216OK 217.OK 218OK 219........OK 220OK 221OK 222OK .OK 223OK 224........OK 225OK 226.OK 227OK 228OK 229..OK 230.....OK 231OK 232.OK 233OK 234OK 235.OK 236OK 237..OK 238.OK 239OK 240OK 241.OK 242OK 243OK .244.OK 245..OK 246OK 247OK 248OK 249.OK 250.OK 251.OK 252..OK 253..OK 254OK 255OK 256.OK 257OK 258.....OK 259..OK 260OK 261OK 262.OK 263OK 264......OK 265.OK 266OK 267268OK 269.OK 270......OK 271.OK 272OK 273.OK 274OK 275OK 276......OK 277OK .OK 278OK 279.OK 280OK 281OK 282......OK 283OK 284OK 285286OK 287.OK 288OK 289.OK 290.OK 291OK 292.OK 293OK 294OK 295.OK 296OK .297.OK 298..OK 299..OK 300OK 301OK 302.OK 303OK 304..OK 305..O
K 306..OK 307OK 308OK 309OK .OK 310OK 311..OK 312..OK .313.OK 314OK 315.OK 316OK 317OK 318..OK 319...OK 320.OK 321OK 322.OK 323OK 324OK 325..OK 326...OK 327OK 328OK 329OK 330OK .331OK 332OK 333..OK 334...OK 335OK 336OK 337338OK 339.OK 340.OK 341.OK 342....OK 343OK 344.OK 345OK 346..OK 347.OK 348...OK .OK 349OK 350.OK 351OK 352..OK 353.OK .354OK .355OK 356OK 357358OK 359OK 360OK 361.....OK 362.OK 363OK 364OK 365.OK 366OK 367OK 368.......OK 369OK 370OK 371.OK 372OK 373OK 374.......OK 375OK 376377OK 378.OK 379OK 380.......OK 381OK 382.OK 383OK .OK 384.OK 385.....OK .OK 386OK 387.OK 388OK 389OK .390OK 391.OK 392...OK 393OK 394OK 395OK .396OK 397..OK 398.OK 399...OK 400OK 401OK .OK 402.OK 403..OK .404OK 405...OK 406OK 407.OK 408OK 409....OK 410...OK 411OK 412OK 413OK .OK 414OK 415....OK 416...OK 417OK 418419OK 420OK .OK 421422.OK 423.OK 424...OK 425OK 426.OK 427OK 428OK 429OK 430.OK 431.OK 432..OK 433OK 434OK 435OK .436OK 437OK .438.OK 439....OK 440OK 441442OK 443.OK 444.OK 445.OK .446..OK 447OK 448OK 449.OK 450 TEST FAILURE
Bisecting: 2627 revisions left to test after this (roughly 11 steps)

Before this, I bisected another soft lockup bug to the same commit
2a8c0883c, however it seems to be fixed by another commit in Linus'
tree, so I didn't report it. But here are the call traces as FYI:

[ 2215.030127] [sched_delayed] sched: RT throttling activated
[ 2215.026783] BUG: soft lockup - CPU#1 stuck for 2047s! [99-trinity:504]
[ 2215.026783] Modules linked in:
[ 2215.026783] Pid: 504, comm: 99-trinity Not tainted 3.6.0-rc1 #225 Bochs Bochs
[ 2215.026783] EIP: 0060:[<c105b0aa>] EFLAGS: 00000206 CPU: 1
[ 2215.026783] EIP is at __might_sleep+0x4b/0x14a
[ 2215.026783] EAX: c13ad954 EBX: c7121600 ECX: 00000000 EDX: 00000000
[ 2215.026783] ESI: c1319bb0 EDI: 000000aa EBP: c7111e94 ESP: c7111e84
[ 2215.026783]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 2215.026783] CR0: 80050033 CR2: b76ff20c CR3: 07123000 CR4: 000006d0
[ 2215.026783] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 2215.026783] DR6: ffff0ff0 DR7: 00000400
[ 2215.026783] Process 99-trinity (pid: 504, ti=c7110000 task=c7141420 task.ti=c7110000)
[ 2215.026783] Stack:
[ 2215.026783]  c7121620 c7121620 c711f268 c7124bfc c7111eb4 c10d94f9 c117b180 c70e71b4
[ 2215.026783]  00000000 00000000 00000000 c7124bfc c7111ef8 c10d2d39 c70e71b4 00000001
[ 2215.026783]  00000001 c70e7180 b76ff20c 0d9aa065 c711f268 cdedf290 00000000 00000000
[ 2215.026783] Call Trace:
[ 2215.026783]  [<c10d94f9>] anon_vma_prepare+0x24/0x180
[ 2215.026783]  [<c117b180>] ? do_raw_spin_unlock+0xa0/0xc5
[ 2215.026783]  [<c10d2d39>] handle_pte_fault+0x9f5/0xd78
[ 2215.026783]  [<c107510e>] ? lock_acquire+0xae/0xf9
[ 2215.026783]  [<c10d3317>] handle_mm_fault+0x25b/0x26a
[ 2215.026783]  [<c1028892>] do_page_fault+0x40c/0x5ae
[ 2215.026783]  [<c1001ea6>] ? restore_sigcontext+0xd2/0x100
[ 2215.026783]  [<c1002d32>] ? math_state_restore+0xe1/0x17f
[ 2215.026783]  [<c1028486>] ? vmalloc_sync_all+0x192/0x192
[ 2215.026783]  [<c122959a>] error_code+0x5a/0x60
[ 2215.026783]  [<c1028486>] ? vmalloc_sync_all+0x192/0x192
[ 2215.026783] Code: c8 74 0f 83 3d 80 5e 3c c1 01 0f 85 12 01 00 00 eb 32 83 3d ec 2b 37 c1 00 b8 54 d9 3a c1 0f 94 c3 31 c9 0f b6 d3 e8 61 84 04 00 <84> db 74 05 e9 e1 00 00 00 9c 58 8d 74 26 00 f6 c4 02 74 c4 e9

[ 2236.184052] BUG: soft lockup - CPU#0 stuck for 22s! [swapper/0:0]
[ 2236.184052] Modules linked in:
[ 2236.184052] Pid: 0, comm: swapper/0 Not tainted 3.6.0-rc1 #225 Bochs Bochs
[ 2236.184052] EIP: 0060:[<c10271a2>] EFLAGS: 00000246 CPU: 0
[ 2236.184052] EIP is at native_safe_halt+0x5/0x7
[ 2236.184052] EAX: c13a6f50 EBX: 00000000 ECX: 00000000 EDX: 00000000
[ 2236.184052] ESI: 00000000 EDI: c1362800 EBP: c1361fac ESP: c1361fac
[ 2236.184052]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 2236.184052] CR0: 8005003b CR2: b76dafb8 CR3: 0156b000 CR4: 000006d0
[ 2236.184052] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 2236.184052] DR6: ffff0ff0 DR7: 00000400
[ 2236.184052] Process swapper/0 (pid: 0, ti=c1360000 task=c136b108 task.ti=c1360000)
[ 2236.184052] Stack:
[ 2236.184052]  c1361fbc c1009a7c 00000000 018b0b92 c1361fc8 c100a96e 00000002 c1361fd4
[ 2236.184052]  c1211053 c13f3000 c1361fe4 c13c89ab c13f30d4 00000800 c1361ff8 c13c82a2
[ 2236.184052]  00000800 00020800 c1362800 01c10003 00000000
[ 2236.184052] Call Trace:
[ 2236.184052]  [<c1009a7c>] default_idle+0xfe/0x261
[ 2236.184052]  [<c100a96e>] cpu_idle+0x80/0xc6
[ 2236.184052]  [<c1211053>] rest_init+0xa7/0xac
[ 2236.184052]  [<c13c89ab>] start_kernel+0x386/0x38b
[ 2236.184052]  [<c13c82a2>] i386_start_kernel+0x78/0x7d                                                                  
[ 2236.184052] Code: 0f 22 e0 5d c3 55 89 e5 0f 09 5d c3 55 89 e5 9c 58 5d c3 55 89 e5 50 9d 5d c3 55 89 e5 fa 5d c3 55 89 e5 fb 5d c3 55 8
9 e5 fb f4 <5d> c3 55 89 e5 f4 5d c3 55 89 e5 57 89 c7 56 89 ce 53 53 8b 00                                               

[  125.893909] Testing tracer branch:
[  152.868290] BUG: soft lockup - CPU#0 stuck for 22s! [swapper/0:1]
[  152.868290] Modules linked in:
[  152.868290] Pid: 1, comm: swapper/0 Not tainted 3.6.0-rc1 #225 Bochs Bochs
[  152.868290] EIP: 0060:[<c1228f6c>] EFLAGS: 00000246 CPU: 0
[  152.868290] EIP is at _raw_spin_unlock_irqrestore+0x48/0x5a
[  152.868290] EAX: 00000246 EBX: cd4a1800 ECX: cd472000 EDX: 00000000
[  152.868290] ESI: 00000246 EDI: c1563c60 EBP: cd40df44 ESP: cd40df3c
[  152.868290]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  152.868290] CR0: 8005003b CR2: 00000000 CR3: 0156b000 CR4: 000006d0
[  152.868290] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  152.868290] DR6: 00000000 DR7: 00000000
[  152.868290] Process swapper/0 (pid: 1, ti=cd40a000 task=cd458000 task.ti=cd454000)
[  152.868290] Stack:
[  152.868290]  cd4a1420 00000001 cd40df6c c105edc6 00000000 00000246 cd4a1808 00000000
[  152.868290]  cdb6bc60 c15993a0 ffffffff cd40dfc4 cd40df74 c105edf6 cd40df7c c10cb4a2
[  152.868290]  cd40dfd0 c103f5c0 c1599dd8 c1599bd8 00000000 c10cb490 00000100 c19e03ec
[  152.868290] Call Trace:
[  152.868290]  [<c105edc6>] try_to_wake_up+0x273/0x27d
[  152.868290]  [<c105edf6>] wake_up_process+0x14/0x16
[  152.868290]  [<c10cb4a2>] sync_supers_timer_fn+0x12/0x19
[  152.868290]  [<c103f5c0>] run_timer_softirq+0x1ee/0x36a
[  152.868290]  [<c10cb490>] ? bdi_arm_supers_timer+0x34/0x34
[  152.868290]  [<c103987e>] __do_softirq+0xef/0x248
[  152.868290]  [<c103978f>] ? local_bh_enable+0x11a/0x11a
[  152.868290]  <IRQ>
[  152.868290]  [<c1039bf7>] ? irq_exit+0x3a/0x6a
[  152.868290]  [<c10042ee>] ? do_IRQ+0x7f/0x93
[  152.868290]  [<c1229d29>] ? common_interrupt+0x29/0x30
[  152.868290]  [<c1228f6c>] ? _raw_spin_unlock_irqrestore+0x48/0x5a
[  152.868290]  [<c12250ee>] ? schedule_timeout+0x15d/0x1a5
[  152.868290]  [<c103f80f>] ? add_timer_on+0xd3/0xd3
[  152.868290]  [<c10a36aa>] ? enable_branch_tracing+0x28/0x2d
[  152.868290]  [<c1225150>] ? schedule_timeout_uninterruptible+0x1a/0x1c
[  152.868290]  [<c103fefc>] ? msleep+0x15/0x1b
[  152.868290]  [<c109fae3>] ? trace_selftest_startup_branch+0x32/0x6f
[  152.868290]  [<c109fef6>] ? register_tracer+0x11c/0x1f7
[  152.868290]  [<c13dc80b>] ? init_annotated_branch_stats+0x27/0x27
[  152.868290]  [<c13dc838>] ? init_branch_tracer+0x2d/0x2f
[  152.868290]  [<c1001070>] ? do_one_initcall+0x70/0x154
[  152.868290]  [<c13c8aa8>] ? kernel_init+0xf8/0x18b
[  152.868290]  [<c13c8abe>] ? kernel_init+0x10e/0x18b
[  152.868290]  [<c13c89b0>] ? start_kernel+0x38b/0x38b
[  152.868290]  [<c1229d36>] ? kernel_thread_helper+0x6/0x10
[  152.868290] Code: ff 89 d8 e8 97 21 f5 ff b8 ac fe 3a c1 83 3d f0 2b 37 c1 00 0f 94 c3 31 c9 0f b6 d3 e8 a9 a5 e7 ff 84 db 74 02 0f 0b 8
9 f0 50 9d <8d> 74 26 00 89 e0 25 00 e0 ff ff ff 48 14 5b 5e 5d c3 55 89 e5

Thanks,
Fengguang
