Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab2E3RtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:49:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:49951 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273Ab2E3RtN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:49:13 -0400
Message-ID: <1338400142.28384.12.camel@twins>
Subject: Re: [PATCH 1/3] uprobes: install_breakpoint() should fail if
 is_swbp_insn() == T
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 30 May 2012 19:49:02 +0200
In-Reply-To: <20120530173717.GM15587@linux.vnet.ibm.com>
References: <20120530165757.GA8077@redhat.com>
	 <20120530165816.GA8085@redhat.com> <1338398931.28384.7.camel@twins>
	 <20120530173717.GM15587@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 23:07 +0530, Srikar Dronamraju wrote:
> > > 
> > > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > > ---
> > >  kernel/events/uprobes.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> > > index 8c5e043..1593b43 100644
> > > --- a/kernel/events/uprobes.c
> > > +++ b/kernel/events/uprobes.c
> > > @@ -704,7 +704,7 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
> > >  			return ret;
> > >  
> > >  		if (is_swbp_insn((uprobe_opcode_t *)uprobe->arch.insn))
> > > -			return -EEXIST;
> > > +			return -ENOTSUPP;
> > >  
> > >  		ret = arch_uprobe_analyze_insn(&uprobe->arch, mm);
> > >  		if (ret)
> > 
> > IIRC this -EEXIST existed because the vma iteration it does is racy and
> > one can encounter the same vma twice or so. See the special -EEXIST
> > handling in register_for_each_vma().
> > 
> > Changing it like this would break stuff. 
> > 
> 
> Peter, 
> 
> is_swbp_insn() is looking at the copy of the instruction thats read from
> the file. This path is only taken even before any mm's are inserted with
> the breakpoint instruction.
> 
> We still check and return -EEXIST if the memory while inserting the breakpoint
> instruction  already has a breakpoint.
> 
> Hence this change is correct. 

Oh, indeed. I overlooked copy_insn() is taking the page from the
page-cache instead of the page-tables and will thus get the original.

OK, no worries then.
