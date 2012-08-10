Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab2HJR1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 13:27:41 -0400
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:49396 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754721Ab2HJR1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 13:27:38 -0400
Message-ID: <50254434.7040701@xenotime.net>
Date: Fri, 10 Aug 2012 10:26:12 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alex Elder <elder@inktank.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH]  lib/parser.c: avoid overflow in match_number()
References: <5024179D.30308@inktank.com>
In-Reply-To: <5024179D.30308@inktank.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 01:03 PM, Alex Elder wrote:

> The result of converting an integer value to another signed integer
> type that's unable to represent the original value is implementation
> defined.  (See notes in section 6.3.1.3 of the C standard.)
> 
> In match_number(), the result of simple_strtol() (which returns type
> long) is assigned to a value of type int.
> 
> Instead, handle the result of simple_strtol() in a well-defined way,
> and return -ERANGE if the result won't fit in the int variable used
> to hold the parsed result.
> 
> No current callers pay attention to the particular error value
> returned, so this additional return code shouldn't do any harm.
> 
> Signed-off-by: Alex Elder <elder@inktank.com>


Makes sense to me, but I wonder who will merge it.

I'm Cc-ing a couple of possibilities.

> ---
>  lib/parser.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> Index: b/lib/parser.c
> ===================================================================
> --- a/lib/parser.c
> +++ b/lib/parser.c
> @@ -122,13 +122,14 @@ int match_token(char *s, const match_tab
>   *
>   * Description: Given a &substring_t and a base, attempts to parse the substring
>   * as a number in that base. On success, sets @result to the integer represented
> - * by the string and returns 0. Returns either -ENOMEM or -EINVAL on failure.
> + * by the string and returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
>   */
>  static int match_number(substring_t *s, int *result, int base)
>  {
>      char *endp;
>      char *buf;
>      int ret;
> +    long val;
>      size_t len = s->to - s->from;
> 
>      buf = kmalloc(len + 1, GFP_KERNEL);
> @@ -136,10 +137,15 @@ static int match_number(substring_t *s,
>          return -ENOMEM;
>      memcpy(buf, s->from, len);
>      buf[len] = '\0';
> -    *result = simple_strtol(buf, &endp, base);
> +
>      ret = 0;
> +    val = simple_strtol(buf, &endp, base);
>      if (endp == buf)
>          ret = -EINVAL;
> +    else if (val < (long) INT_MIN || val > (long) INT_MAX)
> +        ret = -ERANGE;
> +    else
> +        *result = (int) val;
>      kfree(buf);
>      return ret;
>  }
> -- 


-- 
~Randy
