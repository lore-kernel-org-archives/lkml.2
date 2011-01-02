Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab1ABH40 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:56:26 -0500
Received: from mail.windriver.com ([147.11.1.11]:35412 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab1ABHXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:16 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 109/260] USB: serial/mos*: prevent reading uninitialized stack memory
Date: Sun,  2 Jan 2011 02:16:45 -0500
Message-Id: <1293952756-15010-110-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:09.0196 (UTC) FILETIME=[C4408EC0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit a0846f1868b11cd827bdfeaf4527d8b1b1c0b098 upstream.

The TIOCGICOUNT device ioctl in both mos7720.c and mos7840.c allows
unprivileged users to read uninitialized stack memory, because the
"reserved" member of the serial_icounter_struct struct declared on the
stack is not altered or zeroed before being copied back to the user.
This patch takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/mos7720.c |    3 +++
 drivers/usb/serial/mos7840.c |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 0d47f2c..623a6d3 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -1566,6 +1566,9 @@ static int mos7720_ioctl(struct tty_struct *tty, struct file *file,
 
 	case TIOCGICOUNT:
 		cnow = mos7720_port->icount;
+
+		memset(&icount, 0, sizeof(struct serial_icounter_struct));
+
 		icount.cts = cnow.cts;
 		icount.dsr = cnow.dsr;
 		icount.rng = cnow.rng;
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index a73f2f5..16f0548 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2286,6 +2286,9 @@ static int mos7840_ioctl(struct tty_struct *tty, struct file *file,
 	case TIOCGICOUNT:
 		cnow = mos7840_port->icount;
 		smp_rmb();
+
+		memset(&icount, 0, sizeof(struct serial_icounter_struct));
+
 		icount.cts = cnow.cts;
 		icount.dsr = cnow.dsr;
 		icount.rng = cnow.rng;
-- 
1.7.3.3

