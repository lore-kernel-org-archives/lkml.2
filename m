Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab0KRUES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:04:18 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58022 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab0KRUER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:04:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vitrVhWcCk7TTOv5BaiyqpHLvnXB5Kxh9QaXsdEpZfFN9PaFxss05NiWqZhuuZOsE9
         +7R+9xEeALk0AhXQVndacKD4YMznAbRWxP/yTndyoX/Frz627L3PW5EJmpne++Tq/tat
         QrR5UKjaoDIHnGib7gxecyUv5ua5e0uKHNQ5Q=
Date: Thu, 18 Nov 2010 23:04:11 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
Message-ID: <20101118200411.GB6028@lenovo>
References: <4CDD6389.2080206@windriver.com> <20101112161144.GP4823@redhat.com> <4CDD6CAD.30303@windriver.com> <20101112172755.GR4823@redhat.com> <20101116184325.GB4823@redhat.com> <4CE2E3C3.6060800@windriver.com> <20101118080516.GJ32621@elte.hu> <4CE52048.5080802@windriver.com> <1290086232.2109.1507.camel@laptop> <20101118193247.GF18100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118193247.GF18100@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 02:32:47PM -0500, Don Zickus wrote:
> On Thu, Nov 18, 2010 at 02:17:12PM +0100, Peter Zijlstra wrote:
> > On Thu, 2010-11-18 at 06:47 -0600, Jason Wessel wrote:
> > > More specifically
> > > when another subsystem injects an NMI event the perf NMI code returns
> > > NOTIFY_STOP. 
> > 
> > Not unconditionally, right? We only do so when the previous NMI was from
> > the PMU and nobody claimed this one (NOTIFY_STOP from DIE_NMIUNKNOWN).
> > 
> > Or are you hitting the other one, where !handled but pmu_nmi.handled >
> > 1 ?
> 
> I think the problem with the virt stuff is that it emulates 0 to the
> rdmsrl calls.  All platforms except perf_events_intel.c rely on checking
> the high bit of the counter register to not be zero, otherwise the code
> thinks it crossed zero and triggered an PMI.
> 
> The intel code is a litte smarter and relies on the interrupt logic and
> thus doesn't have this problem (to clarify only core2 and later use this,
> p4 and p6 use the old methods).
> 
> So the problem is when the nmi watchdog is enabled, the perf event is
> 'active' and thus tries to read the counter value.  Because it is always
> zero, perf just assumes the counter overflowed and the NMI is his.
> 
> Not sure how to fix it yet, other than include the logic that detects we
> are on a guest and disable perf??
> 
> On a side note I think I have a fix for the p4 problem but will probably
> need Cyril to look at it.  Basically in, p4_pmu_clear_cccr_ovf() it is
> using the high part of the cccr register to determine if the counter
> overflowed, when it probably wants to use the low bits of the cccr
> register and high bits of the event_base.
> 
> Cheers,
> Don
>

good observation Don! One of the problem is that some overflow may happen
without setting 'overflow' control bit but have to check the high bits.
not sure I follow the kvm part, you mean rdmsrl returns 0?
 
  Cyrill
