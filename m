Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab2HXLhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 07:37:25 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47025 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab2HXLhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 07:37:21 -0400
Date: Fri, 24 Aug 2012 07:36:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@alien8.de>, Attilio Rao <attilio.rao@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH v4 1/2] XEN/X86: Improve semantic support for
 x86_init.mapping.pagetable_reserve
Message-ID: <20120824113644.GE11007@konrad-lan.dumpdata.com>
References: <1345648122-11935-1-git-send-email-attilio.rao@citrix.com>
 <1345648122-11935-2-git-send-email-attilio.rao@citrix.com>
 <alpine.LFD.2.02.1208231722040.2856@ionos>
 <50364FE5.1070608@citrix.com>
 <alpine.LFD.2.02.1208231800530.2856@ionos>
 <503664C3.7010301@citrix.com>
 <20120824100309.GG3019@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120824100309.GG3019@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 12:03:09PM +0200, Borislav Petkov wrote:
> On Thu, Aug 23, 2012 at 06:13:39PM +0100, Attilio Rao wrote:
> > You seriously think that adding a single-check, that will be
> > certainly skipped (now), in a boot-time function is going to add any
> > performance burden?
> > 
> > >What you are doing is actively wrong. You suggest that it's fine to
> > >call that function with something different than pgt_buf_start as the
> > >start argument. That's complete nonsense. The early pages are
> > >allocated bottom up beginning at pgt_buf_start. So what the heck would
> > >make it sane to change that argument ever?
> > 
> > If you really don't like this approach, at this point I think the
> > best thing to do is to assume that the start address will be
> > pgt_buf_start and loose the starting argument at all.
> > If you agree I can make a patch for that.
> 
> One thing I don't understand is why is xen touching x86 code when it
> doesn't have to? At least I cannot find a single reason for it in this
> thread.

Has this discussion gotten off the wrong track... The underlaying reason
for this x86_init.mapping.pagetable_reserve is to fix Xen guests from
crashing at bootup time b/c the pagetables that were hooked up were not
labeled as RO (but as RW). The git commit for the line in question
should say that. There was also a lengthy discussion about this and
why other attempts (like sticking the check in xen_set_pte_init and
not have pagetable_reserve) did not work. And Stefano also posted a
patch series that would remove the x86_init.mapping.pagetable_reserve
and change the logic in the earlier code to determine the _exact_ size
of the pagetable that is required. Ingo liked it, but Peter was not to
thrilled (or maybe he was OK but that was the timeline when his son was
born) and decided that we will stick with the
x86_init.mapping.pagetable_reserve for now.

(Sorry about not posting the links to the discussions - will to that in
a couple of hours).

> 
> Thomas is clearly explaining to you that what you're trying to
> enforce cannot happen on baremetal x86 and you're still insisting on
> "documenting" that.

His goal was to document the semantics of the call. We all want to clean
up the mess of extra calls that don't make sense (remember the
write_msr_safe one?) and the first step is get some of the calls
documented so that we know if some of these calls can be moved around
for refactoring. Attilio went then beyond that being enthuastic about
this and wrote logic to deal with the description of the semantics.
In part this would help the refactoring as it would catch runtime
issues.

So if you just consider the "documentation" part then only part of his
patch makes sense.

> 
> Here's a simple answer: if it doesn't fix a bug on x86 baremetal (and
> you're changing x86 native code only for the sake of xen), there's no
> reason wasting energy to create patches.

That is at odds with what Peter would like to have fixed:
(from
http://lists.linux-foundation.org/pipermail/ksummit-2012-discuss/2012-June/000070.html)
"
   Hooks and notifiers are a form of "COME FROM" programming, and they
   make it very hard to reason about the code.  The only way that that
   can be reasonably mitigated is by having the exact semantics of a
   hook or notifier -- the preconditions, postconditions, and other
   invariants -- carefully documented.  Experience has shown that in
   practice that happens somewhere between rarely and never.

   Hooks that terminate into hypercalls or otherwise are empty in the
   "normal" flow are particularly problematic, as it is trivial for a
   mainstream developer to break them.
"

> 
> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.
