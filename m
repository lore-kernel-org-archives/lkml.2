Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab2AENSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 08:18:51 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:48119 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277Ab2AENSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 08:18:50 -0500
Message-ID: <4F05A332.1060600@redhat.com>
Date: Thu, 05 Jan 2012 14:18:42 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        security@kernel.org, pmatouse@redhat.com, agk@redhat.com,
        jbottomley@parallels.com, mchristi@redhat.com, msnitzer@redhat.com,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] block: fail SCSI passthrough ioctls on partition
 devices
References: <1324576939-23619-3-git-send-email-pbonzini@redhat.com> <CA+55aFzAo5hjCkKe1aaHgyCYc6RYRb8tf+zPTUwO6R8WWd9T-Q@mail.gmail.com> <4EF38269.7080804@redhat.com> <CA+55aFz9aRjSaof+vtHRquYn4w3fYd_+qXdNO3M+7kRWWfKxvA@mail.gmail.com> <4EF391A6.2040504@redhat.com> <CA+55aFzmCoX17j9h5-RLrPctpf5GAh5i7bG3vDUBKsZoXNFugg@mail.gmail.com> <4EF3AA74.1060801@redhat.com> <CA+55aFw+ipBQFTj9SbNjE1KkS+xNpY7RdF1emSf7WrzavyReqA@mail.gmail.com> <20111222234830.GC31021@agk-dp.fab.redhat.com> <CA+55aFxqy1wJFFVbykBJWuGm8YAjA-VP=xAqHttVOwC_zuxvOA@mail.gmail.com> <20111223062649.GD21994@1wt.eu> <CA+55aFxnOwkquH8tirqJnM_KTcavAejY8drL11jy2S+2PXmZuw@mail.gmail.com> <4EF48CE4.3000104@redhat.com> <CA+55aFy=7wGzQv76dirJ=ZjeNdbKVKDRCLA323orsE13GcKvwQ@mail.gmail.com>
In-Reply-To: <CA+55aFy=7wGzQv76dirJ=ZjeNdbKVKDRCLA323orsE13GcKvwQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2011 11:46 PM, Linus Torvalds wrote:
> It sounds like people didn't even*think*  of the potential issues this
> patch can bring.  I'd absolutely be insane to apply them for -rc7.

Fair enough, I obviously cannot say they aren't intrusive.

Anyway, I set to change the patches to use ENOIOCTLCMD.  I did some
research and found the following commit:

commit d9ecdea7ed7467db32ec160f4eca46c279255606
Author: Christoph Hellwig <hch@lst.de>
Date:   Sat Jun 20 21:29:41 2009 +0200

    virtio_blk: ioctl return value fix
    
    Block driver ioctl methods must return ENOTTY and not -ENOIOCTLCMD if
    they expect the block layer to handle generic ioctls.
    
    This triggered a BLKROSET failure in xfsqa #200.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

which indeed matches the current code in block/ioctl.c:

	case BLKROSET:
		ret = __blkdev_driver_ioctl(bdev, mode, cmd, arg);
		/* -EINVAL to handle old uncorrected drivers */
		if (ret != -EINVAL && ret != -ENOTTY)
			return ret;
		if (!capable(CAP_SYS_ADMIN))
			return -EACCES;
		if (get_user(n, (int __user *)(arg)))
			return -EFAULT;
		set_device_ro(bdev, n);
		return 0;

Hence, changing scsi_verify_blk_ioctl to return ENOIOCTLCMD is not
really possible.  I can make it return a boolean value, but I do not
like it: does true mean "pass this ioctl" or "forbid this ioctl"?

Would you apply the patches as they are or do you want me to squash in
something like this?

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index a6bedfe..bb94c88 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -710,6 +710,14 @@ int scsi_verify_blk_ioctl(struct block_device *bd, unsigned int cmd)
 	case SG_SET_RESERVED_SIZE:
 	case SG_EMULATED_HOST:
 		return 0;
+
+	case CDROMEJECT:
+		/* This is also unsafe for partition devices, but
+		 * "eject /mnt/usb-drive" invokes it.  Warn about it
+		 * and keep backwards compatibility.  */
+		printk_ratelimited(KERN_WARNING
+				   "sending CDROMEJECT ioctl to a partition\n");
+		return 0;
 	default:
 		break;
 	}

... perhaps allowing it only for CAP_SYS_RAWIO?

Paolo
