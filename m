Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517Ab0JVS5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:57:08 -0400
Received: from kroah.org ([198.145.64.141]:34387 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759400Ab0JVS5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:57:00 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:34 2010
Message-Id: <20101022185234.713243789@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [082/103] [SCSI] Fix VPD inquiry page wrapper
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Martin K. Petersen <martin.petersen@oracle.com>

commit 16d3ea26f82271fef9b1c4523b5e1ea31fa39eec upstream.

Fix two bugs in the VPD page wrapper:

    - Don't return failure if the user asked for page 0

    - The end of buffer check failed to account for the page header size
      and consequently didn't work

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1046,13 +1046,13 @@ int scsi_get_vpd_page(struct scsi_device
 
 	/* If the user actually wanted this page, we can skip the rest */
 	if (page == 0)
-		return -EINVAL;
+		return 0;
 
 	for (i = 0; i < min((int)buf[3], buf_len - 4); i++)
 		if (buf[i + 4] == page)
 			goto found;
 
-	if (i < buf[3] && i > buf_len)
+	if (i < buf[3] && i >= buf_len - 4)
 		/* ran off the end of the buffer, give us benefit of doubt */
 		goto found;
 	/* The device claims it doesn't support the requested page */


