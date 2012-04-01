Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab2DAVcC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 17:32:02 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53637 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab2DAVcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 17:32:00 -0400
Date: Mon, 2 Apr 2012 00:31:54 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
Message-ID: <20120401213154.GB4408@p183.telecom.by>
References: <20120401125741.GA7484@p183.telecom.by>
 <1333295005.2325.5204.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333295005.2325.5204.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2012 at 05:43:25PM +0200, Eric Dumazet wrote:
> On Sun, 2012-04-01 at 15:57 +0300, Alexey Dobriyan wrote:
> 
> > +
> > +/* Return first opened file descriptor which is >= than the argument. */
> > +SYSCALL_DEFINE1(nextfd, unsigned int, fd)
> > +{
> > +	struct files_struct *files = current->files;
> > +	struct fdtable *fdt;
> > +
> > +	rcu_read_lock();
> > +	fdt = files_fdtable(files);
> > +	while (fd < fdt->max_fds) {
> > +		struct file *file;
> > +
> > +		file = rcu_dereference_check_fdtable(files, fdt->fd[fd]);
> > +		if (file) {
> > +			rcu_read_unlock();
> > +			return fd;
> > +		}
> > +		fd++;
> > +	}
> > +	rcu_read_unlock();
> > +	return -ESRCH;
> > +}
> 
> Interesting idea but what about using fdt->open_fds bitmap to have a
> fast search and less cache pollution ?
> 
> alloc_fd(start, flags) uses find_next_zero_bit(), you could use
> find_next_bit().

Indeed.
I've copied code from /proc/*/fd implementation which does loop.
