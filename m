Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab1CJSVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 13:21:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121Ab1CJSVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 13:21:15 -0500
Date: Thu, 10 Mar 2011 13:20:00 -0500
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Daney <ddaney@caviumnetworks.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, peterz@infradead.org,
        hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 0/2] jump label: update for .39
Message-ID: <20110310182000.GB2906@redhat.com>
References: <cover.1299702291.git.jbaron@redhat.com> <1299728191.15854.319.camel@gandalf.stny.rr.com> <BLU0-SMTP690BB959832A97E002293396C80@phx.gbl> <1299771504.15854.347.camel@gandalf.stny.rr.com> <4D790A13.4060705@caviumnetworks.com> <1299780241.15854.393.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299780241.15854.393.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 01:04:01PM -0500, Steven Rostedt wrote:
> On Thu, 2011-03-10 at 09:27 -0800, David Daney wrote:
> > On 03/10/2011 07:38 AM, Steven Rostedt wrote:
> 
> > >> Can you explain what would prevent gcc from aligning these 3 pointers
> > >> (total of 24 bytes on 64-bit architectures) on 32-bytes ?
> > 
> > I can:
> > 
> > http://www.x86-64.org/documentation/abi.pdf Section 3.1.2:
> > 
> >     Aggregates and Unions
> 
> Note, we are not dealing with C or arrays, but with inline assembly, and
> the linker.
> 
> +static __always_inline bool arch_static_branch(struct jump_label_key *key)
> +{
> +       asm goto("1:\tnop\n\t"
> +               "nop\n\t"
> +               ".pushsection __jump_table,  \"aw\"\n\t"
> +               WORD_INSN " 1b, %l[l_yes], %0\n\t"
> +               ".popsection\n\t"
> +               : :  "i" (key) : : l_yes);
> +       return false;
> +l_yes:
> +       return true;
> +}
> 
> 
> That push/pop section part creates the structure we are talking about.
> It's made up of three pointers. The address of the nop, the address of
> the label l_yes and the address of the key.
> 
> Now its up to the linker to decide where to place that element. Can we
> guarantee that it will always be on an 8 byte boundery?
> Hmm, I wonder if we could add a .ALIGN sizeof(long) before that?
> 

we can. Sparc does it, see: arch/sparc/include/asm/jump_label.h.

So I guess it would be .align 8 for 64-bit and .align 4 for 32-bit...

-Jason
