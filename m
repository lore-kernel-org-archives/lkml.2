Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab1LJHF1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 02:05:27 -0500
Received: from ozlabs.org ([203.10.76.45]:40200 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab1LJHFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 02:05:25 -0500
From: Rusty Russell <rusty@ozlabs.org>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        arjan.van.de.ven@intel.com, alan.cox@intel.com
Cc: Jon Masters <jcm@jonmasters.org>
Subject: Re: [PATCH 21/21] MODSIGN: Apply signature checking to modules on module load [ver #3]
In-Reply-To: <2657.1323456206@redhat.com>
References: <87boriouwa.fsf@rustcorp.com.au> <20111202184229.21874.25782.stgit@warthog.procyon.org.uk> <20111202184651.21874.57769.stgit@warthog.procyon.org.uk> <2657.1323456206@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Sat, 10 Dec 2011 17:31:15 +1030
Message-ID: <8739csq5ac.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Dec 2011 18:43:26 +0000, David Howells <dhowells@redhat.com> wrote:
> Rusty Russell <rusty@ozlabs.org> wrote:
> 
> > And adds a great deal of code in a supposedly security-sensitive path to
> > achieve it.
> > 
> > How about simply append a signature to the module?  That'd be about 20 lines
> > of code to carefully check the bounds of the module to figure out where the
> > signature is.  You could even allow multiple signatures, then have one for
> > stripped, and one for non-stripped versions.
> 
> A big chunk of the code is dealing with the cryptographic bits - and you need
> those anyway - and if it's done right it can be shared with other things
> (eCryptfs for example; maybe CIFS from what Steve French said) and auxiliary
> keys can be stored in places other than the kernel (the TPM for
> example).

Sure, I was only commenting on the module parts, which are my
responsibility.

> > Sure, you now need to re-append that after stripping, but that's not the
> > kernel's problem.
> 
> You may also have to remove the signature before passing it to any
> binutils tool lest it malfunction on the trailer

Well, you're already on your own if you're using non-module-init-tools
tools on modules.  But objdump doesn't care about appended data.
objcopy and strip will remove it, of course, but without complaining.

> - and would you also
> have to modify insmod and modprobe?  I suspect they parse the ELF to
> find out about parameters and things.

No.  modprobe needs to read .modinfo for --force, and modinfo does too.
depmod is the worst: it actually looks through symtab and strtab, etc.
And again, they're all fine.

But even if they weren't, it wouldn't be an argument for putting all
this in the kernel!

(We'll want to enhance modinfo, at least, to show the signatures).

> I've found that rpmbuild and mkinitrd alter the module files at
> various times, so you'd need a bunch of signatures, one for each (may
> just be two, but I can't guarantee that).  This means the kernel build
> process needs to know what transformations are going to be applied to
> a module - something that has changed occasionally within the
> distribution I use and may vary between distributions (or even just
> someone building for themselves).

Yes, there may be more than stripped and unstripped.  You may need to
do fancy things.  But now, adding a signature is so easy that it's not a
real problem.  And we can always have a hook, like:

        if VARIANTS=`make-module-variants $MOD`; then
                for m in $VARIANTS; do sign $m >> $MOD; rm $m; done
        fi

Cheers,
Rusty.
