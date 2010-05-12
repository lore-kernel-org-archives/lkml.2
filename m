Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab0ELXj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 19:39:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753147Ab0ELXj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 19:39:57 -0400
Date: Wed, 12 May 2010 16:39:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Blanchard <anton@samba.org>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] panic: Call console_verbose in panic
Message-Id: <20100512163907.c67c08ab.akpm@linux-foundation.org>
In-Reply-To: <20100510225959.GC12203@kryten>
References: <20100510225959.GC12203@kryten>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010 08:59:59 +1000
Anton Blanchard <anton@samba.org> wrote:

> 
> Most distros turn the console verbosity down and that means a backtrace after
> a panic never makes it to the console. I assume we haven't seen this because
> a panic is often preceeded by an oops which will have called console_verbose.
> There are however a lot of places we call panic directly, and they are
> broken.
> 
> Use console_verbose like we do in the oops path to ensure a directly called
> panic will print a backtrace.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
> 
> Index: linux-2.6/kernel/panic.c
> ===================================================================
> --- linux-2.6.orig/kernel/panic.c	2010-05-09 09:13:06.000000000 +1000
> +++ linux-2.6/kernel/panic.c	2010-05-09 09:14:13.000000000 +1000
> @@ -87,6 +87,7 @@ NORET_TYPE void panic(const char * fmt, 
>  	 */
>  	preempt_disable();
>  
> +	console_verbose();
>  	bust_spinlocks(1);
>  	va_start(args, fmt);
>  	vsnprintf(buf, sizeof(buf), fmt, args);

hm, console_verbose() is interesting:

: static inline void console_verbose(void)
: {
: 	if (console_loglevel)
: 		console_loglevel = 15;
: }

so if someone has run console_silent():

: static inline void console_silent(void)
: {
: 	console_loglevel = 0;
: }

then console_verbose() doesn't work.


The sole caller of console_silent() is
arch/mn10300/kernel/mn10300-watchdog.c:watchdog_interrupt(), which
makes me wonder if mn10300 is doing something wrong or outdated?

