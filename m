Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab2IOOjL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 10:39:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab2IOOjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 10:39:10 -0400
Date: Sat, 15 Sep 2012 16:41:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] uprobes: teach find_active_uprobe() to clear
	MMF_HAS_UPROBES
Message-ID: <20120915144101.GA19898@redhat.com>
References: <20120819164008.GA25454@redhat.com> <20120819164042.GA25490@redhat.com> <20120914164324.GE28033@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914164324.GE28033@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2012-08-19 18:40:42]:
>
> > Note the "not strictly accurate" comment in mmf_recalc_uprobes().
> > We can fix this, we only need to teach vma_has_uprobes() to return
> > a bit more more info, but I am not sure this worth the trouble.
> ...
> > +		/*
> > +		 * This is not strictly accurate, we can race with
> > +		 * uprobe_unregister() and see the already removed
> > +		 * uprobe if delete_uprobe() was not yet called.
> > +		 */
> > +		if (vma_has_uprobes(vma, vma->vm_start, vma->vm_end))
>
> Should we set the MMF_RECALC_UPROBES here?

Assuming uprobe was removed - yes.

> Its harmless but my thought was if we indeed saw a uprobe that was
> already deleted, then the next time we hit a non uprobe breakpoint in
> the same process context, we will not come here because
> MMF_RECALC_UPROBES is cleared.

Yes, this is what the comment/changelog tries to document.

vma_has_uprobes() needs to check uprobe->consumers under uprobes_treelock
and return no|yes|maybe. Or it can do rb_prev/rb_entry until it finds the
live uprobe. We can do this later to improve this logic. And we can do
other improvements, say, fork() can be much more accurate but with more
complications.

> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Thanks,

Oleg.

