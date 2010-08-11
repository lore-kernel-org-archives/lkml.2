Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab0HKWnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 18:43:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39308 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab0HKWnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 18:43:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=qHdLxWDLzPob8pPY+OlWLAirsNvuKs8TVfBGdNtrRhzdtQP2cb+iIk1KL2idDJhWSF
         hKcfr/FzrOAOHlRAyCqDxejc7HGka/F/kafoMsZ/am48dtq4VISnMSxXvJ/8k+XptJBn
         m3x4Jo1I5KsNYfanCEzxLFI2KF+EZJCGzLG+4=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCHv3 1/2] lib: vsprintf: optimised put_dec() function
Date: Thu, 12 Aug 2010 00:43:34 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, m.nazarewicz@samsung.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "Douglas W. Jones" <jones@cs.uiowa.edu>
References: <1bec965de7de10bf9cddda988a2eaaf755852919.1281532502.git.mina86@mina86.com>
In-Reply-To: <1bec965de7de10bf9cddda988a2eaaf755852919.1281532502.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008120043.34081.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 August 2010 23:58, Michal Nazarewicz wrote:
> +static noinline_for_stack
> +char *put_dec(char *buf, unsigned long long n)
> +{
> +	uint32_t d3, d2, d1, q;
> +
> +	if (n < 10) {
> +		*buf++ = '0' + (unsigned)n;
> +		return buf;
> +	}

I looked at it and discovered that 0 is already special-cased
at put_dec() callsite. You can drop the above if() block
(or better comment it out, explaining that caller does it),
and while at it, improve special-case code in number():
replace

        /* generate full string in tmp[], in reverse order */
        i = 0;
        if (num == 0)
                tmp[i++] = '0';

with

        if (num <= 7)
                tmp[i++] = '0' + num;

(7, not 9, because it can be an octal conversion).


> +	q   = q / 10000;
> +	buf = put_dec_full4(buf, q % 10000);

Bug. You need to use temporary variable to store q / 10000 result.

-- 
vda
