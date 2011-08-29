Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab1H2RrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:47:09 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:53620 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962Ab1H2RrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:47:06 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Mike Thomas <rmthomas@sciolus.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] staging/easycap: fix mismatch in easycap_poll() mutex lock-unlock
Date: Mon, 29 Aug 2011 21:46:57 +0400
Message-Id: <1314640017-27561-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case if condition (kd != isdongle(peasycap)) becomes true,
easycap_poll() returns without releasing easycapdc60_dongle[kd].mutex_video.
The patch adds mutex_unlock() before that return.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/easycap/easycap_main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/easycap/easycap_main.c b/drivers/staging/easycap/easycap_main.c
index bea2816..3ea51c3 100644
--- a/drivers/staging/easycap/easycap_main.c
+++ b/drivers/staging/easycap/easycap_main.c
@@ -953,8 +953,10 @@ static unsigned int easycap_poll(struct file *file, poll_table *wait)
 	 *  peasycap, IN WHICH CASE A REPEAT CALL TO isdongle() WILL FAIL.
 	 *  IF NECESSARY, BAIL OUT.
 	 */
-		if (kd != isdongle(peasycap))
+		if (kd != isdongle(peasycap)) {
+			mutex_unlock(&easycapdc60_dongle[kd].mutex_video);
 			return -ERESTARTSYS;
+		}
 		if (!file) {
 			SAY("ERROR:  file is NULL\n");
 			mutex_unlock(&easycapdc60_dongle[kd].mutex_video);
-- 
1.7.4.1

