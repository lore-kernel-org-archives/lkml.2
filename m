Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab0GVNYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 09:24:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37151 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab0GVNYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 09:24:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PWvc/Xo5lQaYnEFqDWq/zso4W1G1mHVVTzwnBxE1ESARNEyMSIVTJ8+xD4oVhSnUnY
         PmwE0LI8+AlZS4wq90ymW5RsQcqxFuDmhfiEYefKiR7LToeohUPGSgcdJy7iv3NvPYiK
         cuD5vAT1StLq+23xSWbrjM5xbhduZUSZZGoRU=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH] staging: clean up code a bit, use kernel native methods
Date: Thu, 22 Jul 2010 16:24:02 +0300
Message-Id: <1279805042-9936-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/otus/apdbg.c             |   22 -----------------
 drivers/staging/panel/panel.c            |   19 +++++---------
 drivers/staging/rtl8192su/r8192S_Efuse.c |   27 ++-------------------
 drivers/staging/wlags49_h2/wl_util.c     |   37 +-----------------------------
 drivers/staging/wlags49_h2/wl_util.h     |    2 -
 drivers/staging/wlan-ng/prism2sta.c      |    6 +---
 6 files changed, 13 insertions(+), 100 deletions(-)

diff --git a/drivers/staging/otus/apdbg.c b/drivers/staging/otus/apdbg.c
index 32c26e5..09415a6 100644
--- a/drivers/staging/otus/apdbg.c
+++ b/drivers/staging/otus/apdbg.c
@@ -90,28 +90,6 @@ struct zdap_ioctl {
 
 #endif
 
-static char hex(char v)
-{
-	if (isdigit(v))
-		return v - '0';
-	else if (isxdigit(v))
-		return tolower(v) - 'a' + 10;
-	else
-		return 0;
-}
-
-static unsigned char asctohex(char *str)
-{
-	unsigned char value;
-
-	value = hex(*str) & 0x0f;
-	value = value << 4;
-	str++;
-	value |= hex(*str) & 0x0f;
-
-	return value;
-}
-
 char *prgname;
 
 int set_ioctl(int sock, struct ifreq *req)
diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 8bd7182..3e07e41 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -48,6 +48,7 @@
 #include <linux/fcntl.h>
 #include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/kernel.h>
 #include <linux/ctype.h>
 #include <linux/parport.h>
 #include <linux/version.h>
@@ -1179,22 +1180,16 @@ static inline int handle_lcd_special_code(void)
 			break;
 
 		while (*esc) {
+			char *endp;
+
 			if (*esc == 'x') {
 				esc++;
-				lcd_addr_x = 0;
-				while (isdigit(*esc)) {
-					lcd_addr_x = lcd_addr_x * 10 +
-						     (*esc - '0');
-					esc++;
-				}
+				lcd_addr_x = simple_strtoul(esc, &endp, 10);
+				esc = endp;
 			} else if (*esc == 'y') {
 				esc++;
-				lcd_addr_y = 0;
-				while (isdigit(*esc)) {
-					lcd_addr_y = lcd_addr_y * 10 +
-						     (*esc - '0');
-					esc++;
-				}
+				lcd_addr_y = simple_strtoul(esc, &endp, 10);
+				esc = endp;
 			} else
 				break;
 		}
diff --git a/drivers/staging/rtl8192su/r8192S_Efuse.c b/drivers/staging/rtl8192su/r8192S_Efuse.c
index 1e1d55e..c4bbe40 100644
--- a/drivers/staging/rtl8192su/r8192S_Efuse.c
+++ b/drivers/staging/rtl8192su/r8192S_Efuse.c
@@ -30,6 +30,7 @@
 #include "r8192S_Efuse.h"
 
 #include <linux/types.h>
+#include <linux/ctype.h>
 
 //typedef  int	INT32;
 //
@@ -1828,26 +1829,6 @@ EFUSE_ProgramMap(struct net_device* dev, char* pFileName,u8	TableType)
 
 #endif
 
-//
-//	Description:
-//		Return TRUE if chTmp is represent for hex digit and
-//		FALSE otherwise.
-//
-//
-bool IsHexDigit(	char chTmp)
-{
-	if( (chTmp >= '0' && chTmp <= '9') ||
-		(chTmp >= 'a' && chTmp <= 'f') ||
-		(chTmp >= 'A' && chTmp <= 'F') )
-	{
-		return TRUE;
-	}
-	else
-	{
-		return FALSE;
-	}
-}
-
 /*-----------------------------------------------------------------------------
  * Function:	efuse_ParsingMap
  *
@@ -1893,10 +1874,8 @@ efuse_ParsingMap(char* szStr,u32* pu4bVal,u32* pu4bMove)
 
 	// Check if szScan is now pointer to a character for hex digit,
 	// if not, it means this is not a valid hex number.
-	if(!IsHexDigit(*szScan))
-	{
+	if (!isxdigit(*szScan))
 		return FALSE;
-	}
 
 	// Parse each digit.
 	do
@@ -1905,7 +1884,7 @@ efuse_ParsingMap(char* szStr,u32* pu4bVal,u32* pu4bMove)
 
 		szScan++;
 		(*pu4bMove)++;
-	} while(IsHexDigit(*szScan));
+	} while (isxdigit(*szScan));
 
 	return TRUE;
 
diff --git a/drivers/staging/wlags49_h2/wl_util.c b/drivers/staging/wlags49_h2/wl_util.c
index bbdb997..ce8ed41 100644
--- a/drivers/staging/wlags49_h2/wl_util.c
+++ b/drivers/staging/wlags49_h2/wl_util.c
@@ -259,41 +259,6 @@ int is_valid_key_string( char *s )
 
 
 /*******************************************************************************
- *	hexdigit2int()
- *******************************************************************************
- *
- *  DESCRIPTION:
- *
- *      Converts a hexadecimal digit character to an integer
- *
- *  PARAMETERS:
- *
- *      c   - the hexadecimal digit character
- *
- *  RETURNS:
- *
- *      the converted integer
- *
- ******************************************************************************/
-int hexdigit2int( char c )
-{
-   if( c >= '0' && c <= '9' )
-       return c - '0';
-
-   if( c >= 'A' && c <= 'F' )
-       return c - 'A' + 10;
-
-   if( c >= 'a' && c <= 'f' )
-       return c - 'a' + 10;
-
-   return 0;
-} // hexdigit2int
-/*============================================================================*/
-
-
-
-
-/*******************************************************************************
  *	key_string2key()
  *******************************************************************************
  *
@@ -328,7 +293,7 @@ void key_string2key( char *ks, KEY_STRCT *key )
         p = (char *)key->key;
 
         for( i = 2; i < l; i+=2 ) {
-           *p++ = ( hexdigit2int( ks[i] ) << 4 ) + hexdigit2int (ks[i+1] );
+			*p++ = (hex_to_bin(ks[i]) << 4) + hex_to_bin(ks[i+1]);
            n++;
         }
 
diff --git a/drivers/staging/wlags49_h2/wl_util.h b/drivers/staging/wlags49_h2/wl_util.h
index 561e85b..ba537a6 100644
--- a/drivers/staging/wlags49_h2/wl_util.h
+++ b/drivers/staging/wlags49_h2/wl_util.h
@@ -71,8 +71,6 @@ int is_valid_key_string( char *s );
 
 void key_string2key( char *ks, KEY_STRCT *key );
 
-int hexdigit2int( char c );
-
 void wl_hcf_error( struct net_device *dev, int hcfStatus );
 
 void wl_endian_translate_event( ltv_t *pLtv );
diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
index 5ec5741..1a502bc 100644
--- a/drivers/staging/wlan-ng/prism2sta.c
+++ b/drivers/staging/wlan-ng/prism2sta.c
@@ -83,8 +83,6 @@
 #include "hfa384x.h"
 #include "prism2mgmt.h"
 
-#define wlan_hexchar(x) (((x) < 0x0a) ? ('0' + (x)) : ('a' + ((x) - 0x0a)))
-
 /* Create a string of printable chars from something that might not be */
 /* It's recommended that the str be 4*len + 1 bytes long */
 #define wlan_mkprintstr(buf, buflen, str, strlen) \
@@ -99,8 +97,8 @@
 		} else { \
 			(str)[j] = '\\'; \
 			(str)[j+1] = 'x'; \
-			(str)[j+2] = wlan_hexchar(((buf)[i] & 0xf0) >> 4); \
-			(str)[j+3] = wlan_hexchar(((buf)[i] & 0x0f)); \
+			(str)[j+2] = hex_asc_hi((buf)[i]); \
+			(str)[j+3] = hex_asc_lo((buf)[i]); \
 			j += 4; \
 		} \
 	} \
-- 
1.7.1.1

