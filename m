Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab2D2HUP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 03:20:15 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34406 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab2D2HUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 03:20:13 -0400
MIME-Version: 1.0
In-Reply-To: <4F9CE18C.2060806@msgid.tls.msk.ru>
References: <20120427.151433.1007849975903946491.davem@davemloft.net>
 <20120427.151651.2274764174217164454.davem@davemloft.net> <CA+55aFzPbAprx-iT0TYh24uS7+JnL92mbTg_js6Cd_O0q+Dvmw@mail.gmail.com>
 <20120427.152404.2292425516870981391.davem@davemloft.net> <CA+55aFzGO+PHmjjVgxnYawbB-wFAqHtkh19vTv1AwQNpc9MsWg@mail.gmail.com>
 <20120427234215.079a1565@pyramind.ukuu.org.uk> <CA+55aFxq4TunFa8mqJk5MHfvvFSg7Dr54acW7Cnqc5amOPdqrg@mail.gmail.com>
 <CA+55aFzdEcfXVXXqCumVJo=9+fK+1HvH6L4qY03HfTTvCs1Fwg@mail.gmail.com> <4F9CE18C.2060806@msgid.tls.msk.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 29 Apr 2012 00:19:50 -0700
X-Google-Sender-Auth: AlwEEiMW-QfnQSL27vU2PWiNsXc
Message-ID: <CA+55aFyS9VYT50JAXeGrLrtFVWSGr+DMTA1hhrcPYzmjrSV5+A@mail.gmail.com>
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

On Sat, Apr 28, 2012 at 11:37 PM, Michael Tokarev <mjt@tls.msk.ru> wrote:
>
> And no, it does not quite work.  Strace shows that systemd correctly
> reads first 300 bytes, but next read returns 4 bytes, so it reads
> these and waits for next 300-4 = 296 bytes of data.
>
> /proc/1/fdinfo/16  -- the autofs pipe fd# -- shows flags=02004000
> which is O_CLOEXEC|O_NONBLOCK, but this is the other end of the
> pipe..  shouldn't the READ side of the pipe have O_DIRECT flag now?

Gaah, it should, but it won't.

I bet my original patch worked fine, because the pipe has only one
inode and pipe structure. But it has *two* 'struct file's associated
with it, and autofs only ever sees the writing side, and never gets to
mark the reading side O_DIRECT. So yeah, the reading side won't do the
proper packetized read.

Duh. So we need to put the flag back in the pipe_inode_info. Too bad -
because the O_DIRECT approach was so nice in other ways.

                     Linus
