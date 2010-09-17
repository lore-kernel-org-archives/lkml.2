Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab0IQVk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 17:40:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771Ab0IQVkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 17:40:55 -0400
Date: Fri, 17 Sep 2010 14:40:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Arnd Bergmann <arnd@arndb.de>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] init: add sys-wrapper.h
Message-Id: <20100917144024.33e66e53.akpm@linux-foundation.org>
In-Reply-To: <1283268619-10728-2-git-send-email-namhyung@gmail.com>
References: <1283268619-10728-1-git-send-email-namhyung@gmail.com>
	<1283268619-10728-2-git-send-email-namhyung@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  1 Sep 2010 00:30:18 +0900
Namhyung Kim <namhyung@gmail.com> wrote:

> sys-wrapper.h contains wrapper functions for various syscalls used in init
> code. This wrappers handle proper address space conversion so that it can
> remove a lot of warnings from sparse.

This all looks pretty neat.

> +#define kernel_sys_call(call, ...)		\
> +({						\
> +	long result;				\
> +	mm_segment_t old_fs = get_fs();		\
> +	set_fs(KERNEL_DS);			\
> +	result = call(__VA_ARGS__);		\
> +	set_fs(old_fs);				\
> +	result;					\
> +})

I was worried that some syscalls don't need the set_fs(), and that this
would add overhead.  But I see that the patch addresses that.

> -	int err = sys_mount(name, "/root", fs, flags, data);
> +	int err = kernel_sys_mount(name, "/root", fs, flags, data);

It would be good if we could arrange for _all_ kernel syscalls to use
the wrappers.  ie: cause a direct call to sys_mount() to not compile?

I don't know how practical that would be.
