Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab1ADXVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 18:21:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44371 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801Ab1ADXVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 18:21:13 -0500
Date: Tue, 4 Jan 2011 15:21:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>
Subject: Re: [resend][PATCH] fs: use kernel's hex_to_bin() method
Message-Id: <20110104152100.29d0da02.akpm@linux-foundation.org>
In-Reply-To: <1291978505-29076-1-git-send-email-andy.shevchenko@gmail.com>
References: <1291978505-29076-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010 12:55:05 +0200
Andy Shevchenko <andy.shevchenko@gmail.com> wrote:

> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: linux-fsdevel@vger.kernel.org
> ---
>  fs/binfmt_misc.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index 1befe2e..a0fb271 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -28,6 +28,7 @@
>  #include <linux/mount.h>
>  #include <linux/syscalls.h>
>  #include <linux/fs.h>
> +#include <linux/kernel.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -244,10 +245,8 @@ static int unquote(char *from)
>  	while ((c = *s++) != '\0') {
>  		if (c == '\\' && *s == 'x') {
>  			s++;
> -			c = toupper(*s++);
> -			*p = (c - (isdigit(c) ? '0' : 'A' - 10)) << 4;
> -			c = toupper(*s++);
> -			*p++ |= c - (isdigit(c) ? '0' : 'A' - 10);
> +			*p = hex_to_bin(*s++) << 4;
> +			*p++ |= hex_to_bin(*s++);
>  			continue;
>  		}
>  		*p++ = c;

Calling hex_to_bin() twice is a bit sad - we need a library function
which does hex-to-bin on a digit string.

And lo, one just got added in linux-next.  However it cruelly didn't
return anything useful, so...

From: Andrew Morton <akpm@linux-foundation.org>

As a convenience to callers.

Not a terribly convenient convenience, as most callers will need to cast
away the constness of the return value.  Oh well, those callers should
have been using a `const char *' anyway.

Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 +-
 lib/hexdump.c          |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN lib/hexdump.c~lib-hexdumpc-make-hex2bin-return-the-updated-src-address lib/hexdump.c
--- a/lib/hexdump.c~lib-hexdumpc-make-hex2bin-return-the-updated-src-address
+++ a/lib/hexdump.c
@@ -39,13 +39,14 @@ EXPORT_SYMBOL(hex_to_bin);
  * @src: ascii hexadecimal string
  * @count: result length
  */
-void hex2bin(u8 *dst, const char *src, size_t count)
+const char *hex2bin(u8 *dst, const char *src, size_t count)
 {
 	while (count--) {
 		*dst = hex_to_bin(*src++) << 4;
 		*dst += hex_to_bin(*src++);
 		dst++;
 	}
+	return src;
 }
 EXPORT_SYMBOL(hex2bin);
 
diff -puN include/linux/kernel.h~lib-hexdumpc-make-hex2bin-return-the-updated-src-address include/linux/kernel.h
--- a/include/linux/kernel.h~lib-hexdumpc-make-hex2bin-return-the-updated-src-address
+++ a/include/linux/kernel.h
@@ -278,7 +278,7 @@ static inline char *pack_hex_byte(char *
 }
 
 extern int hex_to_bin(char ch);
-extern void hex2bin(u8 *dst, const char *src, size_t count);
+extern const char *hex2bin(u8 *dst, const char *src, size_t count);
 
 /*
  * General tracing related utility functions - trace_printk(),
_


After which we can change your patch thusly:

--- a/fs/binfmt_misc.c~fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix
+++ a/fs/binfmt_misc.c
@@ -244,9 +244,7 @@ static int unquote(char *from)
 
 	while ((c = *s++) != '\0') {
 		if (c == '\\' && *s == 'x') {
-			s++;
-			*p = hex_to_bin(*s++) << 4;
-			*p++ |= hex_to_bin(*s++);
+			s = (char *)hex2bin(p, s + 1, 1);
 			continue;
 		}
 		*p++ = c;
_



