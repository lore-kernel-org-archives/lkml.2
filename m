Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab1LMW7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 17:59:03 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38879 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab1LMW67 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 17:58:59 -0500
MIME-Version: 1.0
In-Reply-To: <1323641436-12249-1-git-send-email-brgerst@gmail.com>
References: <CAMzpN2jiZn3=Og9EVhnWbEhZkvi6eebEJpR7qYn00OyJnZgcFQ@mail.gmail.com>
 <1323641436-12249-1-git-send-email-brgerst@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 13 Dec 2011 14:58:37 -0800
X-Google-Sender-Auth: RLJjqRcJa2IdzpMlBVYBN-5f2S8
Message-ID: <CA+55aFx37CgDoZeJzxQpsk14yZAzt0g69VtJx=Upj=FBUpCPQw@mail.gmail.com>
Subject: Re: [PATCH] x86: Split off mem*io functions
To: Brian Gerst <brgerst@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, tim@klingt.org,
        hpa@zytor.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 11, 2011 at 2:10 PM, Brian Gerst <brgerst@gmail.com> wrote:
> Commit 6175ddf06b6172046a329e3abfd9c901a43efd2e changed the mem*io
> functions to use the standard memcpy/memset routines, but there were
> unintended consequences.  Some devices cannot cope with 64-bit or
> non-sequential accesses that the optimized routines do.  Change them
> back to simple 32-bit sequential writes.

It might be worth giving examples of when the optimized routines don't work:

 - some devices (for example, traditional CGA/VGA) read and write to
different banks and bit modes, so a "read-mask-write" operation just
does not work at all. You have to do pure writes when copying to such
a destination. Afaik, none of our *current* memory copies do this for
partial words, but it's an example of something that is valid (and
sometimes done) in memcpy to avoid unaligned stores, for example.

 - Many devices do not like overlapping stores, which the optimized
memory copies *do* do. Our memory copy does things like this:

        /*
         * Move data from 4 bytes to 7 bytes.
         */
        movl (%rsi), %ecx
        movl -4(%rsi, %rdx), %r8d
        movl %ecx, (%rdi)
        movl %r8d, -4(%rdi, %rdx)

   to copy 4-7 bytes from source %rsi to destination %dsi (with %rdx
containing the size), which actually writes four bytes twice - some of
th ebytes are just going to be overlapping. This often does not work
at all for memory mapped IO.

 - the "enhanced string" support actually makes "rep movsb" the most
optimal way to copy memory, but only to cacheable RAM. If the source
or destination is memory mapped IO, the microcode will make "rep
movsb" turn into the traditional slow byte-by-byte copy. That will be
*extremely* slow, even if it might work for the device.

 - Finally, 64-bit writes may confuse some devices.

But the point being that it's a much bigger issue than just 64-bit.

                   Linus
