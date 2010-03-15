Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936976Ab0COW0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 18:26:12 -0400
Received: from mail.vyatta.com ([76.74.103.46]:36601 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936949Ab0COW0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 18:26:09 -0400
Date: Mon, 15 Mar 2010 15:25:51 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       roger.oksanen@cs.helsinki.fi
Subject: Re: [Stable-review] [19/39] e100: Use pci pool to work around
 GFP_ATOMIC order 5 memory allocation failure
Message-ID: <20100315152551.3da75728@nehalam>
In-Reply-To: <20100315.152037.32744329.davem@davemloft.net>
References: <20100315.143225.212581877.davem@davemloft.net>
	<20100315143653.294c0650@nehalam>
	<20100315.143906.150716862.davem@davemloft.net>
	<20100315.152037.32744329.davem@davemloft.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Mar 2010 15:20:37 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: David Miller <davem@davemloft.net>
> Date: Mon, 15 Mar 2010 14:39:06 -0700 (PDT)
> 
> > From: Stephen Hemminger <shemminger@vyatta.com>
> > Date: Mon, 15 Mar 2010 14:36:53 -0700
> > 
> >> The kernel has both fixes in it. The customer reported that if both
> >> were reverted, the kernel panic went away.
> > 
> > Please recheck that as your backtrace matches exactly the
> > crash signature fixed by the memset().
> 
> As an update, after some auditing I found that ring parameter changes
> aren't handled correctly by the PCI pool changes and that might
> explain the crash.
> 
> I'll push the following fix around as soon as possible:
> 
> diff --git a/drivers/net/e100.c b/drivers/net/e100.c
> index a26ccab..b997e57 100644
> --- a/drivers/net/e100.c
> +++ b/drivers/net/e100.c
> @@ -2858,7 +2858,7 @@ static int __devinit e100_probe(struct pci_dev *pdev,
>  	}
>  	nic->cbs_pool = pci_pool_create(netdev->name,
>  			   nic->pdev,
> -			   nic->params.cbs.count * sizeof(struct cb),
> +			   nic->params.cbs.max * sizeof(struct cb),
>  			   sizeof(u32),
>  			   0);
>  	DPRINTK(PROBE, INFO, "addr 0x%llx, irq %d, MAC addr %pM\n",

I will cherry pick it back into our kernel for validation.
