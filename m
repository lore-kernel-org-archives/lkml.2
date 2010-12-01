Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab0LAOka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 09:40:30 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59671 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab0LAOk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 09:40:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=VDH8E+BxYnh0WVzZMKNx84t0cJ/Bj/IFKzCozW0aouX8jS1Yb5Vsm1F1jUqHz5lGZg
         65d7ztvnjWz+tX0jB5wSZMBZu8NXo42JRo8GAdTfFy9PhpTbWJw9wr3ahs57Oox49I02
         GjUgVn9CkBbKeW6k13TYhVQWSQJqCiAJxbd9Q=
MIME-Version: 1.0
Date: Wed, 1 Dec 2010 22:40:27 +0800
Message-ID: <AANLkTin_94J_eu5raDsPXTUJy7EbkUWuG_d8_xEn3Gzh@mail.gmail.com>
Subject: [PATCH] add regulation of BLK_EH_RESET_TIMER for block request
From: Hillf Danton <dhillf@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devel@open-fcoe.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When timer run, if BLK_EH_RESET_TIMER returned by LLD, the retries of
block request, though defined, is not checked in both scsi middle
later and block layer.

Regulation of BLK_EH_RESET_TIMER could help LLD fiddle timer in
reasonable manner.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/scsi_error.c	2010-11-01 19:54:12.000000000 +0800
+++ b/drivers/scsi/scsi_error.c	2010-12-01 22:26:36.000000000 +0800
@@ -138,8 +138,15 @@ enum blk_eh_timer_return scsi_times_out(
 	else if (scmd->device->host->hostt->eh_timed_out)
 		rtn = scmd->device->host->hostt->eh_timed_out(scmd);

+	if (rtn == BLK_EH_RESET_TIMER)
+		if (req->retries-- > 0)
+			return rtn;
+		else
+			goto handled;
+
 	if (unlikely(rtn == BLK_EH_NOT_HANDLED &&
 		     !scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))) {
+ handled:
 		scmd->result |= DID_TIME_OUT << 16;
 		rtn = BLK_EH_HANDLED;
 	}
