Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab0KDKBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 06:01:50 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:50791 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754602Ab0KDKBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 06:01:49 -0400
Message-ID: <4CD2847B.1060009@stericsson.com>
Date: Thu, 4 Nov 2010 11:01:31 +0100
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        elinwal <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Subject: [PATCH] regulator: lock supply in regulator enable
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add locks around regulator supply enable.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
---
The previous patch I sent solves a problem seen in our system.
This patch does not solve a problem I have seen but I still think
it should be there. Or at least some locking of the supply in regulator enable.
What do you guys think?
---
 drivers/regulator/core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c625633..d10ad4a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1270,7 +1270,9 @@ static int _regulator_enable(struct regulator_dev *rdev)
 
 	/* do we need to enable the supply regulator first */
 	if (rdev->supply) {
+		mutex_lock(&rdev->supply->mutex);
 		ret = _regulator_enable(rdev->supply);
+		mutex_unlock(&rdev->supply->mutex);
 		if (ret < 0) {
 			printk(KERN_ERR "%s: failed to enable %s: %d\n",
 			       __func__, rdev_get_name(rdev), ret);
-- 
1.6.3.3

