Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab2IPUWE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 16:22:04 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:53042 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752575Ab2IPUWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 16:22:02 -0400
X-Greylist: delayed 2000 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Sep 2012 16:22:02 EDT
Message-ID: <505626A8.8040806@mimc.co.uk>
Date: Sun, 16 Sep 2012 20:21:12 +0100
From: Mark Jackson <mpfj-list@mimc.co.uk>
Organization: Mercury HMI Ltd
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: Advice on mmap() "feature"
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies if this is the wrong place to post this query.  Please feel 
free to redirect me to the correct place.

I have come across a weird (but documented [1]) "feature" of mmap(), 
which is:-

"The mmap()function adds an extra reference to the file associated with 
the file descriptor fildeswhich is not removed by a subsequent close() 
on that file descriptor. This reference is removed when there are no 
more mappings to the file."

In my embedded application, this is resulting in the consumption of 
available file descriptors.

As an example I wrote the following test running on Ubuntu 11.04 64bit.

#include <fcntl.h>
#include <errno.h>
#include <stdio.h>
#include <sys/mman.h>

#define FRAM_SIZE            (64 * 1024)
#define FRAM_BASE_ADDRESS    0x00000000

int main(int argc, char **argv)
{
     int i;
     for (i = 0; i < 5000; i++)
     {
         // open the fram device
         int m_fdFram = open("/dev/mem", O_RDWR | O_SYNC);
         if (m_fdFram < 0)
         {
             printf("could not open /dev/mem, exiting with errno %d\n", 
errno);
             return 0;
         }

         // map the device to memory
         char *m_pFram = (char *)mmap(    0,
                                         FRAM_SIZE * sizeof(unsigned short),
                                         PROT_READ | PROT_WRITE,
                                         MAP_SHARED,
                                         m_fdFram,
                                         FRAM_BASE_ADDRESS);
         if ((int)m_pFram == -1)
         {
             close(m_fdFram);
             m_fdFram = -1;
             printf("could not mmap, exiting with errno %d\n", errno);
             return 0;
         }

         // now remove the mapping
         if (m_pFram)
         munmap(m_pFram, FRAM_SIZE);

         if (m_fdFram != -1)
             close(m_fdFram);
     }

     puts("sleeping");
     sleep(50);

     return 0;
}

$ gcc test.c -o test
$ cat /proc/sys/fs/file-nr
10016    0    387704
$ ./test &
sleeping
$ cat /proc/sys/fs/file-nr
15008    0    387704

As can be seen, when I run the test, it consumes 5000 fd's, but only 
releases them when the application closes, 50 seconds later.

My application is designed to run for many years without a restart, 
spawning other tasks to do various system jobs, these fd's never seem to 
get released, and eventually the system runs out of available fd's.

So my questions are:-

(a) Since all the mappings have been removed, so why don't the fd's get 
released ?

(b) Can I somehow force some form of garbage collection to allow the 
fd's to be freed up ?

Again, apologies if this is the wrong place to ask, but I'm out of ideas.

Thanks in advance
Mark JACKSON

[1] http://pubs.opengroup.org/onlinepubs/007908775/xsh/mmap.html
