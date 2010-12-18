Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab0LRAxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 19:53:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756582Ab0LRAxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 19:53:32 -0500
Date: Fri, 17 Dec 2010 16:53:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org, jmorris@namei.org, eugeneteo@kernel.org,
        kees.cook@canonical.com, mingo@elte.hu, davem@davemloft.net
Subject: Re: [PATCH v2] kptr_restrict for hiding kernel pointers from
 unprivileged users
Message-Id: <20101217165319.98670d66.akpm@linux-foundation.org>
In-Reply-To: <1292025924.2965.20.camel@Dan>
References: <1292025924.2965.20.camel@Dan>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010 19:05:24 -0500
Dan Rosenberg <drosenberg@vsecurity.com> wrote:

> +	case 'K':
> +		if (kptr_restrict) {
> +			if (in_irq() || in_serving_softirq() || in_nmi())
> +				WARN(1, "%%pK used in interrupt context.\n");
> +
> +			else if (capable(CAP_SYSLOG))
> +				break;
> +
> +			if (spec.field_width == -1) {
> +				spec.field_width = 2 * sizeof(void *);
> +				spec.flags |= ZEROPAD;
> +			}
> +			return number(buf, end, 0, spec);
> +		}
> +		break;

Also, we should emit the runtime warning even if kptr_restrict is
false.  Otherwise programmers might ship buggy code because they didn't
enable kptr_restrict during testing.

So what I ended up with was

	case 'K':
		/*
		 * %pK cannot be used in IRQ context because it tests
		 * CAP_SYSLOG.
		 */
		if (in_irq() || in_serving_softirq() || in_nmi())
			WARN_ONCE(1, "%%pK used in interrupt context.\n");

		if (!kptr_restrict)
			break;		/* %pK does not obscure pointers */

		if (capable(CAP_SYSLOG))
			break;		/* privileged apps expose pointers */

		if (spec.field_width == -1) {
			spec.field_width = 2 * sizeof(void *);
			spec.flags |= ZEROPAD;
		}
		return number(buf, end, 0, spec);

How does that look?


Also...  permitting root to bypass the %pK obscuring seems pretty lame,
really.  I bet a *lot* of the existing %p sites are already root-only
(eg, driver initialisation).  So much of the value is lost.
