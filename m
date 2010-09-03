Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab0ICGsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 02:48:39 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56835 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab0ICGsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 02:48:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=i3TZfBxt98ynD2zwAkjh5GS0zICy5cC7WKffEfBydnE+Uko3wm/Z+iThK8u4e8Kg0H
         hwCURXmqTnVALJWRfkZuTIiBCEsFiM37V/uB0Tl1a8iLfjeEYqbGrG4K9E1buX8ezJt6
         PjpjHlOen65ZyEqGXhlGN+4j4h3ffsLNm345s=
Message-ID: <4C809A40.8070300@gmail.com>
Date: Fri, 03 Sep 2010 16:18:32 +0930
From: Graham Gower <graham.gower@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100721 Thunderbird/3.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/char/vt_ioctl.c: Fix VT_OPENQRY error value
References: <4C809632.6090706@gmail.com>
In-Reply-To: <4C809632.6090706@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When all VT's are in use, VT_OPENQRY casts -1 to unsigned char
before returning it to userspace as an int. VT255 is not the next
available console.

Signed-off-by: Graham Gower <graham.gower@gmail.com>
---

Sorry, I seem to have dropped a patch fragment in the previous mail.

--- drivers/char/vt_ioctl.c~	2010-08-11 04:07:31.000000000 +0930
+++ drivers/char/vt_ioctl.c	2010-09-03 16:13:59.000000000 +0930
@@ -503,6 +503,7 @@
 	struct kbd_struct * kbd;
 	unsigned int console;
 	unsigned char ucval;
+	unsigned int uival;
 	void __user *up = (void __user *)arg;
 	int i, perm;
 	int ret = 0;
@@ -657,7 +658,7 @@
 		break;
 
 	case KDGETMODE:
-		ucval = vc->vc_mode;
+		uival = vc->vc_mode;
 		goto setint;
 
 	case KDMAPDISP:
@@ -695,7 +696,7 @@
 		break;
 
 	case KDGKBMODE:
-		ucval = ((kbd->kbdmode == VC_RAW) ? K_RAW :
+		uival = ((kbd->kbdmode == VC_RAW) ? K_RAW :
 				 (kbd->kbdmode == VC_MEDIUMRAW) ? K_MEDIUMRAW :
 				 (kbd->kbdmode == VC_UNICODE) ? K_UNICODE :
 				 K_XLATE);
@@ -717,9 +718,9 @@
 		break;
 
 	case KDGKBMETA:
-		ucval = (vc_kbd_mode(kbd, VC_META) ? K_ESCPREFIX : K_METABIT);
+		uival = (vc_kbd_mode(kbd, VC_META) ? K_ESCPREFIX : K_METABIT);
 	setint:
-		ret = put_user(ucval, (int __user *)arg);
+		ret = put_user(uival, (int __user *)arg);
 		break;
 
 	case KDGETKEYCODE:
@@ -949,7 +950,7 @@
 		for (i = 0; i < MAX_NR_CONSOLES; ++i)
 			if (! VT_IS_IN_USE(i))
 				break;
-		ucval = i < MAX_NR_CONSOLES ? (i+1) : -1;
+		uival = i < MAX_NR_CONSOLES ? (i+1) : -1;
 		goto setint;		 
 
 	/*
