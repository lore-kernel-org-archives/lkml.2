Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab0IQX5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 19:57:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40730 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab0IQX5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 19:57:38 -0400
From: James Hogan <james@albanarts.com>
To: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: [PATCH] fbmem: Fix fb_read, fb_write unaligned accesses.
Date: Sat, 18 Sep 2010 00:57:29 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.6-54.fc13.x86_64; KDE/4.4.5; x86_64; ; )
Cc: "David S. Miller" <davem@davemloft.net>, Dave Airlie <airlied@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        James Simmons <jsimmons@infradead.org>
References: <201009092338.59880.james@albanarts.com>
In-Reply-To: <201009092338.59880.james@albanarts.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009180057.32358.james@albanarts.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comments? I'd also appreciate if somebody familiar with sbus on sparc
could check this patch is sane since I know virtually nothing about sbus
and am not in a position to compile for sparc, let alone test on it:

fb_{read,write} access the framebuffer using lots of fb_{read,write}l's
but don't check that the file position is aligned which can cause
problems on some architectures which do not support unaligned accesses.

Since the operations are essentially memcpy_{from,to}io, new
fb_memcpy_{from,to}fb macros have been defined and these are used
instead.

For Sparc, fb_{read,write} macros use sbus_{read,write}, so this defines
new sbus_memcpy_{from,to}io functions the same as memcpy_{from,to}io but
using sbus_{read,write}b instead of {read,write}b.

Signed-off-by: James Hogan <james@albanarts.com>
---
 arch/sparc/include/asm/io_32.h |   31 +++++++++++++++++++++++++++
 arch/sparc/include/asm/io_64.h |   31 +++++++++++++++++++++++++++
 drivers/video/fbmem.c          |   46 ++++++++++++---------------------------
 include/linux/fb.h             |    6 +++++
 4 files changed, 82 insertions(+), 32 deletions(-)

diff --git a/arch/sparc/include/asm/io_32.h b/arch/sparc/include/asm/io_32.h
index 2889574..c2ced21 100644
--- a/arch/sparc/include/asm/io_32.h
+++ b/arch/sparc/include/asm/io_32.h
@@ -208,6 +208,21 @@ _memset_io(volatile void __iomem *dst, int c, __kernel_size_t n)
 #define memset_io(d,c,sz)	_memset_io(d,c,sz)
 
 static inline void
