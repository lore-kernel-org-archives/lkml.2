Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127Ab0EYVty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 17:49:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758708Ab0EYVtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 17:49:53 -0400
Date: Tue, 25 May 2010 14:49:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, david.altobelli@hp.com,
       tony.camuso@redhat.com
Subject: Re: [PATCH]: hpilo: fix pointer warning in ilo_ccb_setup
Message-Id: <20100525144937.e0726ec2.akpm@linux-foundation.org>
In-Reply-To: <20100522004615.25451.83108.sendpatchset@prarit.bos.redhat.com>
References: <20100522004615.25451.83108.sendpatchset@prarit.bos.redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010 20:50:41 -0400
Prarit Bhargava <prarit@redhat.com> wrote:

> Fixes warning:
> 
> drivers/misc/hpilo.c: In function ___ilo_ccb_setup___:
> drivers/misc/hpilo.c:274: warning: cast to pointer from integer of different size
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> 
> diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
> index 98ad012..b07a541 100644
> --- a/drivers/misc/hpilo.c
> +++ b/drivers/misc/hpilo.c
> @@ -272,7 +272,7 @@ static int ilo_ccb_setup(struct ilo_hwinfo *hw, struct ccb_data *data, int slot)
>  		return -ENOMEM;
>  
>  	dma_va = (char *)data->dma_va;
> -	dma_pa = (char *)data->dma_pa;
> +	dma_pa = (char *)(&data->dma_pa);
>  
>  	memset(dma_va, 0, data->dma_size);

Seems very wrong - writes to *dmp_pa will now scribble over the `struct
ccb_data'.

Probably local variable dma_pa should have type dma_addr_t.
