Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab2KMRfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:35:14 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48470 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2KMRfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:35:11 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>, Ric Wheeler <rwheeler@redhat.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH v3 0/2] add per-device sysfs knob to enable unrestricted, unprivileged SG_IO
Date: Tue, 13 Nov 2012 18:25:11 +0100
Message-Id: <1352827513-29890-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Privilege restrictions for SG_IO right now apply without distinction to
all devices, based on the single capability CAP_SYS_RAWIO.  This is a very
broad capability, and makes it difficult to give SG_IO access to trusted
clients that need access to persistent reservations, trim/discard, or
vendor-specific commands.  One problem here is that CAP_SYS_RAWIO allows
to escape a partition and issue commands that affect the full disk,
thus making DAC almost useless.

For simplicity, this series attempts to solve one case only: you want
to pass through almost everything, but still run as confined as possible.
This is for example the case for virtualization, where more complex
filtering can be done just as easily in userspace, in the virtual
machine monitor.  (This does mean the filter can be subverted if the
guest can escape the QEMU jail, but a more generic approach involving
a bitmap was NACKed).

Ok for 3.8?

v2->v3: change bitmap filter to boolean

Paolo Bonzini (2):
  sg_io: pass request_queue to blk_verify_command
  sg_io: introduce unpriv_sgio queue flag

 block/blk-sysfs.c      |   32 ++++++++++++++++++++++++++++++++
 block/bsg.c            |    2 +-
 block/scsi_ioctl.c     |    9 +++++----
 drivers/scsi/sg.c      |    3 ++-
 include/linux/blkdev.h |    6 +++++-
 5 files changed, 45 insertions(+), 7 deletions(-)

-- 
1.7.4.1

