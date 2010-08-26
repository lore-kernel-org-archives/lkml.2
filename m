Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab0HZBRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 21:17:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42272 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab0HZBRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 21:17:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=VsuAc7F8snyC0D1lOvgX8ZG1GAqdHBLvFmM2JmrQrswvyBpUx4sAGHWy7FQmhWphjf
         1KSfvHAyJ39U00YROM8dK2keBPMKu4TfSA4Ihy7wzeesXYNFzfLjVo5uZoAPdriOnxCB
         1JBZB8scvE4xGT1JFBYhyChdmstRGW1/UcopI=
MIME-Version: 1.0
Date: Wed, 25 Aug 2010 18:17:12 -0700
Message-ID: <AANLkTimT4T-6dO=Uo05DexYf3exq=0SkZemHuB5aRP3Q@mail.gmail.com>
Subject: divide by zero bug in find_busiest_group
From: Chetan Ahuja <chetan.ahuja@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has been filed as a bug in the kernel bugzilla
(https://bugzilla.kernel.org/show_bug.cgi?id=16991)
but the visibility on bugzilla seems low ( and the bugizlla server
seems to get overly "stressed" during
certain parts of the day)  so here's my "summary" of the discussion so
far. If for nothing else, so it gets
indexed by search engines etc.

We've seen a divide-by-zero crash  in the function  update_sg_lb_stats
(inlined into find_busiest_group) at the following location :

 /usr/src/linux/kernel/sched.c:3769
*balance = 0;
return;
}

/* Adjust by relative CPU power of the group */
sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) /
group->cpu_power;
aff5: 48 c1 e0 0a shl $0xa,%rax
aff9: 48 f7 f6 div %rsi

Apparently group->cpu_power can be zero under some conditions.

    I noticed  (what I thought was) a race condition between cpu_power
being initted to zero
(in build_xxx_groups functions in sched.c) and their use as
denominator in find_busiest/idlest_group
functions. PeterZ replied that there's a safe codepath from
build_*_groups functions to the crash
location  which guaranteed  a non-zero value.  I did express concern
that in absence of explicit
synchronization/mem-barriers we're at the mercy of compiler and
hardware doing us favors (by
 not re-ordering  instructions in an adverse way) for that guarantee.
But I don't think we got hit
 by the initial zeroes because all the crashes I saw happened after
many months of uptime.

  There's also another place group->cpu_power values gets updated
without any synchronization, in
the update_cpu_power function. Though the only way  this could result
in a bad value for cpu_power
is by  core A reading an in-transit value for a non-atomically-updated
64 bit value from core B :-). Unlikely ?
Very !!. Should we make that update explicity atomic ?  Would be prudent.

We do need more ideas on how the zero could have gotten there. The two
paths I mentioned above don't
provide that warm, fuzzy feeling yet.

Thanks
Chetan

P.S.

a)   kernel version (2.6.32 release from kernel.org. Though a similar
divide-by-zero has been
   reported as recently as 2.6.35 in a Ubuntu distribution kernel
here: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/615135
b) Hardware :  8 core nehalem (Intel E5520).. /proc/cpuinfo shows 16
"hyperthreaded" cores.

some relevant CONFIG settings:
CONFIG_NUMA=y
CONFIG_K8_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
# CONFIG_NUMA_EMU is not set
CONFIG_ACPI_NUMA=y
.
.
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_USER_SCHED is not set
CONFIG_CGROUP_SCHED=y

CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_HRTICK=y
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_SCHED_TRACER is not set
