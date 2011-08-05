Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab1HEDyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 23:54:08 -0400
Received: from smtp-out.google.com ([74.125.121.67]:25677 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab1HEDyA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 23:54:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=osELm1uMwC89jH8SgA6InSdS2ijBygQCpCdVj77szVGDtvO4p2Weh4jZ7UEEmHbW0
	iwrqUwNd/lgjtyG/438dQ==
MIME-Version: 1.0
In-Reply-To: <20110727215816.GA2515@redhat.com>
References: <20110722003211.GA2807@redhat.com> <CAPM31R+UWijCCna5zYfn875h+KPmS4H0Lk8jW6+8JP-oDb72DA@mail.gmail.com>
 <20110722011747.GB2807@redhat.com> <CAPM31RKW+do-U8G8uL-y53BVWvr4oQbSf456A9u-SUV06tSfeg@mail.gmail.com>
 <20110727215816.GA2515@redhat.com>
From: Paul Turner <pjt@google.com>
Date: Thu, 4 Aug 2011 20:53:26 -0700
Message-ID: <CAPM31RKxBghZxcRyPLRv81Et0kxrYdBjzPohOONqHczr6EpDPA@mail.gmail.com>
Subject: Re: [RFT][patch 17/18] sched: use jump labels to reduce overhead when
 bandwidth control is inactive
To: Jason Baron <jbaron@redhat.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

< snip>

>
> Hi Paul,
>
> Ok, I think I finally tracked this down. It may seem a bit crazy, but
> when we are getting down to cycle counting like this, it seems that the
> link order in the kernel/Makefile can make difference. I had the
> jump_label.o listed after the core files, whereas all the code in
> jump_label.o is really slow path code (used when toggling branch
> values). As follows:
>
>
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -10,7 +10,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
>            kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
>            hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
>            notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
> -           async.o range.o jump_label.o
> +           async.o range.o
>  obj-y += groups.o
>
>  ifdef CONFIG_FUNCTION_TRACER
> @@ -107,6 +107,7 @@ obj-$(CONFIG_PERF_EVENTS) += events/
>  obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
>  obj-$(CONFIG_PADATA) += padata.o
>  obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
> +obj-$(CONFIG_JUMP_LABEL) += jump_label.o
>
>  ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
>  # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
>
>
> I've tested the patch using a single 'static_branch()' in the getppid() path,
> and basically running tight loops of calls to getppid(). Before, the
> patch, I was seeing results similar to what you reported, after the
> patch, things improved for all metrics. Here are my results for the
> branch disabled case:
>
> With jump labels turned on (CONFIG_JUMP_LABEL), branch disabled:
>
>  Performance counter stats for 'bash -c /tmp/timing;true' (50 runs):
>
>     3,969,510,217 instructions             #      0.864 IPC     ( +-0.000% )
>     4,592,334,954 cycles                     ( +-   0.046% )
>       751,634,470 branches                   ( +-   0.000% )
>
>        1.722635797  seconds time elapsed   ( +-   0.046% )
>
> Jump labels turned off (CONFIG_JUMP_LABEL not set), branch disabled:
>
>  Performance counter stats for 'bash -c /tmp/timing;true' (50 runs):
>
>     4,009,611,846 instructions             #      0.867 IPC     ( +-0.000% )
>     4,622,210,580 cycles                     ( +-   0.012% )
>       771,662,904 branches                   ( +-   0.000% )
>
>        1.734341454  seconds time elapsed   ( +-   0.022% )
>
>
> So all of the measured metrics improved in the jump labels case b/w
> 0.5% - 2.5%.
>
> I'm curious to see what you find with this patch.
>
> Thanks,
>
> -Jason
>

Hi Jason,

Thanks for taking a look at this.  Sorry, this took a few days to
benchmark all the permutations and we had some issues with internal
proxies which interrupted benchmarking runs.

Results and some analysis follow.

[
Key:

npo_XXX = with CONFIG_JUMP_LABEL, without link order patch (no patched order)
po_XXX = with CONFIG_JUMP_LABEL, with link order patch (patched order)
nojl_XXX = without CONFIG_JUMP_LABEL

Where "XXX" is
head: tip (c5bafb3) without patch series
cfs: tip + patch series - jump_label patch
cfs_jl: tip + patch series + jump_label for unconstrained

Test was repeated 3 times, each run was 50 repeats w/ typically ~<0.1
in-test variance on reported output
]

Considering just jump labels in tip, comparing against HEAD w/
!CONFIG_JUMP_LABEL

                           instructions            cycles
    branches              elapsed
---------------------------------------------------------------------------------------------------------------------
	Westmere:
njl_head.1                  798832892               722624737
     145375836             0.203218936   [baseline]
njl_head.2                  798888783 (+0.01)       746118188 (+3.25)
     145386807 (+0.01)     0.208573683 (-2.18)
njl_head.3                  798864253 (+0.00)       731537139 (+1.23)
     145382747 (+0.00)     0.204098175 (-4.28)
npo_head.1                  797033521 (-0.23)       731239359 (+1.19)
     144571358 (-0.55)     0.206910496 (-2.96)
npo_head.2                  797166434 (-0.21)       728926020 (+0.87)
     144603465 (-0.53)     0.202906392 (-4.84)
npo_head.3                  797165370 (-0.21)       725930458 (+0.46)
     144603438 (-0.53)     0.202118274 (-5.21)
po_head.1                   797019904 (-0.23)       699008145 (-3.27)
     144567652 (-0.56)     0.197272615 (-7.48)
po_head.2                   797037682 (-0.22)       705732419 (-2.34)
     144572115 (-0.55)     0.197101692 (-7.56)
po_head.3                   797079804 (-0.22)       698007668 (-3.41)
     144580964 (-0.55)     0.194871253 (-8.61)

	Barcelona:
njl_head.1                  816842028               748362637
     147462095             0.341654152
njl_head.2                  816849735 (+0.00)       748480742 (+0.02)
     147462652 (+0.00)     0.341450734 (-2.90)
njl_head.3                  816834963 (-0.00)       747083797 (-0.17)
     147460200 (-0.00)     0.340802353 (-3.09)
npo_head.1                  815068563 (-0.22)       775012690 (+3.56)
     146661357 (-0.54)     0.353797321 (+0.61)
npo_head.2                  815033261 (-0.22)       759613364 (+1.50)
     146654106 (-0.55)     0.346462671 (-1.48)
npo_head.3                  815029611 (-0.22)       762660196 (+1.91)
     146654169 (-0.55)     0.347565129 (-1.16)
po_head.1                   815026489 (-0.22)       767229109 (+2.52)
     146653376 (-0.55)     0.350241833 (-0.40)
po_head.2                   815035127 (-0.22)       770224495 (+2.92)
     146654019 (-0.55)     0.351352092 (-0.09)
po_head.3                   815109904 (-0.21)       774954096 (+3.55)
     146662020 (-0.54)     0.353505054 (+0.53)



With the patch to fix link-order we're typically faster and it's
probably time to modulate the configs so we get CONFIG_JUMP_LABEL by
default when CC_HAS_ASM_GOTO.

Considering Bandwidth control, comparing vs HEAD w/ CONFIG_JUMP_LABEL:

                            instructions            cycles
     branches              elapsed
---------------------------------------------------------------------------------------------------------------------
	Westmere:
po_head.1                   797019904               699008145
     144567652             0.197272615 [Baseline]
po_head.2                   797037682 (+0.00)       705732419 (+0.96)
     144572115 (+0.00)     0.197101692 (-4.91)
po_head.3                   797079804 (+0.01)       698007668 (-0.14)
     144580964 (+0.01)     0.194871253 (-5.98)
njl_cfs.1                   802649718 (+0.71)       708143552 (+1.31)
     146577437 (+1.39)     0.198770168 (-4.10)
njl_cfs.2                   802679078 (+0.71)       707486608 (+1.21)
     146582628 (+1.39)     0.197890812 (-4.53)
njl_cfs.3                   802647500 (+0.71)       704770712 (+0.82)
     146578141 (+1.39)     0.196742304 (-5.08)
npo_cfs.1                   800661523 (+0.46)       724068093 (+3.59)
     145774786 (+0.83)     0.204632700 (-1.27)
npo_cfs.2                   800646997 (+0.46)       718884486 (+2.84)
     145772293 (+0.83)     0.201248482 (-2.91)
npo_cfs.3                   800783171 (+0.47)       725140326 (+3.74)
     145804350 (+0.86)     0.203266025 (-1.93)
npo_cfs_jl.1                797304605 (+0.04)       687741762 (-1.61)
     143666256 (-0.62)     0.194302293 (-6.26)
npo_cfs_jl.2                797446281 (+0.05)       694066715 (-0.71)
     143700065 (-0.60)     0.194212118 (-6.30)
npo_cfs_jl.3                797374495 (+0.04)       697561774 (-0.21)
     143682692 (-0.61)     0.194935111 (-5.95)
po_cfs.1                    800631004 (+0.45)       715819643 (+2.41)
     145769677 (+0.83)     0.200007036 (-3.51)
po_cfs.2                    800642622 (+0.45)       698569729 (-0.06)
     145769973 (+0.83)     0.194625680 (-6.10)
po_cfs.3                    800752778 (+0.47)       707282749 (+1.18)
     145798992 (+0.85)     0.197047366 (-4.93)
po_cfs_jl.1                 797306617 (+0.04)       686329256 (-1.81)
     143666659 (-0.62)     0.193107369 (-6.83)
po_cfs_jl.2                 797434478 (+0.05)       677865445 (-3.02)
     143697712 (-0.60)     0.189314824 (-8.66)
po_cfs_jl.3                 797299055 (+0.04)       686371679 (-1.81)
     143665758 (-0.62)     0.191859014 (-7.44)

	Barcelona:
po_head.1                   815026489               767229109
     146653376             0.350241833 [Baseline]
po_head.2                   815035127 (+0.00)       770224495 (+0.39)
     146654019 (+0.00)     0.351352092 (-2.47)
po_head.3                   815109904 (+0.01)       774954096 (+1.01)
     146662020 (+0.01)     0.353505054 (-1.87)
njl_cfs.1                   820647075 (+0.69)       756895773 (-1.35)
     148663929 (+1.37)     0.345563962 (-4.07)
njl_cfs.2                   820672501 (+0.69)       761520373 (-0.74)
     148667815 (+1.37)     0.347529253 (-3.53)
njl_cfs.3                   820664350 (+0.69)       763400895 (-0.50)
     148666126 (+1.37)     0.348337223 (-3.30)
npo_cfs.1                   818629349 (+0.44)       758306455 (-1.16)
     147854452 (+0.82)     0.346678486 (-3.77)
npo_cfs.2                   818829256 (+0.47)       768393448 (+0.15)
     147891099 (+0.84)     0.350678075 (-2.65)
npo_cfs.3                   818697806 (+0.45)       772218715 (+0.65)
     147866720 (+0.83)     0.352333672 (-2.20)
npo_cfs_jl.1                815343935 (+0.04)       760127157 (-0.93)
     145753233 (-0.61)     0.347184970 (-3.62)
npo_cfs_jl.2                815415786 (+0.05)       775772068 (+1.11)
     145762961 (-0.61)     0.353965833 (-1.74)
npo_cfs_jl.3                815403187 (+0.05)       764048918 (-0.41)
     145761012 (-0.61)     0.348619922 (-3.23)
po_cfs.1                    819204964 (+0.51)       767156385 (-0.01)
     147959727 (+0.89)     0.350737982 (-2.64)
po_cfs.2                    818665676 (+0.45)       764324366 (-0.38)
     147860788 (+0.82)     0.348814489 (-3.17)
po_cfs.3                    818661849 (+0.45)       752288492 (-1.95)
     147859717 (+0.82)     0.343294319 (-4.70)
po_cfs_jl.1                 815336908 (+0.04)       765760248 (-0.19)
     145755155 (-0.61)     0.349608614 (-2.95)
po_cfs_jl.2                 815322295 (+0.04)       765613685 (-0.21)
     145751972 (-0.61)     0.349321663 (-3.03)
po_cfs_jl.3                 815310833 (+0.03)       759647967 (-0.99)
     145750118 (-0.62)     0.346607639 (-3.78)

Thanks to the magic of compiler re-organization we now report zero
overhead, in fact a speed-up is realized.

I will re-post v7.3 with:
- rebase to minor changes in tip
- removing RFT from adding jump_labels to CFS
- additional hierarchical period constraint

Thanks for looking into this Jason!

- Paul
