Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab2FOMKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 08:10:38 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44750 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab2FOMKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:10:37 -0400
Date: Fri, 15 Jun 2012 14:10:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Hugh Dickins <hughd@google.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] uprobes: __copy_insn() should ensure a_ops->readpage
 != NULL
Message-ID: <20120615121031.GA28541@gmail.com>
References: <20120607165942.GA31966@redhat.com>
 <20120607170018.GB31974@redhat.com>
 <20120615062534.GB3811@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615062534.GB3811@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> * Oleg Nesterov <oleg@redhat.com> [2012-06-07 19:00:18]:
> 
> > __copy_insn() blindly calls read_mapping_page(), this will crash
> > the kernel if ->readpage == NULL, add the necessary check. For
> > example, hugetlbfs_aops->readpage is NULL. Perhaps we should change
> > read_mapping_page() instead.
> > 
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > ---
> >  kernel/events/uprobes.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> > index 48d53af..9c53bc2 100644
> > --- a/kernel/events/uprobes.c
> > +++ b/kernel/events/uprobes.c
> > @@ -616,6 +616,8 @@ __copy_insn(struct address_space *mapping, struct vm_area_struct *vma, char *ins
> > 
> >  	if (!filp)
> >  		return -EINVAL;
> > +	if (!mapping->a_ops->readpage)
> > +		return -EIO;
> 
> Nit: Should there be a blank line before the if. Ingo had insisted on
> these coding style changes.

Well, within sensible limits: if()'s can certainly be in a block 
if they do related things (such as boundary checks, etc.), so 
the above isn't ugly IMO.

Nor are separating newlines strictly necessary - it's also a 
function of the complexity of the code in question - if it's 
complex code then we want all visual and cleanliness help that 
we can think of.

Thanks,

	Ingo
