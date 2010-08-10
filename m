Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab0HJDSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 23:18:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62890 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab0HJDRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 23:17:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=F0KKcLQFxwjYPkmD9Po2QQVcWqG9sCmBewGeus/dO0XU9m0yOsnXIzwWSz0PmZRkgH
         Rb0pUvX1G3Jk9gyX32DmXbAfoDQF/HLmEXAuRxiztLxbwDLQ8M2nCZX237w+9xSwEm9V
         ap4JksPeQZs0Sk3PFsjMfCWBm30BBtKYK5Zg0=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCHv2 1/3] lib: vsprintf: optimised put_dec_trunc() and put_dec_full()
Date: Tue, 10 Aug 2010 05:17:48 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, m.nazarewicz@samsung.com,
        "Douglas W. Jones" <jones@cs.uiowa.edu>,
        Andrew Morton <akpm@linux-foundation.org>
References: <6f90103dea29739de0f4f0ede3f3da68afe84343.1281295424.git.mina86@mina86.com>
In-Reply-To: <6f90103dea29739de0f4f0ede3f3da68afe84343.1281295424.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008100517.48231.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 August 2010 21:29, Michal Nazarewicz wrote:
> -- Speed --------------------------------------------------------
> orig_put_dec_full   :   1.054570   1.356214   1.732636   1.725760  Original
> mod1_put_dec_full   :   1.000000   1.017216   1.255518   1.116559
> mod3_put_dec_full   :   1.018222   1.000000   1.000000   1.000000  Proposed
> 
> orig_put_dec_trunc  :   1.137903   1.216017   1.850478   1.662370  Original
> mod1_put_dec_trunc  :   1.000000   1.078154   1.355635   1.400637
> mod3_put_dec_trunc  :   1.025989   1.000000   1.000000   1.000000  Proposed
> -- Size ---------------------------------------------------------
> orig_put_dec_full   :   1.212766   1.310345   1.355372   1.355372  Original
> mod1_put_dec_full   :   1.021277   1.000000   1.000000   1.000000
> mod3_put_dec_full   :   1.000000   1.172414   1.049587   1.049587  Proposed
> 
> orig_put_dec_trunc  :   1.363636   1.317365   1.784000   1.784000  Original
> mod1_put_dec_trunc  :   1.181818   1.275449   1.400000   1.400000
> mod3_put_dec_trunc  :   1.000000   1.000000   1.000000   1.000000  Proposed

In my testing on Phenom II the speed gain is smaller,
but it is indeed faster. And smaller!


> +	/*
> +	 * '(x * 0xcccd) >> 19' is an approximation of 'x / 10' that
> +	 * gives correct results for all x < 81920.  However, because
> +	 * intermediate result can be at most 32-bit we limit x to be
> +	 * 16-bit.
> +	 *
> +	 * Because of those, we check if we are dealing with a "big"
> +	 * number and if so, we make it smaller remembering to add to
> +	 * the most significant digit.
> +	 */
> +	if (q >= 50000) {
> +		a  = '5';
> +		q -= 50000;
...
> +	/*
> +	 * We need to check if q is < 65536 so we might as well check

You meant "need to check if q is < 81920"?

> +	 * if we can just call the _full version of this function.
> +	 */
> +	if (q > 9999)
> +		return put_dec_full(buf, q);

-- 
vda
