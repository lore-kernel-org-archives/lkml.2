Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845Ab2BXQwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:52:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45964 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab2BXQwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:52:53 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.102.132 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1202241112350.22368@twin.jikos.cz>
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
 <alpine.LRH.2.00.1202241112350.22368@twin.jikos.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 24 Feb 2012 08:52:32 -0800
X-Google-Sender-Auth: J8py6EpJhEGClcNkMN0NALnlPOY
Message-ID: <CA+55aFwg4EpUhbymOHrSt88FEmZWniMx4goCkk-xK7dwiKcsZg@mail.gmail.com>
Subject: Re: Linux 3.3-rc4
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 2:39 AM, Jiri Kosina <jkosina@suse.cz> wrote:
>
> I just got the BUG below (with g45196ce being the topmost commit).
>
> It happened when trying to start 'gwenview', but I am not able to
> reproduce it again. Adding a few people to CC just in case someone
> immediately sees what might be the problem.

Hmm. That is the code that increments the file counter, afaik:

   0:     48 81 63 30 ff df ff ff   andq   $0xffffffffffffdfff,0x30(%rbx)
   8:     48 c7 43 20 00 00 00 00   movq   $0x0,0x20(%rbx)
  10:     48 c7 43 18 00 00 00 00   movq   $0x0,0x18(%rbx)
  18:     48 85 d2                  test   %rdx,%rdx
  1b:     74 4f                     je     0x6c
  1d:     48 8b 42 18               mov    0x18(%rdx),%rax
  21:     4c 8b a2 30 01 00 00      mov    0x130(%rdx),%r12
  28:*    48 8b 40 30               mov    0x30(%rax),%rax     <--
trapping instruction
  2c:     f0 48 ff 42 68            lock incq 0x68(%rdx)
  31:     f6 43 31 08               testb  $0x8,0x31(%rbx)
  35:     74 07                     je     0x3e

and that preceding test is testing for a NULL "file", and then the

   mov    0x18(%rdx),%rax

is "dentry = file->f_path.dentry", while the trapping "mov
0x30(%rax),%rax" is the continuation of that: "dentry->d_inode" (and
the "lock incq" is the get_file() - it's incrementing the file
counter). That "mov 0x130(%rdx),%r12" in between is doing "mapping =
file->f_mapping"

So dentry seems to be NULL for you.

> The machine has gone through several suspend-resume cycles before this
> happened, so it might well also be some memory corruption caused by a
> random driver.

I almost think it is, because "file->dentry" should never be NULL in a
mapping afaik. Especially as your "mapping" certainly isn't NULL (it's
in %r12, so you can see it in your register dump).

This isn't some unusual code sequence either, so I don't see it as
some random latent bug that is just very unlikely and hard to trigger
in that code itself.

I'll think about it, but my first reaction is "memory corruption". Do
you think you could try to run with a kernel that has SLAB debugging
and poisoning on? If it's a stale pointer dereference that has cleared
that dentry, that _might_ show it closer to the actual bug (rather
than a long time later when the NULL dereference happens).

                    Linus
