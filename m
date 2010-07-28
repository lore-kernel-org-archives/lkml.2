Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab0G1Mob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 08:44:31 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61039 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab0G1Moa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 08:44:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:reply-to:mime-version:content-type
         :content-disposition:user-agent;
        b=GvnALGpiBLet6uYNk1ZZxVEwirqsfwZkb8O7v/AbtWU93ikbyM4gNqjASUOSXfdRVO
         a5p25IKW+OaxyMK1Ffjv1NaALfiXGDH78LFSMi80NzTgNvZFsfb1Lik4aqoU+1bhDSXg
         a43Ny/82m4+6lGRKrFegxaB95zLwhhMYspwSo=
Date: Wed, 28 Jul 2010 14:44:25 +0200
From: Michal Januszewski <michalj@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Make sure abs() always works on a signed argument
Message-ID: <20100728123048.GA4127@quadria>
Reply-To: michalj@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The abs() macro is commonly used to calculate the modulus of a difference
of two numbers.  With the introduction of "long" inside the definition
of abs() in the commit a49c59c042c63b432307c1bbf7dac5a104c786e6, some of
the abs() calls in the kernel started returning unexpected values (for
instance, see abs() usage in drivers/video/modedb.c and the resulting
problems reported in https://bugs.gentoo.org/show_bug.cgi?id=296539).

The problem is apparent if the argument of abs() is a difference of two
32-bit integers, at least one of which is unsigned.  The result is then
assumed to be an unsigned integer, which gets cast to a positive long. The
return value of abs() is then this large positive integer, instead of the
expected small positive integer representing the modulus of the argument.

Example:

  u32 a = 0, b = 1;
  u32 c = abs(a - b);

  'c' will end up with a value of 0xffffffff instead of the expected 0x1.

To fix this problem, explicitly cast the argument of abs() to signed, so
that it gets properly expanded to long in case the original argument was
an int.

Signed-off-by: Michal Januszewski <michalj@gmail.com>
--
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 8317ec4..29fd43e 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -158,7 +158,7 @@ extern int _cond_resched(void);
 #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
 
 #define abs(x) ({				\
-		long __x = (x);			\
+		long __x = (signed)(x);		\
 		(__x < 0) ? -__x : __x;		\
 	})
 
