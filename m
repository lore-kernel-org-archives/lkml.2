Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab2FVEvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 00:51:53 -0400
Received: from ozlabs.org ([203.10.76.45]:60952 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818Ab2FVEvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 00:51:52 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: David Howells <dhowells@redhat.com>, kyle@mcmartin.ca,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: [PATCH 00/23] Crypto keys and module signing
In-Reply-To: <20120622015341.GA3414@kroah.com>
References: <8762blyedn.fsf@rustcorp.com.au> <87obpfxdpr.fsf@rustcorp.com.au> <20120522230218.24007.3556.stgit@warthog.procyon.org.uk> <7474.1337782847@redhat.com> <5107.1337868051@redhat.com> <87r4u6w58c.fsf@rustcorp.com.au> <20120622015341.GA3414@kroah.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 22 Jun 2012 13:35:03 +0930
Message-ID: <8762akt2j4.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012 18:53:41 -0700, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sun, May 27, 2012 at 03:11:23PM +0930, Rusty Russell wrote:
> > > > > Why would you want multiple signatures?  That just complicates things.
> > > > 
> > > > The code above stays pretty simple; if the signature fails, you set size
> > > > to i, and loop again.  As I said, if you know exactly how you're going
> > > > to strip the modules, you can avoid storing the stripped module and
> > > > simply append both signatures.
> > > 
> > > You still haven't justified it.  One of your arguments about rejecting the ELF
> > > parsing version was that it was too big for no useful extra value that I could
> > > justify.  Supporting multiple signatures adds extra size and complexity for no
> > > obvious value.
> > 
> > One loop is a lot easier to justify that the ELF-parsing mess.  And it
> > can be done in a backwards compatible way tomorrow: old kernels will
> > only check the last signature.
> > 
> > I had assumed you'd rather maintain a stable strip util which you can
> > use on kernel modules than rework your module builds.  I guess not.
> 
> To dig an old thread up, but what really is wrong with the original ELF
> section stuff?  Why encode "magic" values on the end of the kernel
> module that then require all userspace tools to be modified in order to
> properly handle this?

1) No userspace needs to be modified to use the appended signature.
   modprobe doesn't.  depmod doesn't.  Even strip doesn't (not that
   that's much use).

2) It's far easier to add an appended signature than to add an elf
   section.

3) It's far easier to generate an appended signature than to generate
   a signature for the module which will change when you add the
   signature section (roughly: gpg --sign module.ko > sig && echo
   '@@sig@@ >> module.ko && cat sig >> module.ko).

4) It's trivial to verify a module with an appended signature before you
   touch it.  With a section you need to carefully parse the module,
   make sure you don't include the could-be-modified stuff in the
   signature, and avoid any possible overflows or exploits.

5) It wasn't just that they wanted an elf section.  They wanted the
   signature to work against both a stripped and unstripped module, so
   only the unstrippable parts of the module were signed.

> When I first did this so many many years ago an elf section made it so
> easy to handle.  Userspace didn't need to be modified, and everyone
> knows how to handle elf sections, even the kernel does :)

And there have been bugs in the kernel elf handling code.  There will
undoubtedly be bugs in this, and for what?  A more complex kernel to
match our more complex userspace?

> And I think we really want the ability to have multiple signatures, the
> whole "chain of trust" thing that is needed will work out much better if
> multiple signatures are allowed.  Putting it in an elf section allows
> this to work out easier, right?

Not at all.  Multiple appended signatures is trivial.  Figuring out the
semantics (do they chain, or is any one sufficient?), well that's the
same whether you're talking about an ELF section or not.

Hope that clarifies,
Rusty.
