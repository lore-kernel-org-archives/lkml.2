Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934048Ab1KJDW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:22:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41825 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934021Ab1KJDWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:22:22 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:05 2011
Message-Id: <20111109212705.650138879@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Williams <dcbw@redhat.com>
Subject: [053/262] USB: option: convert interface blacklisting to bitfields
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit b4626c10928c13ee73b013dcbc23676333e79b59 upstream.

It's cleaner than the array stuff, and we're about to add a bunch
more blacklist entries.  Second, there are devices that need both
the sendsetup and the reserved interface blacklists, which the
current code can't accommodate.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |   53 +++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -475,31 +475,24 @@ enum option_blacklist_reason {
 		OPTION_BLACKLIST_RESERVED_IF = 2
 };
 
+#define MAX_BL_NUM  8
 struct option_blacklist_info {
-	const u32 infolen;	/* number of interface numbers on blacklist */
-	const u8  *ifaceinfo;	/* pointer to the array holding the numbers */
-	enum option_blacklist_reason reason;
+	/* bitfield of interface numbers for OPTION_BLACKLIST_SENDSETUP */
+	const unsigned long sendsetup;
+	/* bitfield of interface numbers for OPTION_BLACKLIST_RESERVED_IF */
+	const unsigned long reserved;
 };
 
-static const u8 four_g_w14_no_sendsetup[] = { 0, 1 };
 static const struct option_blacklist_info four_g_w14_blacklist = {
-	.infolen = ARRAY_SIZE(four_g_w14_no_sendsetup),
-	.ifaceinfo = four_g_w14_no_sendsetup,
-	.reason = OPTION_BLACKLIST_SENDSETUP
+	.sendsetup = BIT(0) | BIT(1),
 };
 
-static const u8 alcatel_x200_no_sendsetup[] = { 0, 1 };
 static const struct option_blacklist_info alcatel_x200_blacklist = {
-	.infolen = ARRAY_SIZE(alcatel_x200_no_sendsetup),
-	.ifaceinfo = alcatel_x200_no_sendsetup,
-	.reason = OPTION_BLACKLIST_SENDSETUP
+	.sendsetup = BIT(0) | BIT(1),
 };
 
-static const u8 zte_k3765_z_no_sendsetup[] = { 0, 1, 2 };
 static const struct option_blacklist_info zte_k3765_z_blacklist = {
-	.infolen = ARRAY_SIZE(zte_k3765_z_no_sendsetup),
-	.ifaceinfo = zte_k3765_z_no_sendsetup,
-	.reason = OPTION_BLACKLIST_SENDSETUP
+	.sendsetup = BIT(0) | BIT(1) | BIT(2),
 };
 
 static const struct usb_device_id option_ids[] = {
@@ -1255,21 +1248,28 @@ static int option_probe(struct usb_seria
 	return 0;
 }
 
-static enum option_blacklist_reason is_blacklisted(const u8 ifnum,
-				const struct option_blacklist_info *blacklist)
+static bool is_blacklisted(const u8 ifnum, enum option_blacklist_reason reason,
+			   const struct option_blacklist_info *blacklist)
 {
-	const u8  *info;
-	int i;
+	unsigned long num;
+	const unsigned long *intf_list;
 
 	if (blacklist) {
-		info = blacklist->ifaceinfo;
+		if (reason == OPTION_BLACKLIST_SENDSETUP)
+			intf_list = &blacklist->sendsetup;
+		else if (reason == OPTION_BLACKLIST_RESERVED_IF)
+			intf_list = &blacklist->reserved;
+		else {
+			BUG_ON(reason);
+			return false;
+		}
 
-		for (i = 0; i < blacklist->infolen; i++) {
-			if (info[i] == ifnum)
-				return blacklist->reason;
+		for_each_set_bit(num, intf_list, MAX_BL_NUM + 1) {
+			if (num == ifnum)
+				return true;
 		}
 	}
-	return OPTION_BLACKLIST_NONE;
+	return false;
 }
 
 static void option_instat_callback(struct urb *urb)
@@ -1343,9 +1343,8 @@ static int option_send_setup(struct usb_
 	int val = 0;
 	dbg("%s", __func__);
 
-	if (is_blacklisted(ifNum,
-			   (struct option_blacklist_info *) intfdata->private)
-	    == OPTION_BLACKLIST_SENDSETUP) {
+	if (is_blacklisted(ifNum, OPTION_BLACKLIST_SENDSETUP,
+			(struct option_blacklist_info *) intfdata->private)) {
 		dbg("No send_setup on blacklisted interface #%d\n", ifNum);
 		return -EIO;
 	}


