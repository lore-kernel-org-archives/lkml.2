Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab2EaAlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 20:41:17 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35796 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab2EaAlP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 20:41:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120531002802.GA11775@ZenIV.linux.org.uk>
References: <1337807899.15138.31.camel@falcor> <20120530043443.GA3200@ZenIV.linux.org.uk>
 <20120530163605.GV11775@ZenIV.linux.org.uk> <1338406967.2257.24.camel@localhost>
 <20120530202427.GW11775@ZenIV.linux.org.uk> <CA+55aFxiCksfNdRrm+O-eJSY=qTUQEsZtFbi8wj2_kj1XeNHnQ@mail.gmail.com>
 <20120530205612.GY11775@ZenIV.linux.org.uk> <CA+55aFwXfD6vCj8sHuB33ctB-D8cfJN45h+iURXA6mR=S0mgwA@mail.gmail.com>
 <20120530213638.GZ11775@ZenIV.linux.org.uk> <CA+55aFzP8Eo1AX7MS-RRG_Atq3NF0bS1ReZydRtgxxy7TDn57Q@mail.gmail.com>
 <20120531002802.GA11775@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 May 2012 17:40:54 -0700
X-Google-Sender-Auth: 5FjlxMIvzRBybJFqYgv9mdr9_rw
Message-ID: <CA+55aFzDeZQeFY1i1xLES4ijtDeGBk3EBOh-mA0dhEH2yaGf9A@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@parisplace.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 5:28 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> FWIW, I think it's cleaner to take the whole thing into an inlined helper.

Even better.

I notice that your inlined helper doesn't do what I did: if PROT_EXEC
is already set, stop all the stupid games. IOW, the first test in that
function could as well be

    if (prot & (PROT_READ | PROT_EXEC) != PROT_READ)
        return prot;

because if PROT_EXEC is already set, or if PROT_READ wasn't set, none
of the rest of the checks make any sense at all.

But that's just me being anal. It doesn't really *matter* if we end up
setting PROT_EXEC again.

> It can be reorganized a bit, though.  vm_mmap() aside, there are only two
> callers of do_mmap(), both passing it 0 as the last argument.  So let's
> lift these checks on offset into vm_mmap() and kill do_mmap() completely -
> all that remains of it would be a call of do_mmap_pgoff().  And there's no
> reason to put those sanity checks (now in vm_mmap()) under ->mmap_sem,
> of course.  At that point we *do* get 4 identical pieces of code.  Let's
> call that vm_mmap_pgoff() and put it (and vm_mmap()) to mm/util.c.  Voila...

Good.

End result looks fine to me.

             Linus
