Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab2JSCrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:47:10 -0400
Received: from mail.kernel.org ([198.145.19.201]:51140 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab2JSCrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:47:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 16/62] SCSI: storvsc: Account for in-transit packets in the RESET path
Date: Thu, 18 Oct 2012 19:44:44 -0700
Message-Id: <20121019024258.582915687@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024255.944999470@linuxfoundation.org>
References: <20121019024255.944999470@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 5c1b10ab7f93d24f29b5630286e323d1c5802d5c upstream.

Properly account for I/O in transit before returning from the RESET call.
In the absense of this patch, we could have a situation where the host may
respond to a command that was issued prior to the issuance of the RESET
command at some arbitrary time after responding to the RESET command.
Currently, the host does not do anything with the RESET command.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/storvsc_drv.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1211,7 +1211,12 @@ static int storvsc_host_reset_handler(st
 	/*
 	 * At this point, all outstanding requests in the adapter
 	 * should have been flushed out and return to us
+	 * There is a potential race here where the host may be in
+	 * the process of responding when we return from here.
+	 * Just wait for all in-transit packets to be accounted for
+	 * before we return from here.
 	 */
+	storvsc_wait_to_drain(stor_device);
 
 	return SUCCESS;
 }


