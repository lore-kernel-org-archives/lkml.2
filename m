Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965307Ab0GPMUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 08:20:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63232 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965291Ab0GPMUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:20:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WoMDjflwpGcusW5IHrUSN4BV9TpXy6rghb9F90vDx6TXVvDG5d1pGqfvftSm3Bgx8Y
         Tiz7x5jMVQz67bA2AmFe58RXaWrEkKjY6qlJw044o300nprBNMpFC/4UhmXv1GmdH/i8
         prvmbXYj/1vH77o9U3t8SvJkVVfDQycWNNkpo=
Subject: Re: Badness with the kernel version 2.6.35-rc1-git1 running on P6
 box
From: Eric Dumazet <eric.dumazet@gmail.com>
To: divya <dipraksh@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        sachinp@linux.vnet.ibm.com, benh@kernel.crashing.org,
        netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Jan-Bernd Themann <ossthema@de.ibm.com>
In-Reply-To: <1279274185.2549.14.camel@edumazet-laptop>
References: <4C401D56.3070108@linux.vnet.ibm.com>
	 <1279274185.2549.14.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Jul 2010 14:20:42 +0200
Message-ID: <1279282842.2549.16.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 16 juillet 2010 à 11:56 +0200, Eric Dumazet a écrit :

> [PATCH] ehea: ehea_get_stats() should use GFP_KERNEL
> 
> ehea_get_stats() is called in process context and should use GFP_KERNEL
> allocation instead of GFP_ATOMIC.
> 
> Clearing stats at beginning of ehea_get_stats() is racy in case of
> concurrent stat readers.
> 
> get_stats() can also use netdev net_device_stats, instead of a private
> copy.
> 
> Reported-by: divya <dipraksh@linux.vnet.ibm.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> ---
>  drivers/net/ehea/ehea.h      |    1 -
>  drivers/net/ehea/ehea_main.c |    6 ++----
>  2 files changed, 2 insertions(+), 5 deletions(-)
> 
> 

Hmm, net-next-2.6 contains following patch :

commit 3d8009c780ee90fccb5c171caf30aff839f13547
Author: Brian King <brking@linux.vnet.ibm.com>
Date:   Wed Jun 30 11:59:12 2010 +0000

    ehea: Allocate stats buffer with GFP_KERNEL
    
    Since ehea_get_stats calls ehea_h_query_ehea_port, which
    can sleep, we can also sleep when allocating a page in
    this function. This fixes some memory allocation failure
    warnings seen under low memory conditions.
    
    Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ehea/ehea_main.c b/drivers/net/ehea/ehea_main.c
index 8b92acb..3beba70 100644
--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -335,7 +335,7 @@ static struct net_device_stats
*ehea_get_stats(struct net_device *dev)
 
        memset(stats, 0, sizeof(*stats));
 
-       cb2 = (void *)get_zeroed_page(GFP_ATOMIC);
+       cb2 = (void *)get_zeroed_page(GFP_KERNEL);
        if (!cb2) {
                ehea_error("no mem for cb2");
                goto out;


