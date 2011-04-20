Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab1DTQXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 12:23:51 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:2385
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752167Ab1DTQXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 12:23:50 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 20 Apr 2011 11:23:41 -0500
From: Scott Wood <scottwood@freescale.com>
To: Andrea Galbusera <gizero@gmail.com>
CC: Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>, <netdev@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] powerpc: Fix multicast problem in fs_enet driver
Message-ID: <20110420112341.41d57444@schlenkerla.am.freescale.net>
In-Reply-To: <1303289719-16913-1-git-send-email-gizero@gmail.com>
References: <1303289719-16913-1-git-send-email-gizero@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011 10:55:19 +0200
Andrea Galbusera <gizero@gmail.com> wrote:

> mac-fec.c was setting individual UDP address registers instead of multicast
> group address registers when joining a multicast group.
> This prevented from correctly receiving UDP multicast packets.
> According to datasheet, replaced hash_table_high and hash_table_low
> with grp_hash_table_high and grp_hash_table_low respectively.
> 
> Tested on a MPC5121 based board.
> 
> Signed-off-by: Andrea Galbusera <gizero@gmail.com>
> ---
>  drivers/net/fs_enet/mac-fec.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/fs_enet/mac-fec.c b/drivers/net/fs_enet/mac-fec.c
> index 61035fc..b9fbc83 100644
> --- a/drivers/net/fs_enet/mac-fec.c
> +++ b/drivers/net/fs_enet/mac-fec.c
> @@ -226,8 +226,8 @@ static void set_multicast_finish(struct net_device *dev)
>  	}
>  
>  	FC(fecp, r_cntrl, FEC_RCNTRL_PROM);
> -	FW(fecp, hash_table_high, fep->fec.hthi);
> -	FW(fecp, hash_table_low, fep->fec.htlo);
> +	FW(fecp, grp_hash_table_high, fep->fec.hthi);
> +	FW(fecp, grp_hash_table_low, fep->fec.htlo);
>  }
>  
>  static void set_multicast_list(struct net_device *dev)
> @@ -273,8 +273,8 @@ static void restart(struct net_device *dev)
>  	/*
>  	 * Reset all multicast.
>  	 */
> -	FW(fecp, hash_table_high, fep->fec.hthi);
> -	FW(fecp, hash_table_low, fep->fec.htlo);
> +	FW(fecp, grp_hash_table_high, fep->fec.hthi);
> +	FW(fecp, grp_hash_table_low, fep->fec.htlo);
>  
>  	/*
>  	 * Set maximum receive buffer size.

This will break on 8xx which does not have grp_hash_table_*.  It has only
one set of hash table registers which are used only for multicast -- so
8xx should have fec_hash_table_* renamed to fec_grp_hash_table_* in struct
fec.

-Scott

