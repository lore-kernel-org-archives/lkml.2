Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab1HFAL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:11:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39543 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932275Ab1HFALX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:11:23 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:04:14 2011
Message-Id: <20110806000414.211957036@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:03:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Douglas Gilbert <dgilbert@interlog.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [26/50] [SCSI] ses: requesting a fault indication
In-Reply-To: <20110806000419.GA28392@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Douglas Gilbert <dgilbert@interlog.com>

commit 2a350cab9daf9a46322d83b091bb05cf54ccf6ab upstream.

Noticed that when the sysfs interface of the SCSI SES
driver was used to request a fault indication the LED
flashed but the buzzer didn't sound. So it was doing
what REQUEST IDENT (locate) should do.

Changelog:
   - fix the setting of REQUEST FAULT for the device slot
     and array device slot elements in the enclosure control
     diagnostic page
   - note the potentially defective code that reads the
     FAULT SENSED and FAULT REQUESTED bits from the enclosure
     status diagnostic page

The attached patch is against git/scsi-misc-2.6

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/ses.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -157,6 +157,10 @@ static unsigned char *ses_get_page2_desc
 	return NULL;
 }
 
+/* For device slot and array device slot elements, byte 3 bit 6
+ * is "fault sensed" while byte 3 bit 5 is "fault reqstd". As this
+ * code stands these bits are shifted 4 positions right so in
+ * sysfs they will appear as bits 2 and 1 respectively. Strange. */
 static void ses_get_fault(struct enclosure_device *edev,
 			  struct enclosure_component *ecomp)
 {
@@ -178,7 +182,7 @@ static int ses_set_fault(struct enclosur
 		/* zero is disabled */
 		break;
 	case ENCLOSURE_SETTING_ENABLED:
-		desc[2] = 0x02;
+		desc[3] = 0x20;
 		break;
 	default:
 		/* SES doesn't do the SGPIO blink settings */


