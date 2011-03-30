Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab1C3FgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 01:36:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47849
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912Ab1C3FgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 01:36:14 -0400
Date: Tue, 29 Mar 2011 22:35:36 -0700 (PDT)
Message-Id: <20110329.223536.245392030.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, hidden@balabit.hu, akpm@linux-foundation.org,
        netfilter-devel@vger.kernel.org, kaber@trash.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: Fix build failure when ipv6 but xt_tproxy
 is built in
From: David Miller <davem@davemloft.net>
In-Reply-To: <1301451199.14261.327.camel@gandalf.stny.rr.com>
References: <1301451199.14261.327.camel@gandalf.stny.rr.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 29 Mar 2011 22:13:19 -0400

> While running ktest.pl doing ranconfigs, the following build error
> occurred:

Is sending netfilter patches to the explicitly listed maintainer in
MAINTAINERS too much to ask Stephen? :-/

CC:'d

> 
> net/built-in.o: In function `tproxy_tg6_v1':
> /home/rostedt/work/autotest/nobackup/linux-test.git/net/netfilter/xt_TPROXY.c:288: undefined reference to `ipv6_find_hdr'
> 
> This happened because the xt_TPROXY code was compiled into the kernel
> proper, but the ipv6 netfilter was compiled as a module. The fix is to
> only enter the code that calls ipv6_find_hdr if ipv6 netfilter is
> compiled into the kernel, or if it is a module, so is the xt_TPROXY
> code.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
> index dcfd57e..5915f94 100644
> --- a/net/netfilter/xt_TPROXY.c
> +++ b/net/netfilter/xt_TPROXY.c
> @@ -22,7 +22,13 @@
>  
>  #include <net/netfilter/ipv4/nf_defrag_ipv4.h>
>  
> -#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
> +/*
> + * Only include the following if ip6 tables is compiled in
> + * the kernel, or it is a module and this code is also a module.
> + */
> +#if defined(CONFIG_IP6_NF_IPTABLES) || \
> +	(defined(CONFIG_IP6_NF_IPTABLES_MODULE) && \
> +	 defined(CONFIG_NETFILTER_XT_TARGET_TPROXY_MODULE))
>  #define XT_TPROXY_HAVE_IPV6 1
>  #include <net/if_inet6.h>
>  #include <net/addrconf.h>
> 
> 
