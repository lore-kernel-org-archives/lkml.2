Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab2FORzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 13:55:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756808Ab2FORzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 13:55:16 -0400
Date: Fri, 15 Jun 2012 19:52:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/15] uprobes: move BUG_ON(UPROBE_SWBP_INSN_SIZE) from
	write_opcode() to install_breakpoint()
Message-ID: <20120615175248.GA14122@redhat.com>
References: <20120615154241.GA9524@redhat.com> <20120615154350.GA9611@redhat.com> <20120615163600.GA10922@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615163600.GA10922@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15, Srikar Dronamraju wrote:
>
> > @@ -699,6 +694,10 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
> >  		if (ret)
> >  			return ret;
> >
> > +		/* write_opcode() assumes we don't cross page boundary */
> > +		BUG_ON((uprobe->offset & ~PAGE_MASK) +
> > +				UPROBE_SWBP_INSN_SIZE > PAGE_SIZE);
> > +
> >  		uprobe->flags |= UPROBE_COPY_INSN;
> >  	}
>
> I am now thinking if we really need a BUG_ON?

I was thinking about this too.

> I am now thinking I should
> have had a check at the start in uprobe_register() and failed the request.
>
> Something like
> 	if ((offset & ~PAGE_MASK) + UPROBE_SWBP_INSN_SIZE > PAGE_SIZE)
> 		return -EINVAL;

Perhaps. Or we can simply remove it. arch_uprobe_analyze_insn()
should be careful anyway, and all this validation should be moved
into uprobe_register/alloc_uprobe.

I do not really mind, I only wanted to simplify write_opcode() which
does a lot of unnecessary things (say, lock_page, I am going to kill
it).

So. Do you want me to redo this patch? Or do you think we can keep
this "must not happen after arch_uprobe_analyze_insn" check?

Oleg.

