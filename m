Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab0KLR2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:28:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711Ab0KLR2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:28:20 -0500
Date: Fri, 12 Nov 2010 12:27:55 -0500
From: Don Zickus <dzickus@redhat.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
Message-ID: <20101112172755.GR4823@redhat.com>
References: <1289573033-2889-1-git-send-email-dzickus@redhat.com>
 <4CDD579F.80009@windriver.com>
 <20101112154231.GN4823@redhat.com>
 <4CDD6389.2080206@windriver.com>
 <20101112161144.GP4823@redhat.com>
 <4CDD6CAD.30303@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDD6CAD.30303@windriver.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 10:34:53AM -0600, Jason Wessel wrote:
> On 11/12/2010 10:11 AM, Don Zickus wrote:
> > On Fri, Nov 12, 2010 at 09:55:53AM -0600, Jason Wessel wrote:
> >   
> >>> To answer your question, I doubt this patch series will change that
> >>> outcome if it is still broken.
> >>>
> >>>   
> >>>       
> >> It was most definitely broken in 2.6.36->2.6.37-rc1.  Randy Dunlap had
> >> pointed this out in a separate exchange that was not on LKML.
> >>     
> >
> > Can you clarify by what you mean by broken above?  Was 2.6.36 good or bad?
> >
> >   
> 
> It was absolutely broken in 2.6.36 which I believe is where the new
> LOCKUP_DETECTOR changes were introduced.

Well to be clear here, the lockup detector is a victim not the culprit.
The culprit is the perf nmi handler.  What happens is that the perf nmi
handler first checks to see if it is active, if not then it just returns.
Because the lockup detector is one of the only early users, it activated
the nmi handler and hence the problems you see.

In fact if you can activate your kgdb tests from user space, then you can
probably duplicate the same problem while running the user space perf app
and the lockup detector not compiled in.

> 
> I tested 2.6.35 and it does not hard hang, but suffered from a different
> problem with a perf API change.   The kgdb tests appear to loop and loop
> emitting endless streams of output in 2.6.35 and I already have that
> problem patched.

It doesn't look like this does it?  This is the streaming output I see
when try to reproduce this using the config suggestions you gave me.

[    7.778578] ------------[ cut here ]------------
[    7.778580] WARNING: at
/ssd/dzickus/git/upstream/drivers/misc/kgdbts.c:702 run_simple_test+0x18d/0x2f0()
[    7.778582] Hardware name: To be filled by O.E.M.
[    7.778583] Modules linked in: ata_generic i915 drm_kms_helper drm i2c_algo_bit i2c_core video output dm_mod
[    7.778589] Pid: 150, comm: udevd Tainted: G        W   2.6.36-killnmi+ #12
[    7.778590] Call Trace:
[    7.778591]  <#DB>  [<ffffffff810631cf>] warn_slowpath_common+0x7f/0xc0
[    7.778595]  [<ffffffff8106322a>] warn_slowpath_null+0x1a/0x20
[    7.778598]  [<ffffffff8132941d>] run_simple_test+0x18d/0x2f0
[    7.778600]  [<ffffffff81328ded>] kgdbts_put_char+0x1d/0x20
[    7.778603]  [<ffffffff810c6cbd>] put_packet+0x5d/0x120
[    7.778605]  [<ffffffff810c7f44>] gdb_serial_stub+0xa24/0xc20
[    7.778609]  [<ffffffff810c6558>] kgdb_cpu_enter+0x2c8/0x590
[    7.778612]  [<ffffffff810c6a91>] kgdb_handle_exception+0x121/0x170
[    7.778615]  [<ffffffff814cd7b8>] ?  hw_breakpoint_exceptions_notify+0xe8/0x1d0
[    7.778617]  [<ffffffff81033472>] __kgdb_notify+0x82/0x1b0
[    7.778620]  [<ffffffff810335c7>] kgdb_notify+0x27/0x40
[    7.778623]  [<ffffffff814cf8e5>] notifier_call_chain+0x55/0x80
[    7.778625]  [<ffffffff814cf958>] __atomic_notifier_call_chain+0x48/0x70
[    7.778628]  [<ffffffff814cf996>] atomic_notifier_call_chain+0x16/0x20
[    7.778631]  [<ffffffff814cf9ce>] notify_die+0x2e/0x30
[    7.778633]  [<ffffffff814cc953>] do_debug+0xa3/0x170
[    7.778636]  [<ffffffff814cc438>] debug+0x28/0x40
[    7.778639]  [<ffffffff81062310>] ? do_fork+0x0/0x450
[    7.778640]  <<EOE>>  [<ffffffff81014938>] ? sys_clone+0x28/0x30
[    7.778644]  [<ffffffff8100c4d3>] stub_clone+0x13/0x20
[    7.778647]  [<ffffffff8100c1b2>] ? system_call_fastpath+0x16/0x1b
[    7.778649] ---[ end trace ecf07e0cd1846c34 ]---
[    7.778650] kgdbts: ERROR: beyond end of test on 'do_fork_test' line 11
[    7.778651] ------------[ cut here ]------------

> 
> At this point we have to get back to a working base line.  At this point
> if you use 2.6.37-rc1 the last remaining problem is the perf + lockup
> detector callback eating the injected DIE_NMI event which is meant to
> enter the debugger.

This shouldn't be too hard to solve once we figure out which path it takes
in the perf nmi handler.

Cheers,
Don

> 
> 
> >> The symptom you would see looks like:
> >>
> >> ...kernel boot...
> >> Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> >> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> >> 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> >> brd: module loaded
> >> kgdb: Registered I/O driver kgdbts.
> >> kgdbts:RUN plant and detach test
> >> [...HARD HANG STARTS HERE...]
> >>
> >> The kernel is looping at that point waiting for the master kgdb cpu to
> >> have all the slaves join the debugger but it never happens because the
> >> perf callback chain which is used by the lockup detector eats the NMI
> >> IPI event.  After the perf callback is processed perf returns
> >> NOTIFY_STOP so the notifier which brings the slave CPU into the debugger
> >> never fires.
> >>     
> >
> > Ok.  We have code to handle extra spurious NMIs that is hard to accurately
> > determine if the NMI was for perf or someone else.  This logic may still
> > need tweaking.  What cpu are you running on?  AMD/Intel?  If Intel, then
> > core/core2/nehalem?
> >
> >   
> 
> In this case I just built a 32 bit kernel and ran it under kvm on a 64
> bit host.  I can send you the .config separately.
> 
> kvm  -nographic -k en-us -kernel arch/x86/boot/bzImage -net user -net
> nic,macaddr=52:54:00:12:34:56,model=i82557b -append
> "console=ttyS0,115200 ip=dhcp root=/dev/nfs
> nfsroot=10.0.2.2:/space/exp/x86 rw acpi=force UMA=1" -smp 2

Does that you hit the problem on the kvm guest or host?  I wasn't aware
the perf worked inside the guest (well at least the hardware pieces of
it, like NMI).

Cheers,
Don
