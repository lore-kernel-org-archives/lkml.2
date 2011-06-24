Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1FXVpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 17:45:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:33962 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab1FXVpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 17:45:11 -0400
Message-ID: <4E050559.8000604@infradead.org>
Date: Fri, 24 Jun 2011 18:44:57 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Jesper Juhl <jj@chaosbits.net>, LKML <linux-kernel@vger.kernel.org>,
        trivial@kernel.org, linux-media@vger.kernel.org,
        ceph-devel@vger.kernel.org, Sage Weil <sage@newdream.net>
Subject: Re: [RFC] Don't use linux/version.h anymore to indicate a per-driver
 version - Was: Re: [PATCH 03/37] Remove unneeded version.h includes from
 include/
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>	<4E04912A.4090305@infradead.org>	<BANLkTim9cBiiK_GsZaspxpPJQDBvAcKCWg@mail.gmail.com>	<201106241554.10751.hverkuil@xs4all.nl>	<4E04A122.2080002@infradead.org> <20110624203404.7a3f6f6a@stein>
In-Reply-To: <20110624203404.7a3f6f6a@stein>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 24-06-2011 15:34, Stefan Richter escreveu:
> On Jun 24 Mauro Carvalho Chehab wrote:
>> Em 24-06-2011 10:54, Hans Verkuil escreveu:
>>> On Friday, June 24, 2011 15:45:59 Devin Heitmueller wrote:
>>>> The versions are increased at the discretion of the driver maintainer,
>>>> usually when there is some userland visible change in driver behavior.
>>>>  I assure you the application developers don't *want* to rely on such
>>>> a mechanism, but there have definitely been cases in the past where
>>>> there was no easy way to detect the behavior of the driver from
>>>> userland.
>>>>
>>>> It lets application developers work around things like violations of
>>>> the V4L2 standard which get fixed in newer revisions of the driver.
>>>> It provides them the ability to put a hack in their code that says "if
>>>> (version < X) then this driver feature is broken and I shouldn't use
>>>> it."
>>>
>>> Indeed. Ideally we shouldn't need it. But reality is different.
>>>
>>> What we have right now works and I see no compelling reason to change the
>>> behavior.
>>
>> A per-driver version only works if the user is running a vanilla kernel without 
>> any stable patches applied. 
>>
>> I doubt that this covers the large amount of the users: they'll either use an 
>> stable patched kernel or a distribution-specific one. On both cases, the driver
>> version is not associated with a bug fix, as the driver maintainers just take
>> care of increasing the driver version once per each new kernel version (when
>> they care enough).
>>
>> Also, a git blame for the V4L2 drivers shows that only a few drivers have their
>> version increased as changes are applied there. So, relying on cap->version 
>> has a minimal chance of working only with a few drivers, with vanilla *.0 kernels.
> 
> If the "driver version" is in fact an ABI version, then the driver author
> should really increase it only when ABI behavior is changed (and only if
> the behavior change can only be communicated by version number --- e.g.
> addition of an ioctl is not among such reasons).  And the author should
> commit behavior changing implementation and version number change in a
> single changeset.

Yes, but "driver version" were never used as such. Several drivers got lots of
updates, ABI change behavior (like the removal of V4L1 API), etc without having
a single "driver version" increment. Other drivers increase it even on minor
changes.

IMO, it makes no sense on keeping it, but removing this field would break 
userspace, as a few programs seem to use it.

> And anybody who backmerges such an ABI behavior change into another kernel
> branch (stable, longterm, distro...) must backmerge the associated version
> number change too.

Yes, but, again, this doesn't happen. In general, the drivers that use it either
increment the version number on a separate patch, or integrate it with one of
the patches.

It is easy to take a look at ivtv, as it has a separate file with the version
number:

