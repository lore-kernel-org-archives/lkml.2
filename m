Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab1DYXqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 19:46:52 -0400
Received: from mail.perches.com ([173.55.12.10]:4964 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757270Ab1DYXqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 19:46:51 -0400
Subject: [PATCH] n_gsm: Use print_hex_dump_bytes
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20110425082230.6d656ed0.randy.dunlap@oracle.com>
References: <65136ab68431de0cc0c554663cee33fc9d4a9850.1303615717.git.joe@perches.com>
	 <20110425082230.6d656ed0.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Apr 2011 16:46:49 -0700
Message-ID: <1303775210.23494.6.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the standard mechanism to print a hex buffer
to eliminate empty printf warning.

A couple % smaller text and data too.

$ size drivers/tty/n_gsm.o*
   text	   data	    bss	    dec	    hex	filename
  23543	    312	   6376	  30231	   7617	drivers/tty/n_gsm.o.new
  24051	    408	   6496	  30955	   78eb	drivers/tty/n_gsm.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/tty/n_gsm.c |   35 ++++++++++-------------------------
 1 files changed, 10 insertions(+), 25 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 74273e6..b0fcffc 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -526,19 +526,6 @@ static int gsm_stuff_frame(const u8 *input, u8 *output, int len)
 	return olen;
 }
 
-static void hex_packet(const unsigned char *p, int len)
-{
-	int i;
-	for (i = 0; i < len; i++) {
-		if (i && (i % 16) == 0) {
-			pr_cont("\n");
-			pr_debug("");
-		}
-		pr_cont("%02X ", *p++);
-	}
-	pr_cont("\n");
-}
-
 /**
  *	gsm_send	-	send a control frame
  *	@gsm: our GSM mux
@@ -685,10 +672,10 @@ static void gsm_data_kick(struct gsm_mux *gsm)
 			len = msg->len + 2;
 		}
 
-		if (debug & 4) {
-			pr_debug("gsm_data_kick:\n");
-			hex_packet(gsm->txframe, len);
-		}
+		if (debug & 4)
+			print_hex_dump_bytes("gsm_data_kick: ",
+					     DUMP_PREFIX_OFFSET,
+					     gsm->txframe, len);
 
 		if (gsm->output(gsm, gsm->txframe + skip_sof,
 						len - skip_sof) < 0)
@@ -2095,10 +2082,9 @@ static int gsmld_output(struct gsm_mux *gsm, u8 *data, int len)
 		set_bit(TTY_DO_WRITE_WAKEUP, &gsm->tty->flags);
 		return -ENOSPC;
 	}
-	if (debug & 4) {
-		pr_debug("-->%d bytes out\n", len);
-		hex_packet(data, len);
-	}
+	if (debug & 4)
+		print_hex_dump_bytes("gsmld_output: ", DUMP_PREFIX_OFFSET,
+				     data, len);
 	gsm->tty->ops->write(gsm->tty, data, len);
 	return len;
 }
@@ -2152,10 +2138,9 @@ static void gsmld_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	char buf[64];
 	char flags;
 
-	if (debug & 4) {
-		pr_debug("Inbytes %dd\n", count);
-		hex_packet(cp, count);
-	}
+	if (debug & 4)
+		print_hex_dump_bytes("gsmld_receive: ", DUMP_PREFIX_OFFSET,
+				     cp, count);
 
 	for (i = count, dp = cp, f = fp; i; i--, dp++) {
 		flags = *f++;
-- 
1.7.5.rc3.dirty



