Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab0JKJIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 05:08:01 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49151 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab0JKJH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 05:07:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=srGpbizY+AgbFD9HVoXwr+17IHfeT3SwJChdDPdFVDBZvZs8syKBf4H2gPB9VAY5B2
         9q0p+PuxZ8WISZmDn7GX35o0P3afTikc9b0fpSADNSkezYByR1EPSZtr9LgEZEWLW3v1
         2s2QcS624a80JTS3bsdDrlHOP5lhnZxsHu+0w=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Nohee Ko <noheek@broadcom.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCHv2 2/2] staging: brcm80211: remove custom string library again
Date: Mon, 11 Oct 2010 12:07:35 +0300
Message-Id: <29a7e8fb4c59176d0a05eabc7f8a5dcbad4f704c.1286787946.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <9134fce655e27d36628ab508127a6d3f2d8fbfb8.1286787946.git.andy.shevchenko@gmail.com>
References: <9134fce655e27d36628ab508127a6d3f2d8fbfb8.1286787946.git.andy.shevchenko@gmail.com>
In-Reply-To: <9134fce655e27d36628ab508127a6d3f2d8fbfb8.1286787946.git.andy.shevchenko@gmail.com>
References: <9134fce655e27d36628ab508127a6d3f2d8fbfb8.1286787946.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a clean up commit for softmac driver. Do the same for fullmac
implementation.

Here:
 - strtoul and bcm_strtoul are changed to simple_strtoul
 - bcmstrtok -> strsep

All unused functions are deleted.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_common.c  |   24 ++++----
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    4 +-
 drivers/staging/brcm80211/include/bcmutils.h     |    1 -
 drivers/staging/brcm80211/util/bcmutils.c        |   76 ----------------------
 4 files changed, 14 insertions(+), 91 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 54b07f9..481c35d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -15,6 +15,8 @@
  */
 #include <typedefs.h>
 #include <osl.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
 #include <bcmutils.h>
 #include <bcmendian.h>
 #include <dngl_stats.h>
@@ -967,8 +969,6 @@ void print_buf(void *pbuf, int len, int bytes_per_line)
 	printf("\n");
 }
 
-#define strtoul(nptr, endptr, base) simple_strtoul((nptr), (endptr), (base))
-
 /* Convert user's input in hex pattern to byte-size mask */
 static int wl_pattern_atoh(char *src, char *dst)
 {
@@ -986,7 +986,7 @@ static int wl_pattern_atoh(char *src, char *dst)
 		char num[3];
 		strncpy(num, src, 2);
 		num[2] = '\0';
-		dst[i] = (u8) strtoul(num, NULL, 16);
+		dst[i] = (u8) simple_strtoul(num, NULL, 16);
 		src += 2;
 	}
 	return i;
@@ -1015,7 +1015,7 @@ dhd_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg, int enable,
 	arg_org = arg_save;
 	memcpy(arg_save, arg, strlen(arg) + 1);
 
-	argv[i] = bcmstrtok(&arg_save, " ", 0);
+	argv[i] = strsep(&arg_save, " ");
 
 	i = 0;
 	if (NULL == argv[i]) {
@@ -1032,7 +1032,7 @@ dhd_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg, int enable,
 	pkt_filterp = (wl_pkt_filter_enable_t *) (buf + str_len + 1);
 
 	/* Parse packet filter id. */
-	enable_parm.id = htod32(strtoul(argv[i], NULL, 0));
+	enable_parm.id = htod32(simple_strtoul(argv[i], NULL, 0));
 
 	/* Parse enable/disable value. */
 	enable_parm.enable = htod32(enable);
@@ -1101,9 +1101,9 @@ void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 		goto fail;
 	}
 
-	argv[i] = bcmstrtok(&arg_save, " ", 0);
+	argv[i] = strsep(&arg_save, " ");
 	while (argv[i++])
