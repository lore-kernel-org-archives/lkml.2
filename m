Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab2DQA3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 20:29:50 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:42978 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab2DQA3t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 20:29:49 -0400
MIME-Version: 1.0
Message-ID: <1019c5a1-983d-42c0-9f18-e3db8d10455f@default>
Date: Mon, 16 Apr 2012 17:29:19 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Sheng Yang <sheng@yasker.org>, Tim Deegan <tim@xen.org>
Cc: David Vrabel <david.vrabel@citrix.com>, Jan Beulich <JBeulich@suse.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        xen-devel <xen-devel@lists.xen.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [Xen-devel] [PATCH] xen: always set the sched clock as unstable
References: <1334341255-11153-1-git-send-email-david.vrabel@citrix.com>
 <4F8C1F6D020000780007E11A@nat28.tlf.novell.com> <4F8C33E0.2080007@citrix.com>
 <049b7b93-fb37-4962-b272-d786e1dcfacb@default>
 <20120416170827.GE13111@ocelot.phlegethon.org>
 <3e05ae0e-afe4-4ed7-b839-39a343cc0d06@default>
 <20120416181744.GF13111@ocelot.phlegethon.org>
 <CA+2rt41pCFV1haMAHo63rY9kx88VgiV419pf8Y=u2cXrdmGOBA@mail.gmail.com>
In-Reply-To: <CA+2rt41pCFV1haMAHo63rY9kx88VgiV419pf8Y=u2cXrdmGOBA@mail.gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A020205.4F8CB96C.00B6,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Sheng Yang [mailto:sheng@yasker.org]
> Subject: Re: [Xen-devel] [PATCH] xen: always set the sched clock as unstable

Hi Sheng --

See reply at the very end...

