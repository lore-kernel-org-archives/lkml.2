Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab0FNTZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 15:25:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774Ab0FNTZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 15:25:34 -0400
Date: Mon, 14 Jun 2010 12:25:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, tony.camuso@hp.com,
       david.altobelli@hp.com, dzickus@redhat.com
Subject: Re: [PATCH]: hpilo: fix pointer warning in ilo_ccb_setup [v2]
Message-Id: <20100614122517.775fc67c.akpm@linux-foundation.org>
In-Reply-To: <20100608151923.10554.57721.sendpatchset@prarit.bos.redhat.com>
References: <20100608151923.10554.57721.sendpatchset@prarit.bos.redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jun 2010 11:25:36 -0400
Prarit Bhargava <prarit@redhat.com> wrote:

> Fix i386 PAE compile warning:
> 
> drivers/misc/hpilo.c: In function ___ilo_ccb_setup___:
> drivers/misc/hpilo.c:274: warning: cast to pointer from integer of different size
> 
> dma_addr_t is 64 on i386 PAE which causes a size mismatch.
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> 
> diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
> index 98ad012..557a8c2 100644
> --- a/drivers/misc/hpilo.c
> +++ b/drivers/misc/hpilo.c
> @@ -256,7 +256,8 @@ static void ilo_ccb_close(struct pci_dev *pdev, struct ccb_data *data)
>  
>  static int ilo_ccb_setup(struct ilo_hwinfo *hw, struct ccb_data *data, int slot)
>  {
> -	char *dma_va, *dma_pa;
> +	char *dma_va;
> +	dma_addr_t dma_pa;
>  	struct ccb *driver_ccb, *ilo_ccb;
>  
>  	driver_ccb = &data->driver_ccb;
> @@ -272,12 +273,12 @@ static int ilo_ccb_setup(struct ilo_hwinfo *hw, struct ccb_data *data, int slot)
>  		return -ENOMEM;
>  
>  	dma_va = (char *)data->dma_va;
> -	dma_pa = (char *)data->dma_pa;
> +	dma_pa = data->dma_pa;
>  
>  	memset(dma_va, 0, data->dma_size);
>  
>  	dma_va = (char *)roundup((unsigned long)dma_va, ILO_START_ALIGN);
> -	dma_pa = (char *)roundup((unsigned long)dma_pa, ILO_START_ALIGN);
> +	dma_pa = roundup(dma_pa, ILO_START_ALIGN);

Well.  roundup() does division, and 64-bit divides can cause a linkage
error on i386.  But the compiler will save us because ILO_START_ALIGN
is a power-of-2.  But as we require that ILO_START_ALIGN be a
power-of-2, we may as well use round_up(), which doesn't use division.

> --- a/drivers/misc/hpilo.h
> +++ b/drivers/misc/hpilo.h
> @@ -79,21 +79,21 @@ struct ilo_hwinfo {
>  struct ccb {
>  	union {
>  		char *send_fifobar;
> -		u64 padding1;
> +		u64 send_fifobar_pa;
>  	} ccb_u1;
>  	union {
>  		char *send_desc;
> -		u64 padding2;
> +		u64 send_desc_pa;
>  	} ccb_u2;
>  	u64 send_ctrl;
>  
>  	union {
>  		char *recv_fifobar;
> -		u64 padding3;
> +		u64 recv_fifobar_pa;
>  	} ccb_u3;
>  	union {
>  		char *recv_desc;
> -		u64 padding4;
> +		u64 recv_desc_pa;
>  	} ccb_u4;
>  	u64 recv_ctrl;

So what's happening here.  As send_fifobar_pa, send_desc_pa,
recv_fifobar_pa and recv_desc_pa are only ever written to, I assume
that we're writing a 64-bit value and then reading it back via the
32-bit value which shares the same storage.

Which means that this code doesn't have a hope of working on big-endian
machines?


