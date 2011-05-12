Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab1ELNb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 09:31:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757064Ab1ELNb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 09:31:57 -0400
Message-ID: <4DCBE13A.2050204@redhat.com>
Date: Thu, 12 May 2011 16:31:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Jan Kiszka <jan.kiszka@siemens.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v1 0/5] KVM in-guest performance monitoring
References: <1305129333-7456-1-git-send-email-avi@redhat.com> <20110512093309.GD8707@8bytes.org> <4DCBACC7.8080000@siemens.com> <20110512131130.GG8707@8bytes.org>
In-Reply-To: <20110512131130.GG8707@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2011 04:11 PM, Joerg Roedel wrote:
> On Thu, May 12, 2011 at 11:47:51AM +0200, Jan Kiszka wrote:
> >  On 2011-05-12 11:33, Joerg Roedel wrote:
>
> >  >  Anyway, I thought about a paravirt-approach instead of implementing a
> >  >  real PMU... But there are certainly good reasons for both.
> >
> >  Paravirt is taking away the pressure from CPU vendors to do their virt
> >  extensions properly - and doesn't help with unmodifiable OSes.
>
> Seriously, I think such decisions should be technical only and not
> political like that. The losers of such political decisions are always
> the users because they don't get useful features that are technical
> possible.

I agree.  But there are technical advantages to using architectural 
features instead of paravirt:

- when the cpu gains support for virtualizing the architectural feature, 
we transparently speed the guest up, including support for live 
migrating from a deployment that emulates the feature to a deployment 
that properly virtualizes the feature, and back.  Usually the 
virtualized support will beat the pants off any paravirtualization we can do
- following an existing spec is a lot easier to get right than doing 
something from scratch
- no need to meticulously document the feature
- easier testing
- existing guest support - only need to write the host side (sometimes 
the only one available to us)

We saw all that with the move from shadow paging to nested paging.  We 
had paravirt support which turned out to be poorly documented, had a 
security issue, and would have been slower on npt.  In the end we ripped 
it out.

Paravirtualizing does have its advantages.  For the PMU, for example, we 
can have a single hypercall read and reprogram all counters, saving 
*many* exits.  But I think we need to start from the architectural PMU 
and see exactly what the problems are, before we optimize it to death.

-- 
error compiling committee.c: too many arguments to function