$ git log --oneline drivers/media/video/ivtv/ivtv-version.h
4359e5b V4L/DVB: ivtv: Increment driver version due to firmware loading changes
c019f90 V4L/DVB (10965): ivtv: bump version
c58dc0b V4L/DVB (8633): ivtv: update ivtv version number
be303e1 V4L/DVB (7930): ivtv: bump version to 1.3.0.
fcbbf6f V4L/DVB (7759): ivtv: increase version number to 1.2.1
0170a48 V4L/DVB (6762): ivtv: update version number to 1.2
612570f V4L/DVB (6091): ivtv: header cleanup
f38a798 V4L/DVB (5909): ivtv: update version to 1.1 to mark ivtv-fb support
1a0adaf V4L/DVB (5345): ivtv driver for Conexant cx23416/cx23415 MPEG encoder/decoder

Looking at the details of the above commits, on several cases there's no explanation
why the version was incremented, or why an userspace application should bother to have
any special treatment for that version or for the previous one.

The date of the commits also don't help much:

Date:   Sat Jun 12 13:55:33 2010 -0300
Date:   Wed Mar 11 18:50:04 2009 -0300
Date:   Wed Sep 3 16:46:58 2008 -0300
Date:   Sat May 24 12:43:43 2008 -0300
Date:   Sat Apr 26 09:43:22 2008 -0300
Date:   Fri Dec 7 20:31:17 2007 -0300
Date:   Thu Aug 23 05:42:59 2007 -0300
Date:   Sun Jul 22 08:39:43 2007 -0300
Date:   Fri Apr 27 12:31:25 2007 -0300

Even when there seems to have a good reason for version bump, like on this example
(from cx18 driver):

commit 9982be8
Author: Andy Walls <awalls@radix.net>
Date:   Wed Apr 15 20:49:19 2009 -0300

    V4L/DVB (11620): cx18: Increment version due to significant buffer handling changes
    
    Version bump from 1.1.0 to 1.2.0
    
    Signed-off-by: Andy Walls <awalls@radix.net>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

The commit message doesn't help to tell the application developer how version 1.1.0 is
different than version 1.2.0.

Also, as this is on a separate commit, if the buffer changes were backported into a
stable or distro kernel, the application will have no way to detect the differences.

On several cases, the version upgrade is simply due to the addition of a new type of
support, like this one:

commit 437b775
Author: Andy Walls <awalls@md.metrocast.net>
Date:   Sun Mar 27 00:43:30 2011 -0300

    [media] cx18: Bump driver version, since a new class of HVR-1600 is properly supported
    
    Make a user visible driver version change, for the inevitable user support
    questions about why newer model HVR-1600's do not work with (older
    versions of) the cx18 driver.

For things like that, it would be enough to simply increment MODULE_VERSION().

> Of course sometimes people realize this only after the fact.  Or driver
> authors don't have a clear understanding of ABI versioning to begin with.
> I am saying so because I had to learn it too; I certainly wasn't born
> with an instinct knowledge how to do it properly.
> 
> (Disclaimer:  I have no stake in drivers/media/ ABIs.  But I am involved
> in maintaining a userspace ABI elsewhere in drivers/firewire/, and one of
> the userspace libraries that use this ABI.)


Em 24-06-2011 15:48, Devin Heitmueller escreveu:
> To be clear, I don't think anyone is actually proposing that the
> driver version number really be used as any form of formal "ABI
> versioning" scheme.  In almost all cases, it's so the application can
> know to *not* do something is the driver is older than X.

As I've explained before, even that is wrong, as the version increment
patch may not have been backported.

> Given all the cases I've seen, it doesn't really hurt anything if the
> driver contains a fix from newer than X, aside from the fact that the
> application won't take advantage of whatever feature/functionality the
> fix made work.  In other words, I think from a backport standpoint, it
> usually doesn't *hurt* anything if a fix is backported without the
> version being incremented, aside from applications not knowing that
> the feature/fix is present.

New features could also be backported without version increment. This happens
from time to time at the enterprise distros, and on long duration stable
releases.

> Really, this is all about applications being able to jam a hack into
> their code that translates to "don't call this ioctl() with some
> particular argument if it's driver W less than version X, because the
> driver had a bug that is likely to panic the guy's PC".  Sure, it's a
> crummy solution, but at this point it's the best that we have got.

Version number is not enough for that. When there are such panic/OOPS bugs,
they are backported to -stable and to the distro kernels.

An application doing that will be removing a feature that is probably already
fixed.

Mauro.
