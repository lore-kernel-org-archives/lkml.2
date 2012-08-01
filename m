Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab2HAXvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 19:51:01 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38934 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab2HAXuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 19:50:51 -0400
Message-ID: <5019C0D4.5010403@gmail.com>
Date: Thu, 02 Aug 2012 09:50:44 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Cruz Julian Bishop <cruzjbishop@gmail.com>
CC: greg@kroah.com, swetland@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] Fixes a potential bug in android/logger.c
References: <1343796860-7025-1-git-send-email-cruzjbishop@gmail.com> <1343796860-7025-6-git-send-email-cruzjbishop@gmail.com>
In-Reply-To: <1343796860-7025-6-git-send-email-cruzjbishop@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/12 14:54, Cruz Julian Bishop wrote:
> Previously, when calling is_between(a, b, c), the calculation was wrong.
> It counted C as between A and B if C was equal to B, but not A.
> 
> Example of this are:
> 
> is_between(1, 10, 10) = 1 (Expected: 0)
> is_between(1, 10, 1) = 0 (Expected: 0)
> is_between(20, 10, 10) = 1 (Expected: 0)
> 
> And so on and so forth.
> 
> Obviously, ten is not a number between one and ten - only two to eight are, so I made this patch :)

Is nine not a number between one and ten? :-p.

The question with a patch like this is whether the function's
documentation, which says it returns 1 if a < c < b is wrong, or whether
the implementation, which does a < c <= b is wrong. If the documentation
is wrong, and something is relying on the current implementation, then
this patch might actually break things.

> Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
> ---
>  drivers/staging/android/logger.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
> index 226d8b5..925df5c 100644
> --- a/drivers/staging/android/logger.c
> +++ b/drivers/staging/android/logger.c
> @@ -298,11 +298,11 @@ static inline int is_between(size_t a, size_t b, size_t c)
>  {
>  	if (a < b) {
>  		/* is c between a and b? */
> -		if (a < c && c <= b)
> +		if (a < c && c < b)
>  			return 1;
>  	} else {
>  		/* is c outside of b through a? */
> -		if (c <= b || a < c)
> +		if (c < b || a < c)
>  			return 1;
>  	}

A couple of other improvements could be done here. The function should
really return bool, inline is unnecessary (the compiler is smart enough
to do that for us), and we can simplify the logic a bit too:

static bool is_between(size_t a, size_t b, size_t c)
{
	if (a < b)
		swap(a, b);

	return (a < c && c < b);
}

~Ryan




