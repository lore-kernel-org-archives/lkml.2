Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab2D2S3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 14:29:39 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37053 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab2D2S3h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 14:29:37 -0400
MIME-Version: 1.0
In-Reply-To: <4F9CF191.5020607@msgid.tls.msk.ru>
References: <20120427.151433.1007849975903946491.davem@davemloft.net>
 <20120427.151651.2274764174217164454.davem@davemloft.net> <CA+55aFzPbAprx-iT0TYh24uS7+JnL92mbTg_js6Cd_O0q+Dvmw@mail.gmail.com>
 <20120427.152404.2292425516870981391.davem@davemloft.net> <CA+55aFzGO+PHmjjVgxnYawbB-wFAqHtkh19vTv1AwQNpc9MsWg@mail.gmail.com>
 <20120427234215.079a1565@pyramind.ukuu.org.uk> <CA+55aFxq4TunFa8mqJk5MHfvvFSg7Dr54acW7Cnqc5amOPdqrg@mail.gmail.com>
 <CA+55aFzdEcfXVXXqCumVJo=9+fK+1HvH6L4qY03HfTTvCs1Fwg@mail.gmail.com>
 <4F9CE18C.2060806@msgid.tls.msk.ru> <CA+55aFyS9VYT50JAXeGrLrtFVWSGr+DMTA1hhrcPYzmjrSV5+A@mail.gmail.com>
 <4F9CF191.5020607@msgid.tls.msk.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 29 Apr 2012 11:29:16 -0700
X-Google-Sender-Auth: iLiPK1_23M0Ohn9xwpNZRJfy9jQ
Message-ID: <CA+55aFzJjk8vvY7au-aUOJqJaRaFT3zqP0_H9JXS2Y93wkXwEg@mail.gmail.com>
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix
 design error.
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Meyer <thomas@m3y3r.de>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        autofs@vger.kernel.org, raven@themaw.net, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2012 at 12:45 AM, Michael Tokarev <mjt@tls.msk.ru> wrote:
> On 29.04.2012 11:19, Linus Torvalds wrote:
>>
>> Gaah, it should, but it won't.
>>
>> I bet my original patch worked fine, because the pipe has only one
>> inode and pipe structure. But it has *two* 'struct file's associated
>> with it, and autofs only ever sees the writing side, and never gets to
>> mark the reading side O_DIRECT. So yeah, the reading side won't do the
>> proper packetized read.
>
> Can't we go - in kernel - from one struct file to pipe structure to
> another file structure and set O_DIRECT there?  Autofs kernel code
> checks if the file descriptor is a pipe, so it should be possible...

Nope. We don't have any back-pointers to the other "struct file". They
have the inode - and the "struct pipe_inode_info" in common, but
there's no way to find the other "struct file" from that.

And sure, a pipe in Linux could work with a single read-write "struct
file" that is used both for the reading and writing, but that's not
how the "pipe()" system call is defined - it gets two separate file
descriptors, one read-only, one write-only. So that's what autofs and
systemd hands the kernel - the write side of the pipe. And we can't
find the read-side one.

But I think I have another approach. We can make the *writer* be the
only one that cares about the packetized nature, and if it's a packet
write, it will set a PIPE_BUF_PACKET flag in the pipe buffer. The
reader can react to that. I think that actually has the potential to
make the code a bit prettier too..

I'll cook it up.

                     Linus
