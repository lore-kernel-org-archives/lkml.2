Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489Ab0JHTNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 15:13:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758294Ab0JHTNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 15:13:31 -0400
Date: Fri, 8 Oct 2010 12:13:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/parser: cleanup match_number()
Message-Id: <20101008121302.b281e84a.akpm@linux-foundation.org>
In-Reply-To: <1286552657-3353-1-git-send-email-namhyung@gmail.com>
References: <1286552657-3353-1-git-send-email-namhyung@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  9 Oct 2010 00:44:17 +0900
Namhyung Kim <namhyung@gmail.com> wrote:

> Use new variable 'len' to make code more readable.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  lib/parser.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/parser.c b/lib/parser.c
> index fb34977..6e89eca 100644
> --- a/lib/parser.c
> +++ b/lib/parser.c
> @@ -128,12 +128,13 @@ static int match_number(substring_t *s, int *result, int base)
>  	char *endp;
>  	char *buf;
>  	int ret;
> +	size_t len = s->to - s->from;
>  
> -	buf = kmalloc(s->to - s->from + 1, GFP_KERNEL);
> +	buf = kmalloc(len + 1, GFP_KERNEL);
>  	if (!buf)
>  		return -ENOMEM;
> -	memcpy(buf, s->from, s->to - s->from);
> -	buf[s->to - s->from] = '\0';
> +	memcpy(buf, s->from, len);
> +	buf[len] = '\0';
>  	*result = simple_strtol(buf, &endp, base);
>  	ret = 0;
>  	if (endp == buf)

Fair enough.  `len' should strictly be ptrdiff_t and then later on it
wants to be size_t. I can't think of much to do about that...

The function itself looks a bit buggy to me:

static int match_number(substring_t *s, int *result, int base)
{
	char *endp;
	char *buf;
	int ret;
	size_t len = s->to - s->from;

	buf = kmalloc(len + 1, GFP_KERNEL);
	if (!buf)
		return -ENOMEM;
	memcpy(buf, s->from, len);
	buf[len] = '\0';
	*result = simple_strtol(buf, &endp, base);
	ret = 0;
	if (endp == buf)
		ret = -EINVAL;
	kfree(buf);
	return ret;
}

afaict, if you feed it "12q34" then simple_strtoul() will return a
pointer to the 'q' and the result is 12.  The `if (endp == buf)' check
will return false, so this function's attempt to check that all digits
were valid doesn't work right.

If I'm correct, that's fixable by using strict_strtol() or by switching
the test to "if (*endp == '\0')" or similar.  But fixing this may
easily break existing kernel code and existing machine installations,
so we need to tread carefully.




