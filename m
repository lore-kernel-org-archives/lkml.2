Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab0JRMvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 08:51:18 -0400
Received: from bohort.kerlabs.com ([90.80.97.101]:47144 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab0JRMvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 08:51:17 -0400
Message-ID: <4CBC42C2.4040604@kerlabs.com>
Date: Mon, 18 Oct 2010 14:51:14 +0200
From: =?UTF-8?B?TWF0dGhpZXUgRmVydHLDqQ==?= <matthieu.fertre@kerlabs.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_bohort-9784-1287406239-0001-2"
To: Darren Hart <dvhart@linux.intel.com>
CC: Louis Rilling <louis.rilling@kerlabs.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RESEND PATCH] futex: fix key reference counter in case of requeue.
References: <1287055805-18233-1-git-send-email-louis.rilling@kerlabs.com> <4CB8A7EB.6050303@linux.intel.com>
In-Reply-To: <4CB8A7EB.6050303@linux.intel.com>
X-Enigmail-Version: 1.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-9784-1287406239-0001-2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hi Darren,

Le 15/10/2010 21:13, Darren Hart a écrit :
> On 10/14/2010 04:30 AM, Louis Rilling wrote:
>> From: Matthieu Fertré<matthieu.fertre@kerlabs.com>
> 
> Hi Matthew,
> 
>>
>> This patch ensures that we are referring to the right key when dropping
>> reference for the futex_wait operation.
>>
>> The following scenario explains a typical case where the bug was
>> happening:
>>
>> Process P calls futex_wait() on futex identified by 'key1'. 2 references
>> are taken on this key: one for the struct futex_q itself, and one for the
>> futex_wait operation.
>> If now, process P is requeued on a futex identified by 'key2', its
>> futex_q->key is updated from 'key1' to 'key2' and a reference is got
>> to 'key2' and one is dropped to 'key1'.
>> Later, another process calls futex_wake(): it gets a reference to
>> 'key2', wakes process P, and drops reference to 'key2'.
>> Once process P is woken up, it should unqueue, drop reference to 'key2'
>> (the one referring to the futex_q, this is done in unqueue_me())
>> and to 'key1' (the one referring to futex_wait operation). Without this
>> patch it drops reference to 'key2' instead of 'key1'.
> 
> Nice catch. How did this manifest itself? Did you catch it just by code
> inspection?


I found it while testing the distributed implementation of futex in
Kerrighed (www.kerrighed.org).

After deeply looking, I noticed that the bug comes from vanilla linux
kernel 2.6.30 (the one on which current version of Kerrighed is based).
Then I checked if the bug still existed in latest linux rc or if there
were some bugfixes.

I have attached the test that reveals the bug on my system. The test
runs some basic wait/wake/requeue scenario on futex "hosted" in a sysv
shared memory segment. It is composed of one executable and 2 scripts
that are to be used with LTP. To run it without LPT, you can replace
calls to tst_resm/tst_brkm with echo in the shell scripts.

Without debugging facilities, it may BUG while destroying the shared
segment. As far as I remember, with some kernel hacking features
enabled, it was complaining in the kernel log, but there was no crash
and I don't remember exactly about what it complains.

> 
> I've been trying to develop a futex test suite to catch issues with the
> futex implementation, as well as to test any changes made to avoid
> regressions. Mind having a look?
> 
> http://git.kernel.org/?p=linux/kernel/git/dvhart/futextest.git;a=summary

I had already a git checkout for this futex test suite :)
It was not fitting to my tests since I was checking behavior of
distributed futex inside Kerrighed. (I need test done by separate
processes spreaded on different nodes accessing the futex through sysv
shared segments).

Regards,

Matthieu

