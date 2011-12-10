Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199Ab1LJMug (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 07:50:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab1LJMud convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 07:50:33 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+MtwOEHYu1z8TLXv7jwCKfgavaGX7EWXmxq2xs6b0jbujy35g@mail.gmail.com>
References: <CA+MtwOEHYu1z8TLXv7jwCKfgavaGX7EWXmxq2xs6b0jbujy35g@mail.gmail.com> <28442.1323269262@redhat.com>
To: =?us-ascii?Q?=3D=3FISO-8859-2=3FQ=3FArkadiusz=5FMi=3DB6kiewicz=3F=3D?= 
	<a.miskiewicz@gmail.com>
Cc: dhowells@redhat.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, arjan@linux.intel.com,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [GIT PULL] Crypto keys and module signing
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Sat, 10 Dec 2011 12:50:11 +0000
Message-ID: <21891.1323521411@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arkadiusz Miśkiewicz <a.miskiewicz@gmail.com> wrote:

> If I understand it is not possible to sign modules after they are built

Well, modules are signed after they're built.  It's a matter of creating a
detached signature for the parts of the module file you want to protect and
then inserting the signature into the module file.  I've created a way to do
this as part of the build process, but previously we had the spec file do it
during the kernel RPM build.

> and load keys without actually rebuilding kernel?

Well, yes and no.

The way we have used up to now involves building a set of public keys into the
kernel so that modules can be verified with them during loading.  We could make
a way to load extra keys, but how does the kernel know it can trust those keys?

With the new mechanism in the patches I've submitted, there is the possibility
of using a cryptographic key storage hardware (such as a TPM) to directly store
either extra public keys that you want to be able to verify modules with, or to
hold a key you sign the extra public keys with.

That way you can have modules signed with the kernel's build-time temporary key
and also have modules signed with other keys that are trusted by the
administrator.

> For distro kernel the public and secret keys have to be available publicly,
> right?

No.  The public key has to be publically available, but the secret key must be
kept, well, secret - otherwise there's no point.  If anyone can sign a module
to run on your system, then the signature mechanism may as well not be there.

RHEL keeps the secret key as secret as it possibly can by generating a new one
each time a kernel RPM is built and then it's deleted afterwards when the BUILD
directory is cleaned up.  No record of the secret key is kept.  It's not easy
to have the buildfarm save the secret key in a database somewhere as anyone who
gets hold of a RHEL kernel SRPM and wants to build it mustn't find the build
fails because the secret-key-save mechanism doesn't work.  Besides - you don't
want it quietly saving your privately built secret key to Red Hat's big
database, right?

> Otherwise people using distro kernels won't be able to build own signed
> modules for use with that distro kernel.

That's the whole point...  To a point.  You can still load unsigned modules,
but it makes a fuss in the syslog, and you can block unsigned modules.
Hopefully at some time in the future, as mentioned above, you'll be able to use
hardware for this.

> Then I as admin have to rebuild the kernel to get my own keys in and prevent
> other, "unapproved" modules to be loaded. Correct?

Correct.  You could, theoretically, extract the public keys from the kernel
you're rebuilding and include those too, but it's messy.

> Would be nice if the modules could be signed/re-signed after being build

That's relatively straight forward.  You can strip the existing signatures and
replace them with your own.  The modules are really signed *after* being built
- after all, you don't know what it is you're going to be signing until after
the things are built.

> and prehaps kernel could load keys from initramfs?

How do you trust the keys?  If you have a TPM, then yes you can do that.

In fact, how do you trust the public key compiled into the kernel for that
matter?  Ideally, the bootloader would have to check that the kernel image
hasn't been tampered with.  That's easier than checking the initramfs as the
kernel is not changed after building, whereas the initramfs is.

> Then everyone could use own keys on distro kernels without need to rebuild
> the thing.
> 
> I think I'm missing something :)

Perhaps I can summarise:

 (1) The whole point of having a secret key is that you tell as few people as
     absolutely possible what it is.

 (2) Public keys have to be trusted in order for you to use them.

 (3) Cryptography is, by its very nature, inconvenient.  But it only works if
     you inconvenience people who shouldn't have access more than you
     inconvenience those who should.

David
