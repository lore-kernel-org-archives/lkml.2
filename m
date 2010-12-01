Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab0LADT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 22:19:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:11096 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab0LADTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 22:19:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,282,1288594800"; 
   d="scan'208";a="862956072"
Subject: Re: [RFC PATCH 2/3 v2] perf: Implement Nehalem uncore pmu
From: Lin Ming <ming.m.lin@intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <AANLkTim5OHVDM6SXg5QS0QVFjDWTnyCKYFmt=OD9ZvOw@mail.gmail.com>
References: <1290340877.2245.124.camel@localhost>
	 <AANLkTikt8AkZjNahrzTStJ5qM0D4Z+H_7snZBgsABm24@mail.gmail.com>
	 <AANLkTimzEDXzF=hMzmNCvsPok1kqxd0vjNKuYur_+J5L@mail.gmail.com>
	 <AANLkTimN6_v6VibsNU70kV_QUnF4Fj0=M=Akp8aASE-3@mail.gmail.com>
	 <AANLkTikYsT=5qOTKTaQaf-OwdZDMkrfKWaSb=aDqgrrC@mail.gmail.com>
	 <AANLkTikB4WeBPn7PM=wkxYh5TpR4LQLBeLffq_3Lzv4n@mail.gmail.com>
	 <AANLkTim5OHVDM6SXg5QS0QVFjDWTnyCKYFmt=OD9ZvOw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 11:21:51 +0800
Message-ID: <1291173711.2405.223.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-26 at 18:06 +0800, Stephane Eranian wrote:
> On Fri, Nov 26, 2010 at 10:00 AM, Lin Ming <lin@ming.vg> wrote:
> > On Fri, Nov 26, 2010 at 4:33 PM, Stephane Eranian <eranian@google.com> wrote:
> >> Lin,
> >>
> >> Looked at the perfmon code, and it seems the mask is actual
> >> cores, not threads:
> >>                rdmsrl(MSR_NHM_UNC_GLOBAL_CTRL, val);
> >>                val |= 1ULL << (48 + cpu_data(smp_processor_id()).cpu_core_id);
> >>                wrmsrl(MSR_NHM_UNC_GLOBAL_CTRL, val);
> >>
> >> That seems to imply both threads will get the interrupt.
> >>
> >> In the the overflowed event was programmed from on of the two threads, that
> >> means one will process the overflow, the other will get spurious.
> >>
> >> On the cores where no uncore was programmed, then both threads will have
> >> a spurious interrupt.
> >
> > But in my test, if HT is on, only the 2 theads in one of the four cores
> > will receive the interrupt. Even worse, we don't know which core will
> > receive the interrupt
> > when overflow happens.
> >
> The MSR_NHM_UNC_GLOBAL_CTRL is per socket not per core.

Understood.

> 
> > I'll do more tests to verify this.
> 
> In your tests, are your programming the same uncore event
> across all CPUs? If so then you may have a race condition
> setting the MSR because it read-modify-write.
> 
> What about you program only one uncore event from one CPU?

This is what I tested, programming only one uncore event from one CPU.
When HT is off, all four cores in the socket receive the interrupt.
When HT is on, only the 2 threads in one of the four cores receive the
interrupt.

