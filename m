Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab1EPSID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:08:03 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44576 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab1EPSIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:08:01 -0400
Date: Mon, 16 May 2011 14:03:59 -0400 (EDT)
Message-Id: <20110516.140359.111037536766782557.davem@davemloft.net>
To: vfalico@redhat.com
Cc: mmarek@suse.cz, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        dlstevens@us.ibm.com
Subject: Re: [PATCH 1/1] igmp: fix ip_mc_clear_src to not reset
 ip_mc_list->sf{mode,count}
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110515165945.GA20024@darkmag.usersys.redhat.com>
References: <20110515165945.GA20024@darkmag.usersys.redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 16 May 2011 11:04:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Veaceslav Falico <vfalico@redhat.com>
Date: Sun, 15 May 2011 18:59:45 +0200

> ip_mc_clear_src resets the imc->sfcount and imc->sfmode, without taking into
> account the current number of sockets listening on that multicast struct, which
> can lead to bogus routes for local listeners.
> 
> On NETDEV_DOWN/UP event, if there were 3 multicast listeners for that interface's
> address, the imc->sfcount[MCAST_EXCLUDE] will be reset to 1. And after that a
> listener socket destroys, multicast traffic will not be delivered to local
> listeners because __mkroute_output drops the local flag for the route (by
> checking ip_check_mc).
> 
> Signed-off-by: Veaceslav Falico <vfalico@redhat.com>

David, please take a look at this.  Thanks.

> diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
> index 1fd3d9c..b14f371 100644
> --- a/net/ipv4/igmp.c
> +++ b/net/ipv4/igmp.c
> @@ -1775,9 +1775,6 @@ static void ip_mc_clear_src(struct ip_mc_list *pmc)
>  		kfree(psf);
>  	}
>  	pmc->sources = NULL;
> -	pmc->sfmode = MCAST_EXCLUDE;
> -	pmc->sfcount[MCAST_INCLUDE] = 0;
> -	pmc->sfcount[MCAST_EXCLUDE] = 1;
>  }
>  
>  
