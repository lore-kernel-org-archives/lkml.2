Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab1KWLcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 06:32:00 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:4051 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594Ab1KWLb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 06:31:59 -0500
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Nov 2011 06:31:59 EST
X-Mailer: QUALCOMM Windows Eudora Version 7.1.0.9
Date: Wed, 23 Nov 2011 12:25:46 +0100
To: linux-kernel@vger.kernel.org
From: "N. Coesel" <nico@nctdev.nl>
Subject: Fast memcpy patch
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Message-ID: <CPSMTPM-CMT101y332G000633f8@CPSMTPM-CMT101.kpnxchange.com>
X-OriginalArrivalTime: 23 Nov 2011 11:25:46.0635 (UTC) FILETIME=[A52D7DB0:01CCA9D2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear readers,
I noticed the Linux kernel still uses a byte-by-byte copy method for 
memcpy. Since most memory allocations are aligned to the integer size 
of a cpu it is often faster to copy by using the CPU's native word 
size. The patch below does that. The code is already at work in many 
16 and 32 bit embedded products. It should also work for 64 bit 
platforms. So far I only tested 16 and 32 bit platforms.


--- lib/string.c.orig   2010-08-20 20:55:55.000000000 +0200
+++ lib/string.c        2011-11-23 12:29:02.000000000 +0100
@@ -565,14 +565,47 @@ EXPORT_SYMBOL(memset);
   * You should not use this function to access IO space, use memcpy_toio()
   * or memcpy_fromio() instead.
   */
-void *memcpy(void *dest, const void *src, size_t count)
+
+void *memcpy(void *dst, const void *src, size_t length)
  {
-       char *tmp = dest;
-       const char *s = src;
+       void *p=dst;

-       while (count--)
-               *tmp++ = *s++;
-       return dest;
+       //check alignment
+       if (( (int) dst & (sizeof(int) -1)) != ( (int) src & 
(sizeof(int) -1) ))
+               {
+               //unaligned. This will never align so copy byte-by-byte
+               goto copyrest;
+               }
+
+       //seek aligment (lower bits should become 0). Because
+       //we already tested the lower bits are equal, we only need
+       //to test source or destination for matching alignment.
+       while ( (length !=0) && (((int) src & (sizeof(int)-1 ))!=0) )
+               {
+
+                *((char*) dst++)=*((char*)src++);
+               length--;
+               }
+
+       //copy words
+       while(length> (sizeof(int)-1) )
+               {
+               *((int*) dst)=*((int*)src);
+               dst+=sizeof(int);
+               src+=sizeof(int);
+               length-=sizeof(int);
+               }
+
+copyrest:
+
+       //now copy the rest byte-by-byte
+       while(length !=0)
+               {
+               *((char*) dst++)=*((char*) src++);
+               length--;
+               }
+
+       return p;
  }
  EXPORT_SYMBOL(memcpy);
  #endif


Signed of by: Nico Coesel nico@nctdev.nl


o---------------------------------------------------------------o
|                       N C T  Developments                     |
|Innovative embedded solutions                                  |
o---------------------------------------------------------------o 

