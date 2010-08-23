Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab0HWQFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:05:00 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:52522 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754380Ab0HWQE6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:04:58 -0400
Date: Mon, 23 Aug 2010 12:03:28 -0400 (EDT)
From: Miloslav Trmac <mitr@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org
Message-ID: <623164086.1128831282579408813.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1291324238.1127211282578687312.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Subject: Re: [PATCH 00/19] RFC, v2: "New" /dev/crypto user-space interface
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Arnd Bergmann" <arnd@arndb.de> wrote:

> On Friday 20 August 2010 10:45:43 Miloslav Trmač wrote:
> > 
> > Major changes since the previous post:
> > * "struct nlattr"-based extensible attributes used for extensibility
> >   of most operations, both for input and output attributes
> 
> The API here looks overly complex resulting from the use of a combination
> of ioctl and netlink. If your interface cannot be easily expressed using
> simple (no indirect pointers or variable-length fields please) ioctl
> and read/write operations, why not go all the way and turn the interface
> into a netlink facility?
I'm afraid the flexibility is necessary: immediately after posting the first interface with fixed structures there were requests for extensions that would be difficult or impossible to implement using the structures; crypto is not something fixed, new algorithms with algorithm-specific parameters appear all the time.  On the positive side, the implementation of session_once as shorthand for session_{init,update,final} is much nicer with the netlink attributes.

Using netlink sockets is impractical: support of zero-copy encryption and auditing requires that operations are performed synchronously in the task context, and the extra overhead of netlink is non-trivial (ioctl() is one syscall per operation, netlink is at least two syscalls per operation); based on a very crude benchmark, this results in about 20% performance penalty when encrypting 256 bytes using cbc(aes) - and that is not counting the impossibility to do zero-copy operations with netlink).  Also matching netlink replies to requests can be complex in a multi-threaded environments if there is one /dev/crypto file descriptor per process.

> >   The libtom* patches will probably still be too large for the mailing list;
> >   the whole patch set is also available at
> >   http://people.redhat.com/mitr/cryptodev-ncr/v2/ .
> 
> They actually seem to have made it to the list. However, the more signficant
> problem is the amount of code added to a security module. 20000 lines of
> code that is essentially a user-level library moved into kernel space
> can open up so many possible holes that you end up with a less secure
> (and slower) setup in the end than just doing everything in user
> space.
Yes, it's a lot of code.   I'm afraid some of the security profiles require public key algorithms, giving some Linux users no choice in the matter.

On the other hand, the user-space crypto API is not inherently tied to the existence of these algorithms; if the public key algorithms were completely unacceptable for some reason, that should still make it possible to add the crypto API as such.

> >   An user-space library is not separated, options are a) root
> >   running daemon that does crypto, but this would be slow due to context
> >   switches, scheduler mismatching and all the IPC overhead and b) use crypto
> >   that is in the kernel.
> 
> I think you will have to back that statement by measurements. There are
> reasonably fast ways to do IPC and the interface you suggest to put in the
> kernel does not exactly look tuned for performance.
See above for the effect of a single additional syscall.  Crypto is often done on small amounts of data at a time (one TLS/SSH record, which can be thousands of bytes in favorable cases, tens of bytes in the worst case), and each context switch is comparatively costly.

> > * FIPS-140-3 calls out for cryptographic functions to be non-debuggable (ptrace)
> >   meaning that you cannot get to the key material. The solution is the same as
> >   above.
> 
> We have kgdb, kdb, qemu gdbserver, tracing and more things that would very
> much make your code debuggable.
The system administrator is usually considered to be excluded from the requirements of such standards.
    Mirek
