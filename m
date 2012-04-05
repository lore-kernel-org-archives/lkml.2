Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab2DERKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 13:10:22 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46546 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab2DERKU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 13:10:20 -0400
MIME-Version: 1.0
In-Reply-To: <1333569554.864.3.camel@mop>
References: <1333569554.864.3.camel@mop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Apr 2012 10:09:56 -0700
X-Google-Sender-Auth: g1nsDqhIAKDndzmm959xBibG1-0
Message-ID: <CA+55aFyMO=xx0xNvggR-1fs-jKi_zaayNfgCa3HCNkvH0yA16g@mail.gmail.com>
Subject: Re: [PATCH] printk: support structured and multi-facility log messages
To: Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 4, 2012 at 12:59 PM, Kay Sievers <kay@vrfy.org> wrote:
> From: Kay Sievers <kay@vrfy.org>
> Subject: printk: support structured and multi-facility log messages

Much nicer than I was afraid of. Gone are the insane UUID ideas.

However, some concerns remain:

>  $ cat /dev/kmsg
>  PRIORITY=5
>  SEQNUM=0
>  TIMESTAMP=0
>  MESSAGE=Linux version 3.4.0-rc1+ (kay@mop) (gcc version 4.7.0 20120315 ...

Why has this been explicitly designed to be as ugly as humanly
possible, and to be so inconvenient to parse too?

IOW, what's the advantage of the insanity? Especially since PRIORITY,
SEQNUM and TIMESTAMP are fundamental, marking them and separating them
from each other seems totally pointless. It's ugly for humans, and
it's pointlessly harder for automation too, as far as I can tell.

I assume these is some reason for this, but I would want to know what
that reason is. The above is hard to use with grep or any of the
standard unix line-at-a-time tools, so it seems misdesigned. It looks
to be designed for some hacky one-off special parsing tool.

So here's a serious suggestion: aim for "line oriented". And there's a
really nice continuation character that people are getting used to,
and that is widely used in another line-oriented record message model
- SMTP headers. It's "if the first character on a line is a space,
it's a continuation of the previous record".

So if the format was

  priority,seqnum,timestamp,message
  [ possible continuation for multi-line things, and now only the
continuation-lines are tagged about what they are ]

it would be much more easily greppable etc, it would be more readable,
and it would be *easier* to actually parse than that horrible format.

> +/*
> + * The printk log buffer consists of a chain of concatenated variable
> + * length records. Every record starts with a record header, containing
> + * the overall length of the record.

Please also make it very explicit that records have to be "strings".
All your examples are strings, all our history is strings, and I want
to make it clear that we don't do binary data in this thing.

You made the statement that you want to get away from 30 years of
history, but the fact is, "30 years of history" is a damn good
argument for "that thing worked".

Strings work. Embedded random binary crap? Not so much.

No "we're going to hide binary UUID's or firmware images here" crap.

> + * The human readable log message directly follows the message header. The
> + * length of the message text is stored in the header, the message is _not_
> + * terminated by a '\n' or '\0' character.

I agree with having a length specifier, however, you seem to have some
crazy definition where "\n\n" has special meaning.

That's stupid. Don't do it. Make it clear that things are strings, and
the only thing that has special meaning is the NUL character. It's
true in your examples, and it's just a good idea. But the reason I
want to point it out is that from the code and comments, it's clear
that you actually still think that "binary is acceptable" is true.
It's not true, and it needs to not be true.

So this part looks fine, and we do the key/value pairs for other things:

> + * Optionally, a message can carry a dictionary of properties (key/value pairs).
> + * The content of the dictionary is opaque to the printk code, it is stored
> + * only to provide userspace with a machine-readable message context.

But again, "opaque" had better still be "text", not random binary
blobs. It's how environment variables work, it's how we're used to
things, it's just how things work.

So make it opaque extra information, yes, but make sure it's still text.

Because this is just pure and utter *shit*:

> + * A binary value is encoded by not using a '=' character as a delimiter,
> + * but a '\n' character followed directly by a non-aligned inlined little-endian
> + * uint64_t, which specifies the number of binary bytes to read as value.
> + * Example for a dictionary containing a 4 byte long binary value:
> + *  "DEVICE=b12:8\nFIRMWARE_DUMP\n\x04\x00\x00\x00\x00\x00\x00\x00\x11\x12\x13\x14\nDRIVER=ahci\n"

Why? No thank you.

This part gets a big NAK from me.

I don't see the point of this. It's pure crap. There's no advantage.
And the "use an uint64_t" is a classic case of just being a f*cking
moron. There's no way we can *ever* support that kind of sizes for log
messages in the kernel anyway. It's not like we can even support
32-bit random blobs. In fact,  you use a 16-bit value for the
dict-buffer size.

This is the kind of thinking and code that just makes me go "No way,
not today, not ever". It's *stupid*.

So make the rule simple:
 - it's text.
 - it's not binary
 - it's not arbitrarily sized
 - it doesn't have crazy idiotic 64-bit binary numbers encoded in it.
 - '\n\n' isn't special, NUL is. Because that's how we encode things.
If you want to escape something, you escape NUL and special characters
using the standard *text* escaping mechanisms, not using some random
hodge-podge that you just made up.

Other than this issue, I actually don't have any problems with the
code. Most of it seems fairly reasonable. But this one just made me go
"wtf, how can something so reasonable then be so completely crazy in
this regard".

                       Linus
