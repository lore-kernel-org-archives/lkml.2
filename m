Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab0IQNAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:00:44 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41395 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab0IQNAn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:00:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=ZBV7ESbOMFTCn0CKT2+wNDAfDC6QS3Oey2i5fSzSjY+HyCIy6PeXQbKGWcH7J4w08P
         6lLrJ8j2Z3Kg0MZyBrj3PLk2qPXo4QgrZeC5bOsiOedtNocGVcNn6rShnMiD0VYrm2bI
         +cbA8xb3Mc884uR5MFoWNxqjDDGN2IM53Jhn0=
MIME-Version: 1.0
In-Reply-To: <AANLkTim6d0KeuegVy2Z6UrSiXDnoymav1b9K7btsByi-@mail.gmail.com>
References: <AANLkTim6d0KeuegVy2Z6UrSiXDnoymav1b9K7btsByi-@mail.gmail.com>
Date: Fri, 17 Sep 2010 18:30:42 +0530
Message-ID: <AANLkTi=5aEL=YWihgasexK17_oq9uFq7gG+em9ThWk-e@mail.gmail.com>
Subject: mmap issue.
From: naveen yadav <yad.naveen@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I am facing some issue while using mmap .

Issue 1.msync(ptr, PageSize, MS_ASYNC) if i pass MS_SYNC it fail with
bad option.
Issue 2. If i run the above program on target(ARM). the value is not changing

parent leaving critical section: -369098746
parent leaving critical section: -369098746
msync completed successfully
parent leaving critical section: -369098746
parent entered critical section -369098746



Thanks

But same program work well on Host machine.

parent leaving critical section: 12344
parent leaving critical section: 1000
msync completed successfully
parent leaving critical section: 1000
parent leaving critical section: 1000



#include <stdio.h>
#include <semaphore.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <errno.h>
#define SEM_NAME "mysem"
#define _SC_PAGE_SIZE 4096
int count = 100;


int main()
{
    int i, nloop = 1;
    sem_t *mutex;
    int fd, *ptr=NULL;
    int PageSize;
    fd = open ("/dev/mem", O_RDWR|O_SYNC);
    if (fd < 0) {
        printf("Failed while opening the memory descriptor\n");
        printf("Error is = %d\n", errno);
    }
    printf("\n============ PRIOR MAPPING ===========\n");
    char comm[50];
    sprintf(comm,"cat /proc/%d/maps",(int)getpid());
    system(comm);
    printf("============== PRIOR MAPPING =========\n\n");

/*    if ( (PageSize = sysconf(_SC_PAGE_SIZE)) < 0) {
       printf("sysconf() Error=");
       return -1;
   }
*/
       PageSize=4096;

    printf("\n============ PRIOR MAPPIN1 ===========\n");
    ptr = (int*)(mmap(NULL, PageSize, PROT_READ|PROT_WRITE,
MAP_SHARED, fd, 0));

    printf("\n============ PRIOR MAPPIN2 ===========\n");
    if (ptr == MAP_FAILED) {
        printf("MMAP failed\n");
        printf("value of errno is %d\n", errno);
        exit(0);
    }


  printf ("[%s] Mapped_buff_addr: [%8p]\n", __FUNCTION__, ptr);
    printf("\n============ NEW MAPPING ===========\n");
    //char comm[20];
    sprintf(comm,"cat /proc/%d/maps",(int)getpid());
    system(comm);
    printf("============== NEW MAPPING =========\n\n");
    printf("parent leaving critical section: %d\n", *ptr);
    *ptr = 1000;
    printf("parent leaving critical section: %d\n", *ptr);
    mutex = sem_open((SEM_NAME), O_CREAT | O_EXCL, S_IRWXU, 1);
    sem_unlink(SEM_NAME);
    setbuf(stdout, NULL); /* stdout is unbuffered */
    if (msync(ptr, PageSize, MS_ASYNC) < 0) { //naveen change to Async
        printf("Value of errno is %d\n", errno);
        printf("Value of page size is %d\n", PageSize);
        perror ("msync failed:");
        exit(0);
    }
    else {
        printf("msync completed successfully\n");
    }
    /* parent */
    for (i = 0; i < nloop; i++) {
        sem_wait(mutex);
       printf("parent leaving critical section: %d\n", *ptr);
        sleep(2);
        printf("parent leaving critical section: %d\n", *ptr);
        sem_post(mutex);
    }
    close(fd);
    return 0;
}
