Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab0C3BVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 21:21:42 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:56036 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab0C3BVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 21:21:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=S/SDyTtC3ePoD8JHCFoEkSUi3Iu5/vHPexSpT+xPSMHsN7N6GmcvQVtdy96OMxGo+s
         btk+8om8lwystGsHcesaudJveKMNvbErXN+js94hDnCAjQTxskQR8R193jmfvupByk4n
         IrAV2hBhwhcv1ddGzAh7cc/57XKMfgFjSp4BI=
Date: Tue, 30 Mar 2010 17:21:32 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk
Subject: [PATCH] Block: Fix block/elevator.c elevator_get() off-by-one error
Message-ID: <20100330092132.GB2713@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

elevator_get() not check the name length, if the name length > sizeof(elv),
elv will miss the '\0'. And elv buffer will be replace "-iosched" as something
like aaaaaaaaa, then call request_module() can load an not trust module.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 block/elevator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index df75676..76e3702 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -154,7 +154,7 @@ static struct elevator_type *elevator_get(const char *name)
 
 		spin_unlock(&elv_list_lock);
 
-		sprintf(elv, "%s-iosched", name);
+		snprintf(elv, sizeof(elv), "%s-iosched", name);
 
 		request_module("%s", elv);
 		spin_lock(&elv_list_lock);
-- 
1.6.5.3

