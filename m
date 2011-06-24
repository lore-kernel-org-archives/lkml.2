Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347Ab1FXOhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 10:37:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:57801 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274Ab1FXOhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 10:37:33 -0400
Message-ID: <4E04A122.2080002@infradead.org>
Date: Fri, 24 Jun 2011 11:37:22 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Jesper Juhl <jj@chaosbits.net>, LKML <linux-kernel@vger.kernel.org>,
        trivial@kernel.org, linux-media@vger.kernel.org,
        ceph-devel@vger.kernel.org, Sage Weil <sage@newdream.net>
Subject: Re: [RFC] Don't use linux/version.h anymore to indicate a per-driver
 version - Was: Re: [PATCH 03/37] Remove unneeded version.h includes from
 include/
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net> <4E04912A.4090305@infradead.org> <BANLkTim9cBiiK_GsZaspxpPJQDBvAcKCWg@mail.gmail.com> <201106241554.10751.hverkuil@xs4all.nl>
In-Reply-To: <201106241554.10751.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 24-06-2011 10:54, Hans Verkuil escreveu:
> On Friday, June 24, 2011 15:45:59 Devin Heitmueller wrote:
>> On Fri, Jun 24, 2011 at 9:29 AM, Mauro Carvalho Chehab
>> <mchehab@infradead.org> wrote:
>>>> MythTV has a bunch of these too (mainly so the code can adapt to
>>>> driver bugs that are fixed in later revisions).  Putting Mauro's patch
>>>> upstream will definitely cause breakage.
>>>
>>> It shouldn't, as ivtv driver version is lower than 3.0.0. All the old bug fixes
>>> aren't needed if version is >= 3.0.0.
>>>
>>> Besides that, trusting on a driver revision number to detect that a bug is
>>> there is not the right thing to do, as version numbers are never increased at
>>> the stable kernels (nor distro modified kernels take care of increasing revision
>>> number as patches are backported there).
>>
>> The versions are increased at the discretion of the driver maintainer,
>> usually when there is some userland visible change in driver behavior.
>>  I assure you the application developers don't *want* to rely on such
>> a mechanism, but there have definitely been cases in the past where
>> there was no easy way to detect the behavior of the driver from
>> userland.
>>
>> It lets application developers work around things like violations of
>> the V4L2 standard which get fixed in newer revisions of the driver.
>> It provides them the ability to put a hack in their code that says "if
>> (version < X) then this driver feature is broken and I shouldn't use
>> it."
> 
> Indeed. Ideally we shouldn't need it. But reality is different.
>
> What we have right now works and I see no compelling reason to change the
> behavior.

A per-driver version only works if the user is running a vanilla kernel without 
any stable patches applied. 

I doubt that this covers the large amount of the users: they'll either use an 
stable patched kernel or a distribution-specific one. On both cases, the driver
version is not associated with a bug fix, as the driver maintainers just take
care of increasing the driver version once per each new kernel version (when
they care enough).

Also, a git blame for the V4L2 drivers shows that only a few drivers have their
version increased as changes are applied there. So, relying on cap->version 
has a minimal chance of working only with a few drivers, with vanilla *.0 kernels.

Anyway, I think that we should at least apply the enclosed patch, and remove
KERNEL_VERSION and linux/version.h includes for the drivers that didn't change
its version in the past 2 kernel releases.

I'll work later on the linux/version.h cleanup patches.

Cheers,
Mauro

-

[media] v4l2-ioctl: Add a default value for kernel version

Most drivers don't increase kernel versions as newer features are added or
bug fixes are solved. So, vidioc_querycap returned value for cap->version is
meaningless. Instead of keeping this situation forever, let's add a default
value matching the current Linux version.

Drivers that want to keep their own version control can still do it, as they
can override the default value for cap->version.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 213ba7d..61ac6bf 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/version.h>
 
 #include <linux/videodev2.h>
 
@@ -605,6 +606,7 @@ static long __video_do_ioctl(struct file *file,
 		if (!ops->vidioc_querycap)
 			break;
 
+		cap->version = LINUX_VERSION_CODE;
 		ret = ops->vidioc_querycap(file, fh, cap);
 		if (!ret)
 			dbgarg(cmd, "driver=%s, card=%s, bus=%s, "