> 
>> Signed-off-by: Matthieu Fertré<matthieu.fertre@kerlabs.com>
>> Signed-off-by: Louis Rilling<louis.rilling@kerlabs.com>
>> ---
>>   kernel/futex.c |    8 ++++++--
>>   1 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/futex.c b/kernel/futex.c
>> index 6a3a5fa..bed6717 100644
>> --- a/kernel/futex.c
>> +++ b/kernel/futex.c
>> @@ -1791,6 +1791,7 @@ static int futex_wait(u32 __user *uaddr, int
>> fshared,
>>       struct restart_block *restart;
>>       struct futex_hash_bucket *hb;
>>       struct futex_q q;
>> +    union futex_key key;
> 
> We should be able to do this properly without requiring an additional
> key variable. I think tglx has proposed a suitable fix - but it needs
> testing to avoid any subtle regressions.
> 


--=_bohort-9784-1287406239-0001-2
Content-Type: text/x-csrc; name="futex-shm-tool.c"; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="futex-shm-tool.c"

/*
 * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
 * Written by David Howells (dhowells@redhat.com)
 *
 * Copyright (C) 2010 Kerlabs - Matthieu Fertré
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version
 * 2 of the License, or (at your option) any later version.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/mman.h>
#include <asm/unistd.h>
#include <linux/futex.h>
#include <sys/time.h>

static inline int futex(int *uaddr, int op, int val,
			const struct timespec *utime, int *uaddr2, int val3)
{
	return syscall(__NR_futex, uaddr, op, val, utime, uaddr2, val3);
}

#define SYSERROR(X, Y)					\
do {							\
	if ((long)(X) == -1L) {				\
		perror(Y);				\
		exit(EXIT_FAILURE);			\
	}						\
} while(0)

int shmkey = 23;
int shmkey2 = 24;
int nr_wake = 1;
int nr_requeue = 1;
int bitset = 0;
int quiet = 0;
struct timespec utime;

void print_usage(const char* cmd)
{
	printf("%s -h: show this help\n", cmd);
}

void dowait(void)
{
	int shmid, ret, *f, n;
	struct timespec *timeout = NULL;

	shmid = shmget(shmkey, 4, IPC_CREAT|0666);
	SYSERROR(shmid, "shmget");

	f = shmat(shmid, NULL, 0);
	SYSERROR(f, "shmat");

	n = *f;

	if (utime.tv_sec)
		timeout = &utime;

	if (bitset) {
		if (!quiet)
			printf("WAIT_BITSET: %p{%x} bits: %x\n", f, n, bitset);
		ret = futex(f, FUTEX_WAIT_BITSET, n, timeout, NULL, bitset);
	} else {
		if (!quiet)
			printf("WAIT: %p{%x}\n", f, n);
		ret = futex(f, FUTEX_WAIT, n, timeout, NULL, 0);
	}
	SYSERROR(ret, "futex_wait");
	if (!quiet)
		printf("WAITED: %d\n", ret);

	ret = shmdt(f);
	SYSERROR(ret, "shmdt");
}

int dowake(void)
{
	int shmid, ret, *f, nr_proc;

	shmid = shmget(shmkey, 4, IPC_CREAT|0666);
	SYSERROR(shmid, "shmget");

	f = shmat(shmid, NULL, 0);
	SYSERROR(f, "shmat");

	(*f)++;

	if (bitset) {
		if (!quiet)
			printf("WAKE_BITSET: %p{%x} bits: %x\n", f, *f, bitset);
		ret = futex(f, FUTEX_WAKE_BITSET, nr_wake, NULL, NULL, bitset);
	} else {
		if (!quiet)
			printf("WAKE: %p{%x}\n", f, *f);
		ret = futex(f, FUTEX_WAKE, nr_wake, NULL, NULL, 0);
	}

	SYSERROR(ret, "futex_wake");
	if (!quiet)
		printf("WOKE: %d\n", ret);
	nr_proc = ret;

	ret = shmdt(f);
	SYSERROR(ret, "shmdt");

	if (!ret)
		ret = nr_proc;

	return ret;
}

int dorequeue(void)
{
	int shmid1, shmid2, ret, *f1, *f2, nr_proc;

	shmid1 = shmget(shmkey, 4, IPC_CREAT|0666);
	SYSERROR(shmid1, "shmget");

	shmid2 = shmget(shmkey2, 4, IPC_CREAT|0666);
	SYSERROR(shmid2, "shmget");

	f1 = shmat(shmid1, NULL, 0);
	SYSERROR(f1, "shmat");

	f2 = shmat(shmid2, NULL, 0);
	SYSERROR(f2, "shmat");

	/* requeue */
	ret = futex(f1, FUTEX_REQUEUE, nr_wake,
		    (const struct timespec *) (long) nr_requeue, f2, 0);
	SYSERROR(ret, "futex_requeue");

	if (!quiet)
		printf("WOKE or REQUEUED: %d\n", ret);
	nr_proc = ret;

	/* detaching shms */
	ret = shmdt(f1);
	SYSERROR(ret, "shmdt");

	ret = shmdt(f2);
	SYSERROR(ret, "shmdt");

	if (!ret)
		ret = nr_proc;

	return ret;
}

