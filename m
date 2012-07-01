Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab2GAGxY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 02:53:24 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:54462 "HELO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751500Ab2GAGxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 02:53:22 -0400
Message-ID: <4FEFF3DF.9000909@liveu.tv>
Date: Sun, 01 Jul 2012 09:53:19 +0300
From: Shachar Shemesh <shachar@liveu.tv>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Subject: [PATCH] tty ldisc: Close/Reopen race prevention should check
 the proper flag
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shachar Shemesh <shachar@liveu.tv>

Commit acfa747b introduced the TTY_HUPPING flag to distinguish closed 
TTY from currently closing ones. The test in tty_set_ldisc still 
remained pointing at the old flag. This causes pppd to sometimes lapse 
into uninterruptible sleep when killed and restarted.

Signed-off-by: Shachar Shemesh <shachar@liveu.tv>
---
Tested with 3.2.20 kernel.

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 24b95db..a662a24 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -658,7 +658,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
          goto enable;
      }

-    if (test_bit(TTY_HUPPED, &tty->flags)) {
+    if (test_bit(TTY_HUPPING, &tty->flags)) {
          /* We were raced by the hangup method. It will have stomped
             the ldisc data and closed the ldisc down */
          clear_bit(TTY_LDISC_CHANGING, &tty->flags);


