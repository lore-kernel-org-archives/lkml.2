Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab0IOJrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 05:47:39 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56275 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab0IOJrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 05:47:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Gvr/3rZVuL9J4puysHmp+WfD+qESv4oA91C6p05b20Cd/ZCSfS8WmljqFQ9bEqxsZF
         VZ9VIzpV1LeOS8Ch/cWQLgqp7BgZwpyes5hqId2iE0xgs7243FbhpsC/6jJRlH03iL89
         in/coPeTqHzzNioU/qkxqW1PRwrvLLFDjZXi4=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Nohee Ko <noheek@broadcom.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 1/2] staging: brcm80211: use native ctype library
Date: Wed, 15 Sep 2010 12:47:17 +0300
Message-Id: <1284544038-5696-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/brcm80211/include/bcmutils.h |   27 ------------
 drivers/staging/brcm80211/sys/wlc_mac80211.c |    4 +-
 drivers/staging/brcm80211/util/bcmutils.c    |   56 +++-----------------------
 drivers/staging/brcm80211/util/bcmwifi.c     |    3 +-
 4 files changed, 11 insertions(+), 79 deletions(-)

diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index 321071b..f17dbb1 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -21,33 +21,6 @@
 extern "C" {
 #endif
 
-/* ctype replacement */
-#define _BCM_U	0x01		/* upper */
-#define _BCM_L	0x02		/* lower */
-#define _BCM_D	0x04		/* digit */
-#define _BCM_C	0x08		/* cntrl */
-#define _BCM_P	0x10		/* punct */
-#define _BCM_S	0x20		/* white space (space/lf/tab) */
-#define _BCM_X	0x40		/* hex digit */
-#define _BCM_SP	0x80		/* hard space (0x20) */
-
-	extern const unsigned char bcm_ctype[];
-#define bcm_ismask(x)	(bcm_ctype[(int)(unsigned char)(x)])
-
-#define bcm_isalnum(c)	((bcm_ismask(c)&(_BCM_U|_BCM_L|_BCM_D)) != 0)
-#define bcm_isalpha(c)	((bcm_ismask(c)&(_BCM_U|_BCM_L)) != 0)
-#define bcm_iscntrl(c)	((bcm_ismask(c)&(_BCM_C)) != 0)
-#define bcm_isdigit(c)	((bcm_ismask(c)&(_BCM_D)) != 0)
-#define bcm_isgraph(c)	((bcm_ismask(c)&(_BCM_P|_BCM_U|_BCM_L|_BCM_D)) != 0)
-#define bcm_islower(c)	((bcm_ismask(c)&(_BCM_L)) != 0)
-#define bcm_isprint(c)	((bcm_ismask(c)&(_BCM_P|_BCM_U|_BCM_L|_BCM_D|_BCM_SP)) != 0)
-#define bcm_ispunct(c)	((bcm_ismask(c)&(_BCM_P)) != 0)
-#define bcm_isspace(c)	((bcm_ismask(c)&(_BCM_S)) != 0)
-#define bcm_isupper(c)	((bcm_ismask(c)&(_BCM_U)) != 0)
-#define bcm_isxdigit(c)	((bcm_ismask(c)&(_BCM_D|_BCM_X)) != 0)
-#define bcm_tolower(c)	(bcm_isupper((c)) ? ((c) + 'a' - 'A') : (c))
-#define bcm_toupper(c)	(bcm_islower((c)) ? ((c) + 'A' - 'a') : (c))
-
 /* Buffer structure for collecting string-formatted data
 * using bcm_bprintf() API.
 * Use bcm_binit() to initialize before use
diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
index 27ddc23..db9a7c2 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -75,6 +75,8 @@
 #define W_REG(osh, r, v) RPC_WRITE_REG(osh, r, v)
 #endif
 
+#include <linux/ctype.h>
+
 /*
  * buffer length needed for wlc_format_ssid
  * 32 SSID chars, max of 4 chars for each SSID char "\xFF", plus NULL.
@@ -5486,7 +5488,7 @@ int wlc_format_ssid(char *buf, const uchar ssid[], uint ssid_len)
 		if (c == '\\') {
 			*p++ = '\\';
 			*p++ = '\\';
-		} else if (bcm_isprint((uchar) c)) {
+		} else if (isprint((uchar) c)) {
 			*p++ = (char)c;
 		} else {
 			p += snprintf(p, (endp - p), "\\x%02X", c);
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index 9505064..3f521e9 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -27,6 +27,8 @@
 #include <proto/802.1d.h>
 #include <proto/802.11.h>
 
+#include <linux/ctype.h>
+
 #ifdef WLC_LOW
 /* nvram vars cache */
 static char *nvram_vars;
@@ -490,52 +492,6 @@ void *BCMFASTPATH pktq_mdeq(struct pktq *pq, uint prec_bmp, int *prec_out)
 	return p;
 }
 
