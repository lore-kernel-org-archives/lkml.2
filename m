Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab1G0V6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:58:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755672Ab1G0V6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:58:38 -0400
Date: Wed, 27 Jul 2011 17:58:17 -0400
From: Jason Baron <jbaron@redhat.com>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        rth@redhat.com
Subject: Re: [RFT][patch 17/18] sched: use jump labels to reduce overhead
 when bandwidth control is inactive
Message-ID: <20110727215816.GA2515@redhat.com>
References: <20110722003211.GA2807@redhat.com>
 <CAPM31R+UWijCCna5zYfn875h+KPmS4H0Lk8jW6+8JP-oDb72DA@mail.gmail.com>
 <20110722011747.GB2807@redhat.com>
 <CAPM31RKW+do-U8G8uL-y53BVWvr4oQbSf456A9u-SUV06tSfeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPM31RKW+do-U8G8uL-y53BVWvr4oQbSf456A9u-SUV06tSfeg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 06:38:01PM -0700, Paul Turner wrote:
> On Thu, Jul 21, 2011 at 6:17 PM, Jason Baron <jbaron@redhat.com> wrote:
> > On Thu, Jul 21, 2011 at 05:57:31PM -0700, Paul Turner wrote:
> >> On Thu, Jul 21, 2011 at 5:32 PM, Jason Baron <jbaron@redhat.com> wrote:
> >> > rth@redhat.com
> >> > Bcc:
> >> > Subject: Re: [RFT][patch 17/18] sched: use jump labels to reduce overhead
> >> >  when bandwidth control is inactive
> >> > Reply-To:
> >> > In-Reply-To: <20110721184758.403388616@google.com>
> >> >
> >> > On Thu, Jul 21, 2011 at 09:43:42AM -0700, Paul Turner wrote:
> >> >> So I'm seeing some strange costs associated with jump_labels; while on paper
> >> >> the branches and instructions retired improves (as expected) we're taking an
> >> >> unexpected hit in IPC.
> >> >>
> >> >> [From the initial mail we have workloads:
> >> >>   mkdir -p /cgroup/cpu/test
> >> >>   echo $$ > /dev/cgroup/cpu/test (only cpu,cpuacct mounted)
> >> >>   (W1) taskset -c 0 perf stat --repeat 50 -e instructions,cycles,branches bash -c "for ((i=0;i<5;i++)); do $(dirname $0)/pipe-test 20000; done"
> >> >>   (W2)taskset -c 0 perf stat --repeat 50 -e instructions,cycles,branches bash -c "$(dirname $0)/pipe-test 100000;true"
> >> >>   (W3)taskset -c 0 perf stat --repeat 50 -e instructions,cycles,branches bash -c "$(dirname $0)/pipe-test 100000;"
> >> >> ]
> >> >>
> >> >> To make some of the figures more clear:
> >> >>
> >> >> Legend:
> >> >> !BWC = tip + bwc, BWC compiled out
> >> >> BWC = tip + bwc
> >> >> BWC_JL = tip + bwc + jump label (this patch)
> >> >>
> >> >>
> >> >> Now, comparing under W1 we see:
> >> >> W1: BWC vs BWC_JL
> >> >>                             instructions            cycles                  branches              elapsed
> >> >> ---------------------------------------------------------------------------------------------------------------------
> >> >> clovertown [BWC]            845934117               974222228               152715407             0.419014188 [baseline]
> >> >> +unconstrained              857963815 (+1.42)      1007152750 (+3.38)       153140328 (+0.28)     0.433186926 (+3.38)  [rel]
> >> >> +10000000000/1000:          876937753 (+2.55)      1033978705 (+5.65)       160038434 (+3.59)     0.443638365 (+5.66)  [rel]
> >> >> +10000000000/1000000:       880276838 (+3.08)      1036176245 (+6.13)       160683878 (+4.15)     0.444577244 (+6.14)  [rel]
> >> >>
> >> >> barcelona [BWC]             820573353               748178486               148161233             0.342122850 [baseline]
> >> >> +unconstrained              817011602 (-0.43)       759838181 (+1.56)       145951513 (-1.49)     0.347462571 (+1.56)  [rel]
> >> >> +10000000000/1000:          830109086 (+0.26)       770451537 (+1.67)       151228902 (+1.08)     0.350824677 (+1.65)  [rel]
> >> >> +10000000000/1000000:       830196206 (+0.30)       770704213 (+2.27)       151250413 (+1.12)     0.350962182 (+2.28)  [rel]
> >> >>
> >> >> westmere [BWC]              802533191               694415157               146071233             0.194428018 [baseline]
> >> >> +unconstrained              799057936 (-0.43)       751384496 (+8.20)       143875513 (-1.50)     0.211182620 (+8.62)  [rel]
> >> >> +10000000000/1000:          812033785 (+0.27)       761469084 (+8.51)       149134146 (+1.09)     0.212149229 (+8.28)  [rel]
> >> >> +10000000000/1000000:       811912834 (+0.27)       757842988 (+7.45)       149113291 (+1.09)     0.211364804 (+7.30)  [rel]
> >> >> e.g. Barcelona issues ~0.43% less instructions, for a total of 817011602, in
> >> >> the unconstrained case with BWC.
> >> >>
> >> >>
> >> >> Where "unconstrained, 10000000000/1000, 10000000000/10000" are the on
> >> >> measurements for BWC_JL, with (%d) being the relative difference to their
> >> >> BWC counterparts.
> >> >>
> >> >> W1: BWC vs BWC_JL is very similar.
> >> >>       BWC vs BWC_JL
> >> >> clovertown [BWC]            985732031              1283113452               175621212             1.375905653
> >> >> +unconstrained              979242938 (-0.66)      1288971141 (+0.46)       172122546 (-1.99)     1.389795165 (+1.01)  [rel]
> >> >> +10000000000/1000:          999886468 (+0.33)      1296597143 (+1.13)       180554004 (+1.62)     1.392576770 (+1.18)  [rel]
> >> >> +10000000000/1000000:       999034223 (+0.11)      1293925500 (+0.57)       180413829 (+1.39)     1.391041338 (+0.94)  [rel]
> >> >>
> >> >> barcelona [BWC]             982139920              1078757792               175417574             1.069537049
> >> >> +unconstrained              965443672 (-1.70)      1075377223 (-0.31)       170215844 (-2.97)     1.045595065 (-2.24)  [rel]
> >> >> +10000000000/1000:          989104943 (+0.05)      1100836668 (+0.52)       178837754 (+1.22)     1.058730316 (-1.77)  [rel]
> >> >> +10000000000/1000000:       987627489 (-0.32)      1095843758 (-0.17)       178567411 (+0.84)     1.056100899 (-2.28)  [rel]
> >> >>
> >> >> westmere [BWC]              918633403               896047900               166496917             0.754629182
> >> >> +unconstrained              914740541 (-0.42)       903906801 (+0.88)       163652848 (-1.71)     0.758050332 (+0.45)  [rel]
> >> >> +10000000000/1000:          927517377 (-0.41)       952579771 (+5.67)       170173060 (+0.75)     0.771193786 (+2.43)  [rel]
> >> >> +10000000000/1000000:       914676985 (-0.89)       936106277 (+3.81)       167683288 (+0.22)     0.764973632 (+1.38)  [rel]
> >> >>
> >> >> Now this is rather odd, almost across the board we're seeing the expected
> >> >> drops in instructions and branches, yet we appear to be paying a heavy IPC
> >> >> price.  The fact that wall-time has scaled equivalently with cycles roughly
> >> >> rules out the cycles counter being off.
> >> >>
> >
> > if i understand your results, for barcelona you did see an improvement
> > in cycles and eslapsed time with jump labels for unconstrained?
> >
> 
> Under W2, yes.
> 
> >> >> We are seeing the expected behavior in the bandwidth enabled case;
> >> >> specifically the <jl=jmp><ret><cond><ret> blocks are taking an extra branch
> >> >> and instruction which shows up on all the numbers above.
> >> >>
> >> >> With respect to compiler mangling the text is essentially unchanged in size.
> >> >> One lurking suspicion is whether the inserted nops have perturbed some of the
> >> >> jmp/branch alignments?
> >
> > hmmmm....not sure, I'm adding Richard Henderson, to the 'cc list, who
> > worked on the 'asm goto' in gcc.
> >
> >> >>
> >> >>     text    data     bss     dec     hex filename
> >> >>  7277206 2827256 2125824 12230286         ba9e8e vmlinux.jump_label
> >> >>  7276886 2826744 2125824 12229454         ba9b4e vmlinux.no_jump_label
> >> >>
> >
> > the other thing here is that vmlinux.jump_label includes the extra
> > kernel/jump_label.o file, so you can sort of subtract the text size of
> > that file to do a fair comparison.
> 
> Even without doing that it's only a 1.00004% change in text size.
> 
> I was just making the inference that if it's gcc mangling it's likely
> in the layout/alignment.
> 
> >
> > Also, I would have expected the data section to have increased more with
> > jump labels enabled. Are tracepoints disabled (a current user of jump
> > labels).
> 
> Yeah -- Tracing is enabled so the BWC build should have labels
> already; this likely accounts for the small increase noted above.
> 
> >
> >> >>  I have checked to make sure that the right instructions are being patched in
> >> >>  at run-time.  I've also pulled a fully patched jump_label out of the kernel
> >> >>  into a userspace test (and benchmarked it directly under perf).  The results
> >> >>  here are also exactly as expected.
> >> >>
> >> >> e.g.
> >> >>  Performance counter stats for './jump_test':
> >> >>      1,500,839,002 instructions, 300,147,081 branches 702,468,404 cycles
> >> >> Performance counter stats for './jump_test 1':
> >> >>      2,001,014,609 instructions, 400,177,192 branches 901,758,219 cycles
> >> >>
> >
> > what no-op did you use in userspace? I wouldn't think the no-op choice
> > would make any difference though...At compile time we use a 'jmp 0', and
> > then at boot we dynamically patch the 'jmp 0' with the no-op we think works
> > best...
> >
> 
> Sorry -- what I meant here is I pulled the run-time chosen "best" nop
> out of /proc/kcore and tested a
> tight loop about a <JL><RET><COND><RET> sequence (e.g.
> cfs_rq_throttled()) with JL being the nop and jmp respectively.
> 
> Specifically for Westmere this ends up being K8_NOP5  -- 0x666666D0
> 
> > thanks,
> >
> > -Jason
> >
> >> >> Overall if we can fix the IPC the benefit in the globally unconstrained case
> >> >> looks really good.
> >> >>
> >> >> Any thoughts Jason?
> >> >>
> >> >
> >> > Do you have CONFIG_CC_OPTIMIZE_FOR_SIZE set? I know that when
> >> > CONFIG_CC_OPTIMIZE_FOR_SIZE is not set, the compiler can make the code
> >> > more optimal.
> >> >
> >>
> >> Ah I should have mentioned that was one of the holes I stared down:
> >>
> >> Builds were -O2 (gcc-4.6.1) and
> >> $  zcat /proc/config.gz | grep CONFIG_CC_OPTIMIZE_FOR_SIZE
> >> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> >>
> >> Same kernel image across all platforms.
> >>
> >>

