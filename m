Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966336Ab2EOShZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:37:25 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:47438 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964946Ab2EOShV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:37:21 -0400
Message-ID: <1337107014.20904.40.camel@falcor>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@redhat.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        John Johansen <john.johansen@canonical.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Date: Tue, 15 May 2012 14:36:54 -0400
In-Reply-To: <CA+55aFzrJNd5J7i3Rp7-ctc=bDn5GTWu=H1xyCgGZ-rzu74Gbw@mail.gmail.com>
References: <1336963631-3541-1-git-send-email-zohar@us.ibm.com>
	 <CA+55aFzrJNd5J7i3Rp7-ctc=bDn5GTWu=H1xyCgGZ-rzu74Gbw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051518-5518-0000-0000-0000046CB8D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 10:19 -0700, Linus Torvalds wrote:
> On Sun, May 13, 2012 at 7:47 PM, Mimi Zohar <zohar@us.ibm.com> wrote:
> > From: Mimi Zohar <zohar@linux.vnet.ibm.com>
> >
> > This patch has been updated to move the ima_file_mmap() call from
> > security_file_mmap() to the new vm_mmap() function.
> 
> Ugh. I really have to admit to hating this.
> 
> Quite frankly, I'd much rather apply a patch that moved the call to
> security_file_mmap() entirely outside the mmap_sem instead.
> 
> You did basically that, but you only moved the ima_file_mmap()
> portion. Why not move it *all*?

As moving the ima_file_mmap() before taking the mmap_sem is not optimal,
I never even considered moving the security_file_mmap() hook itself, nor
was this suggestion ever made during the initial RFC discussions last
fall.

Unlike execve, which locks the file before calling the security hook,
here the file locking occurs afterwards.  So, instead of moving the
ima_file_mmap() hook closer to where the file is locked, this patch
moves it even farther away.
 
> Sure, that changes semantics. But does the "security_ops->file_mmap()"
> function really need mmap_sem protection?

Having this sort of discussion should probably include the LSM hook
users.  With the Subject line above, not sure how many of them are
reading this.  Am cc'ing others...

Sorry, need to review usage, before commenting ...

Mimi

> As far as I can tell, the *only* thing that the security layer tends
> to care about is that address (ie the whole "dac_mmap_min_addr"
> thing), or the file.
> 
> And the *file* doesn't need or want any mmap_sem protection.
> 
> The actual final address does "need" the mmap_sem, but in fact none of
> the security models really care, except for the obvious NULL mapping
> thing. And that can only happen with MAP_FIXED *or* when a person
> gives an explicit suggested address.
> 
> So I would suggest:
> 
>  - never test the  default mmap address case (ie the case of a NULL
> 'addr' without PROT_FIXED set).
> 
>  - move the whole call to security_file_mmap() to outside the
> mmap_sem, and test the *suggested* address (which is not the same as
> the final address)
> 
> Yes, this makes the assumption that arch_get_unmapped_area() will not
> return a bad address. We'd have to think about that. I already found
> one possible worry, where the default arch_get_unmapped_area() does
> this:
> 
>         if (addr) {
>                 addr = PAGE_ALIGN(addr);
> 
> and maybe we need to make sure that that PAGE_ALIGN() does not
> overflow into 0. Things like that (probably right thing to do: make
> sure that 'addr' is already aligned when checking security), but the
> point being that it looks like a *really* bad idea to require us
> holding the mmap_sem() for this silly security check, when we could
> just do it up-front because nobody really cares.
> 
> Ok?
> 
> I would also actually suggest that we move the "cap_file_mmap()" call
> from the security model ->file_mmap() function into
> "security_file_mmap()", so that all the security models don't even
> have to remember to do that. Because a security model that *doesn't*
> do the dac_mmap_min_addr comparison really is broken (we used to have
> that bug in SELinux).
> 
> What do you think?
> 
>                     Linus

