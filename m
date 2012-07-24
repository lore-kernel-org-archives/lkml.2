Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab2GXUNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 16:13:43 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58460 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab2GXUMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 16:12:12 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxYe64cNUNc5Xsz3R34nLynhWri=7konGGgM9iNHFVuFg@mail.gmail.com>
References: <20120724181209.GA10534@zod.bos.redhat.com> <CA+55aFw-=vY1eAubQAtbqL33nCrQ7mPgXTaHnEJfbKvFDVdHtw@mail.gmail.com>
 <20120724182409.GB10534@zod.bos.redhat.com> <500EF541.50009@redhat.com>
 <CA+55aFwSHae5rgFP_b_+r9Agz9JfM9QdoNbZTq7u+5G-xrr8RQ@mail.gmail.com>
 <20120724194124.GF10534@zod.bos.redhat.com> <CA+55aFxYe64cNUNc5Xsz3R34nLynhWri=7konGGgM9iNHFVuFg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Jul 2012 13:11:49 -0700
X-Google-Sender-Auth: jvUvekmmMIP5XLhHHPvdLFKVvWU
Message-ID: <CA+55aFwUi8Zg_WGtOdJcvpQa9yLH0fOU0pfOKGoAgtnJdOqrSg@mail.gmail.com>
Subject: Re: [PATCH] posix_types.h: make __NFDBITS match glibc definition
To: Josh Boyer <jwboyer@redhat.com>
Cc: Jeff Law <law@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 12:59 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And I suspect (but it must be before even the old bitkeeper tree) that
> we *used* to implement __FD_ISSET() long ago. We removed it, and
> nobody used it, so nobody even noticed that we removed it - but left
> some now unused stuff behind.

Nope, I found it. It was in the arch-specific header files, and then
moved to asm-generic, and then removed entirely by commit 8b3d1cda4f5f
("posix_types: Remove fd_set macros"). Fairly recently, in fact
(February).

But even before they were removed, they were inside #ifdef __KERNEL__
protection, so it wasn't available to user code.

And to be *really* crazy, it turns out that by the time we removed
those __FD_ISSET() etc macros, they didn't even use the helper macros
any more. So instead of using

 #define __FD_ISSET(d, set) ((set)->fds_bits[__FDELT(d)] & __FDMASK(d))

(like the original arch-specific ones had done), we had already
implicitly stopped using those macros inside the kernel when we moved
to the generic version (that did all this by hand in inline
functions).

So the only users of __FDELT/__FDMASK seem to have gone away many
moons ago. I really don't think that any sane user space could be
using those left-over helpers.

Of course, the magic word there is "sane". I'm sure there are insane
users somewhere. But I don't think we should care.

           Linus
