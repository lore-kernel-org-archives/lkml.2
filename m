Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab2E0UvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 16:51:19 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37973 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752786Ab2E0UvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 16:51:14 -0400
Message-ID: <1338151872.28188.16.camel@joe2Laptop>
Subject: Re: [PATCH] x86: kernel/early_printk.c simple_strtoul cleanup
From: Joe Perches <joe@perches.com>
To: shuahkhan@gmail.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 27 May 2012 13:51:12 -0700
In-Reply-To: <1338137317.2968.27.camel@lorien2>
References: <1338137317.2968.27.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-05-27 at 10:48 -0600, Shuah Khan wrote:
> Change early_serial_init() to call kstrtoul() instead of calling obsoleted
> simple_strtoul().
[]
> diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
[]
> @@ -119,22 +119,27 @@ static __init void early_serial_init(char *s)
>  	unsigned char c;
>  	unsigned divisor;
>  	unsigned baud = DEFAULT_BAUD;
> -	char *e;
> +	unsigned long val;
> +	ssize_t ret;
>  
>  	if (*s == ',')
>  		++s;
>  
>  	if (*s) {
> -		unsigned port;
> +		unsigned port = 0;
>  		if (!strncmp(s, "0x", 2)) {
> -			early_serial_base = simple_strtoul(s, &e, 16);
> +			ret = kstrtoul(s, 16, &val);
> +			if (!ret)
> +				early_serial_base = val;

I believe none of the kstrto<foo> calls set
the value in the pointer unless successful so
you don't need a temporary and can simply use:

		ret = kstrtoint(s, 16, &early_serial_base)
		if (ret)

etc...


