Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab2D0XHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 19:07:44 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37809 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523Ab2D0XHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 19:07:43 -0400
MIME-Version: 1.0
In-Reply-To: <4F9B2420.5030806@zytor.com>
References: <20120427.151433.1007849975903946491.davem@davemloft.net>
 <20120427.151651.2274764174217164454.davem@davemloft.net> <CA+55aFzPbAprx-iT0TYh24uS7+JnL92mbTg_js6Cd_O0q+Dvmw@mail.gmail.com>
 <20120427.152404.2292425516870981391.davem@davemloft.net> <CA+55aFzGO+PHmjjVgxnYawbB-wFAqHtkh19vTv1AwQNpc9MsWg@mail.gmail.com>
 <4F9B050C.3000309@zytor.com> <CA+55aFz-1n=REkh9SzA1aEz5J_uGc=B_nKj+cP8J=PR6YSZD1w@mail.gmail.com>
 <4F9B2420.5030806@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Apr 2012 16:07:21 -0700
X-Google-Sender-Auth: RMyQUvG5D8IKnu8mqdomfmOQTTw
Message-ID: <CA+55aFyCpiU5_nG-3Nra5q9x0-71amAQVetZTxxP6waR1ueYNQ@mail.gmail.com>
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix
 design error.
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Miller <davem@davemloft.net>, mjt@tls.msk.ru,
        linux-kernel@vger.kernel.org, autofs@vger.kernel.org, raven@themaw.net,
        thomas@m3y3r.de, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 3:56 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> I guess, though, what you're saying is to change the semantic of the
> existing pipe to return short reads on the receive end.

The important change is actually to make the read return the size requested.

So broken user space does a read() with the wrong size - and then
checks that it gets *exactly* that many bytes. Not more, not less.

The way to handle that is to
 - make sure the kernel always writes the maximally padded data
 - make the packetization simply drop any data that was in the packet
that the reader didn't ask for.

This is very much a semantic change, in that any client that tries to
read the packet with multiple reads (one 4-byte read to see the size,
followed by one "right-sized" read of the data) would be totally
screwed. The first read would indeed read the size, but it also -
because of the packetized interface - would simply drop the data, and
the next read would read the first bytes of the next packet.

But that's not what the autofs users actually do anyway. They just
read the whole packet.  So we can make *them* work. And the new
interface will be fairly robust (in fact, you could pass it some big
buffer and just know you always get exactly one packet, and never have
that whole stupid "sizeof()" at all).

                           Linus
