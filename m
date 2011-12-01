Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab1LACZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 21:25:07 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38637 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab1LACZE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 21:25:04 -0500
MIME-Version: 1.0
In-Reply-To: <CA+icZUVhxHxoED2P7=kYqxYyg-8s3am4PSAvZLE8YSYAAHpaqA@mail.gmail.com>
References: <CA+icZUVoiWrtwB9Yw2a-2DqKO=24dfm0JoaTCBwftkRPK2E0QQ@mail.gmail.com>
	<4ED11933.2000108@gmail.com>
	<CA+icZUVhxHxoED2P7=kYqxYyg-8s3am4PSAvZLE8YSYAAHpaqA@mail.gmail.com>
Date: Wed, 30 Nov 2011 20:25:03 -0600
Message-ID: <CADLC3L1y_Z1Ui-WdNfWXF232TG+EiDGSxOzi1NrMHOxd5V9CiA@mail.gmail.com>
Subject: Re: ERROR: end_request: I/O error, dev fd0, sector 0
From: Robert Hancock <hancockrwd@gmail.com>
To: sedat.dilek@gmail.com
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 7:52 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> On Sat, Nov 26, 2011 at 5:52 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
>> On 11/25/2011 06:53 AM, Sedat Dilek wrote:
>>>
>>> Hi,
>>>
>>> I am watching this issue for a long while, due to my
>>> floppy-blacklist.conf file since next-20110603.
>>>
>>> The bad: The boot-process stalls for approx 10-13 secs when booting
>>> into my Debian/sid i386 system.
>>>
>>> # dmesg | grep -A1 -B1 "end_request: I/O error, dev fd0, sector 0"
>>> [    2.422854] sd 2:0:0:0: [sdb] Attached SCSI disk
>>> [   15.289939] end_request: I/O error, dev fd0, sector 0
>>> [   15.342914] EXT4-fs (sda5): mounted filesystem with ordered data
>>> mode. Opts: (null)
>>>
>>> The funny part is my IBM laptop has no physical floppy drive!
>>>
>>> # dmesg | egrep -i 'floppy|fd0'
>>> [    0.726358] Floppy drive(s): fd0 is 1.44M
>>> [   15.289939] end_request: I/O error, dev fd0, sector 0
>>>
>>> If I blacklist "floppy" kernel-module, the boot-process is as expected
>>> without the above mentionned delay.
>>>
>>> [ /etc/modprobe.d/floppy-blacklist.conf ]
>>> # This file blacklists the floppy driver.
>>> #
>>> # XXX: Workaround: My IBM ThinkPad T40p (model 2374SG6) notebook has
>>> no physical FDD
>>> # dmesg from linux-next (next-20110603) says:
>>> # [    0.755294] Floppy drive(s): fd0 is 1.44M
>>> # [   15.238507] end_request: I/O error, dev fd0, sector 0
>>> blacklist floppy
>>> - EOF -
>>>
>>> I searched for the line and found bool blk_update_request() in
>>> block/blk-core.c file (see [1]).
>>>
>>> I have attached kern.log and dmesg.
>>>
>>> Hope this helps to narrow down the issue.
>>
>> It looks like your laptop's BIOS indicates it has a floppy controller that's
>> active:
>>
>> Nov 25 11:00:32 tbox kernel: [    0.060821] pnp 00:09: [io  0x03f0-0x03f5]
>> Nov 25 11:00:32 tbox kernel: [    0.060825] pnp 00:09: [io  0x03f7]
>> Nov 25 11:00:32 tbox kernel: [    0.060828] pnp 00:09: [irq 6]
>> Nov 25 11:00:32 tbox kernel: [    0.060831] pnp 00:09: [dma 2]
>> Nov 25 11:00:32 tbox kernel: [    0.060892] pnp 00:09: Plug and Play ACPI
>> device, IDs PNP0700 (active)
>>
>> That's presumably why the floppy driver ends up being loaded. And apparently
>> it does have a floppy controller, since the floppy driver seems able to talk
>> to it. Maybe that model of laptop had an optional bay-mounted floppy drive
>> or something?
>>
>
> Could be... next to CD_ROM bay maybe.
>
>> I'm not sure there's a workaround for this at the kernel level, since the
>> kernel probably can't determine if there's actually a floppy drive installed
>> without trying to read from it (which is likely being triggered by partition
>> probing or something). The read error will be what is triggering the message
>> you saw.
>>
>> Is there a BIOS option to disable the floppy controller?
>>
>
> I have disabled "Floppy-Drive" in BIOS setup now (was set to
> "enabled"), but I have still the modprobe backlist for floppy
> activated.
>
> Can you explain the stalling of ***10-12 seconds*** with a wrong FDD
> BIOS setting?
> That's really a long duration, with systemd my boot-process takes
> approx 15-18 seconds.

Well, I can imagine that the floppy request takes that long to time
out or fail. I'm not sure why this would be delaying the boot process,
however.

>
> Attached is the new dmesg output (kernel-config was not changed).

It looks like the BIOS is no longer reporting the floppy controller as
present, so hopefully you shouldn't need the workaround.
