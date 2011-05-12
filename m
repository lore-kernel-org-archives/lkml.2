Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab1ELNip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 09:38:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757311Ab1ELNie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 09:38:34 -0400
Message-ID: <4DCBE2C9.20709@redhat.com>
Date: Thu, 12 May 2011 16:38:17 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH v1 0/5] KVM in-guest performance monitoring
References: <1305129333-7456-1-git-send-email-avi@redhat.com> <20110512093309.GD8707@8bytes.org> <4DCBAD8F.8030006@redhat.com> <20110512130644.GF8707@8bytes.org>
In-Reply-To: <20110512130644.GF8707@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2011 04:06 PM, Joerg Roedel wrote:
> On Thu, May 12, 2011 at 12:51:11PM +0300, Avi Kivity wrote:
> >  On 05/12/2011 12:33 PM, Joerg Roedel wrote:
>
> >>  Gaah, I was just about to submit a talk about PMU virtualization for KVM
> >>  Forum :)
> >
> >  Speed matters.
>
> I'll take that as an argument for paravirt pmu, because that one is
> certainly faster than anything we can emulate on-top of perf_events ;-)

Correct, though some massaging of perf_events can make it faster.  Still 
we'll pay with more exits with the architectural PMU.

Note a v2 PMU can reduce the exit count since it has MSRs for 
programming many PMCs at once.

> >  Note, at this time the architectural PMU is only recognized on an Intel
> >  host.
> >
> >  Is the statement "if an AMD processor returns non-zero information in
> >  cpuid leaf 0xa, then that processor will be compatible with other
> >  vendors' processors reporting the same information" correct?
>
> AMD processors don't implement that cpuid leaf.

Right.  But if an AMD processor were to implement that leaf, it would be 
in a compatible manner, yes?

That allows us to


-    if (vendor == intel && leaf_0xa_indicates_arch_pmu)
+    if (leaf_0xa_indicates_arch_pmu)

> >  If so, we can move the detection of the architectural pmu outside the
> >  cpu vendor checks, and this code will work on both AMD and Intel
> >  processors (even if the host cpu doesn't have an architectural PMU).
>
> Thats already some kind of paravirtualization. Don't get me wrong, I see
> the point of emulating a real pmu in the guest. But on the other side I
> think a interface that works across cpu models fits better into the KVM
> design, because KVM (oposed to other hypervisors) trys to hide details
> of the host cpu as much as necessary to get migration working between
> different cpus.
> And since pmu are, as you said, very model-specific, some abstraction is
> needed.

The architectural PMU is not model specific.

> In the end probably both ways can be implemented in parallel:
>
> 	* re-implementing the host-pmu using perf_events for -cpu host
> 	  guests
> 	* a paravirt pmu for everybody that wants migration and more
> 	  accurate results


A paravirt PMU also has to be implemented on top of perf_events.  
Otherwise we can't share this resource.  So the only question is what 
the interface looks like.  The arch pmu is non-optimized, but well 
specified and somewhat supported in guests.  A paravirt pmu is not so 
well specified at this point but can be faster (less exits).

-- 
error compiling committee.c: too many arguments to function

