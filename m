Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936806Ab2C3XFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:05:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37370 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934796Ab2C3VFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:02 -0400
Message-Id: <20120330195726.709219683@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:57:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jingjun Wu <jingjun_wu@realsil.com.cn>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 032/108] rtlwifi: rtl8192ce: Fix loss of receive performance
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jingjun Wu <jingjun_wu@realsil.com.cn>

commit a9b89e2567c743483e6354f64d7a7e3a8c101e9e upstream.

Driver rtl8192ce when used with the RTL8188CE device would start at about
20 Mbps on a 54 Mbps connection, but quickly drop to 1 Mbps. One of the
symptoms is that the AP would need to retransmit each packet 4 of 5 times
before the driver would acknowledge it. Recovery is possible only by
unloading and reloading the driver. This problem was reported at
https://bugzilla.redhat.com/show_bug.cgi?id=770207.

The problem is due to a missing update of the gain setting.

Signed-off-by: Jingjun Wu <jingjun_wu@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -523,6 +523,10 @@ void rtl92c_dm_write_dig(struct ieee8021
 		  dm_digtable.cur_igvalue, dm_digtable.pre_igvalue,
 		  dm_digtable.backoff_val));
 
+	dm_digtable.cur_igvalue += 2;
+	if (dm_digtable.cur_igvalue > 0x3f)
+		dm_digtable.cur_igvalue = 0x3f;
+
 	if (dm_digtable.pre_igvalue != dm_digtable.cur_igvalue) {
 		rtl_set_bbreg(hw, ROFDM0_XAAGCCORE1, 0x7f,
 			      dm_digtable.cur_igvalue);


