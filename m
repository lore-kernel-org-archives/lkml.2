Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab1KNOZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 09:25:53 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49916 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab1KNOZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 09:25:52 -0500
Message-ID: <4EC124EB.4050203@suse.cz>
Date: Mon, 14 Nov 2011 15:25:47 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Ilya Zykov <ilya@ilyx.ru>
CC: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH v3 2/2] TTY: tty flip buffer optimisation.
References: <4EC10DC6.8070807@ilyx.ru>
In-Reply-To: <4EC10DC6.8070807@ilyx.ru>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2011 01:47 PM, Ilya Zykov wrote:
> Currently, free flip buffer (tty->buf.free) reserve memory for further used,
> only if driver send to ldisc less 257 bytes in one time.
> If driver send more, flip buffer reserve(kmalloc()) and then
> free(kfree()) every chunk more 256 bytes every time.
> 
> 
> This patch allow reserve more than 256 bytes chunks in free buffer.
> And have self-regulation chunk size ability(very useful for pty).
> Also we can control memory used(at the most TTY_BUFFER_MAX).
> And avoiding useless looking up buffer more then 256 byte size.
> 
> With this patch I get follow results:
> 
> ilya@serh:~/src/pty$ time ./bench_pty_buf 253
> chunk = 253. loop = 3952569.
> real	0m21.017s
> user	0m0.436s
> sys	0m17.749s
> 
> ilya@serh:~/src/pty$ time ./bench_pty_buf 255
> chunk = 255. loop = 3921568.
> real	0m21.276s
> user	0m0.544s
> sys	0m17.329s
> 
> ilya@serh:~/src/pty$ time ./bench_pty_buf 257
> chunk = 257. loop = 3891050.
> real	0m21.652s
> user	0m0.512s
> sys	0m18.593s

Hi, the results are indeed nice. However is there any *real* load other
than this tailor-made microbenchmark where the added code complexity is
worth it?

BTW am I guessing correctly that PATCH 1/2 should contain *no* patch in
fact? That it's just to present the benchmark sources?

> Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
> ---
> diff -uprN -X ../../dontdiff a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
> --- a/drivers/tty/tty_buffer.c	2011-11-12 00:19:27.000000000 +0400
> +++ b/drivers/tty/tty_buffer.c	2011-11-14 15:55:45.000000000 +0400
> @@ -58,8 +58,21 @@ static struct tty_buffer *tty_buffer_all
>  {
>  	struct tty_buffer *p;
>  -	if (tty->buf.memory_used + size > 65536)
> -		return NULL;
> +	if (tty->buf.memory_reserve + size > TTY_BUFFER_MAX) {
> +		/* If possible, free small chunks
> +				have been had total size = "size". */
> +		if (tty->buf.memory_reserve - tty->buf.memory_used >= size)
> +			while (tty->buf.memory_reserve + size >
> +							TTY_BUFFER_MAX) {
> +				p = tty->buf.free;
> +				tty->buf.free = p->next;
> +				tty->buf.memory_reserve -= p->size;
> +				WARN_ON(tty->buf.memory_reserve < 0);
> +				kfree(p);
> +			}
> +		else
> +			return NULL;
> +	}
>  	p = kmalloc(sizeof(struct tty_buffer) + 2 * size, GFP_ATOMIC);
>  	if (p == NULL)
>  		return NULL;
> @@ -71,6 +84,7 @@ static struct tty_buffer *tty_buffer_all
>  	p->char_buf_ptr = (char *)(p->data);
>  	p->flag_buf_ptr = (unsigned char *)p->char_buf_ptr + size;
>  	tty->buf.memory_used += size;
> +	tty->buf.memory_reserve += size;
>  	return p;
>  }
>  @@ -91,11 +105,12 @@ static void tty_buffer_free(struct tty_s
>  	tty->buf.memory_used -= b->size;
>  	WARN_ON(tty->buf.memory_used < 0);
>  -	if (b->size >= 512)
> -		kfree(b);
> -	else {
> +	if (tty->buf.free != NULL) {
>  		b->next = tty->buf.free;
>  		tty->buf.free = b;
> +	} else {
> +		tty->buf.free = b;
> +		b->next = NULL;
>  	}
>  }
>  @@ -517,6 +532,7 @@ void tty_buffer_init(struct tty_struct *
>  	tty->buf.tail = NULL;
>  	tty->buf.free = NULL;
>  	tty->buf.memory_used = 0;
> +	tty->buf.memory_reserve = 0;
>  	INIT_WORK(&tty->buf.work, flush_to_ldisc);
>  }
>  diff -uprN -X ../../dontdiff a/include/linux/tty.h b/include/linux/tty.h
> --- a/include/linux/tty.h	2011-11-12 00:19:27.000000000 +0400
> +++ b/include/linux/tty.h	2011-11-14 14:51:21.000000000 +0400
> @@ -82,7 +82,7 @@ struct tty_buffer {
>   */
>   #define TTY_BUFFER_PAGE	(((PAGE_SIZE - sizeof(struct tty_buffer)) / 2) & ~0xFF)
> -
> +#define TTY_BUFFER_MAX		65536
>   struct tty_bufhead {
>  	struct work_struct work;
> @@ -90,6 +90,7 @@ struct tty_bufhead {
>  	struct tty_buffer *head;	/* Queue head */
>  	struct tty_buffer *tail;	/* Active buffer */
>  	struct tty_buffer *free;	/* Free queue head */
> +	int memory_reserve;		/* Buffer space used */
>  	int memory_used;		/* Buffer space used excluding
>  								free queue */
>  };

thanks,
-- 
js
suse labs
