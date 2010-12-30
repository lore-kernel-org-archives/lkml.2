Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab0L3O7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 09:59:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59158 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab0L3O7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 09:59:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nVP03jk/q1lyM5YtEk3BuFArI4Q5+0BexyWyAF6TGcFXC+HwBTZRBokEtRtjeRDFak
         mrb5JjCBioYg5Aq+kow+xo8KGdD7ZDQ0jLiIvk9utOmg8skAQPk0RpW9YCes563H/VrL
         QqDlO9XyP6YlK0+r7nk0YJfpLYiWszk4epRC0=
Date: Thu, 30 Dec 2010 15:58:58 +0100
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        eric.dumazet@gmail.com, yinghai@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, Pekka Enberg <penberg@kernel.org>,
        shaohui.zheng@intel.com
Subject: Re: [PATCH 15/16] x86: Unify node_to_cpumask_map handling between
 32 and 64bit
Message-ID: <20101230145858.GE18831@htj.dyndns.org>
References: <1293536929-31683-1-git-send-email-tj@kernel.org>
 <1293536929-31683-16-git-send-email-tj@kernel.org>
 <alpine.DEB.2.00.1012281240000.8883@chino.kir.corp.google.com>
 <20101230124800.GD18831@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101230124800.GD18831@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Thu, Dec 30, 2010 at 01:48:00PM +0100, Tejun Heo wrote:
> On Tue, Dec 28, 2010 at 12:43:24PM -0800, David Rientjes wrote:
> > This has been almost entirely rewritten in x86/numa by c1c3443c ("x86, 
> > numa: Fake node-to-cpumask for NUMA emulation") and the pending fix 
> > http://marc.info/?l=linux-kernel&m=129340072128297 ("x86, numa: Fix 
> > CONFIG_DEBUG_PER_CPU_MAPS without NUMA").  Since this is only moving those 
> > functions to numa.c, it should be trivial to fix once based on x86/numa.
> 
> Sigh, the new NUMA emulation thing is 64bit only. :-( I'll see if it
> can be applied to 32bit too.  BTW, how does this interact with the
> Shaohui's patchset.  Isn't that about NUMA emulation too?  Are these
> the same patches?

Okay, after going through the changes, here are some thoughts FWIW.

I'm doubtful the direction was the correct one.  NUMA emulation,
almost by definition, doesn't vary too much depending on the
underlying hardware and how it's configured.  All that's necessary is
the physical node map an apicid to nid mapping, which can and probably
should be represented in common form regardless of emulation and the
emulation code should simply manipulate the parsed information.

The original implementation was 64bit apic specific.  If it needed to
be extended to cover amd topology, the right way would be updating the
apic and amd numa code so that they generate the information in a
uniform way and NUMA emulation would follow naturally.  Instead, it
looks like what happened was simply adding amd specific code with more
gluing.  The unnecessary differences between acpi and amd paths sure
aren't your fault but I really don't think we should be moving toward
that direction when things can (and definitely should) be unified with
a bit more effort.  NUMA code already is unnecessary hairy with
32/64bit and different subarchs somewhat unified but subtly differing
in many places without clear indications.

That said, Shaohui is already working on unifying the emulation code,
so I'll just do another quick dirty #ifdef'ing for the affected part.

Thank you.

-- 
tejun
