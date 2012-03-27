Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab2C0One (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 10:43:34 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:18546 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2C0On3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 10:43:29 -0400
Date: Tue, 27 Mar 2012 10:26:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [PATCH 2/2] m2p_find_override: use list_for_each_entry_safe
Message-ID: <20120327142654.GA30655@phenom.dumpdata.com>
References: <1332856364-29995-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <1332856364-29995-2-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332856364-29995-2-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F71D20C.00B7,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 02:52:44PM +0100, Stefano Stabellini wrote:
> Use list_for_each_entry_safe and remove the spin_lock acquisition in
> m2p_find_override.

So this would allow us to get stale entries. Is that OK?

> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/xen/p2m.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> index 1b267e7..7ed8cc3 100644
> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -809,21 +809,17 @@ struct page *m2p_find_override(unsigned long mfn)
>  {
>  	unsigned long flags;
>  	struct list_head *bucket = &m2p_overrides[mfn_hash(mfn)];
> -	struct page *p, *ret;
> +	struct page *p, *t, *ret;
>  
>  	ret = NULL;
>  
> -	spin_lock_irqsave(&m2p_override_lock, flags);
> -
> -	list_for_each_entry(p, bucket, lru) {
> +	list_for_each_entry_safe(p, t, bucket, lru) {
>  		if (page_private(p) == mfn) {
>  			ret = p;
>  			break;
>  		}
>  	}
>  
> -	spin_unlock_irqrestore(&m2p_override_lock, flags);
> -
>  	return ret;
>  }
>  
> -- 
> 1.7.2.5
