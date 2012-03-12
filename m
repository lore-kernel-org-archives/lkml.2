Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab2CLL5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 07:57:20 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:34279 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab2CLL5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 07:57:18 -0400
Message-ID: <4F5DE482.20704@linux.vnet.ibm.com>
Date: Mon, 12 Mar 2012 17:26:50 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH bisected regression] sched: rebuild sched domains at suspend/resume
References: <20120306204357.13169.90791.stgit@zurg> <1331067743.11248.333.camel@twins> <CA+55aFxPiW=T8iNy=Fb_fuO2DYV9+sQL-mr8=Uc7cWymTyVt6A@mail.gmail.com> <1331084302.11248.338.camel@twins> <CA+55aFx6NXjLpAz_Bu1wvaxFB-2zrYGkfBeN_8rM5q7MkYuNEQ@mail.gmail.com> <4F5D00AE.8000602@openvz.org> <alpine.LFD.2.02.1203121221130.2466@ionos>
In-Reply-To: <alpine.LFD.2.02.1203121221130.2466@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12031201-5490-0000-0000-000000ED0045
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 04:52 PM, Thomas Gleixner wrote:

> On Sun, 11 Mar 2012, Konstantin Khlebnikov wrote:
>> Linus Torvalds wrote:
>>> On Tue, Mar 6, 2012 at 5:38 PM, Peter Zijlstra<a.p.zijlstra@chello.nl>
>>> wrote:
>>>> On Tue, 2012-03-06 at 16:54 -0800, Linus Torvalds wrote:
>>>>> I do agree that reverting is probably safer at this point, but can we
>>>>> get agreement on this?
>>>>
>>>> I agree with reverting, shoot it in the head :-) Do you want a git
>>>> thingy?
>>>
>>> Well, it's less a "git thingy" and more that there are tons of people
>>> involved with the original commit that haven't even piped up.
>>>
>>> Srivatsa, Ingo, Prashanth..
>>>
>>> In fact, I notice that Prashanth doesn't even seem to have been cc'd,
>>> even if he's the original reporter of the commit that gets reverted.
>>> Added (see lkml)
>>
>> I forget to mention my kernel boot options. I live with them for a while, so I
>> just forget about it.
>> "debug threadirqs i915.i915_enable_rc6=1 i915.i915_enable_fbc=1
>> i915.lvds_downclock=1 crashkernel=128M"
>>
>> So, "threadirqs" is a lost piece of the puzzle -- without it I cannot
>> reproduce the bug.
>> However, I have no idea how this is connected to sched-domains. =)
> 
> To be honest, I have no idea either. Can you figure out where the box
> hangs or is it in the "silent" phase of suspend/resume?
> 


I built a kernel with a config close to the one that Konstantin shared and
when I booted it with threadirqs parameter, I saw the suspend hangs.

Specifically, it hangs mostly at the processors level of pm_test.
# echo processors > /sys/power/pm_test
# echo mem > /sys/power/state

[But just a few times, processors level test passed and I had to go to
the core level (which is inclusive of processors level) to recreate the
hang.]

And by the way, I hit these warnings at freezer level test, a couple of
times:


