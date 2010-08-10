Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803Ab0HJT7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 15:59:13 -0400
Received: from edu-smtp-02.edutel.nl ([88.159.1.176]:41509 "EHLO
	edu-smtp-02.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab0HJT7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 15:59:10 -0400
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Aug 2010 15:59:10 EDT
Message-ID: <4C61AD7A.7040400@neli.hopto.org>
Date: Tue, 10 Aug 2010 21:50:18 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Why is get_user_pages so slow?
Content-Type: multipart/mixed;
 boundary="------------080303060705060501070609"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080303060705060501070609
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

Why is get_user_pages much slower than taking the faults? (I would 
expect it to be faster).

Attached example program first mallocs a piece of memory (64MB in this 
case) then reads it "to take the faults". Afterwards, it uses mmap with 
MAP_POPULATE to "speed up" and not to have to take the faults, but have 
everything mapped in one go. I think mmap is using get_user_pages in 
this case.

$ ./memspeed
malloc took 0 msecs
read took 14 msecs
write took 0 msecs
free took 1 msecs
mmap took 45 msecs
munmap took 5 msecs

Using MAP_POPULATE is 3 times as slow as the 'stupid' implementation! 
I'm running a Core 2 duo e6300 system with linux 2.6.28.4.

Am I doing something wrong? MAP_POPULATE seems a bit of a joke to me.

Thanks,

Micha

--------------080303060705060501070609
Content-Type: text/x-csrc;
 name="memspeed.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="memspeed.c"

#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/time.h>

#define SIZE (64 << 20)

unsigned tv_msecs(struct timeval *tvs, struct timeval *tve)
{
        return (tve->tv_sec - tvs->tv_sec) * 1000 +
                (tve->tv_usec - tvs->tv_usec) / 1000;
}

int main(void)
{
        struct timeval tvs, tve;
        void *buf;
        int *p, *e, i;

        gettimeofday(&tvs, NULL);
        buf = malloc(SIZE);
        gettimeofday(&tve, NULL);
        printf("malloc took %d msecs\n", tv_msecs(&tvs, &tve));

        gettimeofday(&tvs, NULL);
        for (p = buf, e = buf + SIZE; p < e; p += 0x1000)
                i = *(volatile int*)p;
        gettimeofday(&tve, NULL);
        printf("read took %d msecs\n", tv_msecs(&tvs, &tve));

        gettimeofday(&tvs, NULL);
        for (p = buf, e = buf + SIZE; p < e; p += 0x1000)
                *(volatile int*)p = 0xaa55aa55;
        gettimeofday(&tve, NULL);
        printf("write took %d msecs\n", tv_msecs(&tvs, &tve));

        gettimeofday(&tvs, NULL);
        free(buf);
        gettimeofday(&tve, NULL);
        printf("free took %d msecs\n", tv_msecs(&tvs, &tve));

        gettimeofday(&tvs, NULL);
        buf = mmap(NULL, SIZE, PROT_READ | PROT_WRITE, MAP_PRIVATE |
                MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
        gettimeofday(&tve, NULL);
        printf("mmap took %d msecs\n", tv_msecs(&tvs, &tve));

        gettimeofday(&tvs, NULL);
        munmap(buf, SIZE);
        gettimeofday(&tve, NULL);
        printf("munmap took %d msecs\n", tv_msecs(&tvs, &tve));

        return 0;
}

--------------080303060705060501070609--
