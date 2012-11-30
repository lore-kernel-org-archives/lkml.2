Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab2K3Dky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 22:40:54 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57300 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab2K3Dkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 22:40:36 -0500
Date: Fri, 30 Nov 2012 03:40:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@parisplace.org>
Cc: Pavel Roskin <proski@gnu.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        SE-Linux <selinux@tycho.nsa.gov>
Subject: Re: Bisected regression: iterate_fd() selinux change affects flash
 plugin
Message-ID: <20121130034034.GB4939@ZenIV.linux.org.uk>
References: <20121025101416.v1wilj95q8wkk0os-cebfxv@webmail.spamcop.net>
 <20121111235001.a3gqhaijmec0gk0g-cebfxv@webmail.spamcop.net>
 <CACLa4pu4FFwKdoA8ATfmviOj0e0mAQ3U2FNEiJHCv4RfDY4ZoQ@mail.gmail.com>
 <20121112115707.r8h545480kg0cgkk-cebfxv@webmail.spamcop.net>
 <CACLa4pvixB3Ehz-Ds+opvMF73pNwQJxpNx=02qy94ufJag2qwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACLa4pvixB3Ehz-Ds+opvMF73pNwQJxpNx=02qy94ufJag2qwA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 02:58:46PM -0500, Eric Paris wrote:
> On Mon, Nov 12, 2012 at 11:57 AM, Pavel Roskin <proski@gnu.org> wrote:
> > Quoting Eric Paris <eparis@parisplace.org>:
> >
> >> OMG this +1 -1 stuff is nuts...
> 
> Ping, Al.
> 
> int iterate_fd(struct files_struct *files, unsigned n,
> [snip]
>         while (!res && n < fdt->max_fds) {
>                 file = rcu_dereference_check_fdtable(files, fdt->fd[n++]);
>                 if (file)
>                         res = f(p, file, n);
>         }
>         spin_unlock(&files->file_lock);
>         return res;
> 
> So we increment n (the file descriptor number) in the dereference,
> then pass that (wrong) number to f().
> 
> Every single f() (including SELinux, the cause of this bug) returns
> fd+1 (so now we are up by 2).  Then all of the users of iterate fd
> actually use fd-1 (which is wrong)
> 
> Why not have iterate_fd return -ENOENT on no entries and stop all of
> the stupid games?  We fix the real bug (the above function should do
> the n++ after the f() call, and the interface is sane to design
> against...

Because we might bloody well want to have "run some test on all opened
files, return the first error".  And -ENOENT is quite possible one.
Moreover, -ENOENT for "everything's OK, keep going" would be really
weird.

The bug is real, but Pavel's patch is all wrong.  The problem is in the
argument; we should pass descriptor number, not descriptor + 1.  And fixing
that (in iterator_fd() itself) makes all callbacks work as they ought to.

PS: Pavel, the life is painful enough as it is, no need to involve BZ into
it.  Next time you need to post a patch, please do just that, especially
when it's so short, OK?