+_sbus_memcpy_fromio(void *dst, const volatile void __iomem *src,
+		    __kernel_size_t n)
+{
+	char *d = dst;
+
+	while (n--) {
+		char tmp = sbus_readb(src);
+		*d++ = tmp;
+		src++;
+	}
+}
+
+#define sbus_memcpy_fromio(d, s, sz)	_sbus_memcpy_fromio(d, s, sz)
+
+static inline void
 _memcpy_fromio(void *dst, const volatile void __iomem *src, __kernel_size_t n)
 {
 	char *d = dst;
@@ -222,6 +237,22 @@ _memcpy_fromio(void *dst, const volatile void __iomem *src, 
__kernel_size_t n)
 #define memcpy_fromio(d,s,sz)	_memcpy_fromio(d,s,sz)
 
 static inline void
+_sbus_memcpy_toio(volatile void __iomem *dst, const void *src,
+		  __kernel_size_t n)
+{
+	const char *s = src;
+	volatile void __iomem *d = dst;
+
+	while (n--) {
+		char tmp = *s++;
+		sbus_writeb(tmp, d);
+		d++;
+	}
+}
+
+#define sbus_memcpy_toio(d, s, sz)	_sbus_memcpy_toio(d, s, sz)
+
+static inline void
 _memcpy_toio(volatile void __iomem *dst, const void *src, __kernel_size_t n)
 {
 	const char *s = src;
diff --git a/arch/sparc/include/asm/io_64.h b/arch/sparc/include/asm/io_64.h
index 9517d06..9c89654 100644
--- a/arch/sparc/include/asm/io_64.h
+++ b/arch/sparc/include/asm/io_64.h
@@ -419,6 +419,21 @@ _memset_io(volatile void __iomem *dst, int c, __kernel_size_t n)
 #define memset_io(d,c,sz)	_memset_io(d,c,sz)
 
 static inline void
+_sbus_memcpy_fromio(void *dst, const volatile void __iomem *src,
+		    __kernel_size_t n)
+{
+	char *d = dst;
+
+	while (n--) {
+		char tmp = sbus_readb(src);
+		*d++ = tmp;
+		src++;
+	}
+}
+
+#define sbus_memcpy_fromio(d, s, sz)	_sbus_memcpy_fromio(d, s, sz)
+
+static inline void
 _memcpy_fromio(void *dst, const volatile void __iomem *src, __kernel_size_t n)
 {
 	char *d = dst;
@@ -433,6 +448,22 @@ _memcpy_fromio(void *dst, const volatile void __iomem *src, 
__kernel_size_t n)
 #define memcpy_fromio(d,s,sz)	_memcpy_fromio(d,s,sz)
 
 static inline void
+_sbus_memcpy_toio(volatile void __iomem *dst, const void *src,
+		  __kernel_size_t n)
+{
+	const char *s = src;
+	volatile void __iomem *d = dst;
+
+	while (n--) {
+		char tmp = *s++;
+		sbus_writeb(tmp, d);
+		d++;
+	}
+}
+
+#define sbus_memcpy_toio(d, s, sz)	_sbus_memcpy_toio(d, s, sz)
+
+static inline void
 _memcpy_toio(volatile void __iomem *dst, const void *src, __kernel_size_t n)
 {
 	const char *s = src;
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index b066475..925f25d 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -697,9 +697,9 @@ fb_read(struct file *file, char __user *buf, size_t count, loff_t 
*ppos)
 	struct inode *inode = file->f_path.dentry->d_inode;
 	int fbidx = iminor(inode);
 	struct fb_info *info = registered_fb[fbidx];
-	u32 *buffer, *dst;
-	u32 __iomem *src;
-	int c, i, cnt = 0, err = 0;
+	u8 *buffer, *dst;
+	u8 __iomem *src;
+	int c, cnt = 0, err = 0;
 	unsigned long total_size;
 
 	if (!info || ! info->screen_base)
@@ -730,7 +730,7 @@ fb_read(struct file *file, char __user *buf, size_t count, loff_t 
*ppos)
 	if (!buffer)
 		return -ENOMEM;
 
-	src = (u32 __iomem *) (info->screen_base + p);
+	src = (u8 __iomem *) (info->screen_base + p);
 
 	if (info->fbops->fb_sync)
 		info->fbops->fb_sync(info);
@@ -738,17 +738,9 @@ fb_read(struct file *file, char __user *buf, size_t count, loff_t 
*ppos)
 	while (count) {
 		c  = (count > PAGE_SIZE) ? PAGE_SIZE : count;
 		dst = buffer;
-		for (i = c >> 2; i--; )
-			*dst++ = fb_readl(src++);
-		if (c & 3) {
-			u8 *dst8 = (u8 *) dst;
-			u8 __iomem *src8 = (u8 __iomem *) src;
-
-			for (i = c & 3; i--;)
-				*dst8++ = fb_readb(src8++);
-
-			src = (u32 __iomem *) src8;
-		}
+		fb_memcpy_fromfb(dst, src, c);
+		dst += c;
+		src += c;
 
 		if (copy_to_user(buf, buffer, c)) {
 			err = -EFAULT;
@@ -772,9 +764,9 @@ fb_write(struct file *file, const char __user *buf, size_t count, 
loff_t *ppos)
 	struct inode *inode = file->f_path.dentry->d_inode;
 	int fbidx = iminor(inode);
 	struct fb_info *info = registered_fb[fbidx];
-	u32 *buffer, *src;
-	u32 __iomem *dst;
-	int c, i, cnt = 0, err = 0;
+	u8 *buffer, *src;
+	u8 __iomem *dst;
+	int c, cnt = 0, err = 0;
 	unsigned long total_size;
 
 	if (!info || !info->screen_base)
@@ -811,7 +803,7 @@ fb_write(struct file *file, const char __user *buf, size_t count, 
loff_t *ppos)
 	if (!buffer)
 		return -ENOMEM;
 
-	dst = (u32 __iomem *) (info->screen_base + p);
+	dst = (u8 __iomem *) (info->screen_base + p);
 
 	if (info->fbops->fb_sync)
 		info->fbops->fb_sync(info);
@@ -825,19 +817,9 @@ fb_write(struct file *file, const char __user *buf, size_t count, 
loff_t *ppos)
 			break;
 		}
 
-		for (i = c >> 2; i--; )
-			fb_writel(*src++, dst++);
-
-		if (c & 3) {
-			u8 *src8 = (u8 *) src;
-			u8 __iomem *dst8 = (u8 __iomem *) dst;
-
-			for (i = c & 3; i--; )
-				fb_writeb(*src8++, dst8++);
-
-			dst = (u32 __iomem *) dst8;
-		}
-
+		fb_memcpy_tofb(dst, src, c);
+		dst += c;
+		src += c;
 		*ppos += c;
 		buf += c;
 		cnt += c;
diff --git a/include/linux/fb.h b/include/linux/fb.h
index f0268de..7fca3dc 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -931,6 +931,8 @@ static inline struct apertures_struct *alloc_apertures(unsigned int 
max_num) {
 #define fb_writel sbus_writel
 #define fb_writeq sbus_writeq
 #define fb_memset sbus_memset_io
+#define fb_memcpy_fromfb sbus_memcpy_fromio
+#define fb_memcpy_tofb sbus_memcpy_toio
 
 #elif defined(__i386__) || defined(__alpha__) || defined(__x86_64__) || 
defined(__hppa__) || defined(__sh__) || defined(__powerpc__) || defined(__avr32__) || 
defined(__bfin__)
 
@@ -943,6 +945,8 @@ static inline struct apertures_struct *alloc_apertures(unsigned int 
max_num) {
 #define fb_writel __raw_writel
 #define fb_writeq __raw_writeq
 #define fb_memset memset_io
+#define fb_memcpy_fromfb memcpy_fromio
+#define fb_memcpy_tofb memcpy_toio
 
 #else
 
@@ -955,6 +959,8 @@ static inline struct apertures_struct *alloc_apertures(unsigned int 
max_num) {
 #define fb_writel(b,addr) (*(volatile u32 *) (addr) = (b))
 #define fb_writeq(b,addr) (*(volatile u64 *) (addr) = (b))
 #define fb_memset memset
+#define fb_memcpy_fromfb memcpy
+#define fb_memcpy_tofb memcpy
 
 #endif
 
-- 
1.7.2.3
