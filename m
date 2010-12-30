Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab0L3Skk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 13:40:40 -0500
Received: from smtp-out.google.com ([216.239.44.51]:17406 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab0L3Skj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 13:40:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=nRIQ7gYtxwI98ulm3ulaSQyrVJAIHKuoF+ED0E/+BXmiY9GFVOiXcnAtTtwp0d9nhp
         6207dCklHbdaql9kepFw==
Date: Thu, 30 Dec 2010 10:40:33 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        eric.dumazet@gmail.com, yinghai@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, Pekka Enberg <penberg@kernel.org>,
        shaohui.zheng@intel.com
Subject: Re: [PATCH 15/16] x86: Unify node_to_cpumask_map handling between
 32 and 64bit
In-Reply-To: <20101230145858.GE18831@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1012301028590.12207@chino.kir.corp.google.com>
References: <1293536929-31683-1-git-send-email-tj@kernel.org> <1293536929-31683-16-git-send-email-tj@kernel.org> <alpine.DEB.2.00.1012281240000.8883@chino.kir.corp.google.com> <20101230124800.GD18831@htj.dyndns.org> <20101230145858.GE18831@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Dec 2010, Tejun Heo wrote:

> > Sigh, the new NUMA emulation thing is 64bit only. :-( I'll see if it
> > can be applied to 32bit too.  BTW, how does this interact with the
> > Shaohui's patchset.  Isn't that about NUMA emulation too?  Are these
> > the same patches?
> 

Shaohui's patchset is for node hotplug emulation, not for NUMA emulation 
which has existed for x86_64 for at least over four years.

> Okay, after going through the changes, here are some thoughts FWIW.
> 
> I'm doubtful the direction was the correct one.  NUMA emulation,
> almost by definition, doesn't vary too much depending on the
> underlying hardware and how it's configured.  All that's necessary is
> the physical node map an apicid to nid mapping, which can and probably
> should be represented in common form regardless of emulation and the
> emulation code should simply manipulate the parsed information.
> 

And pxm mappings since node_distance() must reflect the physical topology 
on the emulated environment.  We have specialized callbacks in the amd and 
ACPI code to ascertain the physical topology because its discovery is 
handled differently, either with an implied set of possible nodes in the 
amd case and the statically-allocated nodes_parsed in the ACPI case, prior 
to actually onlining the nodes which is suppressed for NUMA emulation.

> The original implementation was 64bit apic specific.  If it needed to
> be extended to cover amd topology, the right way would be updating the
> apic and amd numa code so that they generate the information in a
> uniform way and NUMA emulation would follow naturally.

You could export an apicid-to-node and pxm-to-node mapping from both amd 
and ACPI code to do the actual remap, but it would still require seperate 
functions, amd_fake_nodes() and acpi_fake_nodes(), to determine what the 
mapping should be.  Instead of adding an additional layer of indirection, 
it's currently done in a single function depending on whether amd or acpi 
is being used.

> Instead, it
> looks like what happened was simply adding amd specific code with more
> gluing.  The unnecessary differences between acpi and amd paths sure
> aren't your fault but I really don't think we should be moving toward
> that direction when things can (and definitely should) be unified with
> a bit more effort.  NUMA code already is unnecessary hairy with
> 32/64bit and different subarchs somewhat unified but subtly differing
> in many places without clear indications.
> 

I agree that unification is in our best interest but the patches as they 
sit in x86/numa right now actually fix real bugs when using numa=fake on 
the command line and adding i386 NUMA emulation is an additional feature 
(and the unification that can be done in the meantime would only be the 
actual apicid-to-node and pxm-to-node mappings after it is exported from 
amd and acpi specific functions), so I'd prefer to handle cleanups as 
incremental patches on top of those.