void badfutex(void)
{
	int *x;
	int ret;

	x = mmap(NULL, 16384, PROT_READ, MAP_PRIVATE|MAP_ANON, -1, 0);
	SYSERROR(x, "mmap");

	ret = futex(x, FUTEX_WAIT, 0, NULL, NULL, 0);
	SYSERROR(ret, "futex");
}

void deletekey(void)
{
	int shmid, ret;

	shmid = shmget(shmkey, 4, 0666);
	SYSERROR(shmid, "shmget");

	ret = shmctl(shmid, IPC_RMID, NULL);
	SYSERROR(ret, "shmctl(IPC_RMID)");

	if (!quiet)
		printf("SHM %d (id=%d) DELETED\n", shmkey, shmid);
}

void parse_args(int argc, char *argv[])
{
	int c;

	utime.tv_sec = 0;
	utime.tv_nsec = 0;

	while (1) {
		c = getopt(argc, argv, "hqb:k:K:r:t:w:");
		if (c == -1)
			break;

		switch (c) {
		case 'h':
			print_usage(argv[0]);
			exit(EXIT_SUCCESS);
			break;
		case 'q':
			quiet=1;
			break;

		case 'b':
			bitset = atoi(optarg);
			break;
		case 'k':
			shmkey = atoi(optarg);
			break;
		case 'K':
			shmkey2 = atoi(optarg);
			break;
		case 'r':
			nr_requeue = atoi(optarg);
			break;
		case 't':
			utime.tv_sec = atoi(optarg);
			break;
		case 'w':
			nr_wake = atoi(optarg);
			break;
		}
	}
}

int main(int argc, char **argv)
{
	char *action;
	int ret = 0;

	parse_args(argc, argv);

	if (argc - optind == 0) {
		print_usage(argv[0]);
		exit(EXIT_FAILURE);
	}

	action = argv[optind];

	if (!quiet)
		printf("Command: %s\n", action);

	if (strcmp(action, "badfutex") == 0)
		badfutex();

	else if (strcmp(action, "wait") == 0)
		dowait();

	else if (strcmp(action, "wake") == 0)
		ret = dowake();

	else if (strcmp(action, "requeue") == 0)
		ret = dorequeue();

	else if (strcmp(action, "delete") == 0)
		deletekey();

	else {
		fprintf(stderr, "Unknown command\n");
		print_usage(argv[0]);
		exit(EXIT_FAILURE);
	}

	exit(ret);
}

--=_bohort-9784-1287406239-0001-2
Content-Type: application/x-shellscript; name="futex_shm01.sh"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="futex_shm01.sh"

