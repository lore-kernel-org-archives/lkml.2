Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab3ABM51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 07:57:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649Ab3ABM50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 07:57:26 -0500
Date: Wed, 2 Jan 2013 13:57:12 +0100
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] uprobes: Introduce uprobe_is_active()
Message-ID: <20130102125712.GB16927@bandura.brq.redhat.com>
References: <20121125223331.GA24788@redhat.com>
 <20121125223347.GA24808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121125223347.GA24808@redhat.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 25, 2012 at 11:33:47PM +0100, Oleg Nesterov wrote:
> The lifetime of uprobe->rb_node and uprobe->inode is not refcounted,
> delete_uprobe() is called when we detect that uprobe has no consumers,
> and it would be deadly wrong to do this twice.
> 
> Change delete_uprobe() to WARN() if it was already called. We use
> RB_CLEAR_NODE() to mark uprobe "inactive", then RB_EMPTY_NODE() can
> be used to detect this case.
> 
> RB_EMPTY_NODE() is not used directly, we add the trivial helper for
> the next change.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/events/uprobes.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)

Acked-by: Anton Arapov <anton@redhat.com>


> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 53dc2eb..2886c82 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -669,6 +669,10 @@ remove_breakpoint(struct uprobe *uprobe, struct mm_struct *mm, unsigned long vad
>  	return set_orig_insn(&uprobe->arch, mm, vaddr);
>  }
>  
> +static inline bool uprobe_is_active(struct uprobe *uprobe)
> +{
> +	return !RB_EMPTY_NODE(&uprobe->rb_node);
> +}
>  /*
>   * There could be threads that have already hit the breakpoint. They
>   * will recheck the current insn and restart if find_uprobe() fails.
> @@ -676,9 +680,13 @@ remove_breakpoint(struct uprobe *uprobe, struct mm_struct *mm, unsigned long vad
>   */
>  static void delete_uprobe(struct uprobe *uprobe)
>  {
> +	if (WARN_ON(!uprobe_is_active(uprobe)))
> +		return;
> +
>  	spin_lock(&uprobes_treelock);
>  	rb_erase(&uprobe->rb_node, &uprobes_tree);
>  	spin_unlock(&uprobes_treelock);
> +	RB_CLEAR_NODE(&uprobe->rb_node); /* for uprobe_is_active() */
>  	iput(uprobe->inode);
>  	put_uprobe(uprobe);
>  }
> -- 
> 1.5.5.1
> 
