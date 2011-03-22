Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969Ab1CVEE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 00:04:26 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:45169 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750757Ab1CVEEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 00:04:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:From:To:Subject:Date:Message-Id:X-Mailer:X-Identified-User;
	b=Tfjgb0cX7rnaCXxkn/QFCYGeeWdbn96xX1bZx8vF+Wwx8LpVtxeZfs3WabbPVzSy9CaqW5nxpJSTYMUmd40u2qXvtQhHxFJKYVdrKDV2rBeMiEGoniL+g90xRnpqxFpH;
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] sd: Free the page in case of unknown provisioning_mode in scsi_setup_discard_cmnd.
Date: Tue, 22 Mar 2011 12:04:08 +0800
Message-Id: <1300766648-18095-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.251.86.0 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

This patch is inspired by a build waring.
drivers/scsi/sd.c:544: warning: ‘ret’ may be used uninitialized in this function

So we need to set a default value to ret here.
But a deep look at scsi_setup_discard_cmnd makes me think
of which value should be set. Now we have BLKPREP_KILL and
BLKPREP_DEFER to indicate an error. As in case of an
unknown sdkp->provisioning_mode, we goto out directly. So
I guess we should return BLKPREP_KILL here and free the page.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 drivers/scsi/sd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3be5db5..91564bd 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -541,7 +541,7 @@ static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 	sector_t sector = bio->bi_sector;
 	unsigned int nr_sectors = bio_sectors(bio);
 	unsigned int len;
-	int ret;
+	int ret = BLKPREP_KILL;
 	char *buf;
 	struct page *page;
 
-- 
1.6.3.GIT

