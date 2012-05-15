Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966016Ab2EORUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:20:10 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59069 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965929Ab2EORUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:20:07 -0400
MIME-Version: 1.0
In-Reply-To: <1336963631-3541-1-git-send-email-zohar@us.ibm.com>
References: <1336963631-3541-1-git-send-email-zohar@us.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 May 2012 10:19:46 -0700
X-Google-Sender-Auth: XoMqDKeSP01MX_KYptSMzstsiFc
Message-ID: <CA+55aFzrJNd5J7i3Rp7-ctc=bDn5GTWu=H1xyCgGZ-rzu74Gbw@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
To: Mimi Zohar <zohar@us.ibm.com>
Cc: linux-security-module@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2012 at 7:47 PM, Mimi Zohar <zohar@us.ibm.com> wrote:
> From: Mimi Zohar <zohar@linux.vnet.ibm.com>
>
> This patch has been updated to move the ima_file_mmap() call from
> security_file_mmap() to the new vm_mmap() function.

Ugh. I really have to admit to hating this.

Quite frankly, I'd much rather apply a patch that moved the call to
security_file_mmap() entirely outside the mmap_sem instead.

You did basically that, but you only moved the ima_file_mmap()
portion. Why not move it *all*?

Sure, that changes semantics. But does the "security_ops->file_mmap()"
function really need mmap_sem protection?

As far as I can tell, the *only* thing that the security layer tends
to care about is that address (ie the whole "dac_mmap_min_addr"
thing), or the file.

And the *file* doesn't need or want any mmap_sem protection.

The actual final address does "need" the mmap_sem, but in fact none of
the security models really care, except for the obvious NULL mapping
thing. And that can only happen with MAP_FIXED *or* when a person
gives an explicit suggested address.

So I would suggest:

 - never test the  default mmap address case (ie the case of a NULL
'addr' without PROT_FIXED set).

 - move the whole call to security_file_mmap() to outside the
mmap_sem, and test the *suggested* address (which is not the same as
the final address)

Yes, this makes the assumption that arch_get_unmapped_area() will not
return a bad address. We'd have to think about that. I already found
one possible worry, where the default arch_get_unmapped_area() does
this:

        if (addr) {
                addr = PAGE_ALIGN(addr);

and maybe we need to make sure that that PAGE_ALIGN() does not
overflow into 0. Things like that (probably right thing to do: make
sure that 'addr' is already aligned when checking security), but the
point being that it looks like a *really* bad idea to require us
holding the mmap_sem() for this silly security check, when we could
just do it up-front because nobody really cares.

Ok?

I would also actually suggest that we move the "cap_file_mmap()" call
from the security model ->file_mmap() function into
"security_file_mmap()", so that all the security models don't even
have to remember to do that. Because a security model that *doesn't*
do the dac_mmap_min_addr comparison really is broken (we used to have
that bug in SELinux).

What do you think?

                    Linus
