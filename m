Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab1HLV7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 17:59:13 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:22263 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab1HLV7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 17:59:09 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-127.messagelabs.com!1313186347!24419963!2
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.99]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] base/devres.c: quiet sparse noise about context imbalance
Date: Fri, 12 Aug 2011 14:58:31 -0700
User-Agent: KMail/1.9.9
CC: <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201108121458.32558.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devres_release_all and devres_release_group both aquire the lock
&dev->devres_lock but the release of that lock is done in release_nodes.
This results in sparse noise about context imbalance.

Add a lock annotation to release_nodes to quiet this noise.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

---

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index cf7a0c7..65cd748 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -397,6 +397,7 @@ static int remove_nodes(struct device *dev,
 
 static int release_nodes(struct device *dev, struct list_head *first,
 			 struct list_head *end, unsigned long flags)
+	__releases(&dev->devres_lock)
 {
 	LIST_HEAD(todo);
 	int cnt;
