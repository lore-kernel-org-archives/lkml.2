Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab0LWEK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 23:10:59 -0500
Received: from mail.perches.com ([173.55.12.10]:2845 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258Ab0LWEK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 23:10:58 -0500
Subject: Re: [PATCH v7] kptr_restrict for hiding kernel pointers
From: Joe Perches <joe@perches.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, jmorris@namei.org,
        eric.dumazet@gmail.com, tgraf@infradead.org, eugeneteo@kernel.org,
        kees.cook@canonical.com, mingo@elte.hu, davem@davemloft.net,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
        eparis@parisplace.org
In-Reply-To: <1293069792.9820.342.camel@dan>
References: <1293069792.9820.342.camel@dan>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 20:10:55 -0800
Message-ID: <1293077455.28077.6.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 21:03 -0500, Dan Rosenberg wrote:
> Add the %pK printk format specifier and
> the /proc/sys/kernel/kptr_restrict sysctl.

Another trivial style comment:

> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
> +	case 'K':
> +		/*
> +		 * %pK cannot be used in IRQ context because its test
> +		 * for CAP_SYSLOG would be meaningless.
> +		 */
> +		if (in_irq() || in_serving_softirq() || in_nmi()) {
> +			if (spec.field_width == -1)
> +				spec.field_width = 2 * sizeof(void *);
> +			return string(buf, end, "pK-error", spec);
> +		}
> +
> +		else if ((kptr_restrict == 0) ||
> +			 (kptr_restrict == 1 &&
> +			  has_capability_noaudit(current, CAP_SYSLOG)))
> +			break;
> +

---

> +		if (spec.field_width == -1) {
> +			spec.field_width = 2 * sizeof(void *);
> +			spec.flags |= ZEROPAD;
> +		}
> +		return number(buf, end, 0, spec);

It'd be slightly smaller code to use:

 		   ptr = 0;
		   break;

and delete the if block and return number.

>  	}
>  	spec.flags |= SMALL;
>  	if (spec.field_width == -1) {


