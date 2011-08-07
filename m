Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab1HGRpL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 13:45:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753291Ab1HGRpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 13:45:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAGhQ9VzBAXv1cW5hAmUmfHQBDcAprLg_8T2XxRyrWT2G85AV6A@mail.gmail.com>
References: <1312595187-3265-1-git-send-email-msb@chromium.org>
 <CAGhQ9Vxb9F0jJ2o0ft-OOfOUMOArj_ci2gO__mxPkZJaNiA+4A@mail.gmail.com>
 <CA+55aFxKES2bbcYWD29TFsGg19KXauPDwdkgYXXZbZ72kEXduw@mail.gmail.com> <CAGhQ9VzBAXv1cW5hAmUmfHQBDcAprLg_8T2XxRyrWT2G85AV6A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 7 Aug 2011 10:44:45 -0700
Message-ID: <CA+55aFyECSVQT9Gi6KuiBrrMoC44CVJRZAb+s0Lt9j0UuKyfwQ@mail.gmail.com>
Subject: Re: [PATCH] lib/sha1: use the git implementation of SHA-1
To: Joachim Eastwood <manabian@gmail.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        Ramsay Jones <ramsay@ramsay1.demon.co.uk>,
        Nicolas Pitre <nico@cam.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 7, 2011 at 10:36 AM, Joachim  Eastwood <manabian@gmail.com> wrote:
>
> These printk's come from drivers/char/random.c
> So it doesn't seem like it hangs in any of the sha_* funtions.

The only other change is to SHA_WORKSPACE_WORDS - I wonder if some
code depends on the old (much bigger) workspace for some reason?

The git SHA1 routines are way smarter than the old SHA1, and will
re-use the workspace area, so they need only a fraction of the old
area.

Try changing SHA_WORKSPACE_WORDS back to 80 (in
include/linux/cryptohash.h). The git sha1 only needs 16 words, but ..

If that fixes it for you, then it's almost certainly some buggy user
that uses the SHA1 workspace array for its own odd case, and
incorrectly "knows" that it's that old wasteful 320 bytes. There's a
few places in networking that uses SHA_WORKSPACE_WORDS.

                                     Linus
