Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab1HGVmR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 17:42:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755369Ab1HGVmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 17:42:14 -0400
MIME-Version: 1.0
In-Reply-To: <1312752577.29102.13.camel@Joe-Laptop>
References: <1312595187-3265-1-git-send-email-msb@chromium.org>
 <CAGhQ9Vxb9F0jJ2o0ft-OOfOUMOArj_ci2gO__mxPkZJaNiA+4A@mail.gmail.com>
 <CA+55aFxKES2bbcYWD29TFsGg19KXauPDwdkgYXXZbZ72kEXduw@mail.gmail.com>
 <CAGhQ9VzBAXv1cW5hAmUmfHQBDcAprLg_8T2XxRyrWT2G85AV6A@mail.gmail.com>
 <CA+55aFyECSVQT9Gi6KuiBrrMoC44CVJRZAb+s0Lt9j0UuKyfwQ@mail.gmail.com>
 <CAGhQ9Vx-MoFb7rEBQCwqi8zLjoWiED7FXvzcq2eDfTEg_P=2ug@mail.gmail.com>
 <d86cf41b-bc2f-400f-823e-8042913974ae@email.android.com> <CAGhQ9VwgpPv=z3TmODKwaXSneTaCrsj4cTpLEVXJ1aATiGZLrg@mail.gmail.com>
 <m2liv5ovf5.fsf@igel.home> <CA+55aFz9K1A=v6RsMMfjJdMURWPNGTi6J53iA5jqSwqP+x-gRQ@mail.gmail.com>
 <CAGhQ9Vy9boyXuMMn=0E5Z-oN629wUTCC=ZMWWwUpB8U9RXJmdw@mail.gmail.com>
 <CA+55aFyNtMwgJaMDjsy8V4k3v+WPcw9byNEVN46VGetvDOheuw@mail.gmail.com> <1312752577.29102.13.camel@Joe-Laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 7 Aug 2011 14:41:14 -0700
Message-ID: <CA+55aFz7UaD+FiWg1XDDWVmZwijX_hhHEMvVp9k6gViLNr4Kiw@mail.gmail.com>
Subject: Re: [PATCH] treewide: Remove direct uses of SHA_WORKSPACE_WORDS
To: Joe Perches <joe@perches.com>
Cc: Joachim Eastwood <manabian@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        Ramsay Jones <ramsay@ramsay1.demon.co.uk>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 7, 2011 at 2:29 PM, Joe Perches <joe@perches.com> wrote:
> While not connected to ARM's implementation of sha_transform,
> maybe this might make code a bit clearer.
>
> Remove need to know the size and type of SHA_WORKSPACE_WORDS.
> Introduce and use opaque struct sha_workspace instead.

The thing is, that workspace thing is likely just broken, and should be removed.

On machines with sufficient registers, we can keep the workspace in
the register set, and setting it up on stack and passing it in as a
buffer is just bad.

On x86 and arm it doesn't matter, but on ppc it likely pessimizes the
code by resulting in pointless writebacks to that stack buffer.

So the right thing to do is probably to just remove it entirely, and
just make the sha_transform() thing allocate it on the stack as
needed. The only issue then is whether you really want the stackspace
cleared afterwards. My personal guess is that it really doesn't
matter: if you leak stack space anywhere, you are seriously screwed
from a security standpoint anyway, so..

But in the meantime, I don't want to add this kind of abstraction for
something that I suspect is just fundamentally broken.

                            Linus
