Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab2EXMIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 08:08:09 -0400
Received: from ozlabs.org ([203.10.76.45]:47136 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab2EXMIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 08:08:05 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org
Subject: Re: [PATCH 00/23] Crypto keys and module signing
In-Reply-To: <7474.1337782847@redhat.com>
References: <87obpfxdpr.fsf@rustcorp.com.au> <20120522230218.24007.3556.stgit@warthog.procyon.org.uk> <7474.1337782847@redhat.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 24 May 2012 21:34:04 +0930
Message-ID: <8762blyedn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012 15:20:47 +0100, David Howells <dhowells@redhat.com> wrote:
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> >         That's pretty weird.  Why not put the "@This Is A Crypto Signed
> > Module\n" before the signature?  Then module-size is implied: everything
> > before that signature.  The signature size is implied: everything after
> > that signature.
> 
> This makes it simpler.  No scanning required.  The magic number can only be in
> one place and you can find it by dead reckoning.

Scanning isn't complicated.  Slow, sure, but I doubt you can really
measure it when you're doing crypto.

Compare:

(1) Your scheme signing looks something like this:
        gpg --sign $m > $m.sig
        MSIZE=`ls -l $m | awk '{ print $5 }'`
        SSIZE=`ls -l $m.sig | awk '{ print $5 }'`
        
        printf '@%-10i@%-10i@This Is A Crypto Signed Module' $MSIZE $SSIZE >> $m

(2) Your verification scheme looks like this:

 +	magic_size = sizeof(modsign_magic) - 1;
 +	if (size <= 11 + 11 + magic_size)
 +		return 1;
 +
 +	if (memcmp(data + size - magic_size, modsign_magic, magic_size) != 0)
 +		return 1;
 +	size -= 11 + 11 + magic_size;
 +
 +	cp = data + size;
 +	if (cp[ 0] != '@' && cp[ 9] != '@' && cp[10] != '\n' &&
 +	    cp[11] != '@' && cp[20] != '@' && cp[21] != '\n')
 +		return -ELIBBAD;
 +	mod_size = simple_strtoul(cp + 1, &end, 10);
 +	if (mod_size > size || (*end != ' ' && *end != '@'))
 +		return -ELIBBAD;
 +	sig_size = simple_strtoul(cp + 12, &end, 10);
 +	if (sig_size > size || (*end != ' ' && *end != '@'))
 +		return -ELIBBAD;
 +
 +	pr_devel("sig at %zu, size %zu (to %zu)\n", mod_size, sig_size,
 size);
 +	if (size - mod_size != sig_size)
 +		return -ELIBBAD;

Now, the scheme I suggested looks like this:

(1) Signing:
        gpg --sign $m > $m.sig
        (echo @This Is A Crypto Signed Module; cat $m.sig) >> $m

(2) Verification:
        size_t i;

        if (i < modsign_magic)
                return 1;

        for (i = size - modsign_magic;
             memcmp(data + i, modsign_magic, magic_size) != 0);
             i++) {
                if (i == 0)
                        return 1;
        }

        /* module: "data", size "i".
         * sig: "data + i + magic_size", size "size - (i + magic_size)" */

> >         In fact, I'd modify this slightly, to allow multiple signatures.
> > This would work nicely with a deterministic strip.  Find the signatures
> > backward, and truncate as they fail.
> 
> Why would you want multiple signatures?  That just complicates things.

The code above stays pretty simple; if the signature fails, you set size
to i, and loop again.  As I said, if you know exactly how you're going
to strip the modules, you can avoid storing the stripped module and
simply append both signatures.

> If you're in FIPS mode, you probably have to panic if any of them fail.

I had to look up what FIPS was, so I'm not qualified to comment.

> I suppose I may as well punt the signature detection and removal to userspace
> and pass the signature as an argument to init_module() as Dmitry suggested.
> Then the signature need not be in the file at all (he wants to use an xattr or
> hardware, I think).  mkinitrd and rpmbuild/kernel spec have to be changed to
> accommodate enablement of these patches, so why not module-init-tools, dracut
> and busybox whilst we're at it?

In some ways that is cleaner, but it's also nice to avoid adding another
syscall.

Cheers,
Rusty.
