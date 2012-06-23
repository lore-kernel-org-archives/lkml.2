Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab2FWQ5N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 12:57:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34783 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab2FWQ5L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 12:57:11 -0400
MIME-Version: 1.0
In-Reply-To: <1340465290.2274.26.camel@joe2Laptop>
References: <1340322723.27036.220.camel@gandalf.stny.rr.com>
 <20120622145402.8047a669.akpm@linux-foundation.org> <20120623061313.GA21895@gmail.com>
 <1340452052.1784.40.camel@mop> <1340465290.2274.26.camel@joe2Laptop>
From: Kay Sievers <kay@vrfy.org>
Date: Sat, 23 Jun 2012 18:56:51 +0200
Message-ID: <CAPXgP10HsfWDpKx98_EokneNK=yAnofxEyfXO9O8-g2kZ__0=w@mail.gmail.com>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to console
To: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 5:28 PM, Joe Perches <joe@perches.com> wrote:

>> - proper device identifiers attached to a message, which allows
>>   tools for the first time to know the contexts of the kernel messages
>
> I think this is not particularly true nor really useful at
> present and the [v]printk_emit parts should be removed
> until a the benefit of such a capability more proven.

We track all 'interesting' devices in userspace. So you can ask the
system management about a mountpoint or a network interface and it
will show all messages that got emitted during that bootup from the
underlying devices in that context. With it's udev integration we can
also include all the userspace data about the devices and walk up the
parent devices and include the parent device information into the
output.

For example, you ask for the state of a mountpoint and the system will
return you all messages that got emitted from the underlying block
devices/disks, then you can broaden the match and include all messages
from the storage host controller where the disks are connected, and so
on.

Similarly you can efficiently retrieve the logged messages for a
network interface, including the parent device, which is usually a PCI
card.

That's just how stuff should work today, and the consumer side of it
is almost ready to ship, it's just the reliable device identifier in
the kernel log that is missing today, and which we wait for, to be
generally available.

The idea is similar how you can ask today for "give me all log
messages of a certain service (note, not a PID):
  https://plus.google.com/108087225644395745666/posts/iuFEgBZT3co

The whole point of attaching the context, where a message was
generated from, in a sane format, is to replace the former unparsable
and unrecognizable prefixes like:
  cdc_acm 2-1.4:1.1: ...
  iwlwifi 0000:03:00.0: ...
  usb usb2: ...

which now are:
   SUBSYSTEM=usb
   DEVICE=+usb:2-1.4:1.1

   SUBSYSTEM=pci
   DEVICE=+pci:0000:03:00.0

   SUBSYSTEM=usb
   DEVICE=c189:1

>From that angle, this just makes things possible which have always
been intended to be possible, but which have just been insufficiently
implemented for dev_printk().

> I'm still concerned someone is going to say that the
> because you say these things, someone else is going to
> declare that the content of the [v]printk_emit bits is
> effectively an ABI (inviolate and immutable) like the
> seq_ functions.  I think that'd make changing any of the
> logging much more difficult and should be avoided.

Nothing should really change to what we do already today, dev_printk()
was supposed to be recognizable, it just wasn't good enough, it wasn't
intentionally insufficiently implemented.

We do not give the messages texts any more meaning than they already
carry, we can just properly *filter* for them. The importance or not
of the actual text stays pretty much the same. People today already
run magic regexes on the kernel log to guess what's happened in there,
and the attached context to allow reliable filtering and
identification does not change it.

What we did in the old logging was to throw away all of the context
the kernel has at logging time, log the pure text with a pretty much
unrecognizable prefix, and later start guessing games to restore the
context again. That's really a pretty amateurish way of doing
software. Tools in "the stuff mostly works, or otherwise humans can
probably make sense of it" category might be fine or even unavoidable
in some areas of software development, but it is surely not how the
basic building blocks of an operating system should work today. :)

Kay
