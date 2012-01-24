Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab2AXX1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:27:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56370 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab2AXX1q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:27:46 -0500
MIME-Version: 1.0
In-Reply-To: <20120124231601.GA4470@sergelap>
References: <20120124000517.GA28878@sergelap> <CA+55aFz9ofF+Ey8VCDS8UEf2XSw36kj2RhkHfFScuzLXMeNrkA@mail.gmail.com>
 <20120124002555.GA29534@sergelap> <CA+55aFzwOU137V6wtyBjessx05NJo2G4KV0rvTKWvC79A+o9iQ@mail.gmail.com>
 <20120124010758.GJ23916@ZenIV.linux.org.uk> <m1k44gj1cu.fsf@fess.ebiederm.org>
 <20120124220247.GA26353@hallyn.com> <CAPXgP13_gczQmG_USAp0p2AuTfxkzAvzHvjbZY_rbbLH-4rDyg@mail.gmail.com>
 <20120124231601.GA4470@sergelap>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 25 Jan 2012 00:27:24 +0100
Message-ID: <CAPXgP12REAwmDORzdGJhsxZKU8nhiauCxoVdKa8Eifw4MWWtgA@mail.gmail.com>
Subject: Re: [RFC] fix devpts mount behavior
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Whitcroft <apw@canonical.com>, sukadev@linux.vnet.ibm.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 00:16, Serge Hallyn <serge.hallyn@canonical.com> wrote:
> Quoting Kay Sievers (kay.sievers@vrfy.org):
>> On Tue, Jan 24, 2012 at 23:02, Serge E. Hallyn <serge@hallyn.com> wrote:
>> > Quoting Eric W. Biederman (ebiederm@xmission.com):
>>
>> >> It looks like relatively recent udev still creates /dev/ptmx and does
>> >
>> > Boy, it does, and it's stubborn about it.  Removing the /lib/udev/rules.d
>> > entry doesn't stop it.  (this is after I've had an init job replace the
>> > devtmpfs-created ptmx entry with a symlink)
>>
>> Udev has nothing to do with that. The kernel creates that device node.
>> Udev does not carry any rules you could remove, to name device nodes,
>> it only set permissions and creates symlinks to device nodes.
>
> That's odd, because I was sure I deleted the node after the kernel created
> it.
>
> But it sounds like I must have done it wrong.

Oh, older udevs re-create it when you run 'udevadm trigger', but only
then, never on its own, there will be no such event. Current udevs
will not do mknod() anymore, never.

>> It will never replace a kernel-created device node with a symlink,
>> there is no way to express that. If you don't want a device node
>> there, you need to change the kernel, to not export
>> /sys/class/tty/ptmx/ the way it is today.
>>
>> > So current distros (well, Ubuntu and Fedora at least) would need to at least
>> > (a) fix udev,
>>
>> To do what?
>
> Nothing, as I'm sure you're right above  :)

:)

>> > (b) change the default devpts mount (done from initramfs) to
>> > add ptmxmode=666,
>>
>> > (c) (if not done in udev) create the /dev/ptmx symlink.
>>
>> Udev can only create symlinks to devices the driver-core creates, not
>> to devices inside a custom filesystem.
>
> I see.
>
>> > For safety I'd recommend creating /dev/pts/ptmx with
>> > DEVPTS_MULTIPLE_INSTANCES=n (or dropping that support), and by default
>> > setting ptmxmode to 666 as that's what udev does.
>>
>> The mode for ptmx is set by the kernel itself, and does not even need
>> udev to do that:
>>   $ cat /sys/class/tty/ptmx/uevent
>>   MAJOR=5
>>   MINOR=2
>>   DEVNAME=ptmx
>>   DEVMODE=0666
>
> That has nothing to do with /dev/pts/ptmx, whose perms are set based on
> the '-o ptmxmode=" argument, and default to 000 if not specified.

Yeah, right. Just saying that some permissions are set by the kernel
itself these days. I wouldn't be bad if the kernel had the default of
0666 for the devpts fs, would it?

> If /dev/ptmx is going to be a symlink to /dev/pts/ptmx, then we have to set
> the /dev/pts/ptmx perms to not be 000, or users won't be able to create
> ptys.

Right. Change the devpts in-kernel default?

We might also thing about changing /sys/class/tty/ptmx/, and have the
kernel create the symlink? The loops through userspace to setup
default kernel stuff are kind of crazy ...

Kay
