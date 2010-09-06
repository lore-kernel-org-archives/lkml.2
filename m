Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab0IFVjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 17:39:31 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:40032 "EHLO
	mx01.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755705Ab0IFVj1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 17:39:27 -0400
Date: Mon, 6 Sep 2010 17:39:21 -0400 (EDT)
From: Miloslav Trmac <mitr@redhat.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Message-ID: <609705216.1019541283809161307.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1586512982.1019221283808142288.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Subject: Re: [PATCH 01/19] User-space API definition
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Kyle Moffett" <kyle@moffetthome.net> wrote:
> On Mon, Sep 6, 2010 at 11:50, Miloslav Trmac <mitr@redhat.com> wrote:
> > ----- "Herbert Xu" <herbert@gondor.hengli.com.au> wrote:
> >> On Mon, Aug 23, 2010 at 11:37:40AM -0400, Miloslav Trmac wrote:
> >> > I have seriously considered the keyring API, and this is what I
> came
> >> up with - but I'd love to be shown a better way.
> >>
> >> FWIW adding a second key management system to the kernel is
> >> totally out of the question.
> >>
> >> If the existing system doesn't work for you, find a way to build
> >> on it so that it does.  Adding a second system that pretty much
> >> does the same thing is unacceptable.
> > It does _not_ do the same thing, same as ramfs and file descriptors
> do not do the same thing although they are both related to files.
> >
> > The kernel keyring service is basically a system-wide data storage
> service.  /dev/crypto needs a quick way to refer to short-lived,
> usually process-local, kernel-space data structures from userspace.
> 
> The problem with the approach you're proposing is that we then have
> two entirely separate classes of keys. 
"We have two entirely separate classes of files: inodes and file descriptors".

Isn't that only a problem if there is actual duplicate functionality?  And is copy_from_user() really enough reason to share the interface?

Like in the inodes/file descriptors case, the fact that you can read contents of both does not automatically mean that a single interface for both is the best option.  The naming does suggest that this should be the case here, but the differences are AFAICS much larger than the commonalities.


> Another potential issue is that keys are never actually "unnamed", in
> that sense.
They are perhaps not "unnamed" from a global point of view, or from the point of view of a few functions that directly manipulate the key, but they are quite anonymous from the process' point of view.

> If encryption keys truly were "anonymous" then you would
> find it impossible to reliably decrypt the data on the other end.  For
> example, every RSA private key should be indexed either by the X.509
> DN or for bare SSH keys by the public modulus information.
Why would that be useful?  The SSH private key should be only available to sshd.  sshd has loaded the key from a file (_that_ is the key's "name", as far as the system administrator is concerned), and then the key is used only privately within the sshd process.  There is no more reason to have a name attached to the loaded private key object than there is a reason to have a name attached to the file descriptor used to read /etc/ssh/sshd_config - the key is an application-internal object and its user-space identifier is merely a "safe pointer into the kernel".

Actually, in a modularly-designed program, only one component of the program works with the key, the rest should not even be aware of the existence of the key, and having a process-wide (or even more general) name for the key can lead to unintended conflicts.  Imagine having the option to give an every file descriptor a name, automatically replacing earlier file descriptors with the same name.

Having a well-known name for the sshd host private key is perhaps useful as an "attack this" sign :)

Same for public keys - when an application does
   public_key = import_from_certificate();
   encrypt_data_using(public_key)
it is not interested in sharing the public key object with other processes - after all, what if another process loaded a different key under the indented name?  Creating a meaningful identifier is about as costly as just importing the key, anyway.

>  Even transient SSL session keys are always put into an SSL session cache by
> apache or whatever to allow them to be reused across multiple TCP
> streams!
The SSL session cache is a quite unusual case.

Also, there is one SSL private key per server DNS name, and one SSL session cache entry per client-server pair, but there are at least four temporary keys, for each connection, and there is absolutely no need to name these.

> So my recommendation would be to create some new operations of the
> existing keyring code:

> (2) Add cryptoapi hooks to automatically register keyring key types
> based on the loaded cryptoapi modules.
Hm, using a different key type for each cipher would at least allow reusing add_key()/KEYCTL_{READ,UPDATE}; I didn't think even these could be useful.

So it's better than absolutely hopeless now :)

Thank you,
    Mirek
