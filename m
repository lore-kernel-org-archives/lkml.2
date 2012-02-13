Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127Ab2BMQV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 11:21:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572Ab2BMQVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 11:21:54 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1328708710.2679.4.camel@falcor>
References: <1328708710.2679.4.camel@falcor> <cover.1328122362.git.dmitry.kasatkin@intel.com> <alpine.LRH.2.00.1202061250400.16907@tundra.namei.org> <CALLzPKZSWSp6r-5e1c1Z6qOH6C0DcOz=LHJ20Y468SQE6UU1ww@mail.gmail.com> <87zkcuh8iq.fsf@rustcorp.com.au> <CALLzPKZRUTaOE8afXD1b=Kd6fOaisOpAW+XGJMi7uHdE0sEgFw@mail.gmail.com> <87bopagqn4.fsf@rustcorp.com.au> 
To: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: dhowells@redhat.com, Rusty Russell <rusty@ozlabs.org>,
        James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Jon Masters <jcm@redhat.com>, mjg@redhat.com
Subject: Re: [RFC][PATCH v1 0/2] integrity: module integrity verification
Date: Mon, 13 Feb 2012 16:20:54 +0000
Message-ID: <16527.1329150054@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> As a distro knows what it is shipping, why would you need support for
> both stripped/unstripped versions.  Unless "stripping" occurs post
> install.  Perhaps something similar to 'prelink'?

Let me summarise the state of things.


In RHEL and Fedora the stripping occurs twice that I know of:

 (1) During package generation the debugging info in each module file is
     extracted into a separate file in a 'debuginfo' RPM and is then stripped
     from the module binary.

 (2) During initramfs generation, the module files are further stripped to get
     rid of all unnecessary bulk.

I'm told that step (1) can be waived - but that means that the installed module
still has all its debug info in it, and thus uses up more filesystem space.


Red Hat already have a working module signature checker that we've been using
for a few years.  However, it incorporates the signature *in* the module file,
using ELF's ability as a container format to carry it in an ELF note.

This has the downside that the kernel then has to determine that the ELF is
sufficiently valid that it's safe to parse it to find the signature note.

The checker is also robust enough that the module survives being stripped a
number of times by tools from a different packages (strip and eu-strip), but
the cost of this is that the kernel has to limit and canonicalise the data it
adds to the signature.

Basically, this checker hasn't required to need any alterations to userspace
tools outside of the kernel sources (eg. busybox, modprobe, insmod, mkinitrd,
strip, kernel rpm specfile, ...) to generate signed modules that can be
checked, and doesn't require any special filesystem features (such as xattrs),
hardware (such as a TPM) or auxiliary files to hold signatures.


However, Rusty doesn't like the RH checker because it is a largish chunk of
code that needs careful checking:

	warthog>size module-verify.o module-verify-elf.o module-verify-sig.o
	   text    data     bss     dec     hex filename
	    170       0       0     170      aa kernel/module-verify.o
	   2351       0       0    2351     92f kernel/module-verify-elf.o
	   2390      32      20    2442     98a kernel/module-verify-sig.o

plus a bit in kernel/module.o on x86_64.

He would prefer to see something that just appends the signature with a magic
number and then the kernel just has to search for the magic number and digest
the entirety of the blob up to that point.  You don't then need to check the
ELF as the validity of the ELF structure is then guaranteed by the signature.

The main downside of this approach is that the signature is only good as long
as the ELF module is not modified anywhere - and this mean no stripping.  If
the unstripped, semi-unstripped and fully stripped modules are all necessary,
then they must all be included in the package, and any variant that is going to
be loaded (which may perhaps only be the fully-stripped variant) must be
signed.  Another problem is recognising the signature marker correctly as it's
conceivably possible for the assembler to generate the same string (there are
ways round that, however).


As I understand it, Dmitry's approach is similar to Rusty's except the
signature is determined by userspace (eg. insmod) and passed to the kernel
separately as a special argument to insmod.  This allows Dmitry to store the
signature separately, say in an xattr on the module file or in some special
hardware.

The downsides of this approach are similar to Rusty's, and have the additional
problem that insmod & co. may need to implement multiple methods for finding
the signature (are there xattrs in the initramfs, for example?).

However, if there is a real requirement to store the signature detached from
the module (say in a cryptographic hardware cache), then Dmitry's approach may
be the only viable one, and userspace can look through the module file for an
inline signature, and, if found, detach it and give the signature and the
remnant blob to the kernel separately.


At some point I intend to look at integrating Dmitry's stuff with my signature
handling patches to see if we can make a unified system that can handle the
signature being done in software or in hardware, and with any combination of
digest and asymmetric key algorithm.  On that basis, if we can't go with RH's
module signature checker, I'd prefer Dmitry's approach over Rusty's and do the
signature retrieval in userspace.

David
