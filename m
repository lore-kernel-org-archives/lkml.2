Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab2D3Anw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 20:43:52 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37689 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab2D3Anv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 20:43:51 -0400
MIME-Version: 1.0
In-Reply-To: <4F9DDE47.5060008@zytor.com>
References: <20120429205429.63CCD7C0064@ra.kernel.org> <4F9DD994.70202@zytor.com>
 <CA+55aFy72rPMq3M2_PU0ue45Fb38_Effrfhu2uOpdVXt9H1XOg@mail.gmail.com>
 <4F9DDCB6.1070908@zytor.com> <CA+55aFwGZm4+rdJ+xArhsVJ8P5gH3xxCfuoHibotr0Sik484=w@mail.gmail.com>
 <4F9DDE47.5060008@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 29 Apr 2012 17:43:29 -0700
X-Google-Sender-Auth: k5XMI4nLwDWQDJiXhigYMDEnXJY
Message-ID: <CA+55aFzDhkVzaUYQwKbkUqoRNb223+w0-k=pOxTZHja75JOMvQ@mail.gmail.com>
Subject: Re: autofs: make the autofsv5 packet file descriptor use a packetized pipe
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Tokarev <mjt@tls.msk.ru>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ian Kent <raven@themaw.net>, Thomas Meyer <thomas@m3y3r.de>,
        autofs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2012 at 5:35 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Which is funny/sad, because that's actually the intended way the
> interface is meant to work.

Well, the autofs packet model is actually horribly badly misdesigned
even for that: the header doesn't contain the size of the packet. It
contains the packet *type*, and from that you can then determine the
size (of course, every other program would determine it *wrongly* for
this whole x86-64 alignment reason), but that is actually a horrible
model because it assumes you know all the packet types.

(There's a "len" field in the v5 packet, but that's not the packet
length, that's the length of the name component)

And the reason nobody does that is that in practice there is only ever
one single type of packet that is possible anyway, so there's no point
in even reading the header to find the type.

So a much nicer model is one where the actual *size* of the packet is
in the header. That would have allowed for not having that fixed
maximum size of a name etc, and would have avoided the whole problem
to begin with.

Of course, the nicest model of all is to just use a packetized
interface to begin with, so that none of these issues exist. Which is
what we're now effectively moving to, unless we can find some horrible
program that makes that impossible due to it playing games and knowing
it's a "stream".

Looking at am-utils, I think we're ok so far. But maybe you know of
yet another crazy user of the autofs interfaces.

                      Linus
