Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab0DVCIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 22:08:39 -0400
Received: from mail.gmx.net ([213.165.64.20]:33895 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752658Ab0DVCIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 22:08:37 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1/r7JU808briMBHGhAvPOz37lQjwgci9UwNaEXH4f
	+t5gffMCoemENR
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: gregkh@suse.de
Subject: Re: patch md-raid5-allow-for-more-than-2-31-chunks.patch added to 2.6.33-stable tree
Date: Thu, 22 Apr 2010 04:08:30 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.33-2.slh.8-sidux-686; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, king.br@gmail.com,
       stable@kernel.org
References: <12718801381479@kroah.org>
In-Reply-To: <12718801381479@kroah.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004220408.33822.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thursday 22 April 2010, gregkh@suse.de wrote:
> This is a note to let you know that we have just queued up the patch titled
> 
>     Subject: md/raid5: allow for more than 2^31 chunks.
> 
> to the 2.6.33-stable tree.  Its filename is
> 
>     md-raid5-allow-for-more-than-2-31-chunks.patch
> 
> A git repo of this tree can be found at 
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> 
> From 35f2a591192d0a5d9f7fc696869c76f0b8e49c3d Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Tue, 20 Apr 2010 14:13:34 +1000
> Subject: md/raid5: allow for more than 2^31 chunks.
> 
> From: NeilBrown <neilb@suse.de>
> 
> commit 35f2a591192d0a5d9f7fc696869c76f0b8e49c3d upstream.
> 
> With many large drives and small chunk sizes it is possible
> to create a RAID5 with more than 2^31 chunks.  Make sure this
> works.
> 
> Reported-by: Brett King <king.br@gmail.com>
> Signed-off-by: NeilBrown <neilb@suse.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

This patch, as part of the current 2.6.33 stable queue, breaks compiling
on i386 (CONFIG_LBDAF=y) for me (amd64 builds fine):

[...]
  BUILD   arch/x86/boot/bzImage
Root device is (254, 6)
Setup is 12700 bytes (padded to 12800 bytes).
System is 2415 kB
CRC db6fa5fa
Kernel: arch/x86/boot/bzImage is ready  (#1)
ERROR: "__umoddi3" [drivers/md/raid456.ko] undefined!

reverting just this patch fixes the problem for me.

Current Debian/ unstable:
ii  binutils                                            2.20.1-7                   The GNU assembler, linker and binary utilities
ii  gcc-4.4                                             4.4.3-9                    The GNU C compiler
ii  make                                                3.81-8                     An utility for Directing compilation.

Regards
	Stefan Lippers-Hollmann

-- 
> ---
>  drivers/md/raid5.c |   19 +++++++------------
>  1 file changed, 7 insertions(+), 12 deletions(-)
> 
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -1649,8 +1649,8 @@ static sector_t raid5_compute_sector(rai
>  				     int previous, int *dd_idx,
>  				     struct stripe_head *sh)
>  {
> -	long stripe;
> -	unsigned long chunk_number;
> +	sector_t stripe;
> +	sector_t chunk_number;
>  	unsigned int chunk_offset;
>  	int pd_idx, qd_idx;
>  	int ddf_layout = 0;
> @@ -1670,17 +1670,12 @@ static sector_t raid5_compute_sector(rai
>  	 */
>  	chunk_offset = sector_div(r_sector, sectors_per_chunk);
>  	chunk_number = r_sector;
> -	BUG_ON(r_sector != chunk_number);
>  
>  	/*
>  	 * Compute the stripe number
>  	 */
> -	stripe = chunk_number / data_disks;
> -
> -	/*
> -	 * Compute the data disk and parity disk indexes inside the stripe
> -	 */
> -	*dd_idx = chunk_number % data_disks;
> +	stripe = chunk_number;
> +	*dd_idx = sector_div(stripe, data_disks);
>  
>  	/*
>  	 * Select the parity disk based on the user selected algorithm.
> @@ -1869,14 +1864,14 @@ static sector_t compute_blocknr(struct s
>  				 : conf->algorithm;
>  	sector_t stripe;
>  	int chunk_offset;
> -	int chunk_number, dummy1, dd_idx = i;
> +	sector_t chunk_number;
> +	int dummy1, dd_idx = i;
>  	sector_t r_sector;
>  	struct stripe_head sh2;
>  
>  
>  	chunk_offset = sector_div(new_sector, sectors_per_chunk);
>  	stripe = new_sector;
> -	BUG_ON(new_sector != stripe);
>  
>  	if (i == sh->pd_idx)
>  		return 0;
> @@ -1969,7 +1964,7 @@ static sector_t compute_blocknr(struct s
>  	}
>  
>  	chunk_number = stripe * data_disks + i;
> -	r_sector = (sector_t)chunk_number * sectors_per_chunk + chunk_offset;
> +	r_sector = chunk_number * sectors_per_chunk + chunk_offset;
>  
>  	check = raid5_compute_sector(conf, r_sector,
>  				     previous, &dummy1, &sh2);
