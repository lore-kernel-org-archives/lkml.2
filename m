Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab2EVJgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 05:36:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757318Ab2EVJgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 05:36:16 -0400
Date: Tue, 22 May 2012 11:36:08 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 2/3] x86: x2apic/cluster: Make use of lowest priority
 delivery mode
Message-ID: <20120522093608.GA8382@dhcp-26-207.brq.redhat.com>
References: <20120518102640.GB31517@dhcp-26-207.brq.redhat.com>
 <CAE9FiQXUM-+KSZ1OcxipRW-3XQED3Csyxs=0ke0hJZR7E_hrhg@mail.gmail.com>
 <20120521081330.GB28930@dhcp-26-207.brq.redhat.com>
 <CAE9FiQUVJ3YHQfJ5i1fr8VU8-n_Rpd683DZ7M+54JwLk5kL_=g@mail.gmail.com>
 <CAE9FiQUA_hSA4wH6Sm93+yVty6X=Dq8UGinC7PNRcFcbpB3MpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQUA_hSA4wH6Sm93+yVty6X=Dq8UGinC7PNRcFcbpB3MpQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 04:33:03PM -0700, Yinghai Lu wrote:
> >>        *dest_id = apic->cpu_mask_to_apicid_and(mask, cfg->domain);
> >>
> >> So we really need to submit all possible CPUs here ^^^ to be able finding the
> >> best/heaviest cluster out of the 'mask'.
> >
> > ok.
> 
> Maybe you can not simply to change that to possible_cpu_mask.
> 
> otherwise assign_irq_vector will try to get same vector for all cpus
> for one irq.
> 
> then will make x2apic cluster mode will one support 224 irqs instead.

I am curious if we broke this threshold since the current design was introduced
in 2006? Not without an opposition from some notable maintainers ;)

> so you need to make vector_allocation_domain() to be less cpu set.

Yeah, reserving a vector for dozens of CPUs while up to eight will actually use
it seems an overkill. On the other hand, vector_allocation_domain() has been
either all-CPUs or single-CPU so far.

May be it is time to bring some intelligence here?

I.e. if we move cluster selection from cpu_mask_to_apicid{,_and}() to
vector_allocation_domain() ...

	void vector_allocation_domain(int cpu,
				      const struct cpumask *cpumask,
				      struct cpumask *retmask);

... then it seems nicely fits into __ioapic_set_affinity(). Have to ensure it,
though.

> 
> Yinghai

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
