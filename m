Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab0LRVIB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 16:08:01 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44431 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab0LRVH7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 16:07:59 -0500
MIME-Version: 1.0
In-Reply-To: <1292692835.10804.67.camel@dan>
References: <1292692835.10804.67.camel@dan>
Date: Sat, 18 Dec 2010 16:07:59 -0500
Message-ID: <AANLkTimqpKem=rcfk5gsk0bMdWk45EuEThe0wAYiogxc@mail.gmail.com>
Subject: Re: [PATCH v3] kptr_restrict for hiding kernel pointers
From: Eric Paris <eparis@parisplace.org>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, jmorris@namei.org,
        eric.dumazet@gmail.com, tgraf@infradead.org, eugeneteo@kernel.org,
        kees.cook@canonical.com, mingo@elte.hu, davem@davemloft.net,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 12:20 PM, Dan Rosenberg
<drosenberg@vsecurity.com> wrote:

> @@ -1035,6 +1038,26 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>                return buf + vsnprintf(buf, end - buf,
>                                       ((struct va_format *)ptr)->fmt,
>                                       *(((struct va_format *)ptr)->va));
> +       case 'K':
> +               /*
> +                * %pK cannot be used in IRQ context because it tests
> +                * CAP_SYSLOG.
> +                */
> +               if (in_irq() || in_serving_softirq() || in_nmi())
> +                       WARN_ONCE(1, "%%pK used in interrupt context.\n");
> +
> +               if (!kptr_restrict)
> +                       break;          /* %pK does not obscure pointers */
> +
> +               if ((kptr_restrict != 2) && capable(CAP_SYSLOG))
> +                       break;          /* privileged apps expose pointers,
> +                                          unless kptr_restrict is 2 */

I would suggest has_capability_noaudit() since a failure here is not a
security policy violation it is just a code path choice.

I was confused also by the comment about CAP_SYSLOG and IRQ context.
You can check CAP_SYSLOG in IRQ context, it's just that the result is
not going to have any relation to the work being done.  This function
in general doesn't make sense in that context and I don't think saying
that has anything to do with CAP_SYSLOG makes that clear....  Unless
I'm misunderstanding...
