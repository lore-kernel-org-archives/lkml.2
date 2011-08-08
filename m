Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab1HHBZE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 21:25:04 -0400
Received: from relais.videotron.ca ([24.201.245.36]:57630 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab1HHBZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 21:25:01 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sun, 07 Aug 2011 21:25:00 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joachim Eastwood <manabian@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Mandeep Singh Baines <msb@chromium.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Ramsay Jones <ramsay@ramsay1.demon.co.uk>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] lib/sha1: use the git implementation of SHA-1
In-reply-to: <CA+55aFyNtMwgJaMDjsy8V4k3v+WPcw9byNEVN46VGetvDOheuw@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1108072112300.20358@xanadu.home>
References: <1312595187-3265-1-git-send-email-msb@chromium.org>
 <CAGhQ9Vxb9F0jJ2o0ft-OOfOUMOArj_ci2gO__mxPkZJaNiA+4A@mail.gmail.com>
 <CA+55aFxKES2bbcYWD29TFsGg19KXauPDwdkgYXXZbZ72kEXduw@mail.gmail.com>
 <CAGhQ9VzBAXv1cW5hAmUmfHQBDcAprLg_8T2XxRyrWT2G85AV6A@mail.gmail.com>
 <CA+55aFyECSVQT9Gi6KuiBrrMoC44CVJRZAb+s0Lt9j0UuKyfwQ@mail.gmail.com>
 <CAGhQ9Vx-MoFb7rEBQCwqi8zLjoWiED7FXvzcq2eDfTEg_P=2ug@mail.gmail.com>
 <d86cf41b-bc2f-400f-823e-8042913974ae@email.android.com>
 <CAGhQ9VwgpPv=z3TmODKwaXSneTaCrsj4cTpLEVXJ1aATiGZLrg@mail.gmail.com>
 <m2liv5ovf5.fsf@igel.home>
 <CA+55aFz9K1A=v6RsMMfjJdMURWPNGTi6J53iA5jqSwqP+x-gRQ@mail.gmail.com>
 <CAGhQ9Vy9boyXuMMn=0E5Z-oN629wUTCC=ZMWWwUpB8U9RXJmdw@mail.gmail.com>
 <CA+55aFyNtMwgJaMDjsy8V4k3v+WPcw9byNEVN46VGetvDOheuw@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Aug 2011, Linus Torvalds wrote:

> On Sun, Aug 7, 2011 at 1:48 PM, Joachim  Eastwood <manabian@gmail.com> wrote:
> >
> > yes, this works. At least my board boots as normal.
> 
> Ok, I'll remove it for -rc1, just to have a working ARM setup. Maybe
> we can re-introduce it later (either together with some arm-specific
> hack for SHA_WORKSPACE_WORDS or by having an arm-optimized version of
> the *good* sha1 routine).
> 
> But I doubt it: there used to be an ARM-optimized thing in git too. It
> was removed two years ago with the commit message:
> 
>     remove ARM and Mozilla SHA1 implementations
> 
>     They are both slower than the new BLK_SHA1 implementation, so it is
>     pointless to keep them around.
> 
> and quite frankly, that removed code seems to be the same as the
> in-kernel one. So I bet the ARM "optimized" SHA1 is simply not worth
> keeping around.

Indeed.  The ARM code in the kernel is mine:

|commit c09f98271f685af349d3f0199360f1c0e85550e0
|Author: Nicolas Pitre <nico@cam.org>
|Date:   Fri Oct 28 15:26:40 2005 +0100
|
|    [ARM] 2930/1: optimized sha1 implementation for ARM
|
|    Patch from Nicolas Pitre
|
|    Here's an ARM assembly SHA1 implementation to replace the default C
|    version. It is approximately 50% faster than the generic C version. On
|    an XScale processor running at 400MHz:
|        generic C version:      9.8 MB/s
|        my version:             14.5 MB/s
[...]

I eventually added it to Git as well.  After a while I worked on the C 
version in Git:

|$ git log --reverse --oneline --author="Nicolas Pitre" git/block-sha1/
|30ba0de block-sha1: move code around
|dc52fd2 block-sha1: split the different "hacks" to be individually selected
|660231a block-sha1: support for architectures with memory alignment restrictions
|ee7dc31 block-sha1: more good unaligned memory access candidates
|d5f6a96 block-sha1: make the size member first in the context struct
|51ea551 make sure byte swapping is optimal for git
|e9c5dcd block-sha1: guard gcc extensions with __GNUC__
|30ae47b remove ARM and Mozilla SHA1 implementations

I therefore think that the ARM version in the kernel should also be 
removed if the Git C version goes in.


Nicolas
