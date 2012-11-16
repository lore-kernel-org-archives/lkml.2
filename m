Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab2KPT6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:58:49 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48626 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab2KPT6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:58:47 -0500
MIME-Version: 1.0
In-Reply-To: <20121112115707.r8h545480kg0cgkk-cebfxv@webmail.spamcop.net>
References: <20121025101416.v1wilj95q8wkk0os-cebfxv@webmail.spamcop.net>
	<20121111235001.a3gqhaijmec0gk0g-cebfxv@webmail.spamcop.net>
	<CACLa4pu4FFwKdoA8ATfmviOj0e0mAQ3U2FNEiJHCv4RfDY4ZoQ@mail.gmail.com>
	<20121112115707.r8h545480kg0cgkk-cebfxv@webmail.spamcop.net>
Date: Fri, 16 Nov 2012 14:58:46 -0500
Message-ID: <CACLa4pvixB3Ehz-Ds+opvMF73pNwQJxpNx=02qy94ufJag2qwA@mail.gmail.com>
Subject: Re: Bisected regression: iterate_fd() selinux change affects flash plugin
From: Eric Paris <eparis@parisplace.org>
To: Pavel Roskin <proski@gnu.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        SE-Linux <selinux@tycho.nsa.gov>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 11:57 AM, Pavel Roskin <proski@gnu.org> wrote:
> Quoting Eric Paris <eparis@parisplace.org>:
>
>> OMG this +1 -1 stuff is nuts...

Ping, Al.

int iterate_fd(struct files_struct *files, unsigned n,
[snip]
        while (!res && n < fdt->max_fds) {
                file = rcu_dereference_check_fdtable(files, fdt->fd[n++]);
                if (file)
                        res = f(p, file, n);
        }
        spin_unlock(&files->file_lock);
        return res;

So we increment n (the file descriptor number) in the dereference,
then pass that (wrong) number to f().

Every single f() (including SELinux, the cause of this bug) returns
fd+1 (so now we are up by 2).  Then all of the users of iterate fd
actually use fd-1 (which is wrong)

Why not have iterate_fd return -ENOENT on no entries and stop all of
the stupid games?  We fix the real bug (the above function should do
the n++ after the f() call, and the interface is sane to design
against...

-Eric
