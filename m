Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934Ab2FEBHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 21:07:12 -0400
Received: from ozlabs.org ([203.10.76.45]:56926 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756862Ab2FEBHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 21:07:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>, kyle@mcmartin.ca,
        dmitry.kasatkin@intel.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        "Tim Abbott" <tabbott@ksplice.com>
Subject: Re: [PATCH 00/23] Crypto keys and module signing
In-Reply-To: <1338814071.4044.19.camel@falcor>
References: <20120522230218.24007.3556.stgit@warthog.procyon.org.uk> <26029.1337960539@redhat.com> <87ipf73lsi.fsf@rustcorp.com.au> <1338814071.4044.19.camel@falcor>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 05 Jun 2012 10:35:56 +0930
Message-ID: <87wr3min4b.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Jun 2012 08:47:51 -0400, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Mon, 2012-06-04 at 11:01 +0930, Rusty Russell wrote:
> > On Fri, 25 May 2012 16:42:19 +0100, David Howells <dhowells@redhat.com> wrote:
> > > 
> > > Hi Rusty,
> > > 
> > > If you prefer to have userspace extract the module signature and pass it in
> > > uargs, here's a tree that will do that:
> > > 
> > > 	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=shortlog;h=refs/heads/modsign-uarg
> > 
> > OK, there's merit in this approach: it certainly moves the argument
> > about how to encode the signature out of my backyard :)
> > 
> > Should we just bite the bullet and create a new syscall:
> > 
> > SYSCALL_DEFINE5(init_module2, void __user *, umod,
> > 		unsigned long, len, const char __user *, uargs,
> >                 unsigned int, siglen, const char __user *, sig)
> > 
> > But I'm easily swayed if you prefer the current approach.
> > 
> > Thanks,
> > Rusty.
> 
> If you're really considering creating a new syscall, then perhaps this
> discussion should include passing the file descriptor instead of a
> buffer and signature.  As I said https://lkml.org/lkml/2012/5/25/261, I
> don't know the historical reasons for passing a buffer instead of the
> file descriptor itself.  If the file descriptor was passed, it would
> allow IMA-appraisal, which is in the process of being upstreamed, to
> verify and enforce file data and metadata integrity like on the other
> hooks open, execve, and mmap.

It's flexible.  Compressed modules, for example.  And who knew if we
would be runtime generating modules?  But I don't think even the ksplice
guys generate modules on the fly for insertion.

modprobe has --force-vermagic and --force-modversion, but frankly that
could be replaced by a single "force" flag handed to the kernel.

If there's real benefit, it could be done.  Do we still want a separate
signature blob?

SYSCALL_DEFINE5(init_module_fd,
                int, fd,
                unsigned int, flags,
                const char *__user *, uargs,
                unsigned int, siglen,
                const char __user *, sig);

Cheers,
Rusty.
