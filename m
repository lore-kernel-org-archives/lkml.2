Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab0JJKUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 06:20:36 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47619 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335Ab0JJKUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 06:20:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qMUhs6R99UIfH41aV8fC9goCxzVVMoMoZCTSSnINBJ0tsJvJPigNfBxTwPLTarI2cB
         j8//RucuqGLpEYoSKhKLumLX1HDExVBjT31eWWqDVER2/iQuIn4SuMVeaWsJ69RdQsvm
         QpEhK4GsMLBnnNBpkTM+CFk5CI5o4NqFpIAxk=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Nohee Ko <noheek@broadcom.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 2/3] staging: brcm80211: remove custom string library again
Date: Sun, 10 Oct 2010 13:20:12 +0300
Message-Id: <1afe92c01d15d6c9d55754e2e0984ae20b0be151.1286705921.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <86dfcd5dfdee8ce5ca558634d4606922f05e96e1.1286705921.git.andy.shevchenko@gmail.com>
References: <86dfcd5dfdee8ce5ca558634d4606922f05e96e1.1286705921.git.andy.shevchenko@gmail.com>
In-Reply-To: <86dfcd5dfdee8ce5ca558634d4606922f05e96e1.1286705921.git.andy.shevchenko@gmail.com>
References: <86dfcd5dfdee8ce5ca558634d4606922f05e96e1.1286705921.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a clean up commit for softmac driver. Do the same for fullmac
implementation.

Here:
 - strtoul and bcm_strtoul are changed to simple_strtoul
 - bcmstrcat -> strcat
 - bcmstrtok -> strsep

All unused functions are deleted.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmutils.c    |  289 +---------------------
 drivers/staging/brcm80211/brcmfmac/dhd_common.c  |   24 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c    |    7 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    4 +-
 drivers/staging/brcm80211/include/bcmutils.h     |   14 -
 5 files changed, 20 insertions(+), 318 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmutils.c b/drivers/staging/brcm80211/brcmfmac/bcmutils.c
index f0685c1..f5c552d 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmutils.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmutils.c
@@ -30,6 +30,7 @@
 #endif
 #endif				/* BCMDRIVER */
 #include <linux/ctype.h>
+#include <linux/kernel.h>
 #include <bcmendian.h>
 #include <bcmdevs.h>
 #include <bcmnvram.h>
@@ -484,271 +485,13 @@ void *pktq_mdeq(struct pktq *pq, uint prec_bmp, int *prec_out)
 }
 #endif				/* BCMDRIVER */
 
