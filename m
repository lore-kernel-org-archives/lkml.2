Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab0IVPn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 11:43:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240Ab0IVPn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 11:43:58 -0400
Date: Wed, 22 Sep 2010 11:43:10 -0400
From: Jason Baron <jbaron@redhat.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Andi Kleen <andi@firstfloor.org>, rusty@rustcorp.co.au,
        rostedt@goodmis.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        hpa@zytor.com, tglx@linutronix.de, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] Rewrite jump_label.c to use binary search
Message-ID: <20100922154310.GE2816@redhat.com>
References: <1285150102-5506-1-git-send-email-andi@firstfloor.org> <1285150102-5506-2-git-send-email-andi@firstfloor.org> <20100922113114.GA14179@Krystal> <4a8f3ad8416ed61cba1746883da1f839.squirrel@www.firstfloor.org> <589c3dd38437c80704d8224523efbccc.squirrel@www.firstfloor.org> <20100922150250.GB4897@Krystal> <20100922150743.GA6272@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100922150743.GA6272@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 11:07:43AM -0400, Mathieu Desnoyers wrote:
> * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> > * Andi Kleen (andi@firstfloor.org) wrote:
> > > 
> > > >
> > > >>> +	for (; entry < stop && entry->key == key; entry++)
> > > >>> +		if (kernel_text_address(entry->code))
> > > >>
> > > >> This does not work for modules I'm afraid, only for the core kernel. You
> > > >> should test for __module_text_address() somewhere.
> > > >
> > > > I thought it was shared now, but ok.
> > > 
> > > Double checked. This is ok because kernel_text_address()
> > > already checks for modules. You were probably thinking
> > > of __kernel_text_address()
> > 
> > Ah right,
> > 
> > Although we have another problem:
> > 
> > __module_text_address() includes module init text, which defeats the
> > purpose of the check put in there by Jason.
> > 
> > So the check works for the core kernel, but not for modules.
> 
> So, we have this issue, but I also have a question for Jason: what
> happens if someone puts static jump in a function declared in the __init
> section of the core kernel/module ? Can we enable them at early boot ?
> 
> Thanks,
> 
> Mathieu
> 

Hi Mathieu,

Yes, we should be able to enable these. Look at the definition for
core_kernel_text():

int core_kernel_text(unsigned long addr)
{
        if (addr >= (unsigned long)_stext &&
            addr <= (unsigned long)_etext)
                return 1;

        if (system_state == SYSTEM_BOOTING &&
            init_kernel_text(addr))
                return 1;
        return 0;
}

If the system is in the SYSTEM_BOOTING state we allow the text to be
updated. same for modules, the check will allow module __init text
modifications. At very early init there could be some issue
text_poke_smp() working on x86, I'm not sure. In any case, we could
always fall back to text_poke_early(), if needed. So I don't see any
fundamental issues with this case.

thanks,

-Jason
