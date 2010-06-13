Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab0FMIOp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 04:14:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:11100 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738Ab0FMIOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 04:14:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,410,1272870000"; 
   d="scan'208";a="807449570"
Subject: Re: BUG: aim7/specjbb2005/fio hang due to commit:
 597a264b1a9c7e36d1728f
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: john.r.fastabend@intel.com, davem@davemloft.net, yanmin.zhang@intel.com,
       tim.c.chen@intel.com, linux-kernel@vger.kernel.org
In-Reply-To: <1276409640.9452.49.camel@debian>
References: <1276409640.9452.49.camel@debian>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sun, 13 Jun 2010 16:16:56 +0800
Message-Id: <1276417016.2096.467.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-06-13 at 14:14 +0800, Alex,Shi wrote:
> The listed benchmark using loopback mode netio and all hang in 35-rc3
> testing. Yanmin and I found it is due to the commit
> 597a264b1a9c7e36d1728f677c66c5c1f7e3b837.
All these benchmark stops at network io reading to wait for data.

>  
> After revert this patch, all benchmarks can be recovered. Seems the
> following line is the suspicious. 
> 
> 
> 
> +       /*
> +        * bonding note: skbs received on inactive slaves should only
> +        * be delivered to pkt handlers that are exact matches.  Also
> +        * the deliver_no_wcard flag will be set.  If packet handlers
> +        * are sensitive to duplicate packets these skbs will need to
> +        * be dropped at the handler.  The vlan accel path may have
> +        * already set the deliver_no_wcard flag.
> +        */
>         null_or_orig = NULL;
>         orig_dev = skb->dev;
>         master = ACCESS_ONCE(orig_dev->master);
> -       if (master) {
> -               if (skb_bond_should_drop(skb, master))
> +       if (skb->deliver_no_wcard)
> +               null_or_orig = orig_dev;
> +       else if (master) {
> +               if (skb_bond_should_drop(skb, master)) {
> +                       skb->deliver_no_wcard = 1;
>                         null_or_orig = orig_dev; /* deliver only exact
> match */
> -               else
> +               } else
>                         skb->dev = master;
>         }
> 
> Thanks
> Alex 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


