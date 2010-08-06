Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935300Ab0HFFSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:18:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55787 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933784Ab0HFFSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:18:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Rsp8HYfvuQJks+8/Ml1vZZaxQn2h4a27mtEEmw4jnNrOHWriDuIm9TPjHSUTCZdt71
         bCcT4J2wmUj8dW8PkfAFaB3geR7ksXNR3UhBPBa3zOmUO/N1p5amht0K9ZiKEOFQ8qGu
         1SWUjFj0WsUtBdhlJUWkFkWfStZGgEeHtQlFw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH 2/3] lib: vsprintf: optimised put_dec() for 32-bit machines
Date: Fri, 6 Aug 2010 07:18:38 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, m.nazarewicz@samsung.com,
        "Douglas W. Jones" <jones@cs.uiowa.edu>,
        Andrew Morton <akpm@linux-foundation.org>
References: <f894e94adccb940ef904983fa039a28e12217f48.1280872240.git.mina86@mina86.com> <0543dae0f66ba8e0ce42ce3adf1fe31704eb240d.1280872240.git.mina86@mina86.com>
In-Reply-To: <0543dae0f66ba8e0ce42ce3adf1fe31704eb240d.1280872240.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008060718.38345.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 August 2010 00:38, Michal Nazarewicz wrote:
> The disadvantage is that the proposed function is 2.5-3.5 bigger.
> Those are not big functions though -- we are talking here about
> proposed function being below 512.

It's a slippery slope. Here's where it ends: glibc
has memcpy() function which is "only" 8k of code or so.
I'm not joking.



> +#if BITS_PER_LONG == 64
> +
...  
> +#else
...
> +/*
> + * Based on code by Douglas W. Jones found at
> + * <http://www.cs.uiowa.edu/~jones/bcd/decimal.html#sixtyfour>.  This
> + * performs no 64-bit division and hence should be faster on 32-bit
> + * machines then the version of the function above.
> + */
> +static noinline_for_stack
> +char *put_dec(char *buf, unsigned long long n)
> +{
> +	uint32_t d3, d2, d1, q;
> +
> +	if (!n) {
> +		*buf++ = '0';
> +		return buf;
> +	}
> +
> +	d1  = (n >> 16) & 0xFFFF;
> +	d2  = (n >> 32) & 0xFFFF;
> +	d3  = (n >> 48) & 0xFFFF;

Are you assuming that sizeof(long long) == 8, always?

-- 
vda
