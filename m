Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab0EMTRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 15:17:38 -0400
Received: from kroah.org ([198.145.64.141]:43901 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932449Ab0EMTQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 15:16:42 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/3] tty: Fix unbalanced BKL handling in error path
Date: Thu, 13 May 2010 12:16:38 -0700
Message-Id: <1273778199-17578-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100513191601.GA17538@kroah.com>
References: <20100513191601.GA17538@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Arnd noted:

After the "retry_open:" label, we first get the tty_mutex
and then the BKL. However a the end of tty_open, we jump
back to retry_open with the BKL still held. If we run into
this case, the tty_open function will be left with the BKL
still held.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_io.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 6da962c..d71f0fc 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1875,6 +1875,7 @@ got_driver:
 		 */
 		if (filp->f_op == &hung_up_tty_fops)
 			filp->f_op = &tty_fops;
+		unlock_kernel();
 		goto retry_open;
 	}
 	unlock_kernel();
-- 
1.7.1

