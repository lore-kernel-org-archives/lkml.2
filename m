Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab2LJGtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 01:49:22 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48421 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab2LJGtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 01:49:21 -0500
Date: Mon, 10 Dec 2012 11:49:01 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] uprobes: Kill the pointless inode/uc checks in
 register/unregister
Message-ID: <20121210061901.GF22164@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121123202741.GA18858@redhat.com>
 <20121123202806.GA18887@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121123202806.GA18887@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121006-7182-0000-0000-000003A7EB75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-11-23 21:28:06]:

> register/unregister verifies that inode/uc != NULL. For what?
> This really looks like "hide the potential problem", the caller
> should pass the valid data.
> 

Agree that users should pass valid data.
I do understand that we expect the users to be knowledge-able. 
Also users are routed thro in-kernel api that does this check.

However from an api perspective, if a user passes invalid data, do we
want the system to crash.
Esp if kernel can identify that users has indeed passed wrong info. I do agree
that users can still pass invalid data that kernel maynot be able to
identify in most cases.


> register() also checks uc->next == NULL, probably to prevent the
> double-register but the caller can do other stupid/wrong things.

Users can surely do more stupid things. But this is again something that
kernel can identify. By allowing a double-register of a consumer, thats
already registered, we might end up allowing circular loop of consumers.

> If we do this check, then we should document that uc->next should
> be cleared before register() and add BUG_ON().
> 
> Also add the small comment about the i_size_read() check.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
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

