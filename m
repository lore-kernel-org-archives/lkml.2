Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072Ab0KSXAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 18:00:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757504Ab0KSXAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 18:00:10 -0500
Date: Fri, 19 Nov 2010 14:59:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Carpenter <error27@gmail.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] dca: missing unlock in unregister_dca_providers()
Message-Id: <20101119145937.60c5f688.akpm@linux-foundation.org>
In-Reply-To: <20101117051032.GC31724@bicker>
References: <20101117051032.GC31724@bicker>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010 08:10:32 +0300
Dan Carpenter <error27@gmail.com> wrote:

> We return here with the lock held and IRQs disabled by mistake.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/dca/dca-core.c b/drivers/dca/dca-core.c
> index b98c676..b4c95be 100644
> --- a/drivers/dca/dca-core.c
> +++ b/drivers/dca/dca-core.c
> @@ -110,8 +110,10 @@ static void unregister_dca_providers(void)
>  
>  	/* at this point only one domain in the list is expected */
>  	domain = list_first_entry(&dca_domains, struct dca_domain, node);
> -	if (!domain)
> +	if (!domain) {
> +		spin_unlock_irqrestore(&dca_lock, flags);
>  		return;
> +	}
>  
>  	list_for_each_entry_safe(dca, _dca, &domain->dca_providers, node) {
>  		list_del(&dca->node);

I think the code's just bogus, actually. 
list_first_entry(&dca_domains) can't return NULL.

