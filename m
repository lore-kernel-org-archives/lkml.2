Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab2GPW1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 18:27:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33417 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab2GPW1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 18:27:51 -0400
Date: Mon, 16 Jul 2012 23:27:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.5-rc6 dentry related GPF
Message-ID: <20120716222747.GR31729@ZenIV.linux.org.uk>
References: <20120711183239.GA7122@redhat.com>
 <CA+55aFz5E4NMDF+OXDoGkHz2Mr2sBXf6nYcOXomDZHmnUSdWHA@mail.gmail.com>
 <20120716213218.GQ31729@ZenIV.linux.org.uk>
 <20120716215318.GA14629@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120716215318.GA14629@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 05:53:18PM -0400, Dave Jones wrote:
> On Mon, Jul 16, 2012 at 10:32:18PM +0100, Al Viro wrote:
>  > On Wed, Jul 11, 2012 at 12:10:12PM -0700, Linus Torvalds wrote:
>  > >   rdi = 54415541e5894855
>  > > 
>  > > which looks like some odd corrupted ASCII to me ("UH\211\345AUAT") but
>  > > that makes no sense either.
>  > 
>  > 	It makes a lot of sense as amd64 code, though:
>  > 
>  >    55                      push   %rbp
>  >    48 89 e5                mov    %rsp,%rbp
>  >    41 55                   push   %r13
>  >    41 54                   push   %r12
>  > 
>  > IOW, it's the first 8 bytes from a fairly sane beginning of some function.
>  > So &(inode->i_fop->owner) (and thus inode->i_fop - owner is the first field)
>  > is some spot in .text.  Would be interesting to find out what function
>  > was that from (i.e. what's the value of inode->i_fop); with any luck it
>  > might've still been in some register.  Could you post objdump of
>  > do_dentry_open() from your kernel?
> 
> I've done a few rebuilds since posting that, but hopefully things haven't
> moved around too much in that area recently..
> 
> http://fpaste.org/Pw5d/ is the whole open.o disassembly.

Lousy...
	mov 0x200(%r14),%rax	// r14 == inode, rax = inode->i_fop
	test %rax,%rax		// if (rax)
	je 1f			// {
	mov (%rax),%rdi		// rdi = rax->owner
	callq try_module_get	// rax = try_module_get(rdi);
1f:

... and the value of inode->i_fop, which somehow has turned out to be
the address of some function prologue, was only in rax.  Clobbered
by the point where try_module_get() has oopsed ;-/

Alas.  Looks like all we are getting out of that one is that some
function address has ended up in inode->i_fop...
