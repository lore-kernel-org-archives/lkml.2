Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab2D0Wkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 18:40:55 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58385 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab2D0Wkx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 18:40:53 -0400
MIME-Version: 1.0
In-Reply-To: <20120427.162925.2185774349490743693.davem@davemloft.net>
References: <CA+55aFzPbAprx-iT0TYh24uS7+JnL92mbTg_js6Cd_O0q+Dvmw@mail.gmail.com>
 <20120427.152404.2292425516870981391.davem@davemloft.net> <CA+55aFzGO+PHmjjVgxnYawbB-wFAqHtkh19vTv1AwQNpc9MsWg@mail.gmail.com>
 <20120427.162925.2185774349490743693.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Apr 2012 15:40:32 -0700
X-Google-Sender-Auth: wM44SWRQrz18J2rvzABbnP4w9FE
Message-ID: <CA+55aFw=T-+fsLi7RWxPz2FWAUzk4fxH28GWGLhwo3+L5JWsrw@mail.gmail.com>
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix
 design error.
To: David Miller <davem@davemloft.net>
Cc: mjt@tls.msk.ru, linux-kernel@vger.kernel.org, autofs@vger.kernel.org,
        raven@themaw.net, thomas@m3y3r.de, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 1:29 PM, David Miller <davem@davemloft.net> wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Fri, 27 Apr 2012 12:56:20 -0700
>
>>  - when reading, consider a pipe buffer to be "spent" when any of the
>> data has been read
>
> So basically any sized read empties the entire pipe, right?
>
> As long as we never generate multiple messages at the same
> time, I guess this would work.

It would work regardless.

Read the notes (or the small patch) again. Reading a part of a pipe
buffer clears *that* buffer. And since the packetized mode also
disables merging of writes into buffers, that means that multiple
writes result in multiple buffers. By default, pipes have 16 buffers
(you can set the number if you really want to), so you can do multiple
writes of multiple packets, and then as you read them, you'll see each
write individually.

So let's say that you have a writer that does the following writes: 8
bytes, 100 bytes, 32 bytes.  If you have a reader that reads a
fixed-size buffer (let's pick 64 bytes just to make an example), the
reader will then see those exact three writes, except it will only get
the 64 first bytes of the 100-byte write (and the remaining 36 bytes
will be lost forever).

So it really is packetized.

Of course, if you try to write more than PAGE_SIZE in one single
write, the pipe code will split that up into multiple buffers, so then
a reader would see that as multiple "packets". But hey, that's how
pipes work - they have a size limit on write atomicity guarantees,
regardless of the packetized mode. And obviously right now we only
expose the packetized mode for the autofs pipe, which only does writes
of that one fixed size (~300 bytes).

                     Linus
