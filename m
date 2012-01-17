Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab2AQRox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:44:53 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:56059 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab2AQRov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:44:51 -0500
Date: Tue, 17 Jan 2012 12:44:49 -0500 (EST)
Message-Id: <20120117.124449.1065919030248165158.davem@davemloft.net>
To: fruggeri@aristanetworks.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net: race condition in ipv6 forwarding and
 disable_ipv6 parameters
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+HUmGgLmsHsTUbKb=XB_Ow+BPajpu75B18Um0zRZRkof8rQmw@mail.gmail.com>
References: <CA+HUmGgLmsHsTUbKb=XB_Ow+BPajpu75B18Um0zRZRkof8rQmw@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 17 Jan 2012 09:44:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francesco Ruggeri <fruggeri@aristanetworks.com>
Date: Mon, 16 Jan 2012 12:40:10 -0800

> -static int addrconf_fixup_forwarding(struct ctl_table *table, int *p, int old)
> +static int addrconf_fixup_forwarding(struct ctl_table *table, int *p, int newf)
 ...
> @@ -4257,9 +4259,17 @@ int addrconf_sysctl_forward(ctl_table *c
>  	int *valp = ctl->data;
>  	int val = *valp;
>  	loff_t pos = *ppos;
> +	ctl_table lctl;
>  	int ret;
> 
> -	ret = proc_dointvec(ctl, write, buffer, lenp, ppos);
> +	/*
> +	 * ctl->data points to idev->cnf.forwarding, we should
> +	 * not modify it until we get the rtnl lock.
> +	 */
> +	lctl = *ctl;
> +	lctl.data = &val;
> +
> +	ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
> 
>  	if (write)
>  		ret = addrconf_fixup_forwarding(ctl, valp, val);

I don't understand this at all.

"val" is still the old value, before proc_dointvec() runs, after your
changes.  So renaming the argument to addrconf_fixup_forwarding() as
"newf" and treating it as the new value doesn't make any sense at all.

Did you really test this patch?
