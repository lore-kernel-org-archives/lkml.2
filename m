Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab1FYMPL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 08:15:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab1FYMPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 08:15:08 -0400
Message-ID: <4E05D13A.6030209@redhat.com>
Date: Sat, 25 Jun 2011 09:14:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: LKML <linux-kernel@vger.kernel.org>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Jesper Juhl <jj@chaosbits.net>, trivial@kernel.org,
        linux-media@vger.kernel.org, ceph-devel@vger.kernel.org,
        Sage Weil <sage@newdream.net>, Mike Isely <isely@isely.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans De Goede <hdegoede@redhat.com>,
        Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [PATCH] [media] Stop using linux/version.h on most drivers
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net> <4E04A122.2080002@infradead.org> <4E04D696.7020800@redhat.com> <201106251209.21228.hverkuil@xs4all.nl>
In-Reply-To: <201106251209.21228.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 25-06-2011 07:09, Hans Verkuil escreveu:
> On Friday, June 24, 2011 20:25:26 Mauro Carvalho Chehab wrote:
>> All the modified drivers didn't have any version increment since
>> Jan, 1 2011. Several of them didn't have any version increment
>> for a long time, even having new features and important bug fixes
>> happening.
>>
>> As we're now filling the QUERYCAP version with the current Kernel
>> Release, we don't need to maintain a per-driver version control
>> anymore. So, let's just use the default.
>>
>> In order to preserve the Kernel module version history, a
>> KERNEL_VERSION() macro were added to all modified drivers, and
>> the extraver number were incremented.
>>
>> I opted to preserve the per-driver version control to a few
>> drivers: cx18, davinci, fsl-viu, gspca, ivtv, m5mols, soc_camera,
>> pwc, s2255, s5p-fimc and sh_vou. The rationale is that the 
>> per-driver version control seems to be actively maintained on 
>> those.
>>
>> A few drivers are still using the legacy way to handle ioctl's.
>> So, we can't do such change on them, otherwise, they'll break.
>> Those are: uvc, pvrusb2, et61x251 and sn9c102.
>>
>> Yet, I think that the better for them would be to just use the
>> default version numbering, instead of doing that by themselves.
>>
>> While here, removed a few not needed include linux/version.h.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> Sorry, but I have to say NACK to this.
> 
> If we do this, then we should do this consistently.

IMO, all drivers should stop reporting its own version via V4L2 API:
people forget to maintain it on a consistent way. That was my original
proposal, and it can still be implemented later.

This patch does it on a consistent way: on places were version is not updated
for more than 6 months (2 kernel releases) and use video_ioctl2, the version 
string were replaced by a number that it is greater than the previous value.

My original proposal were to replace it on every place, but you and Devin
argued against. So, this approach is a mid-term: let's do it initially
where it makes more sense, and discuss what will be done with the remaining
drivers that implement their own version control.

With the mid-term approach taken by this patch, we warrant that, when newer
V4L2 core API changes are applied, the version number will also be incremented,
reflecting that changes could have affected the driver.

> I thought it over and filling it with the current kernel version would work
> well with one exception: the pwc driver has a major number of 10 which is
> larger than the kernel's major number. (cpia2 has a version of 3.0.0, so that
> just works).

That's what I've explained on my first email about this subject: the only driver that has
a numbering > 3.0.0 is the pwc driver, and it does that on a not consistent way:
when you've removed the V4L1 API, you've incremented the version string, but you forgot
to upgrade the caps->version. So, if any application is relying on it for pwc, the
check is currently broken.

> I am inclined to sort of close my eyes for that one and just replace it as
> well, but that's just me :-)

I like the idea of replacing pwc version to 3.0.0. We moved it into drivers/media 
at 2006-03-25. On that time, the version was: 9.0.2-unofficial, and only the V4L1 API
was implemented.

In other words, the pwc driver never returned version 3.0.0 to VIDIOC_QUERYCAP.
So, it is safe to just use 3.x.y. Assuming that we'll be incrementing Kernel major
versions on every 10 years, the namespace conflicts will happen 70 years from now ;)
Seriously, I don't think we need to be concerned with a conflict with 10.0.x. numbering
that will happen on lots of years in the future (also, because we probably won't use
the extraver numbering).

