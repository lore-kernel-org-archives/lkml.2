Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab0LEGuo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 01:50:44 -0500
Received: from mx1.brouhaha.com ([64.62.206.9]:43394 "EHLO mx1.brouhaha.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab0LEGun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 01:50:43 -0500
X-Greylist: delayed 615 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Dec 2010 01:50:43 EST
Message-ID: <4CFB33DA.1070306@brouhaha.com>
Date: Sat, 04 Dec 2010 22:40:26 -0800
From: Eric Smith <eric@brouhaha.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: mmap to address zero with MAP_FIXED returns ENOPERM for non-root
 users?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm doing some work with binary translation of an executable from a 
non-x86 microcontroller to run in an x86 process, and need to have part 
of the memory map match that of the microcontroller.  This includes 
having some memory at virtual address zero.  I know why this isn't 
usually a good idea, and why mmap() won't give that out without MAP_FIXED.

However, when I try an anonymous mmap() to virtual address zero with 
MAP_FIXED, I get ENOPERM unless running as superuser.

Is this deliberate?  I really don't want to have to run my translated 
executable as superuser.

strace shows the system call, so I don't think glibc is the culprit.

I'm running Fedora 14 with kernel 2.6.35.6-48.fc14.x86_64.  I'm 
compiling with gcc 4.5.1 with the -m32 option to get a 32-bit 
executable, which I'm then running on the 64-bit kernel.  However, I 
seem to get the same behavior if I build a 64-bit executable.  My 
trivial test program is below.

Thanks!
Eric




#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>

int main (int argc, char *argv [])
{
   void *p;
   int fd = -1;
   int offset = 0;

   uint32_t addr;
   uint32_t length;

   if (argc != 3)
     {
       fprintf (stderr, "usage: %s <addr> <length>\n", argv [0]);
       return 1;
     }

   addr = strtoul (argv [1], NULL, 0);
   length = strtoul (argv [2], NULL, 0);

   printf ("attempting to create anonymous mapping at addr 0x%08x, 
length 0x%08x\n", addr, length);

   p = mmap ((void *) addr,
         length,
         PROT_READ | PROT_WRITE,
         MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED,
         fd,
         offset);

   if (p == MAP_FAILED)
     {
       perror ("mapping failed");
       return 2;
     }

   printf ("mapped at address 0x%08x\n", (uint32_t) p);
   return 0;
}

