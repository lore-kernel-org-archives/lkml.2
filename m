Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab0HWIKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 04:10:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52066 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab0HWIKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 04:10:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>
Subject: Re: [PATCH 00/19] RFC, v2: "New" /dev/crypto user-space interface
Date: Mon, 23 Aug 2010 10:09:54 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.5.0; x86_64; ; )
Cc: Miloslav =?utf-8?q?Trma=C4=8D?= <mitr@redhat.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-crypto@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
        linux-kernel@vger.kernel.org
References: <1282293963-27807-1-git-send-email-mitr@redhat.com> <201008211908.03705.arnd@arndb.de> <4C70D72E.2040605@gmail.com>
In-Reply-To: <4C70D72E.2040605@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201008231009.55037.arnd@arndb.de>
X-Provags-ID: V02:K0:OLzUWU0BWdaPXcgD2od6gcRP0CpiSn+0InE6AqT8Bkp
 AT/DYGm29vXCIgJTC5fOSixXStq5p8UZvzpw79Ub5hAQIWMuDh
 H4AatUOT/yQcQMGpyvkH79HfAuIb6TJlkg5zoBm7ROZFhspeuf
 iFmKBpBPMlkxlpDorQrumyZDX2unH+1aystjL5haeuOgN+Q706
 LIvC3E78uGEKJC7Ne2yfA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 August 2010 09:52:14 Nikos Mavrogiannopoulos wrote:
> On 08/21/2010 07:08 PM, Arnd Bergmann wrote:
> > On Friday 20 August 2010 10:45:43 Miloslav Trmač wrote:

> >> * Full compat_ioctl implementation
> > New drivers should be written to *avoid* compat_ioctl calls, using only
> > very simple fixed-length data structures as ioctl commands.
> 
> There are cases where this cannot be easily done, when say pointers are
> involved. IMHO forcing pointers to be u64 or u32 is dirtier than using
> the compat interface.

Yes, but that only means you should avoid pointers in data structures
that are passed to ioctl. Ideally, you would use ioctl to control
the device while you use read and write to pass actual bits of data.

> >> * Version number added to the data format used when wrapping keys for storage
> > Again, wrong direction. If you think you need a version number, the interface
> > is probably not ready for inclusion yet. Make sure it is simple enough that
> > you don't run into the case where you have to make incompatible changes
> > that require API versioning.
> 
> Note that the version number is not to the interface but to data that
> are intended for storage. It is desirable to have such a version there.

ok, makes sense.

> >>   The libtom* patches will probably still be too large for the mailing list;
> >>   the whole patch set is also available at
> >>   http://people.redhat.com/mitr/cryptodev-ncr/v2/ .
> > They actually seem to have made it to the list. However, the more signficant
> > problem is the amount of code added to a security module. 20000 lines of
> > code that is essentially a user-level library moved into kernel space
> > can open up so many possible holes that you end up with a less secure
> > (and slower) setup in the end than just doing everything in user space.
> 
> The same argument could apply to an other algorithm in the kernel such
> as deflate, lzma, AES etc. There are cases that the benefits outweigh
> the risks of adding them. I believe this is such a case.

The algorithms that are in the kernel already are there specifically because
they are used by the kernel itself, which is an entirely different story.

> >>   An user-space library is not separated, options are a) root
> >>   running daemon that does crypto, but this would be slow due to context
> >>   switches, scheduler mismatching and all the IPC overhead and b) use crypto
> >>   that is in the kernel.
> > I think you will have to back that statement by measurements. There are
> > reasonably fast ways to do IPC and the interface you suggest to put in the
> > kernel does not exactly look tuned for performance.
> 
> This is an alternative design. There quite some reasons against that,
> such as the auditing features. For me the main reason was  that there
> was no way to make it as fast (zero-copy) as this design, for the
> requirements we had (interface with existing crypto libraries through
> pkcs11). Zero-copy is important since crypto operations might involve
> large chunks of data.

You mean using a shared memory segment would not be possible without changing
the libpkcs11 interface?

	Arnd
