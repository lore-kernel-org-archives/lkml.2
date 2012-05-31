Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab2EaA2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 20:28:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40555 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab2EaA2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 20:28:11 -0400
Date: Thu, 31 May 2012 01:28:02 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Paris <eparis@parisplace.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
Message-ID: <20120531002802.GA11775@ZenIV.linux.org.uk>
References: <1337807899.15138.31.camel@falcor>
 <20120530043443.GA3200@ZenIV.linux.org.uk>
 <20120530163605.GV11775@ZenIV.linux.org.uk>
 <1338406967.2257.24.camel@localhost>
 <20120530202427.GW11775@ZenIV.linux.org.uk>
 <CA+55aFxiCksfNdRrm+O-eJSY=qTUQEsZtFbi8wj2_kj1XeNHnQ@mail.gmail.com>
 <20120530205612.GY11775@ZenIV.linux.org.uk>
 <CA+55aFwXfD6vCj8sHuB33ctB-D8cfJN45h+iURXA6mR=S0mgwA@mail.gmail.com>
 <20120530213638.GZ11775@ZenIV.linux.org.uk>
 <CA+55aFzP8Eo1AX7MS-RRG_Atq3NF0bS1ReZydRtgxxy7TDn57Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzP8Eo1AX7MS-RRG_Atq3NF0bS1ReZydRtgxxy7TDn57Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 03:51:27PM -0700, Linus Torvalds wrote:
> On Wed, May 30, 2012 at 2:36 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > The only difference is that for file-backed ones !MMU wants
> > VM_MAYEXEC in that file's bdi flags (BDI_CAP_EXEC_MAP). ?And
> > that actually sounds reasonable in !MMU case.
> 
> Ok, I don't think it should be strictly necessary, but I guess I don't
> mind either.
> 
> > Anyway, I've dumped the variant I've got into vfs.git@security_file_mmap;
> > it should be at commit f12a0fd062b1d259a0b6bc6442019e6d4c45e9f5.
> >
> > Comments?
> 
> Two small ones:
> 
>  - I really don't think you should use "goto out" in
> security_mmap_file(). That implies that you're exiting the function,
> but in fact you're jumping to the very *meat* of the function.
> 
>    So I think you should rename "out" as "no_added_exec" or something.

FWIW, I think it's cleaner to take the whole thing into an inlined helper.

> And a small question:  This code:
> 
> +       ret = security_mmap_file(file, prot, flags);
> +       if (!ret) {
> +               down_write(&current->mm->mmap_sem);
> +               retval = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
> +               up_write(&current->mm->mmap_sem);
> +       }
> 
> now seems to exist in four places. And in fact, that pretty much seems
> to *be* what vm_mmap() is, at this point. Why isn't there just one
> single vm_mmap() implementation, and then the callers of that?

Umm...  Not quite.  The difference is that vm_mmap() takes its argument as
offset in bytes, while sys_mmap_pgoff() - in pages.

It can be reorganized a bit, though.  vm_mmap() aside, there are only two
callers of do_mmap(), both passing it 0 as the last argument.  So let's
lift these checks on offset into vm_mmap() and kill do_mmap() completely -
all that remains of it would be a call of do_mmap_pgoff().  And there's no
reason to put those sanity checks (now in vm_mmap()) under ->mmap_sem,
of course.  At that point we *do* get 4 identical pieces of code.  Let's
call that vm_mmap_pgoff() and put it (and vm_mmap()) to mm/util.c.  Voila...

I've pushed that to the same place (vfs.git#security_file_mmap).  Should
propagate to git.kernel.org in a few...  Guys, does anybody have objections
about the way it looks?
