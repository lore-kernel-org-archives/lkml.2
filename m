Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964776Ab2HWRPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:15:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:56534 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758810Ab2HWRPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:15:08 -0400
Date: Thu, 23 Aug 2012 19:14:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Attilio Rao <attilio.rao@citrix.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH v4 1/2] XEN/X86: Improve semantic support for
 x86_init.mapping.pagetable_reserve
In-Reply-To: <50364FE5.1070608@citrix.com>
Message-ID: <alpine.LFD.2.02.1208231800530.2856@ionos>
References: <1345648122-11935-1-git-send-email-attilio.rao@citrix.com> <1345648122-11935-2-git-send-email-attilio.rao@citrix.com> <alpine.LFD.2.02.1208231722040.2856@ionos> <50364FE5.1070608@citrix.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2012, Attilio Rao wrote:
> On 23/08/12 16:46, Thomas Gleixner wrote:
> > On Wed, 22 Aug 2012, Attilio Rao wrote:
> > 
> >    
> > > - Allow xen_mapping_pagetable_reserve() to handle a start different from
> > >    pgt_buf_start, but still bigger than it.
> > >      
> > What's the purpose of this and how is this going to be used and how is
> > it useful at all?
> >    
> 
> (Just replying here as all the other your comments are derivative)
> Looks like you are missing the whole point of the patch.
> What the patch is supposed to do is just to "enforce a correct semantic for
> the setup function" and not fix an actual problem found in the code.
> This means that after the patch you know exactly what expect in terms of
> semantic by the function and the callers will work following it.
> 
> Otherwise, what could happen is that if one day for a reason or another begin
> start being different from pgt_buf_start this function will just break
> silently, reintroducing the original problem in a different form.

Which original problem?

> I think this was clarified by the 0/2 but evidently you completely missed it.

No, I did not miss it. And it's still not telling what the whole thing
is about. 

There is no reason why start should ever be different. So your whole
argument is that someone might change the call site of
x86_init.mapping.pagetable_reserve().

And then you tell in 1/2 changelog:

 - Allow xen_mapping_pagetable_reserve() to handle a start different from
   pgt_buf_start, but still bigger than it.

without giving a rationale why this is necessary and why this can ever
happen. It's wrong to begin with to feed that function something else
than pgt_buf_start, period.

Don't misunderstand me. I'm not against documenting and not against
making code safe and less error prone, but we do not add checks just
because some moron might change the callee arguments to random
nonsense or because some tinkerer might use the same function for
something else.

Following your argumentation we'd need to plaster the kernel code with
sanity checks. This is not a random Java API used by a gazillion of
code monkeys; it's low level architecture code and not a driver
API. People who touch that code should better know what they are
doing.

What you are doing is actively wrong. You suggest that it's fine to
call that function with something different than pgt_buf_start as the
start argument. That's complete nonsense. The early pages are
allocated bottom up beginning at pgt_buf_start. So what the heck would
make it sane to change that argument ever?

Thanks,

	tglx

