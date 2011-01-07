Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab1AGA76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 19:59:58 -0500
Received: from void.printf.net ([89.145.121.20]:48911 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126Ab1AGA75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 19:59:57 -0500
Date: Fri, 7 Jan 2011 00:59:54 +0000
From: Chris Ball <cjb@laptop.org>
To: Nick Piggin <npiggin@gmail.com>
Cc: Jongman Heo <jongman.heo@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [announce] vfs-scale git tree update
Message-ID: <20110107005954.GA18145@void.printf.net>
References: <20110105102534.GA6679@amd> <loom.20110106T030535-794@post.gmane.org> <AANLkTikO68RQW0jzeLDOzRw7Hm15Ho0G9=Bp1KobKsrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikO68RQW0jzeLDOzRw7Hm15Ho0G9=Bp1KobKsrQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Fri, Jan 07, 2011 at 11:09:53AM +1100, Nick Piggin wrote:
> > It makes the boot time of my Fedora14 on vmware much slower, while Ubuntu
> > (native, not on vmware) has no problem.
> 
> Chris also noticed the problem on native hardware, so it looks like it might be
> specific to redhat.
> 
> http://marc.info/?l=linux-kernel&m=129287788825563&w=2
> 
> It's interesting because the rcu-walk path lookup failure even in the worst case
> that everything blows up in our face, should be a barely measurable hit -- no
> more than about 2x slowdown on something as fast as a path lookup.
> 
> So I suspect it is a bug in the sysfs .d_revalidate_rcu conversion. It is a bit
> nasty and needs some cleanup anyway.
> 
> So what I will do is split those conversions properly so the core code is done
> first, and the filesystem conversions done individually after that for better
> bisecting. I'll also drop the sysfs conversion (it was mainly useful for my own
> testing anyway, and not so performance critical).
> 
> I might ping you again to test the sysfs patch if I get keen, after the dust of
> this merge window settles :)

I did some more digging, with Andrew's help.

In my case, the hang happens when microcode.ko is modprobed and calls
out for device firmware via request_firmware(), and then udev also calls
microcode_ctl, which attempts to open(2) /dev/cpu/microcode to write
microcode into it.  (The request_firmware() interface is the preferred
one, and opening /dev/cpu/microcode is an older compatibility interface.)

During boot (but not afterwards), that open(2) on /dev/cpu/microcode
will hang in the kernel.  After sixty seconds udev will declare the
helper as having failed and give up on it, and then that repeats * 8. 
(I have eight CPUs).  I'll attach a sysrq-w during one of the hangs.

I started to binary-search through -next and got as far as "2010-12-13
works and 2010-12-20 doesn't", but the Fedora cgroup boot failures
caused by the same vfs-scale patchset got in the way of getting closer
I'm happy to test any patches you come up with, or take suggestions for
extra debugging to do.

Thanks,

- Chris.

