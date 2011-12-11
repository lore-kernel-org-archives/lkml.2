Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610Ab1LKFLz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 00:11:55 -0500
Received: from ozlabs.org ([203.10.76.45]:42576 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab1LKFLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 00:11:49 -0500
From: Rusty Russell <rusty@ozlabs.org>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        arjan.van.de.ven@intel.com, alan.cox@intel.com,
        Jon Masters <jcm@jonmasters.org>
Subject: Re: [PATCH 21/21] MODSIGN: Apply signature checking to modules on module load [ver #3]
In-Reply-To: <30007.1323526114@redhat.com>
References: <8739csq5ac.fsf@rustcorp.com.au> <87boriouwa.fsf@rustcorp.com.au> <20111202184229.21874.25782.stgit@warthog.procyon.org.uk> <20111202184651.21874.57769.stgit@warthog.procyon.org.uk> <2657.1323456206@redhat.com> <30007.1323526114@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Sun, 11 Dec 2011 15:27:45 +1030
Message-ID: <87obvfogc6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Dec 2011 14:08:34 +0000, David Howells <dhowells@redhat.com> wrote:
> Rusty Russell <rusty@ozlabs.org> wrote:
> 
> > > > Sure, you now need to re-append that after stripping, but that's not the
> > > > kernel's problem.
> > > 
> > > You may also have to remove the signature before passing it to any
> > > binutils tool lest it malfunction on the trailer
> > 
> > Well, you're already on your own if you're using non-module-init-tools
> > tools on modules.
> 
> The distributions packaging tools and initramfs tools are things I have to
> contend with, and others will have to contend with.

If they're doing weird things to modules, yep, they'll break.  They're
not supposed to, but I know these things happen.  But I'll need more
than speculation, we'll need examples.

> > (We'll want to enhance modinfo, at least, to show the signatures).
> 
> Ummm...  To show what exactly?  And why?  The modinfo has to go into the
> signature hash.  Further to find the modinfo, you have to parse the ELF - which
> brings us right back to how do you know you can trust it?

I think you misunderstand, I'm talking about the modinfo command, not
the .modinfo section.

> > > I've found that rpmbuild and mkinitrd alter the module files at
> > > various times, so you'd need a bunch of signatures, one for each (may
> > > just be two, but I can't guarantee that).  This means the kernel build
> > > process needs to know what transformations are going to be applied to
> > > a module - something that has changed occasionally within the
> > > distribution I use and may vary between distributions (or even just
> > > someone building for themselves).
> > 
> > Yes, there may be more than stripped and unstripped.  You may need to
> > do fancy things.  But now, adding a signature is so easy that it's not a
> > real problem.  And we can always have a hook, like:
> > 
> >         if VARIANTS=`make-module-variants $MOD`; then
> >                 for m in $VARIANTS; do sign $m >> $MOD; rm $m; done
> >         fi
> 
> That's not very practical.  That spreads the what-do-we-need-to-calculate
> question over a whole bunch of packages: the kernel, rpmbuild (if RPM-based),
> mkinitramfs and maybe others.  I presume you're thinking of trying all the
> possible strip combinations and generating a signature for each?  However, if
> someone upgrades their binutils, but not their kernel, say, and then their
> initramfs gets rebuilt for some reason, this may invalidate all their module
> signatures.

I'm assuming you either guarantee that strip produces identical results,
or you generate all altered versions during the build (perhaps
make-module-variants has a place it can stash them in the kernel tree
where it gets rolled into your rpm).

But I need to know exactly what these version-dependent mangling of
modules is.  Is it real?  Is it more than strip?  Is it so hard to fix
that it makes sense to add 450 lines of dense kernel code to allow
alteration of a module after signing?

The answer may be "yes".  But I need to know that before accepting your
code.

Thanks,
Rusty.
