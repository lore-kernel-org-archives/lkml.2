Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031117Ab2CQQyE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 12:54:04 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60096 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab2CQQx7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 12:53:59 -0400
MIME-Version: 1.0
In-Reply-To: <FA611BE7-A574-444D-9C1E-7E32CB3BD659@anderson.de>
References: <CA+55aFyv=OKUuAV6pqdmbHeUL7Motsh+n026nWqaT63aEgBjBQ@mail.gmail.com>
 <20120301165726.GF23916@ZenIV.linux.org.uk> <CA+55aFzxWifxyFSpQfuztmOiyBQpYfiM560DWXoooZ8j8p3fYw@mail.gmail.com>
 <20120301183403.GF5054@shiny> <CA+55aFwHN_4=WOOYVC60kdSfwYautigNwTwUnjQDRa-oTanVog@mail.gmail.com>
 <FA611BE7-A574-444D-9C1E-7E32CB3BD659@anderson.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 17 Mar 2012 09:53:37 -0700
X-Google-Sender-Auth: 6lPIaI5JtCZbyzhwUD6Ze16pJ-I
Message-ID: <CA+55aFzg7Wm6hNyFLrtPB5HOdu0SSkZrbLXFJrgreEN+LYEsdg@mail.gmail.com>
Subject: Re: Faulty has_zero()? (was: .. anybody know of any filesystems that
 depend on the exact VFS 'namehash' implementation?)
To: Sven Anderson <sven@anderson.de>
Cc: Chris Mason <chris.mason@oracle.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 17, 2012 at 5:29 AM, Sven Anderson <sven@anderson.de> wrote:
>
> Am 01.03.2012 um 23:42 schrieb Linus Torvalds:
>
>> +/* Return the high bit set in the first byte that is a zero */
>> +static inline unsigned long has_zero(unsigned long a)
>> +{
>> +     return ((a - ONEBYTES) & ~a) & HIGHBITS;
>> +}
>
> (I commented this on your google+ posting as well, but I'm not sure if you will notice it there.)
>
> Out of curiosity I studied your code, and if I'm not mistaken your has_zero() function doesn't do what is expected. If there are leading 0x01 bytes in front of a NUL byte, they are also marked in the mask because of the borrow bit.

So has_zero() doesn't guarantee to return a mask of all zero bytes -
only the *first* one. And that's the only one we care about. Any
subsequent zero bytes are suspect, but we don't use that information -
we mask it all away with the "(mask-1) & ~mask"

So what has_zero() guarantees is two-fold:

 - if there are no zeroes at all, it will return 0.

 - if there is one or more zero bytes, it will return with the high
bit set in the *first* zero byte (and nothing below that).

But if it returns non-zero, only the first bit is "guaranteed". Any of
the high bits in the higher bytes are indeed suspect, exactly because
of borrow.

But for our use, we simply just don't care - we only ever care about
the *first* NUL byte.

This is why the algorithm is fundamentally little-endian only. You may
have confused your test-case on a big-endian machine. On big-endian,
you would need to do a byte-switching load.

And when we do the "NUL or slash" thing, we will or the two cases
together, which means that we catch the first NUL or slash, and even
though *both* of those are suspect in the higher bits, once more, we
won't care. We will only ever look at the *lowest* of the high bits in
the bytes (that whole , which is exactly why borrow will never matter
for us: it can only affect bits above the lowest one.

                      Linus