-unsigned long bcm_strtoul(char *cp, char **endp, uint base)
-{
-	unsigned long result, last_result = 0, value;
-	bool minus;
-
-	minus = FALSE;
-
-	while (isspace(*cp))
-		cp++;
-
-	if (cp[0] == '+')
-		cp++;
-	else if (cp[0] == '-') {
-		minus = TRUE;
-		cp++;
-	}
-
-	if (base == 0) {
-		if (cp[0] == '0') {
-			if ((cp[1] == 'x') || (cp[1] == 'X')) {
-				base = 16;
-				cp = &cp[2];
-			} else {
-				base = 8;
-				cp = &cp[1];
-			}
-		} else
-			base = 10;
-	} else if (base == 16 && (cp[0] == '0')
-		   && ((cp[1] == 'x') || (cp[1] == 'X'))) {
-		cp = &cp[2];
-	}
-
-	result = 0;
-
-	while (isxdigit(*cp) &&
-	       (value =
-		isdigit(*cp) ? *cp - '0' : toupper(*cp) - 'A' + 10) <
-	       base) {
-		result = result * base + value;
-		/* Detected overflow */
-		if (result < last_result && !minus)
-			return (unsigned long)-1;
-		last_result = result;
-		cp++;
-	}
-
-	if (minus)
-		result = (unsigned long) (-(long)result);
-
-	if (endp)
-		*endp = (char *)cp;
-
-	return result;
-}
-
-int bcm_atoi(char *s)
-{
-	return (int)bcm_strtoul(s, NULL, 10);
-}
-
-/* return pointer to location of substring 'needle' in 'haystack' */
-char *bcmstrstr(char *haystack, char *needle)
-{
-	int len, nlen;
-	int i;
-
-	if ((haystack == NULL) || (needle == NULL))
-		return haystack;
-
-	nlen = strlen(needle);
-	len = strlen(haystack) - nlen + 1;
-
-	for (i = 0; i < len; i++)
-		if (memcmp(needle, &haystack[i], nlen) == 0)
-			return &haystack[i];
-	return NULL;
-}
-
-char *bcmstrcat(char *dest, const char *src)
-{
-	char *p;
-
-	p = dest + strlen(dest);
-
-	while ((*p++ = *src++) != '\0')
-		;
-
-	return dest;
-}
-
-char *bcmstrncat(char *dest, const char *src, uint size)
-{
-	char *endp;
-	char *p;
-
-	p = dest + strlen(dest);
-	endp = p + size;
-
-	while (p != endp && (*p++ = *src++) != '\0')
-		;
-
-	return dest;
-}
-
-/****************************************************************************
-* Function:   bcmstrtok
-*
-* Purpose:
-*  Tokenizes a string. This function is conceptually similiar
-*  to ANSI C strtok(),
-*  but allows strToken() to be used by different strings or callers at the same
-*  time. Each call modifies '*string' by substituting a NULL character for the
-*  first delimiter that is encountered, and updates 'string' to point to
-*  the char
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
-	for (count = 0; count < 8; count++)
-		map[count] = 0;
-
-	/* Set bits in delimiter table */
-	do {
-		map[*delimiters >> 5] |= (1 << (*delimiters & 31));
-	}
-	while (*delimiters++)
-		;
-
-	str = (unsigned char *)*string;
-
-	/* Find beginning of token (skip over leading delimiters). Note that
-	 * there is no token iff this loop sets str to point to the terminal
-	 * null (*str == '\0')
-	 */
-	while (((map[*str >> 5] & (1 << (*str & 31))) && *str) || (*str == ' '))
-		str++;
-
-	nextoken = (char *)str;
-
-	/* Find the end of the token. If it is not the end of the string,
-	 * put a null there.
-	 */
-	for (; *str; str++) {
-		if (map[*str >> 5] & (1 << (*str & 31))) {
-			if (tokdelim != NULL)
-				*tokdelim = *str;
-
-			*str++ = '\0';
-			break;
-		}
-	}
-
-	*string = (char *)str;
-
-	/* Determine if a token has been found. */
-	if (nextoken == (char *)str)
-		return NULL;
-	else
-		return nextoken;
-}
-
-#define xToLower(C) \
-	((C >= 'A' && C <= 'Z') ? (char)((int)C - (int)'A' + (int)'a') : C)
-
-/****************************************************************************
-* Function:   bcmstricmp
-*
-* Purpose:    Compare to strings case insensitively.
-*
-* Parameters: s1 (in) First string to compare.
-*             s2 (in) Second string to compare.
-*
-* Returns:    Return 0 if the two strings are equal, -1 if t1 < t2 and 1 if
-*             t1 > t2, when ignoring case sensitivity.
-*****************************************************************************
-*/
-int bcmstricmp(const char *s1, const char *s2)
-{
-	char dc, sc;
-
-	while (*s2 && *s1) {
-		dc = xToLower(*s1);
-		sc = xToLower(*s2);
-		if (dc < sc)
-			return -1;
-		if (dc > sc)
-			return 1;
-		s1++;
-		s2++;
-	}
-
-	if (*s1 && !*s2)
-		return 1;
-	if (!*s1 && *s2)
-		return -1;
-	return 0;
-}
-
-/****************************************************************************
-* Function:   bcmstrnicmp
-*
-* Purpose:    Compare to strings case insensitively, upto a max of 'cnt'
-*             characters.
-*
-* Parameters: s1  (in) First string to compare.
-*             s2  (in) Second string to compare.
-*             cnt (in) Max characters to compare.
-*
-* Returns:    Return 0 if the two strings are equal, -1 if t1 < t2 and 1 if
-*             t1 > t2, when ignoring case sensitivity.
-*****************************************************************************
-*/
-int bcmstrnicmp(const char *s1, const char *s2, int cnt)
-{
-	char dc, sc;
-
-	while (*s2 && *s1 && cnt) {
-		dc = xToLower(*s1);
-		sc = xToLower(*s2);
-		if (dc < sc)
-			return -1;
-		if (dc > sc)
-			return 1;
-		s1++;
-		s2++;
-		cnt--;
-	}
-
-	if (!cnt)
-		return 0;
-	if (*s1 && !*s2)
-		return 1;
-	if (!*s1 && *s2)
-		return -1;
-	return 0;
-}
-
 /* parse a xx:xx:xx:xx:xx:xx format ethernet address */
 int bcm_ether_atoe(char *p, struct ether_addr *ea)
 {
 	int i = 0;
 
 	for (;;) {
-		ea->octet[i++] = (char)bcm_strtoul(p, &p, 16);
+		ea->octet[i++] = (char)simple_strtoul(p, &p, 16);
 		if (!*p++ || i == 6)
 			break;
 	}
@@ -756,34 +499,6 @@ int bcm_ether_atoe(char *p, struct ether_addr *ea)
 	return i == 6;
 }
 