IyEvYmluL2Jhc2gKIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIwojIwojIyBDb3B5cmlnaHQg
KGMpIEtlcmxhYnMsIDIwMTAKIyMKIyMgVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7
ICB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQjb3IgbW9kaWZ5CiMjIGl0IHVuZGVyIHRo
ZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgYXMgcHVibGlzaGVk
IGJ5CiMjIHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb247IGVpdGhlciB2ZXJzaW9uIDIg
b2YgdGhlIExpY2Vuc2UsIG9yCiMjIChhdCB5b3VyIG9wdGlvbikgYW55IGxhdGVyIHZlcnNp
b24uCiMjCiMjIFRoaXMgcHJvZ3JhbSBpcyBkaXN0cmlidXRlZCBpbiB0aGUgaG9wZSB0aGF0
IGl0IHdpbGwgYmUgdXNlZnVsLCBidXQKIyMgV0lUSE9VVCBBTlkgV0FSUkFOVFk7IHdpdGhv
dXQgZXZlbiB0aGUgaW1wbGllZCB3YXJyYW50eSBvZiBNRVJDSEFOVEFCSUxJVFkKIyMgb3Ig
RklUTkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0UuICBTZWUgdGhlIEdOVSBHZW5lcmFs
IFB1YmxpYyBMaWNlbnNlCiMjIGZvciBtb3JlIGRldGFpbHMuCiMjCiMjIFlvdSBzaG91bGQg
aGF2ZSByZWNlaXZlZCBhIGNvcHkgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNl
CiMjIGFsb25nIHdpdGggdGhpcyBwcm9ncmFtOyAgaWYgbm90LCB3cml0ZSB0byB0aGUgRnJl
ZSBTb2Z0d2FyZQojIyBGb3VuZGF0aW9uLCBJbmMuLCA1OSBUZW1wbGUgUGxhY2UsIFN1aXRl
IDMzMCwgQm9zdG9uLCBNQSAwMjExMS0xMzA3IFVTQQojIwojIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjCiMKIyBGaWxlIDogICAgICAgIGZ1dGV4X3NobTAxCiMKIyBEZXNjcmlwdGlvbjog
IFRlc3QgYmFzaWMgb3BlcmF0aW9ucyBvbiBzb21lIGZ1dGV4ZXMgc3RvcmVkIG9uIFNITQoj
CiMgQXV0aG9yOiAgICAgICBNYXR0aGlldSBGZXJ0csOpLCBtYXR0aGlldS5mZXJ0cmVAa2Vy
bGFicy5jb20KIwoKc291cmNlIGBkaXJuYW1lICQwYC9saWJfZnV0ZXguc2gKCmZ1dGV4X3No
bTAxKCkKewogICAga2V5MT0kJAogICAga2V5Mj0kKCgkJCsxKSkKICAgIGJpdHM9NAogICAg
d3JvbmdiaXRzPTIKCiAgICAjIHdhaXQgZjEsIHdha2UgZjEKICAgIGZ1dGV4X3dhaXQgJGtl
eTEgYml0cwoKICAgIHNsZWVwIDQKCiAgICBmdXRleF93YWtlICRrZXkgJGJpdHMgMSAxCgog
ICAgZnV0ZXhfd2FrZSAka2V5ICRiaXRzIDEgMAoKICAgICMgd2FpdCBmMSwgd2FrZSBmMSB3
aXRoIHdyb25nIGJpdHMsIHdha2UgZjEKICAgIGZ1dGV4X3dhaXQgJGtleTEgJGJpdHMKCiAg
ICBzbGVlcCA0CgogICAgZnV0ZXhfd2FrZSAka2V5MSAkd3JvbmdiaXRzIDEgMAoKICAgIGZ1
dGV4X3dha2UgJGtleTEgJGJpdHMgMSAxCgogICAgZnV0ZXhfd2FrZSAka2V5ICRiaXRzIDEg
MAoKICAgICMgd2FpdCBmMSwgd2FpdCBmMSwgd2FrZSAyeCBmMQogICAgZnV0ZXhfd2FpdCAk
a2V5MSAkYml0cwogICAgZnV0ZXhfd2FpdCAka2V5MSAkYml0cwoKICAgIHNsZWVwIDQKCiAg
ICBmdXRleF93YWtlICRrZXkgJGJpdHMgMiAyCgogICAgZnV0ZXhfd2FrZSAka2V5ICRiaXRz
IDEgMAoKICAgICMgd2FpdCBmMSwgd2FpdCBmMSwgd2FrZSBmMSwgd2FrZSBmMQogICAgZnV0
ZXhfd2FpdCAka2V5MSAkYml0cwogICAgZnV0ZXhfd2FpdCAka2V5MSAkYml0cwoKICAgIHNs
ZWVwIDQKCiAgICBmdXRleF93YWtlICRrZXkgJGJpdHMgMSAxCiAgICBmdXRleF93YWtlICRr
ZXkgJGJpdHMgMSAxCgogICAgZnV0ZXhfd2FrZSAka2V5ICRiaXRzIDEgMAoKICAgICMgd2Fp
dCBmMSwgd2FpdCBmMSwgd2FrZSAzeCBmMSAocmV0dXJucyAyKQogICAgZnV0ZXhfd2FpdCAk
a2V5MSAkYml0cwogICAgZnV0ZXhfd2FpdCAka2V5MSAkYml0cwoKICAgIHNsZWVwIDQKCiAg
ICBmdXRleF93YWtlICRrZXkgJGJpdHMgMyAyCgogICAgZnV0ZXhfd2FrZSAka2V5ICRiaXRz
IDEgMAoKICAgICMgd2FpdCBmMSwgcmVxdWV1ZSBmMSBmMiwgd2FrZSBmMgogICAgZnV0ZXhf
d2FpdCAka2V5MSAkYml0cwoKICAgIHNsZWVwIDQKCiAgICBmdXRleF9yZXF1ZXVlICRrZXkx
ICRrZXkyIDAgMSAxCgogICAgZnV0ZXhfd2FrZSAka2V5MiAkYml0cyAxIDEKCiAgICBmdXRl
eF93YWtlICRrZXkyICRiaXRzIDEgMAoKICAgICMgd2FpdCBmMSwgcmVxdWV1ZSBmMSBmMiwg
d2FrZSBmMSwgd2FrZSBmMgogICAgZnV0ZXhfd2FpdCAka2V5MSAkYml0cwoKICAgIHNsZWVw
IDQKCiAgICBmdXRleF9yZXF1ZXVlICRrZXkxICRrZXkyIDAgMSAxCgogICAgZnV0ZXhfd2Fr
ZSAka2V5MSAkYml0cyAxIDAKCiAgICBmdXRleF93YWtlICRrZXkyICRiaXRzIDEgMQoKICAg
IGZ1dGV4X3dha2UgJGtleTEgJGJpdHMgMSAwCgoKICAgICMgd2FpdCBmMSwgcmVxdWV1ZSBm
MSBmMiwgcmVxdWV1ZSBmMiBmMSwgd2FrZSBmMSwgd2FrZSBmMgogICAgZnV0ZXhfd2FpdCAk
a2V5MSAkYml0cwoKICAgIHNsZWVwIDQKCiAgICBmdXRleF9yZXF1ZXVlICRrZXkxICRrZXky
IDAgMSAxCgogICAgZnV0ZXhfcmVxdWV1ZSAka2V5MiAka2V5MSAwIDEgMQoKICAgIGZ1dGV4
X3dha2UgJGtleTEgJGJpdHMgMSAxCgogICAgZnV0ZXhfd2FrZSAka2V5MiAkYml0cyAxIDAK
CiAgICAjIHdhaXQgZjEsIHdhaXQgZjEsIHJlcXVldWUgZjEgZjIsIHJlcXVldWUgZjIgZjEs
IHdha2UgZjEsIHdha2UgZjIKICAgIGZ1dGV4X3dhaXQgJGtleTEgJGJpdHMKICAgIGZ1dGV4
X3dhaXQgJGtleTEgJGJpdHMKCiAgICBzbGVlcCA0CgogICAgZnV0ZXhfcmVxdWV1ZSAka2V5
MSAka2V5MiAxIDEgMgoKICAgIGZ1dGV4X3JlcXVldWUgJGtleTIgJGtleTEgMCAyIDEKCiAg
ICBmdXRleF93YWtlICRrZXkxICRiaXRzIDEgMAoKICAgIGZ1dGV4X3dha2UgJGtleTIgJGJp
dHMgMSAxCgogICAgIyB3YWl0IGYxLCB3YWl0IGYxLCByZXF1ZXVlIGYxIGYyLCByZXF1ZXVl
IGYyIGYxLCB3YWtlIGYxLCB3YWtlIGYyCiAgICBmdXRleF93YWl0ICRrZXkxICRiaXRzCiAg
ICBmdXRleF93YWl0ICRrZXkxICRiaXRzCgogICAgc2xlZXAgNAoKICAgIGZ1dGV4X3JlcXVl
dWUgJGtleTEgJGtleTIgMSAxIDIKCiAgICBmdXRleF9yZXF1ZXVlICRrZXkyICRrZXkxIDAg
MiAxCgogICAgZnV0ZXhfd2FrZSAka2V5MiAkYml0cyAxIDEKCiAgICBmdXRleF93YWtlICRr
ZXkxICRiaXRzIDEgMAoKCiAgICBmdXRleF9kZWxldGUgJGtleTEKCiAgICBmdXRleF9kZWxl
dGUgJGtleTIKCiAgICByZXR1cm4gJD8KfQoKZnV0ZXhfc2V0dXAgJEAgfHwgZXhpdCAkPwoK
ZnV0ZXhfc2htMDEgJEAgfHwgZXhpdCAkPw==
--=_bohort-9784-1287406239-0001-2
Content-Type: application/x-shellscript; name="lib_futex.sh"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="lib_futex.sh"