-		argv[i] = bcmstrtok(&arg_save, " ", 0);
+		argv[i] = strsep(&arg_save, " ");
 
 	i = 0;
 	if (NULL == argv[i]) {
@@ -1120,7 +1120,7 @@ void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 	pkt_filterp = (wl_pkt_filter_t *) (buf + str_len + 1);
 
 	/* Parse packet filter id. */
-	pkt_filter.id = htod32(strtoul(argv[i], NULL, 0));
+	pkt_filter.id = htod32(simple_strtoul(argv[i], NULL, 0));
 
 	if (NULL == argv[++i]) {
 		DHD_ERROR(("Polarity not provided\n"));
@@ -1128,7 +1128,7 @@ void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 	}
 
 	/* Parse filter polarity. */
-	pkt_filter.negate_match = htod32(strtoul(argv[i], NULL, 0));
+	pkt_filter.negate_match = htod32(simple_strtoul(argv[i], NULL, 0));
 
 	if (NULL == argv[++i]) {
 		DHD_ERROR(("Filter type not provided\n"));
@@ -1136,7 +1136,7 @@ void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 	}
 
 	/* Parse filter type. */
-	pkt_filter.type = htod32(strtoul(argv[i], NULL, 0));
+	pkt_filter.type = htod32(simple_strtoul(argv[i], NULL, 0));
 
 	if (NULL == argv[++i]) {
 		DHD_ERROR(("Offset not provided\n"));
@@ -1144,7 +1144,7 @@ void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 	}
 
 	/* Parse pattern filter offset. */
-	pkt_filter.u.pattern.offset = htod32(strtoul(argv[i], NULL, 0));
+	pkt_filter.u.pattern.offset = htod32(simple_strtoul(argv[i], NULL, 0));
 
 	if (NULL == argv[++i]) {
 		DHD_ERROR(("Bitmask not provided\n"));
@@ -1290,7 +1290,7 @@ int dhd_preinit_ioctls(dhd_pub_t *dhd)
 	ptr = buf;
 	bcm_mkiovar("ver", 0, 0, buf, sizeof(buf));
 	dhdcdc_query_ioctl(dhd, 0, WLC_GET_VAR, buf, sizeof(buf));
-	bcmstrtok(&ptr, "\n", 0);
+	strsep(&ptr, "\n");
 	/* Print fw version info */
 	DHD_ERROR(("Firmware version = %s\n", buf));
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index c073e44..e9920e5 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -17,6 +17,7 @@
 #include <typedefs.h>
 #include <linuxver.h>
 #include <osl.h>
+#include <linux/kernel.h>
 
 #include <bcmutils.h>
 #include <bcmendian.h>
@@ -3588,7 +3589,6 @@ dongle_offload_out:
 
 static s32 wl_pattern_atoh(s8 *src, s8 *dst)
 {
-#define strtoul(nptr, endptr, base) bcm_strtoul((nptr), (endptr), (base))
 	int i;
 	if (strncmp(src, "0x", 2) != 0 && strncmp(src, "0X", 2) != 0) {
 		WL_ERR(("Mask invalid format. Needs to start with 0x\n"));
@@ -3603,7 +3603,7 @@ static s32 wl_pattern_atoh(s8 *src, s8 *dst)
 		char num[3];
 		strncpy(num, src, 2);
 		num[2] = '\0';
-		dst[i] = (u8) strtoul(num, NULL, 16);
+		dst[i] = (u8) simple_strtoul(num, NULL, 16);
 		src += 2;
 	}
 	return i;
diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index dcb0236..504ff65 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -162,7 +162,6 @@
 #define	PKTPRIO_UPD	0x400	/* DSCP used to update VLAN prio */
 #define	PKTPRIO_DSCP	0x800	/* DSCP prio found */
 
-	char *bcmstrtok(char **string, const char *delimiters, char *tokdelim);
 /* ethernet address */
 	extern char *bcm_ether_ntoa(const struct ether_addr *ea, char *buf);
 	extern int bcm_ether_atoe(char *p, struct ether_addr *ea);
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index 71b23b6..02d76d6 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -1117,79 +1117,3 @@ int bcm_bprintf(struct bcmstrbuf *b, const char *fmt, ...)
 	return r;
 }
 
-/****************************************************************************
-* Function:   bcmstrtok
-*
-* Purpose:
-*  Tokenizes a string. This function is conceptually similiar to ANSI C strtok(),
-*  but allows strToken() to be used by different strings or callers at the same
-*  time. Each call modifies '*string' by substituting a NULL character for the
-*  first delimiter that is encountered, and updates 'string' to point to the char
-*  after the delimiter. Leading delimiters are skipped.
-*
-* Parameters:
-*  string      (mod) Ptr to string ptr, updated by token.
-*  delimiters  (in)  Set of delimiter characters.
-*  tokdelim    (out) Character that delimits the returned token. (May
-*                    be set to NULL if token delimiter is not required).
-*
-* Returns:  Pointer to the next token found. NULL when no more tokens are found.
-*****************************************************************************
-*/
-char *bcmstrtok(char **string, const char *delimiters, char *tokdelim)
-{
-	unsigned char *str;
-	unsigned long map[8];
-	int count;
-	char *nextoken;
-
-	if (tokdelim != NULL) {
-		/* Prime the token delimiter */
-		*tokdelim = '\0';
-	}
-
-	/* Clear control map */
-	for (count = 0; count < 8; count++) {
-		map[count] = 0;
-	}
-
-	/* Set bits in delimiter table */
-	do {
-		map[*delimiters >> 5] |= (1 << (*delimiters & 31));
-	} while (*delimiters++);
-
-	str = (unsigned char *)*string;
-
-	/* Find beginning of token (skip over leading delimiters). Note that
-	 * there is no token iff this loop sets str to point to the terminal
-	 * null (*str == '\0')
-	 */
-	while (((map[*str >> 5] & (1 << (*str & 31))) && *str) || (*str == ' ')) {
-		str++;
-	}
-
-	nextoken = (char *)str;
-
-	/* Find the end of the token. If it is not the end of the string,
-	 * put a null there.
-	 */
-	for (; *str; str++) {
-		if (map[*str >> 5] & (1 << (*str & 31))) {
-			if (tokdelim != NULL) {
-				*tokdelim = *str;
-			}
-
-			*str++ = '\0';
-			break;
-		}
-	}
-
-	*string = (char *)str;
-
-	/* Determine if a token has been found. */
-	if (nextoken == (char *)str) {
-		return NULL;
-	} else {
-		return nextoken;
-	}
-}
-- 
1.7.2.3

