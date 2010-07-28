Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab0G1P24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 11:28:56 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50214 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab0G1P2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 11:28:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v4vvZCuJYDuftzhlXGNCmCEOqW044aLTqudMbkW76aw2wKym5+kfuCWWctobAxL1UA
         oHWcdfgCCLjr+Ns6FqU04OFmrVVIHiKUUQb3sFR1WtQQDkq6qSsgC+nNbV4QT3yAC2qR
         61QjaCpJedHcsnWJoXqCJGwBwUoNjDV/htfbw=
Date: Wed, 28 Jul 2010 17:28:49 +0200
From: Michal Januszewski <michalj@gmail.com>
To: Andreas Schwab <schwab@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Make sure abs() works as expected with both ints and longs
Message-ID: <20100728152849.GA3728@quadria>
Reply-To: michalj@gmail.com
References: <20100728123048.GA4127@quadria>
 <m3eienu3ex.fsf@hase.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <m3eienu3ex.fsf@hase.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The abs() macro is commonly used to calculate the modulus of a difference
of two numbers.  With the introduction of "long" inside the definition
of abs() in the commit a49c59c042c63b432307c1bbf7dac5a104c786e6, some of
the abs() calls in the kernel started returning unexpected values (for
instance, see abs() usage in drivers/video/modedb.c).

The problem is apparent if the argument of abs() is a difference of two
32-bit integers, at least one of which is unsigned.  The result is then
assumed to be an unsigned integer, which gets cast to a positive long. The
return value of abs() is then this large positive integer, instead of the
expected small positive integer representing the modulus of the argument.

Example:

  u32 a = 0, b = 1;
  u32 c = abs(a - b);

  'c' will end up with a value of 0xffffffff instead of the expected 0x1.

To fix this problem, modify the abs() macro so that it detects the size
of the argument, and if it's not larger than 32 bits, uses an int instead
of a long.

Signed-off-by: Michal Januszewski <michalj@gmail.com>
---
OK, please disregard my previous patch.  How about this new one?  
A solution with sizeof() was mentioned as a possibility in the original 
discussion of a49c59c0, but it looks like it was never actually
presented and considered.

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 8317ec4..bacefff 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -157,10 +157,14 @@ extern int _cond_resched(void);
 
 #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
 
-#define abs(x) ({				\
-		long __x = (x);			\
-		(__x < 0) ? -__x : __x;		\
-	})
+#define abs(x) (			\
+	(sizeof(x) <= 4) ? ({		\
+		int __x = (x);		\
+		(__x < 0) ? -__x : __x;	\
+	}) : ({				\
+		long __x = (x);		\
+		(__x < 0) ? -__x : __x;	\
+	}))
 
 #ifdef CONFIG_PROVE_LOCKING
 void might_fault(void);

