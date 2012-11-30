Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992798Ab2K3S4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:56:47 -0500
Received: from mail.kernel.org ([198.145.19.201]:58528 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992759Ab2K3S4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:56:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Bottomley <JBottomley@parallels.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>,
        satoru takeuchi <satoru.takeuchi@gmail.com>
Subject: [ 40/56] scsi: Silence unnecessary warnings about ioctl to partition
Date: Fri, 30 Nov 2012 10:55:32 -0800
Message-Id: <20121130185122.404966631@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 6d9359280753d2955f86d6411047516a9431eb51 upstream.

Sometimes, warnings about ioctls to partition happen often enough that they
form majority of the warnings in the kernel log and users complain. In some
cases warnings are about ioctls such as SG_IO so it's not good to get rid of
the warnings completely as they can ease debugging of userspace problems
when ioctl is refused.

Since I have seen warnings from lots of commands, including some proprietary
userspace applications, I don't think disallowing the ioctls for processes
with CAP_SYS_RAWIO will happen in the near future if ever. So lets just
stop warning for processes with CAP_SYS_RAWIO for which ioctl is allowed.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>
CC: James Bottomley <JBottomley@parallels.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: satoru takeuchi <satoru.takeuchi@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/scsi_ioctl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -721,11 +721,14 @@ int scsi_verify_blk_ioctl(struct block_d
 		break;
 	}
 
+	if (capable(CAP_SYS_RAWIO))
+		return 0;
+
 	/* In particular, rule out all resets and host-specific ioctls.  */
 	printk_ratelimited(KERN_WARNING
 			   "%s: sending ioctl %x to a partition!\n", current->comm, cmd);
 
-	return capable(CAP_SYS_RAWIO) ? 0 : -ENOIOCTLCMD;
+	return -ENOIOCTLCMD;
 }
 EXPORT_SYMBOL(scsi_verify_blk_ioctl);
 


