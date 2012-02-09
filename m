Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab2BIQ2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 11:28:53 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35314 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab2BIQ2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 11:28:52 -0500
Message-ID: <1328804920.6099.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] Reduce the number of expensive division instructions
 done by _parse_integer()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: adobriyan@gmail.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Thu, 09 Feb 2012 17:28:40 +0100
In-Reply-To: <20120209154819.32070.93358.stgit@warthog.procyon.org.uk>
References: <20120209154819.32070.93358.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 09 février 2012 à 15:48 +0000, David Howells a écrit :
> _parse_integer() does one or two division instructions (which are slow) per
> digit parsed to perform the overflow check.
> 
> Furthermore, these are particularly expensive examples of division instruction
> as the number of clock cycles required to complete them may go up with the
> position of the most significant set bit in the dividend:
> 
> 	if (*res > div_u64(ULLONG_MAX - val, base))
> 
> which is as maximal as possible.
> 
> Worse, on 32-bit arches, more than one of these division instructions may be
> required per digit.
> 
> So, assuming we don't support a base of more than 16, skip the check if the
> top nibble of the result is not set at this point.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  lib/kstrtox.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/kstrtox.c b/lib/kstrtox.c
> index 7a94c8f..f80c896 100644
> --- a/lib/kstrtox.c
> +++ b/lib/kstrtox.c
> @@ -64,7 +64,7 @@ unsigned int _parse_integer(const char *s, unsigned int base, unsigned long long
>  
>  		if (val >= base)
>  			break;
> -		if (*res > div_u64(ULLONG_MAX - val, base))
> +		if (unlikely(*res >> 60) && *res > div_u64(ULLONG_MAX - val, base))
>  			overflow = 1;
>  		*res = *res * base + val;
>  		rv++;
> 
> -

You could avoid the divide and have cleaner code I think.

	unsigned long long next = *res * base + val;

	if (next < *res)
		overflow = 1;
	*res = next;


