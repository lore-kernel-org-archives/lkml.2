Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab0ITA2u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 20:28:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64545 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab0ITA2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 20:28:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gDKLqLUxlwJfhaB2u6MYrmdwrGt9QsYHN+qwlMeAAi/hhEMBbnGpKUxdKs3naSxuA6
         d8EzJx57AqqnibwoTau+zUPH3nxYCUfK3o8JgiS0juAcyHdNuqWZAlEFADl3Kod+tZKa
         wHkEKL1F8pY9pqj33eDhj3csgyZ3xKhpW7UUI=
Date: Sun, 19 Sep 2010 17:28:41 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: Re: Build regressions/improvements in v2.6.36-rc4
Message-ID: <20100920002841.GF6565@core.coreip.homeip.net>
References: <alpine.DEB.2.00.1009152121020.23269@ayla.of.borg>
 <20100916060456.GA29795@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916060456.GA29795@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 11:04:56PM -0700, Dmitry Torokhov wrote:
> Hi Geert,
> 
> On Wed, Sep 15, 2010 at 09:29:35PM +0200, Geert Uytterhoeven wrote:
> > 	drivers/input/gameport/lightning.c: error: invalid operands to binary & (have 'void *' and 'int'):  => 177, 141, 86
> > 	drivers/input/gameport/ns558.c: error: invalid operands to binary & (have 'void *' and 'int'):  => 84
> > 	drivers/input/touchscreen/mk712.c: error: invalid operands to binary | (have 'void *' and 'int'):  => 129
> 
> I think these (and a few more) should be fixed for the patch below (not
> even compiled)...
> 

I think this version should be a bit better (still not compiled).

-- 
Dmitry

[CRIS] Convert io macros into inline functions

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

This should silence warnings such as:

drivers/input/gameport/lightning.c: error: invalid operands to binary &
(have 'void *' and 'int'):  => 177, 141, 86
drivers/input/gameport/ns558.c: error: invalid operands to binary &
(have 'void *' and 'int'):  => 84
drivers/input/touchscreen/mk712.c: error: invalid operands to binary |
(have 'void *' and 'int'):  => 129

Marco argument expansion is a bitch...

This also fixes outsl - size of an 'int' is 4 and not 3.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 arch/cris/include/asm/io.h |   44 +++++++++++++++++++++++++++++++-------------
 1 files changed, 31 insertions(+), 13 deletions(-)


diff --git a/arch/cris/include/asm/io.h b/arch/cris/include/asm/io.h
index 32567bc..765c6e2 100644
--- a/arch/cris/include/asm/io.h
+++ b/arch/cris/include/asm/io.h
@@ -10,7 +10,7 @@ struct cris_io_operations
 	u32 (*read_mem)(void *addr, int size);
 	void (*write_mem)(u32 val, int size, void *addr);
 	u32 (*read_io)(u32 port, void *addr, int size, int count);
-	void (*write_io)(u32 port, void *addr, int size, int count);
+	void (*write_io)(u32 port, const void *addr, int size, int count);
 };
 
 #ifdef CONFIG_PCI
@@ -127,18 +127,36 @@ static inline void writel(unsigned int b, volatile void __iomem *addr)
  */
 
 #define IO_SPACE_LIMIT 0xffff
-#define inb(port) (cris_iops ? cris_iops->read_io(port,NULL,1,1) : 0)
-#define inw(port) (cris_iops ? cris_iops->read_io(port,NULL,2,1) : 0)
-#define inl(port) (cris_iops ? cris_iops->read_io(port,NULL,4,1) : 0)
-#define insb(port,addr,count) (cris_iops ? cris_iops->read_io(port,addr,1,count) : 0)
-#define insw(port,addr,count) (cris_iops ? cris_iops->read_io(port,addr,2,count) : 0)
-#define insl(port,addr,count) (cris_iops ? cris_iops->read_io(port,addr,4,count) : 0)
-#define outb(data,port) if (cris_iops) cris_iops->write_io(port,(void*)(unsigned)data,1,1)
-#define outw(data,port) if (cris_iops) cris_iops->write_io(port,(void*)(unsigned)data,2,1)
-#define outl(data,port) if (cris_iops) cris_iops->write_io(port,(void*)(unsigned)data,4,1)
-#define outsb(port,addr,count) if(cris_iops) cris_iops->write_io(port,(void*)addr,1,count)
-#define outsw(port,addr,count) if(cris_iops) cris_iops->write_io(port,(void*)addr,2,count)
-#define outsl(port,addr,count) if(cris_iops) cris_iops->write_io(port,(void*)addr,3,count)
+
+#define BUILDIO(bwl, bw, type)						\
+static inline void out##bwl(type value, int port)			\
+{									\
+	if (cris_iops)							\
+		cris_iops->write_io(port, &value, sizeof(type), 1);	\
+}									\
+									\
+static inline type in##bwl(int port)					\
+{									\
+	return cris_iops ?						\
+		cris_iops->read_io(port, NULL, sizeof(type), 1) : 0;	\
+}									\
+									\
+static inline void outs##bwl(int port,					\
+			     const void *addr, unsigned long count)	\
+{									\
+	if (cris_iops)							\
+		cris_iops->write_io(port, addr, sizeof(type), count);	\
+}									\
+									\
+static inline void ins##bwl(int port, void *addr, unsigned long count)	\
+{									\
+	if (cris_iops)							\
+		cris_iops->read_io(port, addr, sizeof(type), count);	\
+}
+
+BUILDIO(b, unsigned char)
+BUILDIO(w, unsigned short)
+BUILDIO(l, unsigned int)
 
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
