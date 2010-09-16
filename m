Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab0IPGFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 02:05:08 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56504 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab0IPGFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 02:05:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ekW+xbP7pOJBBqME+e/+y0PIvJ1Gza9VDSIXGeGFcGmd+ZHC+9LnVqMTzeG+RtHUCI
         Ek/ahF5JhF+AUCYCCcnl+1cfPZHl7yXYygqGoMDYhsvD4B9mmwa3Ewh8atYA5gNbbepB
         t/WDbBVqFGZGIZ0FuqvUWVr9AdBXn5jCrQN4w=
Date: Wed, 15 Sep 2010 23:04:56 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: Re: Build regressions/improvements in v2.6.36-rc4
Message-ID: <20100916060456.GA29795@core.coreip.homeip.net>
References: <alpine.DEB.2.00.1009152121020.23269@ayla.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1009152121020.23269@ayla.of.borg>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Wed, Sep 15, 2010 at 09:29:35PM +0200, Geert Uytterhoeven wrote:
> 	drivers/input/gameport/lightning.c: error: invalid operands to binary & (have 'void *' and 'int'):  => 177, 141, 86
> 	drivers/input/gameport/ns558.c: error: invalid operands to binary & (have 'void *' and 'int'):  => 84
> 	drivers/input/touchscreen/mk712.c: error: invalid operands to binary | (have 'void *' and 'int'):  => 129

I think these (and a few more) should be fixed for the patch below (not
even compiled)...

Thanks.

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

 arch/cris/include/asm/io.h |   44 ++++++++++++++++++++++++++++++++------------
 1 files changed, 32 insertions(+), 12 deletions(-)


diff --git a/arch/cris/include/asm/io.h b/arch/cris/include/asm/io.h
index 32567bc..e248589 100644
--- a/arch/cris/include/asm/io.h
+++ b/arch/cris/include/asm/io.h
@@ -127,18 +127,38 @@ static inline void writel(unsigned int b, volatile void __iomem *addr)
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
+		cris_iops->write_io(port, (void *)(unsigned long)value,	\
+				    sizeof(type), 1);			\
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
+		cris_iops->write_io(port,				\
+				(void *)addr, sizeof(type), count);	\
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
