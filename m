Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab0FSLFv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 07:05:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38289 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab0FSLFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 07:05:50 -0400
Message-ID: <4C1CA49B.7020104@colorfullife.com>
Date: Sat, 19 Jun 2010 13:06:03 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>
Subject: Re: 2.6.35-rc3 deadlocks on semaphore operations
References: <alpine.DEB.2.00.1006180940140.11575@router.home>
In-Reply-To: <alpine.DEB.2.00.1006180940140.11575@router.home>
Content-Type: multipart/mixed;
 boundary="------------090108050203040708000600"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090108050203040708000600
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 06/18/2010 04:49 PM, Christoph Lameter wrote:
> linux-2.6$ strace -p21561
> Process 21561 attached - interrupt to quit
> semop(32768, {{0, -1, SEM_UNDO}}, 1
>
> linux-2.6$ strace -p21751
> Process 21751 attached - interrupt to quit
> semop(32768, {{0, -1, SEM_UNDO}}, 1
>
> linux-2.6$ strace -p21792
> Process 21792 attached - interrupt to quit
> semop(32768, {{0, -1, SEM_UNDO}}, 1
>
> linux-2.6$ strace -p21793
> Process 21793 attached - interrupt to quit
> semop(32768, {{0, -1, SEM_UNDO}}, 1
>
>    
What are the semaphore values?

Could you run
$ ipcs
$ cat /proc/sysvipc/sem
$ ./getall 32768 -v

getall is attached.

--
     Manfred


--------------090108050203040708000600
Content-Type: text/plain;
 name="getall.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="getall.c"

/*
 * Copyright (C) 1999 by Manfred Spraul.
 * 
 * Redistribution of this file is permitted under the terms of the GNU 
 * General Public License (GPL)
 * $Header: /home/manfred/cvs-tree/manfred/ipcsem/getall.c,v 1.2 2001/02/27 15:44:32 manfred Exp $
 */

#include <sys/sem.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <assert.h>

#define TRUE	1
#define FALSE	0

union semun {
	int val;
	struct semid_ds *buf;
	unsigned short int *array;
	struct seminfo* __buf;
};


int main(int argc,char** argv)
{
	int id;
	int key;
	int res;
	int nsems;

	printf("getall <id> [-v]\n");
	if(argc < 2 || argc > 3) {
		printf("Invalid parameters.\n");
		return 1;
	}
	if (argc == 3 && strcmp(argv[2], "-v")) {
		printf("Invalid parameters.\n");
		return 1;
	}
	key = atoi(argv[1]);
	if(key < 0) {
		printf("Invalid parameters.\n");
		return 1;
	}
/*	id = semget(key,1,0);
	if(id == -1) {
		printf(" findkey() failed.\n");
		return 1;
	} */
	id = key;
	{
		union semun arg;
		struct semid_ds info;

		arg.buf = &info;
		res = semctl(id,0,2,arg);

		if(res==-1) {
			printf("semctl(2) failed (%d).\n",errno);
			return 1;
		}
		nsems = info.sem_nsems;
		printf("found %d semaphores.\n",nsems);
	}
	{
		union semun arg;
		unsigned short *pv;
		int i;
		pv = malloc(sizeof(unsigned short)*nsems);
		arg.array = pv;
		res = semctl(id,nsems, GETALL, arg);
		if(res==-1) {
			printf("GETALL failed.\n");
			return 1;
		}
		for(i=0;i<nsems;i++) {
			if (argc == 3) {
				printf(" %3d: %3d (cnt %3d zcnt %3d)\n",
					i, pv[i], semctl(id, i, GETNCNT),
					semctl(id, i, GETZCNT));
			} else {
				if(i%16 == 0)
					printf("\n 0x%4.4x:",i);
				printf(" %3d",pv[i]);
			}
		}
		printf("\n");
	}
	return 0;
}

--------------090108050203040708000600--
