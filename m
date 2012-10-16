Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab2JPQOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 12:14:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56693 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab2JPQO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 12:14:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Subject: Re: [PATCH 11/16] f2fs: add inode operations for special inodes
Date: Tue, 16 Oct 2012 16:14:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "'Changman Lee'" <cm224.lee@gmail.com>,
        "'Vyacheslav Dubeyko'" <slava@dubeyko.com>,
        "'Jaegeuk Kim'" <jaegeuk.kim@gmail.com>, viro@zeniv.linux.org.uk,
        "'Theodore Ts'o'" <tytso@mit.edu>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com
References: <001201cda2f1$633db960$29b92c20$%kim@samsung.com> <201210151405.41392.arnd@arndb.de> <015a01cdab46$145caa10$3d15fe30$%kim@samsung.com>
In-Reply-To: <015a01cdab46$145caa10$3d15fe30$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201210161614.15636.arnd@arndb.de>
X-Provags-ID: V02:K0:GCtU3QhWPkF8dD8pl6107D3rXwTu0HWeJeBoXHyhxo3
 E1ABHVjVVEO70ugb2ZyLbAC+lLm6rZiTqAwumxTdYQ6QMBVmUw
 QftRoClgdNQAsQoo7wyyXPWvE4U3AApc4eI6VM6xlKfY8U5YHj
 Gu8nEKLcRTKWEKZtvWcRKZK4HjtpC5Qc7wiY/f0wJYU/iO0lqc
 MslVllPrOPJRGxDh1ipm2evx7sN8+gtywVU3dT544sWTZIPdfu
 bFJ21l/v/q16NMX7TPhZE37s2PR9aeI7k+dZ1dyEUED5JeFaUt
 4w0mAGPArc6G4WYgUeSFCGI3IiqDAZ/4/gVATTU7dVuf44G1Ur
 9BhewneqP+kgO1Vosv40=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 October 2012, Jaegeuk Kim wrote:
> Thank you for a lot of points to be addressed. :)
> Maybe it's time to summarize them.
> Please let me know what I misunderstood.
> 
> [In v2]
> - Extension list
>   : Mkfs supports configuring extensions by user, and that information
>     will be stored in the superblock. In order to reduce the cleaning overhead,
>     f2fs supports an additional interface, ioctl, likewise ext4.

That is what I suggested but actually Dave Chinner is the person that you
need to listen to rather than me in this regard. Using an extended attribute
in the root node would be more appropriate to configure this than an ioctl.

> - The number of active logs
>   : No change will be done in on-disk layout (i.e., max 6 logs).
>     Instead, f2fs supports changing the number with a mount option.
>     Currently, I think 4, 5, and 6 would be enough.

Right, that would be the minimum that I would ask for. If it is relatively
easy to support more than six logs in the file format without actually
implementing them in the code, you might want to support up to 16, just
to be future-proof.

For the lower bound, being able to support as little as 2 logs for
cheap hardware would be nice, but 4 logs is the important one.

5 logs is probably not all that important, as long as you have the
choice between 4 and 6. If you implement three different ways, I
would prefer have the choice of 2/4/6 over 4/5/6 logs.

> - Section size
>   : Mkfs supports multiples of segments for a section, not power-of-two.

Right.

> [Future optimization]
> - Data separation
>   : file access pattern, and else?

 : Investigate the option to make large files erase block indirect rather than
   part of the normal logs

There is one more more point that I have not mentioned before, which is the
alignment of write requests. As far as I can tell, you try to group writes
as much as possible, but the alignment and the minimum size is still just
4 KB. I fear that this might not be good enough for a lot of cases when
the page sizes grow and there is no sufficient amount of nonvolatile
write cache in the device. I wonder whether there is something that can
be done to ensure we always write with a minimum alignment, and pad
out the data with zeroes if necessary in order to avoid getting into
garbage collection on devices that can't handle sub-page writes.

	Arnd
