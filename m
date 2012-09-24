Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab2IXOdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:33:09 -0400
Received: from science.horizon.com ([71.41.210.146]:59796 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755893Ab2IXOdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:33:06 -0400
Date: 24 Sep 2012 10:33:05 -0400
Message-ID: <20120924143305.30771.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: akpm@linux-foundation.org, linux@horizon.com, rabin@rab.in
Subject: Re: [PATCH 3/4] lib: vsprintf: Optimize put_dec_trunc8
Cc: hughd@google.com, linux-kernel@vger.kernel.org, mina86@mina86.com,
        vda.linux@googlemail.com
In-Reply-To: <CAH+eYFBscQnH78CZFLq2GwTJZR1+zkUc6gL1QgnWNoFCQwRy2A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rabin Vincent <rabin@rab.in> wrote:
> This patch breaks IP address printing with "%pI4" (and by extension,
> nfsroot).  Example:
>
>  - Before: 10.0.0.1
>  - After: 10...1

Mea culpa, and thank you for catching it!  As I said in my earlier
comment, I tested this most extensively wrapped by some sprintf code
that liked 0 converted to a 0-length string, as that works naturally
with the ANSI spec for %.0u.  And it turns out not to matter for the
usual printf code, as num_to_str special-cases that anyway.

The fix is straightforward:

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index e755083..9872855 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -180,8 +180,6 @@ char *put_dec_trunc8(char *buf, unsigned r)
 		*buf++ = q - 10*r;
 	}
 
-	if (r == 0)
-		return buf;
 	q      = (r * 0x199a) >> 16;	/* r <= 9999 */
 	*buf++ = (r - 10 * q)  + '0';
 	if (q == 0)

Inspired by Michal Nazarewicz, I have some ideas for more tweaking to
that code.


AKPM: How should I submit this to you?  Would you like it as a fixup
patch, or would you like a revised patch from baseline?  You're free to
do either manually and add my Signed-off-by: to the result if you want
the fix faster.

I'm also working on addressing Denys Vlasenko's comments, but I figure
the bugfix is more urgent.