sysrq-w:
[  256.977786] SysRq : Show Blocked State
[  256.978878]   task                        PC stack   pid father
[  256.980052] modprobe        D 00000000ffff4f88     0   372      1 0x00000000
[  256.981227]  ffff88022206dc58 0000000000000086 0000000000000292 00000000ffffffff
[  256.982415]  0000000000013840 0000000000013840 0000000000013840 ffff88022620dc40
[  256.983692]  0000000000013840 ffff88022206dfd8 0000000000013840 0000000000013840
[  256.984979] Call Trace:
[  256.986306]  [<ffffffff81463a41>] schedule_timeout+0x36/0xe3
[  256.987615]  [<ffffffff8110ad4c>] ? kfree+0xc9/0xd6
[  256.988893]  [<ffffffff8103d243>] ? need_resched+0x23/0x2d
[  256.990337]  [<ffffffff81463824>] wait_for_common+0xad/0x102
[  256.991637]  [<ffffffff8104757f>] ? default_wake_function+0x0/0x14
[  256.992954]  [<ffffffff81463931>] wait_for_completion+0x1d/0x1f
[  256.994360]  [<ffffffff812f42df>] _request_firmware+0x2df/0x39a
[  256.995688]  [<ffffffff81462f2e>] ? printk+0x68/0x6a
[  256.997079]  [<ffffffff812f4424>] request_firmware+0x16/0x1a
[  256.998430]  [<ffffffffa00f6c7d>] request_microcode_fw+0x77/0x103 [microcode]
[  256.999744]  [<ffffffffa00f6358>] microcode_init_cpu+0xc4/0x115 [microcode]
[  257.001112]  [<ffffffffa00f6409>] mc_sysdev_add+0x60/0x76 [microcode]
[  257.002458]  [<ffffffff812e9772>] sysdev_driver_register+0xc0/0x11b
[  257.003844]  [<ffffffffa00d9000>] ? microcode_init+0x0/0x131 [microcode]
[  257.005315]  [<ffffffffa00d90c2>] microcode_init+0xc2/0x131 [microcode]
[  257.006685]  [<ffffffff8106db7c>] ? __blocking_notifier_call_chain+0x56/0x60
[  257.008160]  [<ffffffff8100219b>] do_one_initcall+0x7f/0x138
[  257.009537]  [<ffffffff8107fbd1>] sys_init_module+0xa6/0x1e4
[  257.010934]  [<ffffffff81009c02>] system_call_fastpath+0x16/0x1b
[  257.012438] microcode_ctl   D 00000000fffba41a     0   512      1 0x00000000
[  257.013899]  ffff880224c819f8 0000000000000082 ffff880224c81968 ffffffff00000000
[  257.015430]  0000000000013840 0000000000013840 0000000000013840 ffff880222218000
[  257.016924]  0000000000013840 ffff880224c81fd8 0000000000013840 0000000000013840
[  257.018488] Call Trace:
[  257.020047]  [<ffffffff81463a41>] schedule_timeout+0x36/0xe3
[  257.021553]  [<ffffffff810475a8>] ? wake_up_process+0x15/0x17
[  257.023148]  [<ffffffff81063a0e>] ? wake_up_worker+0x24/0x26
[  257.024650]  [<ffffffff81063b99>] ? insert_work+0x54/0x5c
[  257.026252]  [<ffffffff8103d243>] ? need_resched+0x23/0x2d
[  257.027736]  [<ffffffff81463824>] wait_for_common+0xad/0x102
[  257.029244]  [<ffffffff8104757f>] ? default_wake_function+0x0/0x14
[  257.030727]  [<ffffffff812ba40c>] ? misc_open+0xab/0x197
[  257.032206]  [<ffffffff812ba40c>] ? misc_open+0xab/0x197
[  257.033628]  [<ffffffff81463931>] wait_for_completion+0x1d/0x1f
[  257.035156]  [<ffffffff81062b25>] call_usermodehelper_exec+0x87/0xd6
[  257.036588]  [<ffffffff81062db6>] __request_module+0x1ba/0x1f1
[  257.038117]  [<ffffffff8103d243>] ? need_resched+0x23/0x2d
[  257.039617]  [<ffffffff812ba40c>] misc_open+0xab/0x197
[  257.041149]  [<ffffffff81119f14>] chrdev_open+0x11b/0x144
[  257.042599]  [<ffffffff81119df9>] ? chrdev_open+0x0/0x144
[  257.044135]  [<ffffffff811150f1>] __dentry_open+0x161/0x283
[  257.045629]  [<ffffffff81464cde>] ? _raw_spin_lock+0xe/0x10
[  257.047179]  [<ffffffff8112d89c>] ? mntget+0x20/0x26
[  257.048648]  [<ffffffff81115ea5>] nameidata_to_filp+0x55/0x5c
[  257.050207]  [<ffffffff8112206f>] finish_open+0xa2/0x1a4
[  257.051699]  [<ffffffff81121177>] ? do_path_lookup+0xed/0x118
[  257.053287]  [<ffffffff81122615>] do_filp_open+0x1a5/0x6db
[  257.054812]  [<ffffffff81143891>] ? fsnotify+0x23f/0x26b
[  257.056414]  [<ffffffff81463763>] ? _cond_resched+0xe/0x22
[  257.057958]  [<ffffffff81224270>] ? might_fault+0x21/0x23
[  257.059552]  [<ffffffff81224370>] ? __strncpy_from_user+0x1f/0x4e
[  257.061177]  [<ffffffff8112c4d0>] ? alloc_fd+0x74/0x11f
[  257.062700]  [<ffffffff81115f0c>] do_sys_open+0x60/0xf2
[  257.064296]  [<ffffffff81115fbe>] sys_open+0x20/0x22
[  257.065835]  [<ffffffff81009c02>] system_call_fastpath+0x16/0x1b
[  257.067419] microcode_ctl   D 00000000fffba406     0   513      1 0x00000000
[  257.069016]  ffff880224c859f8 0000000000000082 ffff880224c85968 ffffffffffffffff
[  257.070590]  0000000000013840 0000000000013840 0000000000013840 ffff88022416dc40
[  257.072278]  0000000000013840 ffff880224c85fd8 0000000000013840 0000000000013840
[  257.073856] Call Trace:
[  257.075504]  [<ffffffff81463a41>] schedule_timeout+0x36/0xe3
[  257.077108]  [<ffffffff810475a8>] ? wake_up_process+0x15/0x17
[  257.078701]  [<ffffffff81063a0e>] ? wake_up_worker+0x24/0x26
[  257.080288]  [<ffffffff81063b99>] ? insert_work+0x54/0x5c
[  257.081849]  [<ffffffff8103d243>] ? need_resched+0x23/0x2d
[  257.083448]  [<ffffffff81463824>] wait_for_common+0xad/0x102
[  257.085030]  [<ffffffff8104757f>] ? default_wake_function+0x0/0x14
[  257.086601]  [<ffffffff812ba40c>] ? misc_open+0xab/0x197
[  257.088151]  [<ffffffff812ba40c>] ? misc_open+0xab/0x197
[  257.089670]  [<ffffffff81463931>] wait_for_completion+0x1d/0x1f
[  257.091256]  [<ffffffff81062b25>] call_usermodehelper_exec+0x87/0xd6
[  257.092749]  [<ffffffff81062db6>] __request_module+0x1ba/0x1f1
[  257.094336]  [<ffffffff8103d243>] ? need_resched+0x23/0x2d
[  257.095875]  [<ffffffff812ba40c>] misc_open+0xab/0x197
[  257.097461]  [<ffffffff81119f14>] chrdev_open+0x11b/0x144
[  257.099038]  [<ffffffff81119df9>] ? chrdev_open+0x0/0x144
[  257.100517]  [<ffffffff811150f1>] __dentry_open+0x161/0x283
[  257.102083]  [<ffffffff81464cde>] ? _raw_spin_lock+0xe/0x10
[  257.103592]  [<ffffffff8112d89c>] ? mntget+0x20/0x26
[  257.105092]  [<ffffffff81115ea5>] nameidata_to_filp+0x55/0x5c
[  257.106557]  [<ffffffff8112206f>] finish_open+0xa2/0x1a4
[  257.108103]  [<ffffffff81121177>] ? do_path_lookup+0xed/0x118
[  257.109543]  [<ffffffff81122615>] do_filp_open+0x1a5/0x6db
[  257.111074]  [<ffffffff81143891>] ? fsnotify+0x23f/0x26b
[  257.112497]  [<ffffffff81463763>] ? _cond_resched+0xe/0x22
[  257.113971]  [<ffffffff81224270>] ? might_fault+0x21/0x23
[  257.115423]  [<ffffffff81224370>] ? __strncpy_from_user+0x1f/0x4e
[  257.116822]  [<ffffffff8112c4d0>] ? alloc_fd+0x74/0x11f
[  257.118313]  [<ffffffff81115f0c>] do_sys_open+0x60/0xf2
[  257.119739]  [<ffffffff81115fbe>] sys_open+0x20/0x22
[  257.121195]  [<ffffffff81009c02>] system_call_fastpath+0x16/0x1b
[  257.122563] microcode_ctl   D 00000000fffba41b     0   514      1 0x00000000
[  257.124056]  ffff8802262af9f8 0000000000000086 ffff8802262af968 ffffffff00000000
[  257.125469]  0000000000013840 0000000000013840 0000000000013840 ffff8802243e1710
[  257.126965]  0000000000013840 ffff8802262affd8 0000000000013840 0000000000013840
[  257.128478] Call Trace:
[  257.129895]  [<ffffffff81463a41>] schedule_timeout+0x36/0xe3
[  257.131397]  [<ffffffff810475a8>] ? wake_up_process+0x15/0x17
[  257.132816]  [<ffffffff81063a0e>] ? wake_up_worker+0x24/0x26
[  257.134323]  [<ffffffff81063b99>] ? insert_work+0x54/0x5c
[  257.135800]  [<ffffffff8103d243>] ? need_resched+0x23/0x2d
[  257.137263]  [<ffffffff81463824>] wait_for_common+0xad/0x102
[  257.138719]  [<ffffffff8104757f>] ? default_wake_function+0x0/0x14
[  257.140226]  [<ffffffff812ba40c>] ? misc_open+0xab/0x197
[  257.141631]  [<ffffffff812ba40c>] ? misc_open+0xab/0x197
[  257.143133]  [<ffffffff81463931>] wait_for_completion+0x1d/0x1f
[  257.144541]  [<ffffffff81062b25>] call_usermodehelper_exec+0x87/0xd6
[  257.146056]  [<ffffffff81062db6>] __request_module+0x1ba/0x1f1
[  257.147486]  [<ffffffff8121c29d>] ? kobject_get+0x1a/0x21
[  257.149002]  [<ffffffff8103d243>] ? need_resched+0x23/0x2d
[  257.150476]  [<ffffffff812ba40c>] misc_open+0xab/0x197
[  257.151922]  [<ffffffff81119f14>] chrdev_open+0x11b/0x144
[  257.153424]  [<ffffffff81119df9>] ? chrdev_open+0x0/0x144
[  257.154922]  [<ffffffff811150f1>] __dentry_open+0x161/0x283
[  257.156373]  [<ffffffff81464cde>] ? _raw_spin_lock+0xe/0x10
[  257.157833]  [<ffffffff8112d89c>] ? mntget+0x20/0x26
[  257.159353]  [<ffffffff81115ea5>] nameidata_to_filp+0x55/0x5c
[  257.160782]  [<ffffffff8112206f>] finish_open+0xa2/0x1a4
[  257.162309]  [<ffffffff81121177>] ? do_path_lookup+0xed/0x118
[  257.163769]  [<ffffffff81122615>] do_filp_open+0x1a5/0x6db
[  257.165290]  [<ffffffff81143891>] ? fsnotify+0x23f/0x26b
[  257.166717]  [<ffffffff81463763>] ? _cond_resched+0xe/0x22
[  257.168216]  [<ffffffff81224270>] ? might_fault+0x21/0x23
[  257.169595]  [<ffffffff81224370>] ? __strncpy_from_user+0x1f/0x4e
[  257.171077]  [<ffffffff8112c4d0>] ? alloc_fd+0x74/0x11f
[  257.172515]  [<ffffffff81115f0c>] do_sys_open+0x60/0xf2
[  257.173987]  [<ffffffff81115fbe>] sys_open+0x20/0x22
[  257.175346]  [<ffffffff81009c02>] system_call_fastpath+0x16/0x1b
[  257.176721] microcode_ctl   D 00000000fffba3e1     0   515      1 0x00000000
[  257.178213]  ffff880224d379f8 0000000000000082 ffff880224d37968 ffffffff00000000
[  257.179674]  0000000000013840 0000000000013840 0000000000013840 ffff88022416ae20
[  257.181247]  0000000000013840 ffff880224d37fd8 0000000000013840 0000000000013840
[  257.182719] Call Trace:
[  257.184215]  [<ffffffff81463a41>] schedule_timeout+0x36/0xe3
[  257.185620]  [<ffffffff810475a8>] ? wake_up_process+0x15/0x17
[  257.187110]  [<ffffffff81063a0e>] ? wake_up_worker+0x24/0x26
[  257.188578]  [<ffffffff81063b99>] ? insert_work+0x54/0x5c
[  257.190091]  [<ffffffff8103d243>] ? need_resched+0x23/0x2d
[  257.191503]  [<ffffffff81463824>] wait_for_common+0xad/0x102
[  257.193012]  [<ffffffff8104757f>] ? default_wake_function+0x0/0x14
[  257.194481]  [<ffffffff812ba40c>] ? misc_open+0xab/0x197
[  257.195907]  [<ffffffff812ba40c>] ? misc_open+0xab/0x197
[  257.197359]  [<ffffffff81463931>] wait_for_completion+0x1d/0x1f
[  257.198767]  [<ffffffff81062b25>] call_usermodehelper_exec+0x87/0xd6
[  257.200284]  [<ffffffff81062db6>] __request_module+0x1ba/0x1f1
[  257.201761]  [<ffffffff8103d243>] ? need_resched+0x23/0x2d
[  257.203260]  [<ffffffff812ba40c>] misc_open+0xab/0x197
[  257.204698]  [<ffffffff81119f14>] chrdev_open+0x11b/0x144
[  257.206221]  [<ffffffff81119df9>] ? chrdev_open+0x0/0x144
[  257.207682]  [<ffffffff811150f1>] __dentry_open+0x161/0x283
[  257.209194]  [<ffffffff81464cde>] ? _raw_spin_lock+0xe/0x10
[  257.210624]  [<ffffffff8112d89c>] ? mntget+0x20/0x26
[  257.212118]  [<ffffffff81115ea5>] nameidata_to_filp+0x55/0x5c
[  257.213593]  [<ffffffff8112206f>] finish_open+0xa2/0x1a4
[  257.215113]  [<ffffffff81121177>] ? do_path_lookup+0xed/0x118
[  257.216536]  [<ffffffff81122615>] do_filp_open+0x1a5/0x6db
[  257.218049]  [<ffffffff81143891>] ? fsnotify+0x23f/0x26b
[  257.219518]  [<ffffffff81463763>] ? _cond_resched+0xe/0x22
[  257.221025]  [<ffffffff81224270>] ? might_fault+0x21/0x23
[  257.222420]  [<ffffffff81224370>] ? __strncpy_from_user+0x1f/0x4e
[  257.223884]  [<ffffffff8112c4d0>] ? alloc_fd+0x74/0x11f
[  257.225333]  [<ffffffff81115f0c>] do_sys_open+0x60/0xf2
[  257.226702]  [<ffffffff81115fbe>] sys_open+0x20/0x22
[  257.228167]  [<ffffffff81009c02>] system_call_fastpath+0x16/0x1b
[  257.229572] microcode_ctl   D 00000000fffca464     0   530      1 0x00000000
[  257.231051]  ffff8802235639f8 0000000000000086 ffff880223563968 ffffffff00000000
[  257.232464]  0000000000013840 0000000000013840 0000000000013840 ffff880224ddae20
[  257.233979]  0000000000013840 ffff880223563fd8 0000000000013840 0000000000013840
[  257.235443] Call Trace:
[  257.236928]  [<ffffffff81463a41>] schedule_timeout+0x36/0xe3
[  257.238349]  [<ffffffff810475a8>] ? wake_up_process+0x15/0x17
[  257.239823]  [<ffffffff81063a0e>] ? wake_up_worker+0x24/0x26
[  257.241332]  [<ffffffff81063b99>] ? insert_work+0x54/0x5c
[  257.242747]  [<ffffffff8103d243>] ? need_resched+0x23/0x2d
[  257.244269]  [<ffffffff81463824>] wait_for_common+0xad/0x102
[  257.245732]  [<ffffffff8104757f>] ? default_wake_function+0x0/0x14
[  257.247234]  [<ffffffff812ba40c>] ? misc_open+0xab/0x197
[  257.248654]  [<ffffffff812ba40c>] ? misc_open+0xab/0x197
[  257.250156]  [<ffffffff81463931>] wait_for_completion+0x1d/0x1f
[  257.251608]  [<ffffffff81062b25>] call_usermodehelper_exec+0x87/0xd6
[  257.253129]  [<ffffffff81062db6>] __request_module+0x1ba/0x1f1
[  257.254555]  [<ffffffff8103d243>] ? need_resched+0x23/0x2d
[  257.256083]  [<ffffffff812ba40c>] misc_open+0xab/0x197
[  257.257549]  [<ffffffff81119f14>] chrdev_open+0x11b/0x144
[  257.259076]  [<ffffffff81119df9>] ? chrdev_open+0x0/0x144
[  257.260505]  [<ffffffff811150f1>] __dentry_open+0x161/0x283
[  257.262027]  [<ffffffff81464cde>] ? _raw_spin_lock+0xe/0x10
[  257.263451]  [<ffffffff8112d89c>] ? mntget+0x20/0x26
[  257.264970]  [<ffffffff81115ea5>] nameidata_to_filp+0x55/0x5c
[  257.266398]  [<ffffffff8112206f>] finish_open+0xa2/0x1a4
[  257.267973]  [<ffffffff81121177>] ? do_path_lookup+0xed/0x118
[  257.269450]  [<ffffffff81122615>] do_filp_open+0x1a5/0x6db
[  257.270975]  [<ffffffff81143891>] ? fsnotify+0x23f/0x26b
[  257.272433]  [<ffffffff81463763>] ? _cond_resched+0xe/0x22
[  257.273945]  [<ffffffff81224270>] ? might_fault+0x21/0x23
[  257.275356]  [<ffffffff81224370>] ? __strncpy_from_user+0x1f/0x4e
[  257.276793]  [<ffffffff8112c4d0>] ? alloc_fd+0x74/0x11f
[  257.278260]  [<ffffffff81115f0c>] do_sys_open+0x60/0xf2
[  257.279644]  [<ffffffff81115fbe>] sys_open+0x20/0x22
[  257.281112]  [<ffffffff81009c02>] system_call_fastpath+0x16/0x1b
[  257.282510] microcode_ctl   D 00000000fffd7a87     0   536    138 0x00000000
[  257.283990]  ffff880224e079f8 0000000000000086 ffff880224e07968 ffffffff00000000
[  257.285427]  0000000000013840 0000000000013840 0000000000013840 ffff880224ddc530
[  257.286938]  0000000000013840 ffff880224e07fd8 0000000000013840 0000000000013840
[  257.288420] Call Trace:
[  257.289929]  [<ffffffff81463a41>] schedule_timeout+0x36/0xe3
[  257.291357]  [<ffffffff810475a8>] ? wake_up_process+0x15/0x17
[  257.292782]  [<ffffffff81063a0e>] ? wake_up_worker+0x24/0x26
[  257.294283]  [<ffffffff81063b99>] ? insert_work+0x54/0x5c
[  257.295709]  [<ffffffff8103d243>] ? need_resched+0x23/0x2d
[  257.297231]  [<ffffffff81463824>] wait_for_common+0xad/0x102
[  257.298645]  [<ffffffff8104757f>] ? default_wake_function+0x0/0x14
[  257.300123]  [<ffffffff812ba40c>] ? misc_open+0xab/0x197
[  257.301589]  [<ffffffff812ba40c>] ? misc_open+0xab/0x197
[  257.303080]  [<ffffffff81463931>] wait_for_completion+0x1d/0x1f
[  257.304539]  [<ffffffff81062b25>] call_usermodehelper_exec+0x87/0xd6
[  257.306049]  [<ffffffff81062db6>] __request_module+0x1ba/0x1f1
[  257.307480]  [<ffffffff8103d243>] ? need_resched+0x23/0x2d
[  257.309006]  [<ffffffff812ba40c>] misc_open+0xab/0x197
[  257.310475]  [<ffffffff81119f14>] chrdev_open+0x11b/0x144
[  257.312000]  [<ffffffff81119df9>] ? chrdev_open+0x0/0x144
[  257.313426]  [<ffffffff811150f1>] __dentry_open+0x161/0x283
[  257.314938]  [<ffffffff81464cde>] ? _raw_spin_lock+0xe/0x10
[  257.316404]  [<ffffffff8112d89c>] ? mntget+0x20/0x26
[  257.317863]  [<ffffffff81115ea5>] nameidata_to_filp+0x55/0x5c
[  257.319340]  [<ffffffff8112206f>] finish_open+0xa2/0x1a4
[  257.320860]  [<ffffffff81121177>] ? do_path_lookup+0xed/0x118
[  257.322318]  [<ffffffff81122615>] do_filp_open+0x1a5/0x6db
[  257.323734]  [<ffffffff81143891>] ? fsnotify+0x23f/0x26b
[  257.325249]  [<ffffffff81463763>] ? _cond_resched+0xe/0x22
[  257.326677]  [<ffffffff81224270>] ? might_fault+0x21/0x23
[  257.328167]  [<ffffffff81224370>] ? __strncpy_from_user+0x1f/0x4e
[  257.329619]  [<ffffffff8112c4d0>] ? alloc_fd+0x74/0x11f
[  257.331064]  [<ffffffff81115f0c>] do_sys_open+0x60/0xf2
[  257.332481]  [<ffffffff81115fbe>] sys_open+0x20/0x22
[  257.333935]  [<ffffffff81009c02>] system_call_fastpath+0x16/0x1b
[  257.335300] microcode_ctl   D 00000000fffe80e4     0   647    162 0x00000000
[  257.336723]  ffff880222bf39f8 0000000000000082 ffff880222bf3968 ffffffff00000000
[  257.338216]  0000000000013840 0000000000013840 0000000000013840 ffff880222b20000
[  257.339644]  0000000000013840 ffff880222bf3fd8 0000000000013840 0000000000013840
[  257.341171] Call Trace:
[  257.342613]  [<ffffffff81463a41>] schedule_timeout+0x36/0xe3
[  257.344088]  [<ffffffff810475a8>] ? wake_up_process+0x15/0x17
[  257.345553]  [<ffffffff81063a0e>] ? wake_up_worker+0x24/0x26
[  257.347075]  [<ffffffff81063b99>] ? insert_work+0x54/0x5c
[  257.348539]  [<ffffffff8103d243>] ? need_resched+0x23/0x2d
[  257.350001]  [<ffffffff81463824>] wait_for_common+0xad/0x102
[  257.351412]  [<ffffffff8104757f>] ? default_wake_function+0x0/0x14
[  257.352927]  [<ffffffff812ba40c>] ? misc_open+0xab/0x197
[  257.354374]  [<ffffffff812ba40c>] ? misc_open+0xab/0x197
[  257.355868]  [<ffffffff81463931>] wait_for_completion+0x1d/0x1f
[  257.357280]  [<ffffffff81062b25>] call_usermodehelper_exec+0x87/0xd6
[  257.358799]  [<ffffffff81062db6>] __request_module+0x1ba/0x1f1
[  257.360265]  [<ffffffff8103d243>] ? need_resched+0x23/0x2d
[  257.361767]  [<ffffffff812ba40c>] misc_open+0xab/0x197
[  257.363201]  [<ffffffff81119f14>] chrdev_open+0x11b/0x144
[  257.364623]  [<ffffffff81119df9>] ? chrdev_open+0x0/0x144
[  257.366125]  [<ffffffff811150f1>] __dentry_open+0x161/0x283
[  257.367556]  [<ffffffff81464cde>] ? _raw_spin_lock+0xe/0x10
[  257.369055]  [<ffffffff8112d89c>] ? mntget+0x20/0x26
[  257.370487]  [<ffffffff81115ea5>] nameidata_to_filp+0x55/0x5c
[  257.371960]  [<ffffffff8112206f>] finish_open+0xa2/0x1a4
[  257.373444]  [<ffffffff81121177>] ? do_path_lookup+0xed/0x118
[  257.374967]  [<ffffffff81122615>] do_filp_open+0x1a5/0x6db
[  257.376430]  [<ffffffff81143891>] ? fsnotify+0x23f/0x26b
[  257.377939]  [<ffffffff81463763>] ? _cond_resched+0xe/0x22
[  257.379375]  [<ffffffff81224270>] ? might_fault+0x21/0x23
[  257.380891]  [<ffffffff81224370>] ? __strncpy_from_user+0x1f/0x4e
[  257.382329]  [<ffffffff8112c4d0>] ? alloc_fd+0x74/0x11f
[  257.383821]  [<ffffffff81115f0c>] do_sys_open+0x60/0xf2
[  257.385220]  [<ffffffff81115fbe>] sys_open+0x20/0x22
[  257.386666]  [<ffffffff81009c02>] system_call_fastpath+0x16/0x1b
[  257.388128] modprobe        D 00000000fffe8374     0   690    670 0x00000080
[  257.389538]  ffff880226373dc8 0000000000000086 0000000000000001 0000000000000000
[  257.391068]  0000000000013840 0000000000013840 0000000000013840 ffff88022417dc40
[  257.392538]  0000000000013840 ffff880226373fd8 0000000000013840 0000000000013840
[  257.394072] Call Trace:
[  257.395497]  [<ffffffff81463ffd>] __mutex_lock_common.clone.5+0x12f/0x196
[  257.397019]  [<ffffffff81464077>] __mutex_lock_slowpath+0x13/0x15
[  257.398461]  [<ffffffff81463eb4>] mutex_lock+0x36/0x50
[  257.399997]  [<ffffffff812e972d>] sysdev_driver_register+0x7b/0x11b
[  257.401475]  [<ffffffff813a136f>] cpufreq_register_driver+0xcb/0x1b8
[  257.403017]  [<ffffffffa00e10eb>] acpi_cpufreq_init+0xeb/0x11e [acpi_cpufreq]
[  257.404511]  [<ffffffffa00e1000>] ? acpi_cpufreq_init+0x0/0x11e [acpi_cpufreq]
[  257.406004]  [<ffffffff8100219b>] do_one_initcall+0x7f/0x138
[  257.407503]  [<ffffffff8107fbd1>] sys_init_module+0xa6/0x1e4
[  257.409020]  [<ffffffff81009c02>] system_call_fastpath+0x16/0x1b
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
