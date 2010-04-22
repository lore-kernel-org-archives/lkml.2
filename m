Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0DVLgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 07:36:35 -0400
Received: from mail.gmx.net ([213.165.64.20]:59542 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753659Ab0DVLgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 07:36:33 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX184aSsn6rY4aYpyo1mEG6+HCxMTajhXAF+AO4tEwt
	Bxld4w6nhSSyM7
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Neil Brown <neilb@suse.de>
Subject: Re: patch md-raid5-allow-for-more-than-2-31-chunks.patch added to 2.6.33-stable tree
Date: Thu, 22 Apr 2010 13:36:26 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.33-2.slh.8-sidux-686; KDE/4.4.2; i686; ; )
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, king.br@gmail.com,
       stable@kernel.org
References: <12718801381479@kroah.org> <201004220408.33822.s.L-H@gmx.de> <20100422124022.1320e49c@notabene.brown>
In-Reply-To: <20100422124022.1320e49c@notabene.brown>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004221336.28530.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thursday 22 April 2010, Neil Brown wrote:
> On Thu, 22 Apr 2010 04:08:30 +0200
> "Stefan Lippers-Hollmann" <s.L-H@gmx.de> wrote:
> > On Thursday 22 April 2010, gregkh@suse.de wrote:
[...]
> > > From 35f2a591192d0a5d9f7fc696869c76f0b8e49c3d Mon Sep 17 00:00:00 2001
> > > From: NeilBrown <neilb@suse.de>
> > > Date: Tue, 20 Apr 2010 14:13:34 +1000
> > > Subject: md/raid5: allow for more than 2^31 chunks.
> > > 
> > > From: NeilBrown <neilb@suse.de>
> > > 
> > > commit 35f2a591192d0a5d9f7fc696869c76f0b8e49c3d upstream.
> > > 
> > > With many large drives and small chunk sizes it is possible
> > > to create a RAID5 with more than 2^31 chunks.  Make sure this
> > > works.
> > > 
> > > Reported-by: Brett King <king.br@gmail.com>
> > > Signed-off-by: NeilBrown <neilb@suse.de>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > This patch, as part of the current 2.6.33 stable queue, breaks compiling
> > on i386 (CONFIG_LBDAF=y) for me (amd64 builds fine):
> > 
> > [...]
> >   BUILD   arch/x86/boot/bzImage
> > Root device is (254, 6)
> > Setup is 12700 bytes (padded to 12800 bytes).
> > System is 2415 kB
> > CRC db6fa5fa
> > Kernel: arch/x86/boot/bzImage is ready  (#1)
> > ERROR: "__umoddi3" [drivers/md/raid456.ko] undefined!
> > 
> > reverting just this patch fixes the problem for me.
> 
> Thanks for testing and reporting.
> 
> If you could verify that this additional patch fixes the compile error I
> would really appreciate it.

I can confirm that this patch on top of the original 
md-raid5-allow-for-more-than-2-31-chunks.patch fixes the build problem on 
i386 for me (amd64 continues to build fine as well).

Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>

Thank you a lot
	Stefan Lippers-Hollmann

-- 
> Thanks,
> NeilBrown
> 
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 20e4840..58ea0ec 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -1650,7 +1650,7 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
>  				     int previous, int *dd_idx,
>  				     struct stripe_head *sh)
>  {
> -	sector_t stripe;
> +	sector_t stripe, stripe2;
>  	sector_t chunk_number;
>  	unsigned int chunk_offset;
>  	int pd_idx, qd_idx;
> @@ -1677,7 +1677,7 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
>  	 */
>  	stripe = chunk_number;
>  	*dd_idx = sector_div(stripe, data_disks);
> -
> +	stripe2 = stripe;
>  	/*
>  	 * Select the parity disk based on the user selected algorithm.
>  	 */
> @@ -1689,21 +1689,21 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
>  	case 5:
>  		switch (algorithm) {
>  		case ALGORITHM_LEFT_ASYMMETRIC:
> -			pd_idx = data_disks - stripe % raid_disks;
> +			pd_idx = data_disks - sector_div(stripe2, raid_disks);
>  			if (*dd_idx >= pd_idx)
>  				(*dd_idx)++;
>  			break;
>  		case ALGORITHM_RIGHT_ASYMMETRIC:
> -			pd_idx = stripe % raid_disks;
> +			pd_idx = sector_div(stripe2, raid_disks);
>  			if (*dd_idx >= pd_idx)
>  				(*dd_idx)++;
>  			break;
>  		case ALGORITHM_LEFT_SYMMETRIC:
> -			pd_idx = data_disks - stripe % raid_disks;
> +			pd_idx = data_disks - sector_div(stripe2, raid_disks);
>  			*dd_idx = (pd_idx + 1 + *dd_idx) % raid_disks;
>  			break;
>  		case ALGORITHM_RIGHT_SYMMETRIC:
> -			pd_idx = stripe % raid_disks;
> +			pd_idx = sector_div(stripe2, raid_disks);
>  			*dd_idx = (pd_idx + 1 + *dd_idx) % raid_disks;
>  			break;
>  		case ALGORITHM_PARITY_0:
> @@ -1723,7 +1723,7 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
>  
>  		switch (algorithm) {
>  		case ALGORITHM_LEFT_ASYMMETRIC:
> -			pd_idx = raid_disks - 1 - (stripe % raid_disks);
> +			pd_idx = raid_disks - 1 - sector_div(stripe2, raid_disks);
>  			qd_idx = pd_idx + 1;
>  			if (pd_idx == raid_disks-1) {
>  				(*dd_idx)++;	/* Q D D D P */
> @@ -1732,7 +1732,7 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
>  				(*dd_idx) += 2; /* D D P Q D */
>  			break;
>  		case ALGORITHM_RIGHT_ASYMMETRIC:
> -			pd_idx = stripe % raid_disks;
> +			pd_idx = sector_div(stripe2, raid_disks);
>  			qd_idx = pd_idx + 1;
>  			if (pd_idx == raid_disks-1) {
>  				(*dd_idx)++;	/* Q D D D P */
> @@ -1741,12 +1741,12 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
>  				(*dd_idx) += 2; /* D D P Q D */
>  			break;
>  		case ALGORITHM_LEFT_SYMMETRIC:
> -			pd_idx = raid_disks - 1 - (stripe % raid_disks);
> +			pd_idx = raid_disks - 1 - sector_div(stripe2, raid_disks);
>  			qd_idx = (pd_idx + 1) % raid_disks;
>  			*dd_idx = (pd_idx + 2 + *dd_idx) % raid_disks;
>  			break;
>  		case ALGORITHM_RIGHT_SYMMETRIC:
> -			pd_idx = stripe % raid_disks;
> +			pd_idx = sector_div(stripe2, raid_disks);
>  			qd_idx = (pd_idx + 1) % raid_disks;
>  			*dd_idx = (pd_idx + 2 + *dd_idx) % raid_disks;
>  			break;
> @@ -1765,7 +1765,7 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
>  			/* Exactly the same as RIGHT_ASYMMETRIC, but or
>  			 * of blocks for computing Q is different.
>  			 */
> -			pd_idx = stripe % raid_disks;
> +			pd_idx = sector_div(stripe2, raid_disks);
>  			qd_idx = pd_idx + 1;
>  			if (pd_idx == raid_disks-1) {
>  				(*dd_idx)++;	/* Q D D D P */
> @@ -1780,7 +1780,8 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
>  			 * D D D P Q  rather than
>  			 * Q D D D P
>  			 */
> -			pd_idx = raid_disks - 1 - ((stripe + 1) % raid_disks);
> +			stripe2 += 1;
> +			pd_idx = raid_disks - 1 - sector_div(stripe2, raid_disks);
>  			qd_idx = pd_idx + 1;
>  			if (pd_idx == raid_disks-1) {
>  				(*dd_idx)++;	/* Q D D D P */
> @@ -1792,7 +1793,7 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
>  
>  		case ALGORITHM_ROTATING_N_CONTINUE:
>  			/* Same as left_symmetric but Q is before P */
> -			pd_idx = raid_disks - 1 - (stripe % raid_disks);
> +			pd_idx = raid_disks - 1 - sector_div(stripe2, raid_disks);
>  			qd_idx = (pd_idx + raid_disks - 1) % raid_disks;
>  			*dd_idx = (pd_idx + 1 + *dd_idx) % raid_disks;
>  			ddf_layout = 1;
> @@ -1800,27 +1801,27 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
>  
>  		case ALGORITHM_LEFT_ASYMMETRIC_6:
>  			/* RAID5 left_asymmetric, with Q on last device */
> -			pd_idx = data_disks - stripe % (raid_disks-1);
> +			pd_idx = data_disks - sector_div(stripe2, raid_disks-1);
>  			if (*dd_idx >= pd_idx)
>  				(*dd_idx)++;
>  			qd_idx = raid_disks - 1;
>  			break;
>  
>  		case ALGORITHM_RIGHT_ASYMMETRIC_6:
> -			pd_idx = stripe % (raid_disks-1);
> +			pd_idx = sector_div(stripe2, raid_disks-1);
>  			if (*dd_idx >= pd_idx)
>  				(*dd_idx)++;
>  			qd_idx = raid_disks - 1;
>  			break;
>  
>  		case ALGORITHM_LEFT_SYMMETRIC_6:
> -			pd_idx = data_disks - stripe % (raid_disks-1);
> +			pd_idx = data_disks - sector_div(stripe2, raid_disks-1);
>  			*dd_idx = (pd_idx + 1 + *dd_idx) % (raid_disks-1);
>  			qd_idx = raid_disks - 1;
>  			break;
>  
>  		case ALGORITHM_RIGHT_SYMMETRIC_6:
> -			pd_idx = stripe % (raid_disks-1);
> +			pd_idx = sector_div(stripe2, raid_disks-1);
>  			*dd_idx = (pd_idx + 1 + *dd_idx) % (raid_disks-1);
>  			qd_idx = raid_disks - 1;
>  			break;
> 
> 
> 

