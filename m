Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab1EEH00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 03:26:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56378 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab1EEH0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 03:26:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=owcpFcawsSgyfdCtU432reXv0cYx5ekAPhSBcFmKtArux65HdV42xOwZeKBXdk7KzA
         +EYlLvCsvhtCwABi82NUFoxX4vg2UU9lhmjFgpM2k9mlUCyySaV6r7GvQPNdVGwrKPGG
         WPBtowWdKp78kSjgNKf44/ojObvLjgD2yOee8=
Date: Thu, 5 May 2011 10:26:19 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mansour Moufid <mansourmoufid@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] simple_strtoul: prevent integer overflows
Message-ID: <20110505072619.GA4517@p183>
References: <BANLkTikXoy+cJV-aj5RVtpLgEQ_Y-3TOSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikXoy+cJV-aj5RVtpLgEQ_Y-3TOSw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 01:54:41AM -0400, Mansour Moufid wrote:
> This patch prevents integer overflows in the functions
> `simple_strtoull' and `simple_strtoul', in the file lib/vsprintf.c.
> This applies to stable version 2.6.38.5.
> 
> I'm aware of the kstrto* functions, but simple_strto* are still used
> in some network-exposed code (netfilter).

These changes break end pointer management at least
for simple_strtoul().

> --- vsprintf.c.orig
> +++ vsprintf.c
> @@ -63,11 +63,20 @@ unsigned long long simple_strtoull(const
>  		cp += 2;
> 
>  	while (isxdigit(*cp)) {
> -		unsigned int value;
> +		unsigned int value = 0;
> 
> -		value = isdigit(*cp) ? *cp - '0' : TOLOWER(*cp) - 'a' + 10;
> +		if (isdigit(*cp))
> +			value = *cp - '0';
> +		else if (isalpha(*cp))
> +			value = TOLOWER(*cp) - 'a' + 10;
> +		else
> +			break;
>  		if (value >= base)
>  			break;
> +		if (result > (ULLONG_MAX - value) / base) {
> +			result = ULLONG_MAX;
> +			break;
> +		}
>  		result = result * base + value;
>  		cp++;
>  	}
> @@ -86,7 +95,12 @@ EXPORT_SYMBOL(simple_strtoull);
>   */
>  unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base)
>  {
> -	return simple_strtoull(cp, endp, base);
> +	unsigned long long result = simple_strtoull(cp, endp, base);
> +
> +	if (result <= ULONG_MAX)
> +		return result;
> +
> +	return ULONG_MAX;
>  }