-const unsigned char bcm_ctype[] = {
-
-	_BCM_C, _BCM_C, _BCM_C, _BCM_C, _BCM_C, _BCM_C, _BCM_C, _BCM_C,	/* 0-7 */
-	_BCM_C, _BCM_C | _BCM_S, _BCM_C | _BCM_S, _BCM_C | _BCM_S,
-	    _BCM_C | _BCM_S, _BCM_C | _BCM_S, _BCM_C,
-	_BCM_C,			/* 8-15 */
-	_BCM_C, _BCM_C, _BCM_C, _BCM_C, _BCM_C, _BCM_C, _BCM_C, _BCM_C,	/* 16-23 */
-	_BCM_C, _BCM_C, _BCM_C, _BCM_C, _BCM_C, _BCM_C, _BCM_C, _BCM_C,	/* 24-31 */
-	_BCM_S | _BCM_SP, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P,	/* 32-39 */
-	_BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P,	/* 40-47 */
-	_BCM_D, _BCM_D, _BCM_D, _BCM_D, _BCM_D, _BCM_D, _BCM_D, _BCM_D,	/* 48-55 */
-	_BCM_D, _BCM_D, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P,	/* 56-63 */
-	_BCM_P, _BCM_U | _BCM_X, _BCM_U | _BCM_X, _BCM_U | _BCM_X,
-	    _BCM_U | _BCM_X, _BCM_U | _BCM_X,
-	_BCM_U | _BCM_X, _BCM_U,	/* 64-71 */
-	_BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U,	/* 72-79 */
-	_BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U,	/* 80-87 */
-	_BCM_U, _BCM_U, _BCM_U, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P,	/* 88-95 */
-	_BCM_P, _BCM_L | _BCM_X, _BCM_L | _BCM_X, _BCM_L | _BCM_X,
-	    _BCM_L | _BCM_X, _BCM_L | _BCM_X,
-	_BCM_L | _BCM_X, _BCM_L,	/* 96-103 */
-	_BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L,	/* 104-111 */
-	_BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L,	/* 112-119 */
-	_BCM_L, _BCM_L, _BCM_L, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_C,	/* 120-127 */
-	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	/* 128-143 */
-	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	/* 144-159 */
-	_BCM_S | _BCM_SP, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P,
-	    _BCM_P, _BCM_P, _BCM_P,
-	_BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P,	/* 160-175 */
-	_BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P,
-	    _BCM_P, _BCM_P,
-	_BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P,	/* 176-191 */
-	_BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U,
-	    _BCM_U, _BCM_U,
-	_BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U,	/* 192-207 */
-	_BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_P, _BCM_U,
-	    _BCM_U, _BCM_U,
-	_BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_L,	/* 208-223 */
-	_BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L,
-	    _BCM_L, _BCM_L,
-	_BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L,	/* 224-239 */
-	_BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_P, _BCM_L,
-	    _BCM_L, _BCM_L,
-	_BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L	/* 240-255 */
-};
-
 ulong BCMROMFN(bcm_strtoul) (char *cp, char **endp, uint base)
 {
 	ulong result, last_result = 0, value;
@@ -543,7 +499,7 @@ ulong BCMROMFN(bcm_strtoul) (char *cp, char **endp, uint base)
 
 	minus = FALSE;
 
-	while (bcm_isspace(*cp))
+	while (isspace(*cp))
 		cp++;
 
 	if (cp[0] == '+')
@@ -571,9 +527,9 @@ ulong BCMROMFN(bcm_strtoul) (char *cp, char **endp, uint base)
 
 	result = 0;
 
-	while (bcm_isxdigit(*cp) &&
+	while (isxdigit(*cp) &&
 	       (value =
-		bcm_isdigit(*cp) ? *cp - '0' : bcm_toupper(*cp) - 'A' + 10) <
+		isdigit(*cp) ? *cp - '0' : toupper(*cp) - 'A' + 10) <
 	       base) {
 		result = result * base + value;
 		/* Detected overflow */
@@ -1775,7 +1731,7 @@ int bcm_format_ssid(char *buf, const uchar ssid[], uint ssid_len)
 		if (c == '\\') {
 			*p++ = '\\';
 			*p++ = '\\';
-		} else if (bcm_isprint((uchar) c)) {
+		} else if (isprint((uchar) c)) {
 			*p++ = (char)c;
 		} else {
 			p += snprintf(p, (endp - p), "\\x%02X", c);
diff --git a/drivers/staging/brcm80211/util/bcmwifi.c b/drivers/staging/brcm80211/util/bcmwifi.c
index 5eced8e..cb41d10 100644
--- a/drivers/staging/brcm80211/util/bcmwifi.c
+++ b/drivers/staging/brcm80211/util/bcmwifi.c
@@ -19,9 +19,10 @@
 #include <osl.h>
 #include <bcmutils.h>
 #define strtoul(nptr, endptr, base) bcm_strtoul((nptr), (endptr), (base))
-#define tolower(c) (bcm_isupper((c)) ? ((c) + 'a' - 'A') : (c))
 #include <bcmwifi.h>
 
+#include <linux/ctype.h>
+
 /* Chanspec ASCII representation:
  * <channel><band><bandwidth><ctl-sideband>
  *   digit   [AB]     [N]        [UL]
-- 
1.7.2.2