[   75.519681] PM: Syncing filesystems ... done.
[   75.758038] PM: Preparing system for mem sleep
[   75.941235] Freezing user space processes ... (elapsed 0.01 seconds) done.
[   75.953543] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[   75.964517] suspend debug: Waiting for 5 seconds.
[   80.961583] PM: Finishing wakeup.
[   80.961619] Restarting tasks ... 
[   80.963297] rtkit-daemon[1056]: The canary thread is apparently starving. Taking action.
[   80.963376] rtkit-daemon[1056]: Demoting known real-time threads.
[   80.963797] rtkit-daemon[1056]: Successfully demoted thread 1260 of process 1260 (/usr/bin/pulseaudio).
[   80.963869] rtkit-daemon[1056]: Demoted 1 threads.
[   80.964506] done.
[   80.971719] video LNXVIDEO:00: Restoring backlight state
[   80.974799] video LNXVIDEO:01: Restoring backlight state
[   81.140119] dbus-daemon[826]: (process:1418): datetime-plugin-DEBUG: Exiting due to inactivity
[   81.199218] dbus-daemon[826]: (upowerd:1011): UPower-Linux-WARNING **: energy_full (104.240100) is greater than energy_full_design (103.496400)
[   83.004353] PM: Syncing filesystems ... done.
[   83.086329] PM: Preparing system for mem sleep
[   83.259932] Freezing user space processes ... (elapsed 0.01 seconds) done.
[   83.272214] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[   83.283177] suspend debug: Waiting for 5 seconds.
[   88.281663] PM: Finishing wakeup.
[   88.281735] Restarting tasks ... done.
[   88.292095] video LNXVIDEO:00: Restoring backlight state
[   88.292567] dbus-daemon[826]: (upowerd:1011): UPower-Linux-WARNING **: energy 121.012426 bigger than full 104.240100
[   88.296088] video LNXVIDEO:01: Restoring backlight state
[   88.491333] dbus-daemon[826]: (upowerd:1011): UPower-Linux-WARNING **: energy_full (104.240100) is greater than energy_full_design (103.496400)
[   89.265442] PM: Syncing filesystems ... done.
[   89.361045] PM: Preparing system for mem sleep
[   89.538006] Freezing user space processes ... (elapsed 0.01 seconds) done.
[   89.552637] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[   89.564523] suspend debug: Waiting for 5 seconds.
[   94.563665] PM: Finishing wakeup.
[   94.563737] Restarting tasks ... 
[   94.566142] ------------[ cut here ]------------
[   94.566346] WARNING: at drivers/gpu/drm/i915/i915_irq.c:652 ironlake_irq_handler+0x362/0x41d [i915]()
[   94.566585] Hardware name: 4180F59
[   94.566685] Missed a PM interrupt
[   94.566787] Modules linked in: fuse lockd rfcomm bnep ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 ip6table_filter xt_state nf_conntrack ip6_tables snd_hda_codec_conexant thinkpad_acpi snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm uvcvideo videobuf2_core btusb bluetooth rfkilldone.
[   94.567953]  videodev i2c_i801 snd_timer media snd e1000e soundcore joydev v4l2_compat_ioctl32 videobuf2_vmalloc videobuf2_memops snd_page_alloc pcspkr iTCO_wdt iTCO_vendor_support microcode sunrpc uinput sdhci_pci sdhci mmc_core nouveau ttm i915 drm_kms_helper drm i2c_algo_bit mxm_wmi i2c_core video wmi [last unloaded: scsi_wait_scan]
[   94.568292] Pid: 175, comm: irq/42-i915 Not tainted 3.3.0-rc4-cpusetfix-mar12 #2
[   94.568344] Call Trace:
[   94.568390]  [<ffffffff81048509>] warn_slowpath_common+0x83/0x9b
[   94.568437]  [<ffffffff810485c4>] warn_slowpath_fmt+0x46/0x48
[   94.568503]  [<ffffffffa007d456>] ? ironlake_irq_handler+0x33a/0x41d [i915]
[   94.568575]  [<ffffffffa007d47e>] ironlake_irq_handler+0x362/0x41d [i915]
[   94.568635]  [<ffffffff8107314b>] ? get_parent_ip+0xe/0x3f
[   94.568686]  [<ffffffff810b619a>] ? irq_thread_fn+0x3c/0x3c
[   94.568735]  [<ffffffff810b61bf>] irq_forced_thread_fn+0x25/0x45
[   94.568783]  [<ffffffff814e0c28>] ? _raw_spin_unlock_irq+0x32/0x45
[   94.568832]  [<ffffffff810b606a>] irq_thread+0xf7/0x1eb
[   94.568876]  [<ffffffff810b5f73>] ? irq_finalize_oneshot+0xb3/0xb3
[   94.568929]  [<ffffffff81065a28>] kthread+0xa6/0xae
[   94.568972]  [<ffffffff814e8fb4>] kernel_thread_helper+0x4/0x10
[   94.569019]  [<ffffffff814e1074>] ? retint_restore_args+0x13/0x13
[   94.569071]  [<ffffffff81065982>] ? __init_kthread_worker+0x5a/0x5a
[   94.569125]  [<ffffffff814e8fb0>] ? gs_change+0x13/0x13
[   94.569169] ---[ end trace f5e3ff2f2a987fde ]---
[   94.571593] video LNXVIDEO:00: Restoring backlight state
[   94.574446] video LNXVIDEO:01: Restoring backlight state
[   94.808431] dbus-daemon[826]: (upowerd:1011): UPower-Linux-WARNING **: energy_full (104.240100) is greater than energy_full_design (103.496400)
[   95.685606] PM: Syncing filesystems ... done.
[   95.788492] PM: Preparing system for mem sleep
[   95.967680] Freezing user space processes ... (elapsed 0.01 seconds) done.
[   95.981441] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[   95.993481] suspend debug: Waiting for 5 seconds.
[  100.997651] PM: Finishing wakeup.
[  101.002702] Restarting tasks ... done.
[  101.010209] dbus-daemon[826]: (upowerd:1011): UPower-Linux-WARNING **: no voltage values, using 10V as approximation
[  101.012911] dbus-daemon[826]: (upowerd:1011): UPower-Linux-WARNING **: energy_full (93.910000) is greater than energy_full_design (93.240000)
[  101.012989] video LNXVIDEO:00: Restoring backlight state
[  101.016114] video LNXVIDEO:01: Restoring backlight state
[  101.340434] dbus-daemon[826]: (upowerd:1011): UPower-Linux-WARNING **: energy_full (104.240100) is greater than energy_full_design (103.496400)
[  101.350376] sendmail[1618]: starting daemon (8.14.5): SMTP+queueing@01:00:00
[  101.352701] systemd[1]: Failed to read PID file /run/sendmail.pid after start. The service might be broken.
[  101.680287] sm-msp-queue[1625]: starting daemon (8.14.5): queueing@01:00:00
[  101.680842] systemd[1]: Failed to read PID file /run/sm-client.pid after start. The service might be broken.
[  101.681421] systemd[1]: Startup finished in 4s 220ms 750us (kernel) + 18s 7ms 177us (initrd) + 1min 19s 320ms 874us (userspace) = 1min 41s 548ms 801us.
[  220.735559] PM: Syncing filesystems ... done.
[  220.977183] PM: Preparing system for mem sleep
[  221.146370] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  221.160728] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  221.173679] suspend debug: Waiting for 5 seconds.
[  226.172693] PM: Finishing wakeup.
[  226.175017] Restarting tasks ... 
[  226.176134] ------------[ cut here ]------------
[  226.176974] rtkit-daemon[1056]: The canary thread is apparently starving. Taking action.
[  226.176989] rtkit-daemon[1056]: Demoting known real-time threads.
[  226.177692] rtkit-daemon[1056]: Successfully demoted thread 1260 of process 1260 (/usr/bin/pulseaudio).
[  226.177706] rtkit-daemon[1056]: Demoted 1 threads.
[  226.178712] done.
[  226.194843] WARNING: at drivers/gpu/drm/i915/i915_irq.c:652 ironlake_irq_handler+0x362/0x41d [i915]()
[  226.197917] Hardware name: 4180F59
[  226.200863] Missed a PM interrupt
[  226.203780] Modules linked in: fuse lockd rfcomm bnep ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 ip6table_filter xt_state nf_conntrack ip6_tables snd_hda_codec_conexant thinkpad_acpi snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm uvcvideo videobuf2_core btusb bluetooth rfkill videodev i2c_i801 snd_timer media snd e1000e soundcore joydev v4l2_compat_ioctl32 videobuf2_vmalloc videobuf2_memops snd_page_alloc pcspkr iTCO_wdt iTCO_vendor_support microcode sunrpc uinput sdhci_pci sdhci mmc_core nouveau ttm i915 drm_kms_helper drm i2c_algo_bit mxm_wmi i2c_core video wmi [last unloaded: scsi_wait_scan]
[  226.217371] Pid: 175, comm: irq/42-i915 Tainted: G        W    3.3.0-rc4-cpusetfix-mar12 #2
[  226.220766] Call Trace:
[  226.224134]  [<ffffffff81048509>] warn_slowpath_common+0x83/0x9b
[  226.227452]  [<ffffffff810485c4>] warn_slowpath_fmt+0x46/0x48
[  226.230839]  [<ffffffffa007d456>] ? ironlake_irq_handler+0x33a/0x41d [i915]
[  226.234106]  [<ffffffffa007d47e>] ironlake_irq_handler+0x362/0x41d [i915]
[  226.237326]  [<ffffffff8107314b>] ? get_parent_ip+0xe/0x3f
[  226.240371]  [<ffffffff810b619a>] ? irq_thread_fn+0x3c/0x3c
[  226.243306]  [<ffffffff810b61bf>] irq_forced_thread_fn+0x25/0x45
[  226.246172]  [<ffffffff814e0c28>] ? _raw_spin_unlock_irq+0x32/0x45
[  226.248982]  [<ffffffff810b606a>] irq_thread+0xf7/0x1eb
[  226.251781]  [<ffffffff810b5f73>] ? irq_finalize_oneshot+0xb3/0xb3
[  226.254616]  [<ffffffff81065a28>] kthread+0xa6/0xae
[  226.257430]  [<ffffffff814e8fb4>] kernel_thread_helper+0x4/0x10
[  226.260246]  [<ffffffff814e1074>] ? retint_restore_args+0x13/0x13
[  226.263057]  [<ffffffff81065982>] ? __init_kthread_worker+0x5a/0x5a
[  226.265890]  [<ffffffff814e8fb0>] ? gs_change+0x13/0x13
[  226.268681] ---[ end trace f5e3ff2f2a987fdf ]---
[  226.274789] video LNXVIDEO:00: Restoring backlight state
[  226.280073] video LNXVIDEO:01: Restoring backlight state
[  226.488477] dbus-daemon[826]: (upowerd:1011): UPower-Linux-WARNING **: energy_full (104.240100) is greater than energy_full_design (103.496400)


Regards,
Srivatsa S. Bhat

