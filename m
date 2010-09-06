Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab0IFPvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:51:03 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:49520 "EHLO
	mx01.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753568Ab0IFPu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:50:58 -0400
Date: Mon, 6 Sep 2010 11:50:51 -0400 (EDT)
From: Miloslav Trmac <mitr@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Kyle Moffett <kyle@moffetthome.net>, linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Message-ID: <169108422.1009631283788251084.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <272391166.1009231283787434910.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Subject: Re: [PATCH 01/19] User-space API definition
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Herbert Xu" <herbert@gondor.hengli.com.au> wrote:
> On Mon, Aug 23, 2010 at 11:37:40AM -0400, Miloslav Trmac wrote:
> >
> > I can see almost no overlap between the two sets of requirements. 
> Probably the only common use case is handling session keys (e.g. keys
> used in a kerberos ticket), which should be stored in the kernel for
> the duration of the session, made available to each process in the
> session, and available as keys for kernel crypto.  Such keys will be
> in the minority, though, and it seems to me the best approach for
> handling these is to allow key export/import from/to keyring keys in
> addition to export/import from/to data in userspace: the long-term
> storage would be handled by the existing keyring API, which stores the
> key as unformatted binary data, and import into the crypto context
> would convert the key into the internal representation more suitable
> for crypto.
> > 
> > I have seriously considered the keyring API, and this is what I came
> up with - but I'd love to be shown a better way.
> 
> FWIW adding a second key management system to the kernel is
> totally out of the question.
> 
> If the existing system doesn't work for you, find a way to build
> on it so that it does.  Adding a second system that pretty much
> does the same thing is unacceptable.
It does _not_ do the same thing, same as ramfs and file descriptors do not do the same thing although they are both related to files.

The kernel keyring service is basically a system-wide data storage service.  /dev/crypto needs a quick way to refer to short-lived, usually process-local, kernel-space data structures from userspace.

Imagine that instead of
    thread = clone(..., CLONE_THREAD);
you needed to do
    thread_fd = mkstemp("/proc/XXX");
    fork(thread_fd);
That's how "just using the existing keyring" would look like.

Adapting the existing keyring to match the /dev/crypto use case better would make the keyring API at least 25% larger, and introduce completely different key identification and lifetime semantics for a set of keys.

If you can see a way the two can be cleanly integrated, please don't just tell us that we have to do it, tell us how.
 
> Also, the key management for secret keys that you've added should
> not be the only mode offered to the user.  Most people do not need
> the separation between key setting and encryption/decryption.
The "key ID" is not embedded into encryption operation requests (it uses a struct nlattr), so it would be quite possible to supply the raw key instead.
    Mirek
