Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab0ELVsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:48:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755152Ab0ELVr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:47:57 -0400
Date: Wed, 12 May 2010 14:44:53 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, Arnd Bergmann <arnd@arndb.de>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH RFC tip/core/rcu 04/23] net: Make accesses to ->br_port
 safe for sparse RCU
Message-ID: <20100512144453.4df81bdd@nehalam>
In-Reply-To: <1273700022-16523-4-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20100512213317.GA15085@linux.vnet.ibm.com>
	<1273700022-16523-4-git-send-email-paulmck@linux.vnet.ibm.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 14:33:23 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index 9101a4e..3f66cd1 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -246,7 +246,7 @@ int br_fdb_test_addr(struct net_device *dev, unsigned char *addr)
>  		return 0;
>  
>  	rcu_read_lock();
> -	fdb = __br_fdb_get(dev->br_port->br, addr);
> +	fdb = __br_fdb_get(br_port(dev)->br, addr);
>  	ret = fdb && fdb->dst->dev != dev &&
>  		fdb->dst->state == BR_STATE_FORWARDING;
>  	rcu_read_unlock();
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 846d7d1..4fedb60 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -229,6 +229,14 @@ static inline int br_is_root_bridge(const struct net_bridge *br)
>  	return !memcmp(&br->bridge_id, &br->designated_root, 8);
>  }
>  
> +static inline struct net_bridge_port *br_port(const struct net_device *dev)
> +{
> +	if (!dev)
> +		return NULL;
> +
> +	return rcu_dereference(dev->br_port);
> +}

Looks like this is wrapping existing problems, and hurting not helping.

Why introduce a wrapper that could return NULL and not check the
result?

I would rather that:
   1. dev should never be null in this cases so the first if() is 
      unnecessary, and confuses the semantics.
   2. don't use wrapper br_port()
   3. have callers check that rcu_dereference(dev->br_port) did not
      return NULL.
      If they derefernce does return NULL, then it means other CPU
      has started tear down and this CPU should just go home quietly.

-- 
