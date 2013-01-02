Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab3ABG7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 01:59:20 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60406 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab3ABG7Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 01:59:16 -0500
MIME-Version: 1.0
In-Reply-To: <18617468.vkbTvjxc0P@mars>
References: <2597526.usDRg4h3X1@mars> <1492866.3ugQ2fqrP0@mars>
 <201301011537.08466.Martin@lichtvoll.de> <18617468.vkbTvjxc0P@mars>
From: Shentino <shentino@gmail.com>
Date: Tue, 1 Jan 2013 22:58:35 -0800
Message-ID: <CAGDaZ_pDCyMs8BA5XaM19kEcm1X=LwawSsWLit=kqftxpyV_Yw@mail.gmail.com>
Subject: Re: Tux3 report: New news for the new year
To: Daniel Phillips <lkml@phunq.net>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tux3@phunq.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haven't had a chance to benchmark it yet due to system troubles in the
wake of a botched emerge, but from what I can tell the "write a
promise" logic seems to be much smoother than btrfs's recursive
cow'ing.

>From what I can tell on the design, tux3 is "fsync satiating" with a
single disk write.  It writes the data to the final location, updates
the log, and at that point the data is considered committed and it can
let userspace go on its merry way and take care of rolling up the
changes later.  If I understand btrfs correctly though it has to block
until the cow logic percolates all the way up to the superblock.

One other thing that interests me is this "page forking" that allows
userspace to write to a page that's already busy being written to
disk.  From what I heard it bypasses a stall caused by userspace I/O
hitting a locked page.

Finally, atime handling.  I personally dislike the forced default of
"relatime" for mount options and anything that can let atime updates
happen without being a bottleneck is a plus for me.

I'll probably have more to say once I get my new computer set up but
from what I gather talking to these guys on IRC, tux3 seems pretty
promising.

I actually followed its development in its heyday 2 years earlier
before it dropped off the radar.

On Tue, Jan 1, 2013 at 1:49 PM, Daniel Phillips <lkml@phunq.net> wrote:
> Hi Martin,
>
> Thanks for the "tux3 howto". Obviously tux3.org needs refresh, but you hit the
> main points.
>
> On Tuesday, January 01, 2013 03:37:08 PM you wrote:
>> Writing a file with
>>
>> ./tux3 write tux3.img /etc/fstab
>>
>> also seemed to work, but I gave up holding down the enter key at:
>>
>> delta_get: delta 448, refcount 2
>> tuxio: write 1 bytes at 4484, isize = 0x1184
>> delta_put: delta 448, refcount 1
>>
>> /etc/fstab is 1714 bytes long.
>
> Indeed, the trace output is too chatty, but it's nice that it wrote a file. The
> tux3 command is cool, it can access and update an unmounted tux3 volume, even
> make diagrams of it. This will form the basis of our maintenance suite. A
> basic "tux3 fsck" is under construction:
>
>     http://phunq.net/pipermail/tux3/2012-December/000012.html
>     "Towards basic filesystem checking"
>
>     http://phunq.net/pipermail/tux3/2012-December/000013.html
>     "Towards basic filesystem checking (simplified)"
>
>> No tux3fuse, but then, I lacked libfuse-dev, after installing, compiling
>> worked:
>>
>> martin@merkaba:~[…]> make tux3fuse
>> gcc -MF ./.deps/tux3fuse.d -MP -MMD -m64 -std=gnu99 -Wall -g -rdynamic
>> -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -
>> I/home/martin/Linux/Dateisysteme/tux3/tux3/user -Wall -Wextra -Werror
>> -Wundef -Wstrict-prototypes -Werror-implicit- function-declaration
>> -Wno-unused-parameter -Wno-sign-compare -Wno-missing-field-initializers
>> -D_FORTIFY_SOURCE=2 - DLOCK_DEBUG=1 -DROLLUP_DEBUG=1
>> -DDISABLE_ASYNC_BACKEND=1   $(pkg-config --cflags fuse) tux3fuse.c -lfuse
>> -o tux3fuse libtux3.a libklib/libklib.a
>>
>> Then I could use it:
>>
>> martin@merkaba:~[…]> ./tux3 mkfs tux3.img
>> __setup_sb: blocksize 4096, blockbits 12, blockmask 00000fff
>> __setup_sb: volblocks 25600, freeblocks 25600, freeinodes 281474976710656,
>> nextalloc 0 __setup_sb: atom_dictsize 0, freeatom 0, atomgen 1
>> __setup_sb: logchain 0, logcount 0
>> make tux3 filesystem on tux3.img (0x6400000 bytes)
>> […]
>>
>> martin@merkaba:~[…]> sudo ./tux3fuse tux3.img /mnt/zeit
>> [sudo] password for martin:
>>
>> martin@merkaba:~[…]> mount | grep fuse
>> fusectl on /sys/fs/fuse/connections type fusectl (rw,relatime)
>> tux3.img on /mnt/zeit type fuse.tux3.img
>> (rw,nosuid,nodev,relatime,user_id=0,group_id=0)
>>
>> But I am stuck with accessing it:
>>
>> martin@merkaba:~[…]> LANG=C ls -l /mnt/zeit
>> ls: cannot access /mnt/zeit: Permission denied
>>
>> martin@merkaba:~[…]> LANG=C sudo chown martin:martin /mnt/zeit
>> chown: cannot access '/mnt/zeit': Transport endpoint is not connected
>> martin@merkaba:~[…]> LANG=C sudo ls -l /mnt/zeit
>> ls: cannot access /mnt/zeit: Transport endpoint is not connected
>> martin@merkaba:~[…]>
>>
>> Unmounting it again worked nicely.
>
> That would be a bug, most probably in the fuse glue. Nearly all the testing
> recently has been on the kernel port (mostly under kvm) so its nice to hear
> that tux3 write still works and tux3fuse almost works. Probably, the fuse glue
> hit an assert and bailed out, causing the "endpoint is not connected" state. A
> good example of why it would be nice to beef up our team a little. Anybody who
> wants to take charge of the fuse glue is welcome.
>
>> I keep it at that for now until I may take time to take a closer look.
>>
>> I think its better to continue this on tux3 mailing list, which I have
>> subscribed to. But I thought I post this here, to give others some starting
>> point for own experiments as I did not any documentation about this
>> in the git repo.
>
> Thanks, that was great, and quick. We look forward to seeing you on the Tux3
> mailing list.
>
> Another thing I forgot to post is a link to the tux3 mailing list:
>
>      http://phunq.net/mailman/listinfo/tux3
>
> Also, we are on oftc.net, #tux3 channel.
>
> We will do our best to improve the howto documentation. A wiki would be nice.
> We may start one on github, then set one up on tux3.org later. Currently, the
> main focus is on filling in the last few big pieces needed to scale well, and
> of course, debugging. A few more helping hands on things like wikis and
> documentation refresh would be most appreciated. For now, design documentation
> and howtos get posted to the Tux3 mailing list. You are more than welcome to
> post your recipes above.
>
> Thanks again,
>
> Daniel
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
