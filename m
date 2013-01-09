Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934120Ab3AIUtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:49:41 -0500
Received: from mail.kernel.org ([198.145.19.201]:43937 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933810Ab3AIUlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:41:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Corey Minyard <cminyard@mvista.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Mikael Starvik <starvik@axis.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 114/123] CRIS: fix I/O macros
Date: Wed,  9 Jan 2013 12:35:53 -0800
Message-Id: <20130109201513.025462911@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Minyard <cminyard@mvista.com>

commit c24bf9b4cc6a0f330ea355d73bfdf1dae7e63a05 upstream.

The inb/outb macros for CRIS are broken from a number of points of view,
missing () around parameters and they have an unprotected if statement
in them.  This was breaking the compile of IPMI on CRIS and thus I was
being annoyed by build regressions, so I fixed them.

Plus I don't think they would have worked at all, since the data values
were missing "&" and the outsl had a "3" instead of a "4" for the size.
>From what I can tell, this stuff is not used at all, so this can't be
any more broken than it was before, anyway.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <starvik@axis.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/cris/include/asm/io.h |   39 +++++++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 6 deletions(-)

--- a/arch/cris/include/asm/io.h
+++ b/arch/cris/include/asm/io.h
@@ -133,12 +133,39 @@ static inline void writel(unsigned int b
 #define insb(port,addr,count) (cris_iops ? cris_iops->read_io(port,addr,1,count) : 0)
 #define insw(port,addr,count) (cris_iops ? cris_iops->read_io(port,addr,2,count) : 0)
 #define insl(port,addr,count) (cris_iops ? cris_iops->read_io(port,addr,4,count) : 0)
-#define outb(data,port) if (cris_iops) cris_iops->write_io(port,(void*)(unsigned)data,1,1)
-#define outw(data,port) if (cris_iops) cris_iops->write_io(port,(void*)(unsigned)data,2,1)
-#define outl(data,port) if (cris_iops) cris_iops->write_io(port,(void*)(unsigned)data,4,1)
-#define outsb(port,addr,count) if(cris_iops) cris_iops->write_io(port,(void*)addr,1,count)
-#define outsw(port,addr,count) if(cris_iops) cris_iops->write_io(port,(void*)addr,2,count)
-#define outsl(port,addr,count) if(cris_iops) cris_iops->write_io(port,(void*)addr,3,count)
+static inline void outb(unsigned char data, unsigned int port)
+{
+	if (cris_iops)
+		cris_iops->write_io(port, (void *) &data, 1, 1);
+}
+static inline void outw(unsigned short data, unsigned int port)
+{
+	if (cris_iops)
+		cris_iops->write_io(port, (void *) &data, 2, 1);
+}
+static inline void outl(unsigned int data, unsigned int port)
+{
+	if (cris_iops)
+		cris_iops->write_io(port, (void *) &data, 4, 1);
+}
+static inline void outsb(unsigned int port, const void *addr,
+			 unsigned long count)
+{
+	if (cris_iops)
+		cris_iops->write_io(port, (void *)addr, 1, count);
+}
+static inline void outsw(unsigned int port, const void *addr,
+			 unsigned long count)
+{
+	if (cris_iops)
+		cris_iops->write_io(port, (void *)addr, 2, count);
+}
+static inline void outsl(unsigned int port, const void *addr,
+			 unsigned long count)
+{
+	if (cris_iops)
+		cris_iops->write_io(port, (void *)addr, 4, count);
+}
 
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem


