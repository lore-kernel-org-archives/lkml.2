Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab2KJSrl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 13:47:41 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:65049 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab2KJSrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 13:47:39 -0500
Message-ID: <509EA129.800@cs.tu-berlin.de>
Date: Sat, 10 Nov 2012 19:47:05 +0100
From: =?UTF-8?B?IkphbiBILiBTY2jDtm5oZXJyIg==?= <schnhrr@cs.tu-berlin.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120324 Thunderbird/10.0.3
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH resend] printk: drop ambiguous LOG_CONT flag
References: <20121102233610.GA3239@kroah.com> <1351977176-28381-1-git-send-email-schnhrr@cs.tu-berlin.de>
In-Reply-To: <1351977176-28381-1-git-send-email-schnhrr@cs.tu-berlin.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg.

This still needs a small fix, see below.

Am 03.11.2012 22:12, schrieb Jan H. Schönherr:
> From: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
> 
> The meaning of LOG_CONT is unclear, i. e., whether a message is a starting,
> ending, or middle fragment. Unfortunately, this cannot be inferred from
> the LOG_PREFIX and LOG_NEWLINE flags, as they are not always kept.
> Furthermore, in some cases LOG_CONT is set, although it is unknown if
> there will be a continuation. This leads to wrongly concatenated output.
> 
> Fix this by dropping LOG_CONT and rely on LOG_PREFIX and LOG_NEWLINE to
> distinguish the type of fragment. That is, if LOG_PREFIX is set, this
> fragment does not continue the previous fragment. And if LOG_NEWLINE is
> set, this fragment is not continued by the next fragment.
> 
> (Unfortunately, we still have to look at the previous fragment to catch the
> case of an unset LOG_PREFIX on this fragment, but a set LOG_NEWLINE on
> the previous fragment.)
> 
> Tested-By: Kay Sievers <kay@vrfy.org>
> Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
> ---
> Against linux-next from 20121102, added Kay's tested-by.
> ---
>  kernel/printk.c | 57 +++++++++++++++++++++++++++++++++------------------------
>  1 file changed, 33 insertions(+), 24 deletions(-)
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 22e070f..e8e4e67 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c

[...]

> @@ -1581,12 +1585,16 @@ asmlinkage int vprintk_emit(int facility, int level,
>  		 * Flush the conflicting buffer. An earlier newline was missing,
>  		 * or another task also prints continuation lines.
>  		 */
> -		if (cont.len && (lflags & LOG_PREFIX || cont.owner != current))
> -			cont_flush(LOG_NEWLINE);
> +		if (cont.len) {

This line should have been:
+		if (cont.len && !cont.flushed) {

The effect of this is that we now avoid to add a superfluous newline
over and over (due to setting LOG_PREFIX), when the cont buffer has been
flushed but not yet printed.

> +			if (cont.owner != current)
> +				lflags |= LOG_PREFIX;
> +			if (lflags & LOG_PREFIX)
> +				cont_flush(LOG_NEWLINE);
> +		}
>  
>  		/* buffer line if possible, otherwise store it right away */
> -		if (!cont_add(facility, level, text, text_len))
> -			log_store(facility, level, lflags | LOG_CONT, 0,
> +		if (!cont_add(facility, level, lflags, text, text_len))
> +			log_store(facility, level, lflags, 0,
>  				  dict, dictlen, text, text_len);
>  	} else {
>  		bool stored = false;
> @@ -1599,7 +1607,8 @@ asmlinkage int vprintk_emit(int facility, int level,
>  		 */
>  		if (cont.len && cont.owner == current) {

For symmetry reasons, the "if" here could use the same change. But here it
does not really matter as currently cont_add() and cont_flush() are NOPs when
cont.flushed is set.

>  			if (!(lflags & LOG_PREFIX))
> -				stored = cont_add(facility, level, text, text_len);
> +				stored = cont_add(facility, level, lflags,
> +							text, text_len);
>  			cont_flush(LOG_NEWLINE);
>  		}

As I've not yet seen this patch turn up anywhere, I'm preparing a v2 of this
together with a couple of other patches that are now more or less ready.

Regards
Jan


