Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab0LJOHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 09:07:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883Ab0LJOHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 09:07:39 -0500
Date: Fri, 10 Dec 2010 15:07:20 +0100 (CET)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-lab-213.englab.brq.redhat.com
To: Andreas Dilger <adilger.kernel@dilger.ca>
cc: Greg KH <gregkh@suse.de>, Lukas Czerner <lczerner@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tytso@mit.edu, sandeen@redhat.com, hch@infradead.org, axboe@kernel.dk
Subject: Re: [RFC PATCH 0/2 v1] Ioctl for reading block queue information
In-Reply-To: <A9CA290C-6611-478D-B6DD-8DF443575FC4@dilger.ca>
Message-ID: <alpine.LFD.2.00.1012101427270.2813@dhcp-lab-213.englab.brq.redhat.com>
References: <1291908337-18805-1-git-send-email-lczerner@redhat.com> <20101209192050.GA26457@suse.de> <A9CA290C-6611-478D-B6DD-8DF443575FC4@dilger.ca>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Dec 2010, Andreas Dilger wrote:

> On 2010-12-09, at 12:20, Greg KH wrote:
> > On Thu, Dec 09, 2010 at 04:25:35PM +0100, Lukas Czerner wrote:
> >> For a long time it has been pretty painful to retrieve informations from
> >> /sys/block/*/queue for particular block device. Not only it is painful
> >> to retrieve informations within C tool, parsing strings, etc, but one
> >> have to run into problem even finding the proper path in sysfs.
> > 
> > What's wrong with using libudev?  That should give you all of this
> > information easily using a .c program without any need to change the
> > kernel at all.

What's wrong with using libudev ? Well, fist of all I have never heard
about it:), one can argue this is kind of my fault, and second of all
the documentation is kind of non-existent (almost).

But, despite this I did gave libudev a quick try and I must say, it
works, however it is not as simple as calling "ioctl(fd,
BLKGETQUEUEINFO, &val)" as Andreas pointed out.

So, in my use-case, I have a path to the device provided by the user
(strictly speaking it may not be device but for example symbolic link
/dev/mapper/something) and I need to retrieve queue information like
discard_granularity, discard_alignment etc... usually stored in place
like /sys/block/sda/queue/*.

With libudev I need to:

1. create the udev obejct:

	udev = udev_new();
	if (!udev) {
		printf("Can't create udev\n");
		exit(1);
	}

2. Check the path for the block device

	stat(name, &buf);
	if (!S_ISBLK(buf.st_mode)) {
		printf("Not a block device\n");
		exit(1);
	}

3. Get udev device object

	dev = udev_device_new_from_devnum(udev, 'b', buf.st_rdev);
	if (!dev) {
		printf("Can not find the device\n");
		exit(1);
	}

4. Construct path for sysfs attribute I need:

	snprintf(path, PATH_MAX, "%s/queue/%s",
	                udev_device_get_syspath(dev),
			"discard_granularity");

5. Open the sysfs file, get page-sized buffer and parse text :-/ (without
   checks now):

	read(fd, buffer, pagesize);
	sscanf(buffer, "%lu", &value);
	printf("max_hw_sector_size: %lu\n",value);

Which is opposed to BLKGETQUEUEINFO steps (define val, invoke ioctl,
check result) a bit longer. But I can definitely see you point, it is
feasible and since we have libudev we might want to use this in
userspace. The fact is I would really want to stand up and defend my
ioctl approach, but libudev just might provide what I need without
proceeding the just-another-ioctl-madness on kernel lists :).

Thanks!

-Lukas

> > 
> > Ick, no, please just use the sysfs files, don't create a new ioctl, they
> > are horrid.
> 
> Can you please show a real example of how using libudev is less horrid than just calling "ioctl(fd, BLKGETQUEUEINFO, &val)"?
> 
> How is trying to map a block device name from /etc/mtab (via getmntent()) into a possibly wildly different block device name in /sys (e.g. /dev/vgroot/lvhome vs. /dev/dm-0 vs. /dev/mapper/vgroot-lvhome => /sys/block/dm-0), then parsing text output considered a "good API"?
> 
> Cheers, Andreas
> 
> 
> 
