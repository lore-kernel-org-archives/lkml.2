Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab2E0A5u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 20:57:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37624 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab2E0A5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 20:57:39 -0400
Message-Id: <20120527002615.202460676@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:22 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stephen Rothwell <sfr@canb.auug.org.au>,
        Youngsin Lee <youngsin@qualcomm.com>,
        Raja Mani <rmani@qca.qualcomm.com>,
        Senthil Kumar Balasubramanian <senthilb@qca.qualcomm.com>,
        Vipin Mehta <vipimeht@qca.qualcomm.com>,
        "Luis R. Rodriguez" <mcgrof@frijolero.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 09/55] cfg80211: warn if db.txt is empty with CONFIG_CFG80211_INTERNAL_REGDB
In-Reply-To: <20120527005203.GA2146@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Luis R. Rodriguez" <mcgrof@frijolero.org>

commit 80007efeff0568375b08faf93c7aad65602cb97e upstream.

It has happened twice now where elaborate troubleshooting has
undergone on systems where CONFIG_CFG80211_INTERNAL_REGDB [0]
has been set but yet net/wireless/db.txt was not updated.

Despite the documentation on this it seems system integrators could
use some more help with this, so throw out a kernel warning at boot time
when their database is empty.

This does mean that the error-prone system integrator won't likely
realize the issue until they boot the machine but -- it does not seem
to make sense to enable a build bug breaking random build testing.

[0] http://wireless.kernel.org/en/developers/Regulatory/CRDA#CONFIG_CFG80211_INTERNAL_REGDB

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Youngsin Lee <youngsin@qualcomm.com>
Cc: Raja Mani <rmani@qca.qualcomm.com>
Cc: Senthil Kumar Balasubramanian <senthilb@qca.qualcomm.com>
Cc: Vipin Mehta <vipimeht@qca.qualcomm.com>
Cc: yahuan@qca.qualcomm.com
Cc: jjan@qca.qualcomm.com
Cc: vthiagar@qca.qualcomm.com
Cc: henrykim@qualcomm.com
Cc: jouni@qca.qualcomm.com
Cc: athiruve@qca.qualcomm.com
Cc: cjkim@qualcomm.com
Cc: philipk@qca.qualcomm.com
Cc: sunnykim@qualcomm.com
Cc: sskwak@qualcomm.com
Cc: kkim@qualcomm.com
Cc: mattbyun@qualcomm.com
Cc: ryanlee@qualcomm.com
Cc: simbap@qualcomm.com
Cc: krislee@qualcomm.com
Cc: conner@qualcomm.com
Cc: hojinkim@qualcomm.com
Cc: honglee@qualcomm.com
Cc: johnwkim@qualcomm.com
Cc: jinyong@qca.qualcomm.com
Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/reg.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -379,7 +379,15 @@ static void reg_regdb_query(const char *
 
 	schedule_work(&reg_regdb_work);
 }
+
+/* Feel free to add any other sanity checks here */
+static void reg_regdb_size_check(void)
+{
+	/* We should ideally BUILD_BUG_ON() but then random builds would fail */
+	WARN_ONCE(!reg_regdb_size, "db.txt is empty, you should update it...");
+}
 #else
+static inline void reg_regdb_size_check(void) {}
 static inline void reg_regdb_query(const char *alpha2) {}
 #endif /* CONFIG_CFG80211_INTERNAL_REGDB */
 
@@ -2225,6 +2233,8 @@ int __init regulatory_init(void)
 	spin_lock_init(&reg_requests_lock);
 	spin_lock_init(&reg_pending_beacons_lock);
 
+	reg_regdb_size_check();
+
 	cfg80211_regdomain = cfg80211_world_regdom;
 
 	user_alpha2[0] = '9';


