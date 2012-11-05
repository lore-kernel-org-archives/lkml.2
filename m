Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab2KEI0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:26:51 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:41552 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab2KEI0u convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Mon, 5 Nov 2012 03:26:50 -0500
Message-Id: <5097865302000078000A6487@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 05 Nov 2012 08:26:43 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Namit Gupta" <namit2010@gmail.com>
Cc: "George Spelvin" <linux@horizon.com>,
        "Andrei Emeltchenko" <andrei.emeltchenko@intel.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        "open list" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Lib:The patch include fix for "-" during string to
 long conversion
References: <CAKMXDJXssksA0dtyfe5dTt0RerZzTWOORWCZCZdJF7WAp56=Ng@mail.gmail.com>
In-Reply-To: <CAKMXDJXssksA0dtyfe5dTt0RerZzTWOORWCZCZdJF7WAp56=Ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 04.11.12 at 14:26, Namit Gupta <namit2010@gmail.com> wrote:
> API simple_strtol() and simple_strtoul() are giving incorrect result for
> string "-".
> These API's consider "-" as a '-' (negative integer) and return incorrect
> string pointer.
> The API returns pointer next to '-' character. However it should return
> starting pointer of the string.

Where is that behavior specified? If we take the C standard as
reference, it is not being made explicit whether, for "base" other
than zero, the sequence of letters and digits has to be non-empty.

If we take this as implied, then your patch should not only handle
"-" alone, but also cases where "-" is followed by other than a
letter or digit, or an out of range one.

Jan

> Below I have included possible solution for that issue.
> Please review.
> 
> 
> From eea8b5fd7e5bb7b206a41f5eec934152a77a9431 Mon Sep 17 00:00:00 2001
> From: Namit Gupta <namit2010@gmail.com>
> Date: Sun, 4 Nov 2012 23:36:23 +0530
> Subject: [PATCH 1/1] Lib:The patch include fix for "-" during string to
> long conversion
> 
> API simple_strtol and simple_strtoll give wrong result for string "-",
> The API consider "-" as a -ve number which and give incorrect result
> for "-" string.
> 
> Signed-off-by: Namit Gupta <namit2010@gmail.com>
> ---
>  lib/vsprintf.c |   20 ++++++++++++++++----
>  1 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 39c99fe..cde449d 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -76,8 +76,14 @@ EXPORT_SYMBOL(simple_strtoul);
>   */
>  long simple_strtol(const char *cp, char **endp, unsigned int base)
>  {
> -    if (*cp == '-')
> -        return -simple_strtoul(cp + 1, endp, base);
> +    if (*cp == '-') {
> +        if (*(cp+1))
> +            return -simple_strtoul(cp + 1, endp, base);
> +        else if (*endp) { /* The string contains only "-"*/
> +            *endp = (char *)cp;
> +            return 0;
> +        }
> +    }
> 
>      return simple_strtoul(cp, endp, base);
>  }
> @@ -91,8 +97,14 @@ EXPORT_SYMBOL(simple_strtol);
>   */
>  long long simple_strtoll(const char *cp, char **endp, unsigned int base)
>  {
> -    if (*cp == '-')
> -        return -simple_strtoull(cp + 1, endp, base);
> +    if (*cp == '-') {
> +        if (*(cp+1))
> +            return -simple_strtoull(cp + 1, endp, base);
> +        else if (*endp) { /* The string contains only "-"*/
> +            *endp = (char *)cp;
> +            return 0;
> +        }
> +    }
> 
>      return simple_strtoull(cp, endp, base);
>  }
> -- 
> 1.7.1
> 
> 
> Regards,
> Namit



