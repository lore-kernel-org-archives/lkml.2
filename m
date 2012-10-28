Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab2J1Xaz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:30:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42226 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757039Ab2J1X2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:31 -0400
Message-Id: <20121028231546.198682183@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:06 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 030/105] [SCSI] storvsc: Account for in-transit packets in the RESET path
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/hv/storvsc_drv.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -1043,7 +1043,12 @@ static int storvsc_host_reset(struct hv_
 	/*
 	 * At this point, all outstanding requests in the adapter
 	 * should have been flushed out and return to us
+	 * There is a potential race here where the host may be in
+	 * the process of responding when we return from here.
+	 * Just wait for all in-transit packets to be accounted for
+	 * before we return from here.
 	 */
+	storvsc_wait_to_drain(stor_device);
 
 cleanup:
 	return ret;


