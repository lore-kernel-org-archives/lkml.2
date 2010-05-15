Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab0EONaq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 09:30:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27647 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab0EONao convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 09:30:44 -0400
MIME-Version: 1.0
Message-ID: <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default>
Date: Sat, 15 May 2010 06:29:25 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Andi Kleen <andi@firstfloor.org>, Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: RE: [PATCH] x86: Export tsc related information in sysfs
References: <1273887635-27610-1-git-send-email-venki@google.com
 87tyq9mqrz.fsf@basil.nowhere.org>
In-Reply-To: <87tyq9mqrz.fsf@basil.nowhere.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090208.4BEEA1C8.011A:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andi Kleen [mailto:andi@firstfloor.org]
>
> > Kernel information about calibrated value of tsc_khz and
> > tsc_stability (result of tsc warp test) are useful bits of
> information
> > for any app that wants to use TSC directly. Export this read_only
> > information in sysfs.
> 
> Is this really a good idea?  It will encourage the applications
> to use RDTSC directly, but there are all kinds of constraints on

Indeed, that is what it is intended to do.

> that. Even the kernel has a hard time with them, how likely
> is it that applications will get all that right?

That's the point of exposing the tsc_reliable kernel data.
If the processor has Invariant TSC and the system has
successfully passed Ingo's warp test and, as a result
the kernel is using TSC as a clocksource, why not enable
userland apps that need to obtain timestamp data
tens or hundreds of thousands of times per second to
also use the TSC directly?
 
> It would be better to fix them to use the vsyscalls instead.
> Or if they can't use the vsyscalls for some reason today fix them.

The problem is from an app point-of-view there is no vsyscall.
There are two syscalls: gettimeofday and clock_gettime.  Sometimes,
if it gets lucky, they turn out to be very fast and sometimes
it doesn't get lucky and they are VERY slow (resulting in a performance
hit of 10% or more), depending on a number of factors completely
out of the control of the app and even undetectable to the app.

Note also that even vsyscall with TSC as the clocksource will
still be significantly slower than rdtsc, especially in the
common case where a timestamp is directly stored and the
delta between two timestamps is later evaluated; in the
vsyscall case, each timestamp is a function call and a convert
to nsec but in the TSC case, each timestamp is a single
instruction.

> This way if anything changes again in TSC the kernel could
> shield the applications.

If tsc_reliable is 1, the system and the kernel are guaranteeing
to the app that nothing will change in the TSC.  In an Invariant
TSC system that has passed Ingo's warp test (to eliminate the
possibility of a fixed interprocessor TSC gap due to a broken BIOS
in a multi-node NUMA system), if anything changes in the clock
signal that drives the TSC, the system is badly broken and far
worse things -- like inter-processor cache incoherency -- may happen.

Is it finally possible to get past the horrible SMP TSC problems
of the past and allow apps, under the right conditions, to be able
to use rdtsc again? This patch argues "yes".
