Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab2DAPnd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 11:43:33 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55704 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab2DAPn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 11:43:29 -0400
Subject: Re: [PATCH] nextfd(2)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20120401125741.GA7484@p183.telecom.by>
References: <20120401125741.GA7484@p183.telecom.by>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 01 Apr 2012 17:43:25 +0200
Message-ID: <1333295005.2325.5204.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-01 at 15:57 +0300, Alexey Dobriyan wrote:

> +
> +/* Return first opened file descriptor which is >= than the argument. */
> +SYSCALL_DEFINE1(nextfd, unsigned int, fd)
> +{
> +	struct files_struct *files = current->files;
> +	struct fdtable *fdt;
> +
> +	rcu_read_lock();
> +	fdt = files_fdtable(files);
> +	while (fd < fdt->max_fds) {
> +		struct file *file;
> +
> +		file = rcu_dereference_check_fdtable(files, fdt->fd[fd]);
> +		if (file) {
> +			rcu_read_unlock();
> +			return fd;
> +		}
> +		fd++;
> +	}
> +	rcu_read_unlock();
> +	return -ESRCH;
> +}

Interesting idea but what about using fdt->open_fds bitmap to have a
fast search and less cache pollution ?

alloc_fd(start, flags) uses find_next_zero_bit(), you could use
find_next_bit().




