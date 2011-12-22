Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab1LVTSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 14:18:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab1LVTSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 14:18:11 -0500
Message-ID: <4EF38269.7080804@redhat.com>
Date: Thu, 22 Dec 2011 20:18:01 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, security@kernel.org, pmatouse@redhat.com,
        agk@redhat.com, jbottomley@parallels.com, mchristi@redhat.com,
        msnitzer@redhat.com
Subject: Re: [PATCH 2/3] block: fail SCSI passthrough ioctls on partition
 devices
References: <1324576939-23619-1-git-send-email-pbonzini@redhat.com> <1324576939-23619-3-git-send-email-pbonzini@redhat.com> <CA+55aFzAo5hjCkKe1aaHgyCYc6RYRb8tf+zPTUwO6R8WWd9T-Q@mail.gmail.com>
In-Reply-To: <CA+55aFzAo5hjCkKe1aaHgyCYc6RYRb8tf+zPTUwO6R8WWd9T-Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2011 07:37 PM, Linus Torvalds wrote:
> On Thu, Dec 22, 2011 at 10:02 AM, Paolo Bonzini<pbonzini@redhat.com>  wrote:
>> Linux allows executing the SG_IO ioctl on a partition or even on an
>> LVM volume, and will pass the command to the underlying block device.
>> This is well-known, but it is also a large security problem when (via
>> Unix permissions, ACLs, SELinux or a combination thereof) a program or
>> user needs to be granted access to a particular partition or logical
>> volume but not to the full device.
>
> So who actually *does* this in practice?

Virtualization, as explained in the cover letter.

>> +       /* In particular, rule out all resets and host-specific ioctls.  */
>> +       return -ENOTTY;
>
> This kind of crazy needs to go away.

What crazy?  It's not a permission problem.  Sending a SCSI command to a 
partition makes no sense.  A permission problem implies that somehow you 
should be able to fix it by granting additional permissions, which is 
not the case here.

> If it's a permission problem, state that. Don't turn it into ENOTTY that then:
>
>> +               return ret == -ENOTTY ? -ENOIOCTLCMD : ret;
>
> gets turned into another random error number.

That's existing craziness of the compat_ioctl mechanism:

/* Most of the generic ioctls are handled in the normal fallback path.
    This assumes the blkdev's low level compat_ioctl always returns
    ENOIOCTLCMD for unknown ioctls. */

The logic is quite intricate:

1. process generic block layer ioctls that require compat handling 
(compat_blkdev_ioctl)

2. process device-specific ioctls that require special 32-on-64 
handling, whose implementation is outside block/ (sd_compat_ioctl).

3. process device-specific ioctls that require special 32-on-64 
handling, whose implementation is in block/compat_ioctl.c 
(compat_blkdev_driver_ioctl).

4. fallback to the normal ioctl implementation for ioctls that do not 
require 32-on-64 (__blkdev_driver_ioctl).

If I return ENOTTY (or EPERM for that matter: anything but ENOIOCTLCMD), 
then I rule out execution of steps 3 and especially 4.  This means 
32-on-64 systems will get ENOTTY for BLKGETSIZE64 and will fail to boot.

Paolo