> On Mon, Apr 16, 2012 at 11:17 AM, Tim Deegan <tim@xen.org> wrote:
> > At 10:52 -0700 on 16 Apr (1334573568), Dan Magenheimer wrote:
> >> > From: Tim Deegan [mailto:tim@xen.org]
> >> > Subject: Re: [Xen-devel] [PATCH] xen: always set the sched clock as unstable
> >> >
> >> > At 09:05 -0700 on 16 Apr (1334567132), Dan Magenheimer wrote:
> >> > > Hmmm... I spent a great deal of time on TSC support in the hypervisor
> >> > > 2-3 years ago.  I worked primarily on PV, but Intel supposedly was tracking
> >> > > everything on HVM as well.  There's most likely a bug or two still lurking
> >> > > but, for all guests, with the default tsc_mode, TSC is provided by Xen
> >> > > as an absolutely stable clock source.  If Xen determines that the underlying
> >> > > hardware declares that TSC is stable, guest rdtsc instructions are not trapped.
> >> > > If it is not, Xen emulates all guest rdtsc instructions.  After a migration or
> >> > > save/restore, TSC is always emulated.  The result is (ignoring possible
> >> > > bugs) that TSC as provided by Xen is a) monotonic; b) synchronized across
> >> > > CPUs; and c) constant rate.  Even across migration/save/restore.
> >> >
> >> > AIUI, this thread is about the PV-time clock source, not about the TSC
> >> > itself.  Even if the TSC is emulated (or in some other way made
> >> > "stable") the PV wallclock is not necessarily stable across migration.
> >> > But since migration is controlled by the kernel, presumably the kernel
> >> > can DTRT about it.
> >>
> >> Under what circumstances is PV wallclock not stable across migration?
> >
> > The wallclock is host-local, so I don't think it can be guaranteed to be
> > strictly monotonic across migration.  But as I said that's OK because
> > the Xen code in the kernel is in control during migration.
> >
> >> > > In fact, it might be wise for a Xen-savvy kernel to check to see
> >> > > if it is running on Xen-4.0+ and, if so, force clocksource=tsc
> >> > > and tsc=reliable.
> >> >
> >> > That seems like overdoing it.  Certainly it's not OK unless it can also
> >> > check that Xen is providing a stable TSC (i.e. that tscmode==1).
> >>
> >> Xen guarantees a stable TSC for the default (tsc_mode==0) also.
> >>
> >> If the vm.cfg file explicitly sets a guest tsc_mode==2, you are correct
> >> that pvclock is still necessary.  But as the documentation says:
> >> tsc_mode==2 should be set if "it is certain that all apps running in this
> >> VM are TSC-resilient and highest performance is required".  In
> >> the case we are talking about, the PV guest kernel itself isn't TSC-
> >> resilient!
> >
> > Only if we deliberately break it! :)
> >
> >> In any case, IIRC, there is a pvcpuid instruction to determine the
> >> tsc_mode, so when the upstream kernel checks for Xen 4.0+, it could
> >> also check to ensure the tsc_mode wasn't overridden and set to 2.
> >
> > Yes, that's what I was suggesting.
> >
> >> > In the case where the PV clock has been selected, can it not be marked
> >> > unstable without also marking the TSC unstable?
> >>
> >> I'm not sure I understand...
> >>
> >> Are you talking about the HVM case of an upstream kernel, maybe
> >> when the clocksource is manually overridden on the kernel command
> >> line or after boot with sysfs?
> >
> > I'm talking about any case where the clocksource == xen.
> >
> >> If pvclock is necessary (e.g. old Xen), how would it be
> >> marked unstable? (I didn't know there was code to do that.)
> >
> > I think I'm confused by terminology.  Maybe David can correct me.  My
> > understanding was that there is some concept inside linux of a time
> > source being 'stable', which requires it to be synchronized, monotonic
> > and constant-rate.  The PV clock is two of those things (within a
> > reasonable tolerance) but may not be monotonic over migration.  I was
> > suggesting that, however linux deals with that, it can probably do it
> > without changing its opinion of whether the TSC is stable.
> 
> In fact the sched_clock_stable is only regarding one Intel processor
> feature named "Invarient TSC"(a.k.a Non-stop TSC).
> 
> I've reported the original issue to xen-devel, and purpose one patch
> to fix CPUID filter in the libxc of Xen.
> 
> I think mask CPUID bit in the hypervisor is better than make this
> change in the kernel, since Xen controlled what to present to the
> guest, it doesn't make sense if we present a feature to the guest, and
> hack the kernel to disable this feature at the same time.
> 
> I haven't dug much into the code, but here is the background(most
> copied from my xen-devel post):
> 
> Recently we got some reports of migration hang on latest
> Debian(2.6.32-41kernel package) kernel with some certain machines(but
> it's hard to debug on them since they're customer's machine).
> 
> Booting dmesg snippet below:
> 
> [    0.000000] Booting paravirtualized kernel on Xen
> [    0.000000] Xen version: 3.4.2 (preserve-AD)
> [    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:1
> nr_node_ids:1
> [    0.000000] PERCPU: Embedded 15 pages/cpu @c1608000 s37656 r0
> d23784 u65536
> [    0.000000] pcpu-alloc: s37656 r0 d23784 u65536 alloc=16*4096
> [    0.000000] pcpu-alloc: [0] 0
> [508119.807590] trying to map vcpu_info 0 at c1609010, mfn 992cac,
> offset 16
> [508119.807593] cpu 0 using vcpu_info at c1609010
> [508119.807594] Xen: using vcpu_info placement
> [508119.807598] Built 1 zonelists in Zone order, mobility grouping on.
>  Total pages: 32416
> 
> Dmesg show that when booting, timestamp of printk jumped from 0 to a
> big number([508119.807590] in this case) immediately.
> 
> And when migrating:
> 
> [509508.914333] suspending xenstore...
> [516212.055921] trying to map vcpu_info 0 at c1609010, mfn 895fd7,
> offset 16
> [516212.055930] cpu 0 using vcpu_info at c1609010
> 
> Timestamp jumped again. We can reproduce above issues on our Sandy
> Bridge machines.
> 
> After this, call trace and guest hang *maybe* observed on some machines:
> 
> [516383.019499] INFO: task xenwatch:12 blocked for more than 120
> seconds.
> [516383.019566] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [516383.019578] xenwatch      D c1610e20     0    12      2 0x00000000
> [516383.019591]  c781eec0 00000246 c1610e58 c1610e20 c781f300 c1441e20
> c1441e20 001cf000
> [516383.019605]  c781f07c c1610e20 00000000 00000001 c1441e20 c62e01c0
> c1610e20 c62e01c0
> [516383.019617]  c127e18e c781f07c c7830020 c7830020 c1441e20 c1441e20
> c127f2f1 c781f080
> [516383.019629] Call Trace:
> [516383.019640]  [<c127e18e>] ? schedule+0x78f/0x7dc
> [516383.019645]  [<c127f2f1>] ? _spin_unlock_irqrestore+0xd/0xf
> [516383.019649]  [<c127e4a1>] ? schedule_timeout+0x20/0xb0
> [516383.019656]  [<c100573c>] ? xen_force_evtchn_callback+0xc/0x10
> [516383.019660]  [<c127e3aa>] ? wait_for_common+0xa4/0x100
> [516383.019665]  [<c1033315>] ? default_wake_function+0x0/0x8
> [516383.019671]  [<c104a144>] ? kthread_stop+0x4f/0x8e
> [516383.019675]  [<c1047883>] ? cleanup_workqueue_thread+0x3a/0x45
> [516383.019679]  [<c1047903>] ? destroy_workqueue+0x56/0x85
> [516383.019684]  [<c106a395>] ? stop_machine_destroy+0x23/0x37
> [516383.019690]  [<c11962d8>] ? shutdown_handler+0x200/0x22f
> [516383.019694]  [<c1197439>] ? xenwatch_thread+0xdc/0x103
> [516383.019698]  [<c104a322>] ? autoremove_wake_function+0x0/0x2d
> [516383.019701]  [<c119735d>] ? xenwatch_thread+0x0/0x103
> [516383.019705]  [<c104a0f0>] ? kthread+0x61/0x66
> [516383.019709]  [<c104a08f>] ? kthread+0x0/0x66
> [516383.019714]  [<c1008d87>] ? kernel_thread_helper+0x7/0x10
> 
> But I _cannot_ reproduce the call trace and hang on our Sandy Bridge.
> 
> So I think there are maybe *two* bugs in this issue, one caused time
> jump(detail below), the other in the kernel triggered by the first bug
> sometime, thus result in migration fail.
> 
> I've spent some time to identify the timestamp jump issue, and finally
> found it's due to Invarient TSC (CPUID Leaf 0x80000007 EDX:8, also
> called non-stop TSC). The present of the feature would enable a
> parameter in the kernel named: sched_clock_stable. Seems this
> parameter is unable to work with Xen's pvclock. If
> sched_clock_stable() is set, value returned by xen_clocksource_read()
> would be returned as sched_clock_cpu() directly(rather than calculated
> through sched_clock_local()), but CMIIW the value returned by
> xen_clocksource_read() is based on host(vcpu) uptime rather than this
> VM's uptime, then result in the timestamp jump.
> 
> I've compiled a kernel, force sched_clock_stable=0, then it solved the
> timestamp jump issue as expected. Luckily, seems it also solved the
> call trace and guest hang issue as well.
> 
> I've posted a patch to mask the CPUID leaf 0x80000007 in Xen. I think
> the issue can be easily reproduced using a Westmere or SandyBridge
> machine(my old colleagues at Intel said the feature likely existed
> after Nehalem) running newer version of PV guest, check the guest
> cpuinfo you would see nonstop_tsc, and you would notice the abnormal
> timestamp of printk.

Yes definitely.  I thought that I implemented this properly for
PV but I think maybe it never got implemented for HVM?  See the section
titled "TSC INVARIANT BIT and NO_MIGRATE" in docs/misc/tscmode.txt in
the Xen source.

However, if "clocksource=tsc tsc=reliable" is selected for a HVM
domain, I think the results may be the same as if Invariant TSC
bit is checked by the Linux kernel?  So maybe the code for
readjusting the TSC to adjust to migration was also never implemented
in HVM, just in PV?  (I remember discussing this problem with Jun Nakajima
on an Oracle/Intel call a couple of years ago.  Maybe it was
discussed but never implemented... at the time, I was primarily
concerned with and tested only for PV as that was Oracle's
customer at the time.)

Anyway, please force "clocksource=tsc tsc=reliable" on your HVM
guest to see if it fails the same way as when the guest "sees"
the Invariant TSC bit is set.

Thanks,
Dan

P.S. The Invariant TSC bit *did* exist on Nehalem, however there
definitely exists old firmware that did not properly align the
TSCs across all cores on boot, so the bit was present but "lied".
Maybe you are seeing the problems on a Nehalem system with broken
firmware?  I know some Sun x86 systems shipped with broken
firmware, so it is very likely other system vendors did also.
