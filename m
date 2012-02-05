Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab2BEW1b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:27:31 -0500
Received: from 1wt.eu ([62.212.114.60]:62157 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695Ab2BEW13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:27:29 -0500
Message-Id: <20120205220950.812864962@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:21 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Luben Tuikov <ltuikov@yahoo.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 32/91] libsas: remove expander from dev list on error
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 5911e963d3718e306bcac387b83e259aa4228896 upstream.

If expander discovery fails (sas_discover_expander()), remove the
expander from the port device list (sas_ex_discover_expander()),
before freeing it. Else the list is corrupted and, e.g., when we
attempt to send SMP commands to other devices, the kernel oopses.

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
Reviewed-by: Jack Wang <jack_wang@usish.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/libsas/sas_expander.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/drivers/scsi/libsas/sas_expander.c
===================================================================
--- longterm-2.6.27.orig/drivers/scsi/libsas/sas_expander.c	2012-02-05 22:34:34.059914940 +0100
+++ longterm-2.6.27/drivers/scsi/libsas/sas_expander.c	2012-02-05 22:34:39.404915902 +0100
@@ -839,6 +839,9 @@
 
 	res = sas_discover_expander(child);
 	if (res) {
+		spin_lock_irq(&parent->port->dev_list_lock);
+		list_del(&child->dev_list_node);
+		spin_unlock_irq(&parent->port->dev_list_lock);
 		kfree(child);
 		return NULL;
 	}


