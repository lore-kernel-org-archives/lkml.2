Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab1HHXvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 19:51:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080Ab1HHXvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 19:51:19 -0400
MIME-Version: 1.0
In-Reply-To: <1312844837-10086-1-git-send-email-msb@chromium.org>
References: <1312844837-10086-1-git-send-email-msb@chromium.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 8 Aug 2011 16:50:22 -0700
Message-ID: <CA+55aFymLSQyWECCBWLGtChXcJwtWNxOqdJQRbOwGyYzjY=MSg@mail.gmail.com>
Subject: Re: [PATCH] lib/sha1: remove memsets and allocate workspace on the stack
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ramsay Jones <ramsay@ramsay1.demon.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>,
        Joachim Eastwood <manabian@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 8, 2011 at 4:07 PM, Mandeep Singh Baines <msb@chromium.org> wrote:
>
> There is no loss of security due to removing the memset. It would be a
> bug for the stack to leak to userspace. However, a defence-in-depth
> argument could be made for keeping the clearing of the workspace.

So I'm nervous about this just because I can see the security crazies
rising up about this.

The fact is, in our current code in drivers/char/random.c, we do have
a memset() of the workspace buffer on the stack, and any competent
compiler should actually just remove it, because it's dead memory (and
the compiler can *see* that it's dead memory). Of course, I don't know
if gcc does notice that, but it's a prime example of code that "looks"
secure, but has absolutely zero actual real security. Getting rid of
the memset() is actually better for *real* security, in that at least
it's not some kind of pointless security theater. But I  can see some
people wanting to add a memory barrier or something to force the
memset() to actually take place.

So I dunno.

Arguably it's theoretically possible to find random data on the stack,
and maybe it can even be interesting (although I don't think the last
64 bytes of SHA1 state is all that exciting myself). Personally, I
consider it unlikely as hell to be relevant to anybody, and anybody
who has access to the kernel stack has *much* more direct security
holes than some random data that they can use. But the patch still
makes me worry about the brouhaha from some people.

                    Linus
