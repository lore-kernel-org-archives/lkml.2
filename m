Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab2ADRsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 12:48:20 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41395 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab2ADRsQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 12:48:16 -0500
MIME-Version: 1.0
In-Reply-To: <1324198486.4924.3.camel@raz>
References: <1323940396.16032.2.camel@raz>
	<4EEA0C05.4030907@zytor.com>
	<1323962398.11872.3.camel@raz>
	<4EEA10BC.3000906@zytor.com>
	<CAPXgP12QS3jGi3pcEhSAoGcWdtjmujL-HP69Cgy9_+kRLFq1sQ@mail.gmail.com>
	<1324198486.4924.3.camel@raz>
Date: Wed, 4 Jan 2012 11:48:14 -0600
Message-ID: <CABqD9haRkXUPP4JzJTuQP5tFsiuFJYW9PFF55jjYg4N-gwdwfw@mail.gmail.com>
Subject: Re: Subject:[PATCH 1:1] boot paramer "root=" gets a list of devices
From: Will Drewry <wad@chromium.org>
To: rbenyehuda@manz.com
Cc: Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Rasty Slutsker <RSlutsker@manz.com>, Lior Brafman <LBrafman@manz.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 18, 2011 at 2:54 AM, Raz Ben Yehuda <rbenyehuda@manz.com> wrote:
> On Thu, 2011-12-15 at 19:11 +0100, Kay Sievers wrote:
>> On Thu, Dec 15, 2011 at 16:22, H. Peter Anvin <hpa@zytor.com> wrote:
>> > On 12/15/2011 07:19 AM, Raz Ben Yehuda wrote:
>> >>>
>> >>> To which point I have to ask, once again, at which point we stop putting
>> >>> this stuff in the kernel to "bypass the need for initramfs"...
>> >>
>> >> because there are times where we cannot use initramfs. is this a problem
>> >> with way i phrase or with with the whole idea ?
>>
>> I don't see why stuff needs to search a hard-coded list of stuff. That
>> logic seems pretty much backwards to me. You either use the GPT stuff
>> that allows to flag the right partition to boot from a set of
>> partitions, or you go as far as make the kernel parse the filesystem
>> UUID of partitions. But hard-coding search lists on the commandline, I
>> really don't understand.
> Will GPT or fs UUID parsing solve the problem of having the kernel
> think that hda has the root filesystem while hdc has it ?

It's a question of how you address your root filesystem or the
partition containing it. root= is meant for specifying a relatively
unique way to find your root block device (partition) or is overloaded
for use by an initramfs (for FSUUID parsing).  If you can address your
root partition with a UUID, then it doesn't matter what the actual
block device is, the kernel can find it.

The scenario you've laid out is a little confusing.  How does
root_wait interact with a list of block devices?  How do you handle
prioritization if the device come up at different times?  When does it
know to try the next entry? Most of this work seems like it belongs in
either the bootloader or an initramfs.  Then the bootloader can pass
along a unique identifier (like a partition uuid), or if device
enumeration matches, the actual device node name after performing some
boot policy logic.  Using a hard list of device nodes implies a good
bit more boot policy logic than is captured and seems to exceed the
scope of root= by quite a bit.  (Even approaches like md= fit nicely
in the scope that the device specified by root= has an explicit or
kernel-friendly config.)

(And as a side note, those printk(KERN_INFO)s are going to be very
noisy if you have a root_wait scenario.  It's good to go light with
printk()s in this area of the kernel :).

Not sure if this helps, but hopefully it does.
Cheers,
will

>> > There are problems with the whole concept of "cannot use initramfs".  We
>> > allow the initramfs to be integrated with the kernel image for a reason, for
>> > example.
>> >
>> > I'm obviously ranting on this in part to make people think about what they
>> > are doing, and partly to remind that the more complex the in-kernel
>> > root-mounting code get, the more it might be worth reconsidering klibc in
>> > the kernel build tree.
>>
>> I think the whole picture of klibc is confusing and I very much don't
>> want to see that busybox-style hacking in the kernel sources.
>>
>> Distros can not afford to support 2 libcs at bootup, and the distro
>> initramfss gets so complicated today, that a klibc-only solution does
>> not really work. So we end up with 2 libcs in the same initramfs
>> image, which makes zero sense. Leave alone the fact, that the klibc
>> tools duplicate all the stuff that already works in the real root in a
>> completely different and mostly insufficient and sometimes scary way.
>>
>> The thing is, if the setup is that simple that klibc works, it is very
>> likely that the current in-kernel mount code is simple, well tested
>> and sufficient enough. If a distro-style intramfs is needed, klibc is
>> not usable (see above). The big distros will very unlikely ever pick
>> it up. The the remaining use-cases will stay a niche, that, I think,
>> does not justify the kernel inclusion of klibc.
>>
>> If the whole klibc approach, if not entirely rethought, I doubt it
>> will ever go anywhere. In my opinion, with all what I've seen the last
>> years, we either work on a full libc in the kernel tree, that can be
>> used by normal userspace too, or we leave the tiny stuff to busybox
>> and one of the existing tiny libcs.
>>
>> Kay
>
>
