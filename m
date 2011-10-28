Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933872Ab1J1X7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 19:59:00 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:42338 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642Ab1J1X66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 19:58:58 -0400
From: Julia Lawall <julia@diku.dk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: kernel-janitors@vger.kernel.org,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] drivers/staging/rtl8712/rtl871x_mlme.c: eliminate a null pointer dereference
Date: Sat, 29 Oct 2011 01:58:13 +0200
Message-Id: <1319846297-2985-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If ibss_wlan is NULL, it is not correct to memcpy into its field.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
expression E, E1;
identifier f;
statement S1,S2,S3;
@@

if (E == NULL)
{
  ... when != if (E == NULL || ...) S1 else S2
      when != E = E1
*E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
I have no idea whether this is the correct fix.

 drivers/staging/rtl8712/rtl871x_mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
index ef8eb6c..4277d03 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.c
+++ b/drivers/staging/rtl8712/rtl871x_mlme.c
@@ -551,7 +551,7 @@ void r8712_survey_event_callback(struct _adapter *adapter, u8 *pbuf)
 			ibss_wlan = r8712_find_network(
 						&pmlmepriv->scanned_queue,
 						pnetwork->MacAddress);
-			if (!ibss_wlan) {
+			if (ibss_wlan) {
 				memcpy(ibss_wlan->network.IEs,
 					pnetwork->IEs, 8);
 				goto exit;