> The only thing that needs to be done is that media_build needs some hack to
> set the version field to the source git tree kernel version instead of the
> target's kernel version.

Yes. After applying those patches, we'll need to fix the out-of-tree media_build.
It shouldn't be hard: a patch can just add a logic that uses a V4L2_VERSION
version defined on v4l/v4l2-version.h, for example.

> To simplify that and to accomodate the four ioctl-legacy drivers we can
> make a simple include/media/version.h header that defines a V4L2_API_VERSION
> define.

I would not care much about those. The current situation is:
	- et61x251: only one USB ID is currently supported there: 102c:6251, using
the TAS5130D1B sensor. The gspca etoms driver supports the same USB ID with the
same sensor. IMO, we can just move this driver to staging and remove it.
	- sn9c102: I think that there are still a few USB ID's there that aren't yet
at the gspca/sonix* drivers, but Jean-François/Hans could give us a better status.
Anyway, no new features or bug fixes are added there for a long time, and core changes
should likely not affect this driver, as it doesn't use the subdev layer nor 
video_ioctl2. So, we can just keep its version there until its removal;
	- pvrusb2: Mike Isely said on a reply to one of your patches that he's finally
migrating it to use video_ioctl2.
	- uvcvideo: not sure about its current status about its migration to video_ioctl2.
If Laurent is not doing a migration to video_ioctl2 any time soon, a simple patch for it
could make it act consistently. In any case, I don't think we should create a 
include/media/version.h just due to uvcvideo.

> An alternative is to just add an api_version field to v4l2_querycap.
> That would work fine too.
> 
> One reason for doing that may be to help out-of-tree drivers: for those a
> driver version *does* make sense. I know, we shouldn't have to care about
> out-of-tree drivers, but on the other hand why make life hard for them without
> a good reason?

Adding anything at the V4L2 API in order to accommodate a need for an out-of-tree
driver is out of the question. While we have some reserved space there, we should not
waste it due to out-of-tree drivers.

> The more I think about it, the more I like the idea of an api_version field.
> It would keep pwc happy, it wouldn't require many changes to drivers, and it
> will not affect out-of-tree drivers.

As I've explained before, pwc will work with 3.0.0, because there are no namespace
conflicts in any predictable future. The _only_ version that it ever reported with
V4L2 since April, 2006 is 10.0.12 (see commit 2b455db6d456ef2d44808a8377fd3bc832e08317).
For sure, no application is currently checking for its version, as it reports the
same version. So, even on the remote far-away case where we might have a conflict,
it will be on just one specific stable Kernel release (Kernel 10.0.12).

Removing the driver-specific version reported via V4L2 API is a good thing, due to a
series of reasons:
	1) every time include/linux/version.h changes, all media drivers need to be
	   recompiled;
	2) eventually, this macro will be changed at 3.0 times;
	3) developers are lazy on updating it at a per-driver basis; The information
	   there is not consistent;
	4) a check for LINUX_VERSION_CODE (and its equivalent media_build replacement)
	   will be changed on a consistent way, being incremented when new features are
	   added at the Kernel;
	5) An userspace application could use it in order to check if unsupported ioctl's
	   will return -ENOIOCTLCMD (see my patch adding this change to V4L2 API);
	6) From time to time, people do the wrong thing, including version.h where it is
	   not needed, and spending Kernel Janitor's time to cleanup the mess.

Anyway, the approach I'm taking is to:

1) apply a patch making optional for the drivers to fill it;

2) removing it were it is clearly an improvement. The drivers that
still keeps its own version control are basically:
	- the 4 drivers that don't use video-ioctl2;
	- the SoC drivers;
	- 4 drivers that are currently using it at regular basis: gspca, s2255, cx18 and ivtv;
	- pwc;
	- radio drivers;

3) If you agree, I would also do the same for pwc, as it makes sense to me;

4) double-check with the SoC driver developers and with the other maintainers that use the
version control, if using LINUX_VERSION_CODE (and its equivalent media_build replacement)
would fit for them;

5) Do the same change for the radio drivers;

6) If a per-API version control fits to everybody, change v4l2-ioctl to enforce it via 
   video_ioctl2, updating the V4L2 API accordingly.

Cheers,
Mauro.