IyEvYmluL2Jhc2gKIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIwojIwojIyBDb3B5cmlnaHQg
KGMpIEtlcmxhYnMsIDIwMTAKIyMKIyMgVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7
ICB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQjb3IgbW9kaWZ5CiMjIGl0IHVuZGVyIHRo
ZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgYXMgcHVibGlzaGVk
IGJ5CiMjIHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb247IGVpdGhlciB2ZXJzaW9uIDIg
b2YgdGhlIExpY2Vuc2UsIG9yCiMjIChhdCB5b3VyIG9wdGlvbikgYW55IGxhdGVyIHZlcnNp
b24uCiMjCiMjIFRoaXMgcHJvZ3JhbSBpcyBkaXN0cmlidXRlZCBpbiB0aGUgaG9wZSB0aGF0
IGl0IHdpbGwgYmUgdXNlZnVsLCBidXQKIyMgV0lUSE9VVCBBTlkgV0FSUkFOVFk7IHdpdGhv
dXQgZXZlbiB0aGUgaW1wbGllZCB3YXJyYW50eSBvZiBNRVJDSEFOVEFCSUxJVFkKIyMgb3Ig
RklUTkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0UuICBTZWUgdGhlIEdOVSBHZW5lcmFs
IFB1YmxpYyBMaWNlbnNlCiMjIGZvciBtb3JlIGRldGFpbHMuCiMjCiMjIFlvdSBzaG91bGQg
aGF2ZSByZWNlaXZlZCBhIGNvcHkgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNl
CiMjIGFsb25nIHdpdGggdGhpcyBwcm9ncmFtOyAgaWYgbm90LCB3cml0ZSB0byB0aGUgRnJl
ZSBTb2Z0d2FyZQojIyBGb3VuZGF0aW9uLCBJbmMuLCA1OSBUZW1wbGUgUGxhY2UsIFN1aXRl
IDMzMCwgQm9zdG9uLCBNQSAwMjExMS0xMzA3IFVTQQojIwojIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjCiMKIyBGaWxlIDogICAgICAgIGxpYl9mdXRleC5zaAojCiMgRGVzY3JpcHRpb246
ICBGdXRleCAibGlicmFyeSIgZmlsZQojCiMgQXV0aG9yOiAgICAgICBNYXR0aGlldSBGZXJ0
csOpLCBtYXR0aGlldS5mZXJ0cmVAa2VybGFicy5jb20KIwoKTFRQX3ByaW50X2luZm8oKQp7
CiAgICBpZiBbICIkREVCVUciICE9ICIiIF07IHRoZW4KCWVjaG8gIlskJF0gKCRURVNUX1NU
RVApICRAIgogICAgZmkKfQoKTFRQX3ByaW50X3N0ZXBfaW5mbygpCnsKICAgIGlmIFsgIiRE
RUJVRyIgIT0gIiIgXTsgdGhlbgoJVEVTVF9TVEVQPSRbJFRFU1RfU1RFUCsxXQoJZWNobyAi
WyQkXSAoJFRFU1RfU1RFUCkgJEAiCiAgICBmaQp9CgpwcmludF9zdWNjZXNzKCkKewogICAg
bG9jYWwgcj0kMQoKICAgIGlmIFsgIiRyIiAtZXEgMCBdOyB0aGVuCgllY2hvICJbJCRdIE9L
IgogICAgZWxzZQoJZWNobyAiWyQkXSA6LSgiCiAgICBmaQoKICAgIHJldHVybiAkcgp9Cgpm
dXRleF93YWl0KCkKewogICAgbG9jYWwga2V5PSQxCiAgICBsb2NhbCBiaXRzPSQyCgogICAg
ZnV0ZXgtc2htLXRvb2wgLXEgLWska2V5IC1iICRiaXRzIHdhaXQgJgoKICAgIExUUF9wcmlu
dF9zdGVwX2luZm8gIlByb2Nlc3MgJCEgaXMgd2FpdGluZyBvbiBrZXkgJGtleSIKfQoKZnV0
ZXhfd2FrZSgpCnsKICAgIGxvY2FsIGtleT0kMQogICAgbG9jYWwgYml0cz0kMgogICAgbG9j
YWwgbnJ3YWtlPSQzCiAgICBsb2NhbCBhd2FpdGVkPSQ0CgogICAgbG9jYWwgcmVzdWx0PTAK
ICAgIGZ1dGV4LXNobS10b29sIC1xIC1rJGtleSAtYiAkYml0cyAtdyRucndha2Ugd2FrZQog
ICAgcmVzdWx0PSQ/CgogICAgaWYgWyAiJHJlc3VsdCIgLW5lICIkYXdhaXRlZCIgXTsgdGhl
bgoJZWNobyBURkFJTCBOVUxMIFwKCSAgICAiZnV0ZXhfd2FrZSAka2V5OiBpbmNvcnJlY3Qg
bnVtYmVyIG9mIHByb2Nlc3NlcyB3b2tlbiB1cCAoJHJlc3VsdCAhPSAkYXdhaXRlZCkiCgly
ZXR1cm4gMQogICAgZmkKCiAgICBMVFBfcHJpbnRfc3RlcF9pbmZvIFwKCSJmdXRleF93YWtl
ICRrZXk6ICRyZXN1bHQgcHJvY2Vzc2Uocykgd29rZW4gdXAgb24gZnV0ZXggJGtleSIKCiAg
ICByZXR1cm4gMAp9CgpmdXRleF9yZXF1ZXVlKCkKewogICAgbG9jYWwga2V5MT0kMQogICAg
bG9jYWwga2V5Mj0kMgogICAgbG9jYWwgbnJ3YWtlPSQzCiAgICBsb2NhbCBucnJlcXVldWU9
JDQKICAgIGxvY2FsIGF3YWl0ZWQ9JDUKCiAgICBsb2NhbCByZXN1bHQ9MAogICAgZnV0ZXgt
c2htLXRvb2wgLXEgLWska2V5MSAtSyRrZXkyIC13JG5yd2FrZSAtciRucnJlcXVldWUgcmVx
dWV1ZQogICAgcmVzdWx0PSQ/CgogICAgaWYgWyAkcmVzdWx0IC1uZSAkYXdhaXRlZCBdOyB0
aGVuCgllY2hvICJmdXRleF9yZXF1ZXVlICRrZXkxICRrZXkyOiBpbmNvcnJlY3QgbnVtYmVy
IG9mIHByb2Nlc3NlcyB3b2tlbiB1cCBvciByZXF1ZXVlZCgkcmVzdWx0ICE9ICRhd2FpdGVk
KSIKCXJldHVybiAxCiAgICBmaQoKICAgIExUUF9wcmludF9zdGVwX2luZm8gXAoJImZ1dGV4
X3JlcXVldWUgJGtleTEgJGtleTI6ICRyZXN1bHQgcHJvY2Vzc2Uocykgd29rZW4gdXAgb3Ig
cmVxdWV1ZWQiCgogICAgcmV0dXJuIDAKfQoKZnV0ZXhfZGVsZXRlKCkKewogICAgbG9jYWwg
a2V5PSQxCgogICAgZnV0ZXgtc2htLXRvb2wgLXEgLWska2V5IGRlbGV0ZQogICAgTFRQX3By
aW50X3N0ZXBfaW5mbyBcCgkiZnV0ZXggJGtleSBkZWxldGVkIgp9CgojIERlc2NyaXB0aW9u
OgojICAgICAgICAgICAgICAgLSBFeHBvcnQgZ2xvYmFsIHZhcmlhYmxlcwojCiMgUmV0dXJu
ICAgICAgICAtIHplcm8gb24gc3VjY2VzcwojICAgICAgICAgICAgICAgLSBub24gemVybyBv
biBmYWlsdXJlLiByZXR1cm4gdmFsdWUgZnJvbSBjb21tYW5kcyAoJD8pCmZ1dGV4X3NldHVw
KCkKewogICAgIyBQYXJzZSBvcHRpb25zCiAgICB3aGlsZSBnZXRvcHRzICJoZCIgZmxhZwog
ICAgZG8KCWNhc2UgJGZsYWcgaW4KCSAgICBoICkgZWNobyAiIC1kIDogZGVidWcgbW9kZSAo
bW9yZSB2ZXJib3NlKSIKCQlleGl0IDAKCQk7OwoJICAgIGQgKSBERUJVRz0ieWVzIjs7Cgkg
ICAgPyApIGVjaG8gIioqKiB1bmtub3cgb3B0aW9ucyI7IGV4aXQgMTs7Cgllc2FjCiAgICBk
b25lCgogICAgcmV0dXJuIDAKfQo=
--=_bohort-9784-1287406239-0001-2--
