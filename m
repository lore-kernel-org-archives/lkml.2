Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127Ab2HOU2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:28:25 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62852 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512Ab2HOTuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:04 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Michael Chan <mchan@broadcom.com>, "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 052/165] cnic: Improve NETDEV_UP event handling
Date: Wed, 15 Aug 2012 15:46:36 -0400
Message-ID: <1345060109-9187-53-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Chan <mchan@broadcom.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit db1d350fcb156b58f66a67680617077bcacfe6fc upstream.

During NETDEV_UP, we use symbol_get() to get the net driver's cnic
probe function.  This sometimes doesn't work if NETDEV_UP happens
right after NETDEV_REGISTER and the net driver is still running module
init code.  As a result, the cnic device may not be discovered.  We
fix this by probing on all NETDEV events if the device's netif_running
state is up.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/cnic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/cnic.c b/drivers/net/cnic.c
index 4b451a7..49242ac 100644
--- a/drivers/net/cnic.c
+++ b/drivers/net/cnic.c
@@ -4528,7 +4528,7 @@ static int cnic_netdev_event(struct notifier_block *this, unsigned long event,
 
 	dev = cnic_from_netdev(netdev);
 
-	if (!dev && (event == NETDEV_REGISTER || event == NETDEV_UP)) {
+	if (!dev && (event == NETDEV_REGISTER || netif_running(netdev))) {
 		/* Check for the hot-plug device */
 		dev = is_cnic_dev(netdev);
 		if (dev) {
@@ -4544,7 +4544,7 @@ static int cnic_netdev_event(struct notifier_block *this, unsigned long event,
 		else if (event == NETDEV_UNREGISTER)
 			cnic_ulp_exit(dev);
 
-		if (event == NETDEV_UP) {
+		if (event == NETDEV_UP || (new_dev && netif_running(netdev))) {
 			if (cnic_register_netdev(dev) != 0) {
 				cnic_put(dev);
 				goto done;
-- 
1.7.12.rc2

