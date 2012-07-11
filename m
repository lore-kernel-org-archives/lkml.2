Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab2GKPBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:01:40 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60150 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755172Ab2GKPBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:01:38 -0400
Message-ID: <1342018897.13724.61.camel@joe2Laptop>
Subject: Re: pr_cat() + CATSTR(name, size)?
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 11 Jul 2012 08:01:37 -0700
In-Reply-To: <1342002808.810.12.camel@mop>
References: <1342002808.810.12.camel@mop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 12:33 +0200, Kay Sievers wrote:
> Hey Joe,

Hi Kay.

> what do you think this?
> 
> It would make composing continuation lines at the caller side entirely
> race-free, and it might fit into the usual pattern.

Maybe.  comments below...

> The more interesting thing, this would allow us to completely race-free
> use the dev_printk() calls with continuation content, which we should
> avoid otherwise for integrity reasons.
> 
> The patch below is just hacked it into the printk.c file to illustrate
> the idea. It prints:
>   [    0.000000] Kernel command line: root=/dev/sda2 ...
>   [    0.000000] 12 34 56 78
>   [    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
> 
>   5,96,0;Kernel command line: root=/dev/sda2 ...
>   4,97,0;12 34 56 78
>   6,98,0;PID hash table entries: 2048 (order: 2, 16384 bytes)
> 
> Thanks,
> Kay
> 
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index dba1821..1fd00b0 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -48,6 +48,32 @@
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/printk.h>
>  
> +#define CATSTR(name, max)		\
> +	char name[max];			\
> +	size_t _##name_len = 0;		\
> +	size_t _##name_max = max;
> +
> +#define pr_cat(name, fmt, ...)		\
> +	_catstr(name, &_##name_len, _##name_max, fmt, ##__VA_ARGS__)
> +
> +ssize_t _catstr(char *s, size_t *len, size_t size, const char *fmt, ...)
> +{
> +	va_list args;
> +	size_t l = *len;
> +	size_t r;
> +
> +	va_start(args, fmt);
> +	r = vsnprintf(s + l, size - l, fmt, args);
> +	va_end(args);
> +
> +	if (r >= size - l)
> +		return -EINVAL;
> +
> +	*len += r;
> +	s[*len] = '\0';
> +	return r;
> +}
> +
>  /*
>   * Architectures can override it:
>   */
> @@ -668,6 +694,12 @@ void __init setup_log_buf(int early)
>  	char *new_log_buf;
>  	int free;
>  
> +	CATSTR(line, 80);
> +	pr_cat(line, "%i ", 12);
> +	pr_cat(line, "%i ", 34);
> +	pr_cat(line, "%i ", 56);
> +	pr_warn("%s%i\n", line, 78);
> +
>  	if (!new_log_buf_len)
>  		return;

Interesting idea, perhaps workable, but it has
a few defects I can see.

It works for most uses, but it doesn't work for
when there are multiple function sites like

void dump_info(struct foo *bar)
{
	if (bar->baz)
		pr_cont("baz...");
}

---

	pr_info("Some initiator: ")
	dump_info(&descriptor);

Another negative is that is uses a local stack
variable for the entire line which increases
stack pressure.

It also fails to immediately output after some
defect unlike your change to output directly to
console.

It would require all sites with continuation lines
be modified.  Because it requires in-situ code
modifications, I'd prefer a cookie based approach.

I think it's more flexible, allows the cookie to be
passed into extending functions and doesn't demand
(much) extra stack.

Something like:
https://lkml.org/lkml/2012/4/3/231
https://lkml.org/lkml/2011/11/14/349

cheers, Joe