Hi Paul,

Ok, I think I finally tracked this down. It may seem a bit crazy, but
when we are getting down to cycle counting like this, it seems that the
link order in the kernel/Makefile can make difference. I had the
jump_label.o listed after the core files, whereas all the code in
jump_label.o is really slow path code (used when toggling branch
values). As follows:


--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
-	    async.o range.o jump_label.o
+	    async.o range.o
 obj-y += groups.o
 
 ifdef CONFIG_FUNCTION_TRACER
@@ -107,6 +107,7 @@ obj-$(CONFIG_PERF_EVENTS) += events/
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
 obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
+obj-$(CONFIG_JUMP_LABEL) += jump_label.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is


I've tested the patch using a single 'static_branch()' in the getppid() path,
and basically running tight loops of calls to getppid(). Before, the
patch, I was seeing results similar to what you reported, after the
patch, things improved for all metrics. Here are my results for the
branch disabled case:

With jump labels turned on (CONFIG_JUMP_LABEL), branch disabled:

 Performance counter stats for 'bash -c /tmp/timing;true' (50 runs):

     3,969,510,217 instructions             #      0.864 IPC     ( +-0.000% )
     4,592,334,954 cycles                     ( +-   0.046% )
       751,634,470 branches                   ( +-   0.000% )

        1.722635797  seconds time elapsed   ( +-   0.046% )

Jump labels turned off (CONFIG_JUMP_LABEL not set), branch disabled:

 Performance counter stats for 'bash -c /tmp/timing;true' (50 runs):

     4,009,611,846 instructions             #      0.867 IPC     ( +-0.000% )
     4,622,210,580 cycles                     ( +-   0.012% )
       771,662,904 branches                   ( +-   0.000% )

        1.734341454  seconds time elapsed   ( +-   0.022% )


So all of the measured metrics improved in the jump labels case b/w
0.5% - 2.5%. 

I'm curious to see what you find with this patch.

Thanks,

-Jason


