Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab2DARVZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 13:21:25 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39876 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2DARVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 13:21:21 -0400
MIME-Version: 1.0
In-Reply-To: <20120401125741.GA7484@p183.telecom.by>
References: <20120401125741.GA7484@p183.telecom.by>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 1 Apr 2012 10:20:59 -0700
X-Google-Sender-Auth: npZPDIGzeCTM9hr7e0ATmGVfdCg
Message-ID: <CA+55aFwCaekbk7VocaU0_O=7fDgJRBXUiQYvoYh1GDMicbCtow@mail.gmail.com>
Subject: Re: [PATCH] nextfd(2)
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 1, 2012 at 5:57 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
> BSD added closefrom(fd) which is OK for this exact purpose but suboptimal
> on the bigger scale. closefrom(2) does only close(2) (obviously :-)
> closefrom(2) siletly ignores errors from close(2) which in theory is not OK
> for userspace.
>
> So, don't add closefrom(2), add nextfd(2).

I don't disagree with this, but I don't think it's worth a new file of
its own - I think it should go next to dup() and friends (currently in
fs/fcntl.h).

Also, I think you should:

 (a) at a minimum use the bitmap.  It's easy:

    struct fdtable *fdt;

    rcu_read_lock();
    fdt = files_fdtable(current->files);
    .. maximum fd in fdt->max_fds ...
    .. you have the bitmap in fdt->open_fds ..

 (b) I'd also suggest you add a "flag" argument and have at least one
bit option for "search for next *free* file table entry". I'm not sure
anybody wants it, but it is kind of the same operation, and having a
"flags" field means that it's extensible in the future if people want
to find the next cloexec fd or whatever. Or if they just want to find
the *last* fd, or something.

But I think the concept makes sense.

                               Linus