-#if defined(CONFIG_USBRNDIS_RETAIL) || defined(NDIS_MINIPORT_DRIVER)
-/* registry routine buffer preparation utility functions:
- * parameter order is like strncpy, but returns count
- * of bytes copied. Minimum bytes copied is null char(1)/wchar(2)
- */
-unsigned long wchar2ascii(char *abuf, unsigned short * wbuf, unsigned short wbuflen, unsigned long abuflen)
-{
-	unsigned long copyct = 1;
-	unsigned short i;
-
-	if (abuflen == 0)
-		return 0;
-
-	/* wbuflen is in bytes */
-	wbuflen /= sizeof(unsigned short);
-
-	for (i = 0; i < wbuflen; ++i) {
-		if (--abuflen == 0)
-			break;
-		*abuf++ = (char)*wbuf++;
-		++copyct;
-	}
-	*abuf = '\0';
-
-	return copyct;
-}
-#endif	/* CONFIG_USBRNDIS_RETAIL || NDIS_MINIPORT_DRIVER */
-
 char *bcm_ether_ntoa(const struct ether_addr *ea, char *buf)
 {
 	static const char template[] = "%02x:%02x:%02x:%02x:%02x:%02x";
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 27c6976..3c6582f 100644
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
 
-#define strtoul(nptr, endptr, base) bcm_strtoul((nptr), (endptr), (base))
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
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 60b499a..fe8dd7b 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -16,6 +16,7 @@
 
 #include <typedefs.h>
 #include <osl.h>
+#include <linux/string.h>
 #include <bcmsdh.h>
 
 #ifdef BCMEMBEDIMAGE
@@ -2397,15 +2398,15 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, uint32 actionid,
 		{
 			*(char *)arg = 0;
 
-			bcmstrcat(arg, "\nFunc 0\n");
+			strcat(arg, "\nFunc 0\n");
 			bcmsdh_cis_read(bus->sdh, 0x10,
 					(u8 *) arg + strlen(arg),
 					SBSDIO_CIS_SIZE_LIMIT);
-			bcmstrcat(arg, "\nFunc 1\n");
+			strcat(arg, "\nFunc 1\n");
 			bcmsdh_cis_read(bus->sdh, 0x11,
 					(u8 *) arg + strlen(arg),
 					SBSDIO_CIS_SIZE_LIMIT);
-			bcmstrcat(arg, "\nFunc 2\n");
+			strcat(arg, "\nFunc 2\n");
 			bcmsdh_cis_read(bus->sdh, 0x12,
 					(u8 *) arg + strlen(arg),
 					SBSDIO_CIS_SIZE_LIMIT);
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 11084cb..654eb81 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -17,6 +17,7 @@
 #include <typedefs.h>
 #include <linuxver.h>
 #include <osl.h>
+#include <linux/kernel.h>
 
 #include <bcmutils.h>
 #include <bcmendian.h>
@@ -3531,7 +3532,6 @@ dongle_offload_out:
 
 static int32 wl_pattern_atoh(s8 *src, s8 *dst)
 {
-#define strtoul(nptr, endptr, base) bcm_strtoul((nptr), (endptr), (base))
 	int i;
 	if (strncmp(src, "0x", 2) != 0 && strncmp(src, "0X", 2) != 0) {
 		WL_ERR(("Mask invalid format. Needs to start with 0x\n"));
@@ -3546,7 +3546,7 @@ static int32 wl_pattern_atoh(s8 *src, s8 *dst)
 		char num[3];
 		strncpy(num, src, 2);
 		num[2] = '\0';
-		dst[i] = (u8) strtoul(num, NULL, 16);
+		dst[i] = (u8) simple_strtoul(num, NULL, 16);
 		src += 2;
 	}
 	return i;
diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index d0960b7..612384e 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -182,20 +182,6 @@ extern "C" {
 #define	PKTPRIO_UPD	0x400	/* DSCP used to update VLAN prio */
 #define	PKTPRIO_DSCP	0x800	/* DSCP prio found */
 
-#ifdef BRCM_FULLMAC
-/* string */
-	extern int BCMROMFN(bcm_atoi) (char *s);
-	extern unsigned long BCMROMFN(bcm_strtoul) (char *cp, char **endp, uint base);
-	extern char *BCMROMFN(bcmstrstr) (char *haystack, char *needle);
-	extern char *BCMROMFN(bcmstrcat) (char *dest, const char *src);
-	extern char *BCMROMFN(bcmstrncat) (char *dest, const char *src,
-					   uint size);
-	extern unsigned long wchar2ascii(char *abuf, unsigned short *wbuf, unsigned short wbuflen,
-				 unsigned long abuflen);
-	char *bcmstrtok(char **string, const char *delimiters, char *tokdelim);
-	int bcmstricmp(const char *s1, const char *s2);
-	int bcmstrnicmp(const char *s1, const char *s2, int cnt);
-#endif
 /* ethernet address */
 	extern char *bcm_ether_ntoa(const struct ether_addr *ea, char *buf);
 	extern int BCMROMFN(bcm_ether_atoe) (char *p, struct ether_addr *ea);
-- 
1.7.2.3

