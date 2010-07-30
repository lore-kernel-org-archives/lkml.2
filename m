Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010Ab0G3R7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:59:23 -0400
Received: from kroah.org ([198.145.64.141]:59105 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932718Ab0G3R5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:21 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:48 2010
Message-Id: <20100730175148.756459823@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:53:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tilman Schmidt <tilman@imap.cc>,
        "David S. Miller" <davem@davemloft.net>
Subject: [163/205] isdn/gigaset: encode HLC and BC together
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

commit 1ce368ff288ed872a8fee93b8a2b7706111feb9a upstream.

Adapt to buggy device firmware which accepts setting HLC only in the
same command line as BC, by encoding HLC and BC in a single command
if both are specified, and rejecting HLC without BC.

Impact: bugfix
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/gigaset/capi.c     |   81 ++++++++++++++++++++++++----------------
 drivers/isdn/gigaset/ev-layer.c |    4 -
 drivers/isdn/gigaset/gigaset.h  |    5 --
 3 files changed, 52 insertions(+), 38 deletions(-)

--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -1177,7 +1177,7 @@ static void do_connect_req(struct gigase
 	char **commands;
 	char *s;
 	u8 *pp;
-	int i, l;
+	int i, l, lbc, lhlc;
 	u16 info;
 
 	/* decode message */
@@ -1304,42 +1304,59 @@ static void do_connect_req(struct gigase
 		goto error;
 	}
 
-	/* check/encode parameter: BC */
-	if (cmsg->BC && cmsg->BC[0]) {
-		/* explicit BC overrides CIP */
-		l = 2*cmsg->BC[0] + 7;
+	/*
+	 * check/encode parameters: BC & HLC
+	 * must be encoded together as device doesn't accept HLC separately
+	 * explicit parameters override values derived from CIP
+	 */
+
+	/* determine lengths */
+	if (cmsg->BC && cmsg->BC[0])		/* BC specified explicitly */
+		lbc = 2*cmsg->BC[0];
+	else if (cip2bchlc[cmsg->CIPValue].bc)	/* BC derived from CIP */
+		lbc = strlen(cip2bchlc[cmsg->CIPValue].bc);
+	else					/* no BC */
+		lbc = 0;
+	if (cmsg->HLC && cmsg->HLC[0])		/* HLC specified explicitly */
+		lhlc = 2*cmsg->HLC[0];
+	else if (cip2bchlc[cmsg->CIPValue].hlc)	/* HLC derived from CIP */
+		lhlc = strlen(cip2bchlc[cmsg->CIPValue].hlc);
+	else					/* no HLC */
+		lhlc = 0;
+
+	if (lbc) {
+		/* have BC: allocate and assemble command string */
+		l = lbc + 7;		/* "^SBC=" + value + "\r" + null byte */
+		if (lhlc)
+			l += lhlc + 7;	/* ";^SHLC=" + value */
 		commands[AT_BC] = kmalloc(l, GFP_KERNEL);
 		if (!commands[AT_BC])
 			goto oom;
 		strcpy(commands[AT_BC], "^SBC=");
-		decode_ie(cmsg->BC, commands[AT_BC]+5);
+		if (cmsg->BC && cmsg->BC[0])	/* BC specified explicitly */
+			decode_ie(cmsg->BC, commands[AT_BC] + 5);
+		else				/* BC derived from CIP */
+			strcpy(commands[AT_BC] + 5,
+			       cip2bchlc[cmsg->CIPValue].bc);
+		if (lhlc) {
+			strcpy(commands[AT_BC] + lbc + 5, ";^SHLC=");
+			if (cmsg->HLC && cmsg->HLC[0])
+				/* HLC specified explicitly */
+				decode_ie(cmsg->HLC,
+					  commands[AT_BC] + lbc + 12);
+			else	/* HLC derived from CIP */
+				strcpy(commands[AT_BC] + lbc + 12,
+				       cip2bchlc[cmsg->CIPValue].hlc);
+		}
 		strcpy(commands[AT_BC] + l - 2, "\r");
-	} else if (cip2bchlc[cmsg->CIPValue].bc) {
-		l = strlen(cip2bchlc[cmsg->CIPValue].bc) + 7;
-		commands[AT_BC] = kmalloc(l, GFP_KERNEL);
-		if (!commands[AT_BC])
-			goto oom;
-		snprintf(commands[AT_BC], l, "^SBC=%s\r",
-			 cip2bchlc[cmsg->CIPValue].bc);
-	}
-
-	/* check/encode parameter: HLC */
-	if (cmsg->HLC && cmsg->HLC[0]) {
-		/* explicit HLC overrides CIP */
-		l = 2*cmsg->HLC[0] + 7;
-		commands[AT_HLC] = kmalloc(l, GFP_KERNEL);
-		if (!commands[AT_HLC])
-			goto oom;
-		strcpy(commands[AT_HLC], "^SHLC=");
-		decode_ie(cmsg->HLC, commands[AT_HLC]+5);
-		strcpy(commands[AT_HLC] + l - 2, "\r");
-	} else if (cip2bchlc[cmsg->CIPValue].hlc) {
-		l = strlen(cip2bchlc[cmsg->CIPValue].hlc) + 7;
-		commands[AT_HLC] = kmalloc(l, GFP_KERNEL);
-		if (!commands[AT_HLC])
-			goto oom;
-		snprintf(commands[AT_HLC], l, "^SHLC=%s\r",
-			 cip2bchlc[cmsg->CIPValue].hlc);
+	} else {
+		/* no BC */
+		if (lhlc) {
+			dev_notice(cs->dev, "%s: cannot set HLC without BC\n",
+				   "CONNECT_REQ");
+			info = CapiIllMessageParmCoding; /* ? */
+			goto error;
+		}
 	}
 
 	/* check/encode parameter: B Protocol */
--- a/drivers/isdn/gigaset/ev-layer.c
+++ b/drivers/isdn/gigaset/ev-layer.c
@@ -282,9 +282,7 @@ struct reply_t gigaset_tab_cid[] =
 /* dial */
 {EV_DIAL,	 -1,  -1, -1,			 -1, -1, {ACT_DIAL} },
 {RSP_INIT,	  0,   0, SEQ_DIAL,		601,  5, {ACT_CMD+AT_BC} },
-{RSP_OK,	601, 601, -1,			602,  5, {ACT_CMD+AT_HLC} },
-{RSP_NULL,	602, 602, -1,			603,  5, {ACT_CMD+AT_PROTO} },
-{RSP_OK,	602, 602, -1,			603,  5, {ACT_CMD+AT_PROTO} },
+{RSP_OK,	601, 601, -1,			603,  5, {ACT_CMD+AT_PROTO} },
 {RSP_OK,	603, 603, -1,			604,  5, {ACT_CMD+AT_TYPE} },
 {RSP_OK,	604, 604, -1,			605,  5, {ACT_CMD+AT_MSN} },
 {RSP_NULL,	605, 605, -1,			606,  5, {ACT_CMD+AT_CLIP} },
--- a/drivers/isdn/gigaset/gigaset.h
+++ b/drivers/isdn/gigaset/gigaset.h
@@ -186,10 +186,9 @@ void gigaset_dbg_buffer(enum debuglevel
 #define AT_BC		3
 #define AT_PROTO	4
 #define AT_TYPE		5
-#define AT_HLC		6
-#define AT_CLIP		7
+#define AT_CLIP		6
 /* total number */
-#define AT_NUM		8
+#define AT_NUM		7
 
 /* variables in struct at_state_t */
 #define VAR_ZSAU	0


