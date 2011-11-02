Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543Ab1KCCIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:08:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50696 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933495Ab1KCBgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:36:25 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:54 2011
Message-Id: <20111102221454.052669506@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jouni Malinen <jouni@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [043/107] cfg80211: Fix validation of AKM suites
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jouni Malinen <jouni@qca.qualcomm.com>

commit 1b9ca0272ffae212e726380f66777b30a56ed7a5 upstream.

Incorrect variable was used in validating the akm_suites array from
NL80211_ATTR_AKM_SUITES. In addition, there was no explicit
validation of the array length (we only have room for
NL80211_MAX_NR_AKM_SUITES).

This can result in a buffer write overflow for stack variables with
arbitrary data from user space. The nl80211 commands using the affected
functionality require GENL_ADMIN_PERM, so this is only exposed to admin
users.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/nl80211.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3364,9 +3364,12 @@ static int nl80211_crypto_settings(struc
 		if (len % sizeof(u32))
 			return -EINVAL;
 
+		if (settings->n_akm_suites > NL80211_MAX_NR_AKM_SUITES)
+			return -EINVAL;
+
 		memcpy(settings->akm_suites, data, len);
 
-		for (i = 0; i < settings->n_ciphers_pairwise; i++)
+		for (i = 0; i < settings->n_akm_suites; i++)
 			if (!nl80211_valid_akm_suite(settings->akm_suites[i]))
 				return -EINVAL;
 	}


