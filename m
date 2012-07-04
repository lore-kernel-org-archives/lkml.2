Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab2GDPJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 11:09:50 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40142 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752849Ab2GDPJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 11:09:49 -0400
Message-ID: <1341414588.3627.42.camel@joe2Laptop>
Subject: Re: [PATCHv3 2/3] lib: printf: append support of '%*ph[CDN]'
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, proski@gnu.org,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
        linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Date: Wed, 04 Jul 2012 08:09:48 -0700
In-Reply-To: <1341391552-4842-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1341341280.2012.3.camel@joe2Laptop>
	 <1341391552-4842-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1341391552-4842-2-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 11:45 +0300, Andy Shevchenko wrote:
> This patch adds a support of the variable width buffer to print it
> as a hex string with a delimiter.

Hi again Andy.

> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
> @@ -655,6 +655,57 @@ char *resource_string(char *buf, char *end, struct resource *res,
>  }
>  
>  static noinline_for_stack
> +char *hex_string(char *buf, char *end, u8 *addr, struct printf_spec spec,
> +		 const char *fmt)
> +{
> +	char hex_str[8*3+1];	/* support up to 8 bytes to print */

I think you don't need hex_str at all.

[]

> +	if (spec.field_width <= 0)
> +		/* nothing to print */
> +		return buf;

It may be better to default to a 1 and add

	if (addr == ZERO_OR_NULL_PTR)

to avoid dereferencing a NULL or a pointer
to a zero length object.

> +
> +	len = min_t(int, spec.field_width, 64);
> +
> +	while (i < len) {
> +		p = hex_str;
> +		for (j = 0; j < 8 && i < len; j++, i++) {
> +			p = hex_byte_pack(p, addr[i]);
> +
> +			if (separator && i != len - 1)
> +				*p++ = separator;
> +		}
> +		*p = '\0';
> +
> +		for (p = hex_str; *p != '\0'; p++) {
> +			if (buf < end)
> +				*buf = *p;
> +			++buf;
> +		}

why not just directly write to *buf as long as buf < end?

cheers, Joe

