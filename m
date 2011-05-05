Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab1EEFzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 01:55:04 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57737 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1EEFzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 01:55:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=eGzeAN+Yg5IRInsuUHoEbmdprSzWLQK8t3g6dqu63CFKKUTOLgnpXp8WX3IumVEkDL
         Pya9gWdqMLn05eA2hShqgKojT1ZCjW4/KtdPbghMMkZ7hGBuNcFk/fCZEEs6GoO3Rt75
         vG8z2IGwDbDuYPMe8hehCh1wQfpnlV6YWa07s=
MIME-Version: 1.0
From: Mansour Moufid <mansourmoufid@gmail.com>
Date: Thu, 5 May 2011 01:54:41 -0400
Message-ID: <BANLkTikXoy+cJV-aj5RVtpLgEQ_Y-3TOSw@mail.gmail.com>
Subject: [PATCH] simple_strtoul: prevent integer overflows
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mansour Moufid <mansourmoufid@gmail.com>

This patch prevents integer overflows in the functions
`simple_strtoull' and `simple_strtoul', in the file lib/vsprintf.c.
This applies to stable version 2.6.38.5.

I'm aware of the kstrto* functions, but simple_strto* are still used
in some network-exposed code (netfilter).

Signed-off-by: Mansour Moufid <mansourmoufid@gmail.com>
---
--- vsprintf.c.orig	2011-05-04 22:00:07.000000000 -0400
+++ vsprintf.c	2011-05-04 22:27:45.000000000 -0400
@@ -63,11 +63,20 @@ unsigned long long simple_strtoull(const
 		cp += 2;

 	while (isxdigit(*cp)) {
-		unsigned int value;
+		unsigned int value = 0;

-		value = isdigit(*cp) ? *cp - '0' : TOLOWER(*cp) - 'a' + 10;
+		if (isdigit(*cp))
+			value = *cp - '0';
+		else if (isalpha(*cp))
+			value = TOLOWER(*cp) - 'a' + 10;
+		else
+			break;
 		if (value >= base)
 			break;
+		if (result > (ULLONG_MAX - value) / base) {
+			result = ULLONG_MAX;
+			break;
+		}
 		result = result * base + value;
 		cp++;
 	}
@@ -86,7 +95,12 @@ EXPORT_SYMBOL(simple_strtoull);
  */
 unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base)
 {
-	return simple_strtoull(cp, endp, base);
+	unsigned long long result = simple_strtoull(cp, endp, base);
+
+	if (result <= ULONG_MAX)
+		return result;
+
+	return ULONG_MAX;
 }
 EXPORT_SYMBOL(simple_strtoul);
