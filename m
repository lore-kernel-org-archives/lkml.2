Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab1GRMsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 08:48:41 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63349 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab1GRMsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 08:48:39 -0400
X-Nat-Received: from [202.181.97.72]:60950 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1310993315.22979
To: linux-security-module@vger.kernel.org
Cc: andriy.shevchenko@linux.intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Add error check to hex2bin().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1310977597-9666-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<201107182041.EHB78622.VOFSHFMOOFtLJQ@I-love.SAKURA.ne.jp>
	<1310991796.3903.6.camel@smile>
In-Reply-To: <1310991796.3903.6.camel@smile>
Message-Id: <201107182148.AGD21306.FOLtJVMSOOFQHF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 18 Jul 2011 21:48:32 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 17072011 #5619247, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, security/keys/ is the only user of hex2bin().
Should I keep hex2bin() unmodified in case of bad input?
If so, I'd like to make it as hex2bin_safe().
----------------------------------------
[PATCH] Add error check to hex2bin().

Since converting 2 hexadecimal letters into a byte with error checks is
commonly used, we can replace multiple hex_to_bin() calls with single hex2bin()
call by changing hex2bin() to do error checks.

Signed-off-by: Tetsuo Handa <penguin-kernel@I=love.SAKURA.ne.jp>
---
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 953352a..186e9fc 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -374,7 +374,7 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 }
 
 extern int hex_to_bin(char ch);
-extern void hex2bin(u8 *dst, const char *src, size_t count);
+extern bool hex2bin(u8 *dst, const char *src, size_t count);
 
 /*
  * General tracing related utility functions - trace_printk(),
diff --git a/lib/hexdump.c b/lib/hexdump.c
index f5fe6ba..1524002 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -38,14 +38,22 @@ EXPORT_SYMBOL(hex_to_bin);
  * @dst: binary result
  * @src: ascii hexadecimal string
  * @count: result length
+ *
+ * Returns true on success, false in case of bad input.
  */
-void hex2bin(u8 *dst, const char *src, size_t count)
+bool hex2bin(u8 *dst, const char *src, size_t count)
 {
 	while (count--) {
-		*dst = hex_to_bin(*src++) << 4;
-		*dst += hex_to_bin(*src++);
-		dst++;
+		int c = hex_to_bin(*src++);
+		int d;
+		if (c < 0)
+			return false;
+		d = hex_to_bin(*src++);
+		if (d < 0)
+			return false;
+		*dst++ = (c << 4) | d;
 	}
+	return true;
 }
 EXPORT_SYMBOL(hex2bin);
 


In message "Re: [PATCH] net: can: remove custom hex_to_bin()",
Andy Shevchenko wrote:
> On Mon, 2011-07-18 at 20:41 +0900, Tetsuo Handa wrote: 
> > Andy Shevchenko wrote:
> > >  	for (i = 0, dlc_pos++; i < cf.can_dlc; i++) {
> > > -
> > > -		tmp = asc2nibble(sl->rbuff[dlc_pos++]);
> > > -		if (tmp > 0x0F)
> > > +		tmp = hex_to_bin(sl->rbuff[dlc_pos++]);
> > > +		if (tmp < 0)
> > >  			return;
> > >  		cf.data[i] = (tmp << 4);
> > > -		tmp = asc2nibble(sl->rbuff[dlc_pos++]);
> > > -		if (tmp > 0x0F)
> > > +		tmp = hex_to_bin(sl->rbuff[dlc_pos++]);
> > > +		if (tmp < 0)
> > >  			return;
> > >  		cf.data[i] |= tmp;
> > >  	}
> > 
> > What about changing
> > 
> >   void hex2bin(u8 *dst, const char *src, size_t count)
> > 
> > to
> > 
> >   bool hex2bin(u8 *dst, const char *src, size_t count)
> > 
> > in order to do error checks like
> > 
> > bool hex2bin_with_validation(u8 *dst, const char *src, size_t count)
> > {
> > 	while (count--) {
> > 		int c = hex_to_bin(*src++);
> > 		int d;
> > 		if (c < 0)
> > 			return false;
> > 		d = hex_to_bin(*src++)
> > 		if (d < 0)
> > 			return false;
> > 		*dst++ = (c << 4) | d;
> > 	}
> > 	return true;
> > }
> > 
> > and use hex2bin() rather than hex_to_bin()?
> Perhaps, good idea. Could you submit a patch?
> 
> -- 
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Intel Finland Oy
