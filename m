Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab0DTM7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 08:59:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048Ab0DTM7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 08:59:07 -0400
Date: Tue, 20 Apr 2010 09:59:02 -0300
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
Message-ID: <20100420125902.GJ14158@mothafucka.localdomain>
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>
 <1271356648-5108-2-git-send-email-glommer@redhat.com>
 <4BC8CA52.4090703@goop.org>
 <20100419142624.GE14158@mothafucka.localdomain>
 <4BCC829A.6000803@goop.org>
 <20100419182542.GI14158@mothafucka.localdomain>
 <20100420015733.GA28249@amt.cnet>
 <4BCD7557.9090502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCD7557.9090502@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 12:35:19PM +0300, Avi Kivity wrote:
> On 04/20/2010 04:57 AM, Marcelo Tosatti wrote:
> >
> >>Marcelo can probably confirm it, but he has a nehalem with an appearently
> >>very good tsc source. Even this machine warps.
> >>
> >>It stops warping if we only write pvclock data structure once and forget it,
> >>(which only updated tsc_timestamp once), according to him.
> >Yes. So its not as if the guest visible TSCs go out of sync (they don't
> >on this machine Glauber mentioned, or even on a multi-core Core 2 Duo),
> >but the delta calculation is very hard (if not impossible) to get right.
> >
> >The timewarps i've seen were in the 0-200ns range, and very rare (once
> >every 10 minutes or so).
> 
> Might be due to NMIs or SMIs interrupting the rdtsc(); ktime_get()
> operation which establishes the timeline.  We could limit it by
> having a loop doing rdtsc(); ktime_get(); rdtsc(); and checking for
> some bound, but it isn't worthwhile (and will break nested
> virtualization for sure).  Better to have the option to calibrate
> kvmclock just once on machines with
> X86_FEATURE_NONSTOP_TRULY_RELIABLE _TSC_HONESTLY.
For the record, we can only even do that in those machines. If we try to update
time structures only once in machines with the 
X86_FEATURE_TSC_SAYS_IT_IS_OKAY_BUT_IN_REALITY_IS_NOT_OKAY feature flag, guests
won't even boot.

We can detect that, and besides doing calculation only once, also export some
bit indicating that to the guest. Humm... I'm thinking now, that because of
migration, we should check this bit every time, because we might have changed host.
So instead of using an expensive cpuid check, we should probably use some bit in
the vcpu_time_info structure, and use a cpuid bit just to say it is enabled.

Jeremy,

are you okay in turning one of the pad fields in the structure into a flags field?
