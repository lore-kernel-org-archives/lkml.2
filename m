Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab2LMOmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:42:54 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:56598 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab2LMOmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:42:51 -0500
Date: Thu, 13 Dec 2012 19:42:07 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] uprobes: Kill the pointless inode/uc checks in
 register/unregister
Message-ID: <20121213141207.GB3902@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121123202741.GA18858@redhat.com>
 <20121123202806.GA18887@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121123202806.GA18887@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121314-7606-0000-0000-000006709DEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-11-23 21:28:06]:

> register/unregister verifies that inode/uc != NULL. For what?
> This really looks like "hide the potential problem", the caller
> should pass the valid data.
> 
> register() also checks uc->next == NULL, probably to prevent the
> double-register but the caller can do other stupid/wrong things.
> If we do this check, then we should document that uc->next should
> be cleared before register() and add BUG_ON().
> 
> Also add the small comment about the i_size_read() check.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

We might want to add a warn .. but that shouldnt stop this patch though

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/events/uprobes.c |    7 +------
>  1 files changed, 1 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 13b247c..d8e930a 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -844,9 +844,7 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
>  	struct uprobe *uprobe;
>  	int ret;
> 
> -	if (!inode || !uc || uc->next)
> -		return -EINVAL;
> -
> +	/* Racy, just to catch the obvious mistakes */
>  	if (offset > i_size_read(inode))
>  		return -EINVAL;
> 
> @@ -883,9 +881,6 @@ void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consume
>  {
>  	struct uprobe *uprobe;
> 
> -	if (!inode || !uc)
> -		return;
> -
>  	uprobe = find_uprobe(inode, offset);
>  	if (!uprobe)
>  		return;
> -- 
> 1.5.5.1
> 

