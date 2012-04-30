Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab2D3UMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:12:12 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55422 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632Ab2D3UMJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:12:09 -0400
MIME-Version: 1.0
In-Reply-To: <4F9EEFF5.4000703@zytor.com>
References: <20120429205429.63CCD7C0064@ra.kernel.org> <4F9DD994.70202@zytor.com>
 <CA+55aFy72rPMq3M2_PU0ue45Fb38_Effrfhu2uOpdVXt9H1XOg@mail.gmail.com>
 <4F9DDD3E.6010801@zytor.com> <4F9EEFF5.4000703@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 30 Apr 2012 13:11:46 -0700
X-Google-Sender-Auth: XDJSjH4OwaAgmRs8pRQ0II5C0sI
Message-ID: <CA+55aFxXMXmdeHAu3xOBSJEsJ97P_-6qn595FM6s7WXeK0DkjQ@mail.gmail.com>
Subject: Re: autofs: make the autofsv5 packet file descriptor use a packetized pipe
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Tokarev <mjt@tls.msk.ru>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ian Kent <raven@themaw.net>, Thomas Meyer <thomas@m3y3r.de>,
        autofs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 1:03 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Thinking about it some more: for v6, I wouldn't use a packetized pipe at
> all (due to the unnecessary extra buffer consumption.)  Instead just put
> the message size in the header and read a large chunk, which may end up
> being more than one packet and may end up with a partial packet at the
> end.  *This is okay*, because there is only one reader, and any
> additional data needed will be gotten the next time around the loop.

Yes, doing multiple streaming packets is good, but then you really do
need to design the protocol for streaming, which very much includes
having that size early in the header. And then you'd better make the
packets really have different sizes, so that you cannot possibly get
it wrong in an app that "knows" that there's one size.

However, in the case of autofs, I don't actually see multiple packets
being that common. Sure, they can happen, but it really looks like the
normal case will always be the trivial ping-pong scenario ("read one
packet, react to it, rinse and repeat").

But using a big buffer and trying to read lots at one time is valid even then.

The thing I *really* hate about the current autofs situation is how it
really does everything you can possibly do wrong. Not at all the
"let's just read as much as we can, and look at the return value to
determine number of bytes/packets", but literally "I know a-priori how
big the packet is, and I will read exactly that many bytes". That
coupled with the psueod-fixed-size packets just made it a very very
fragile thing.

                  Linus
