Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab0JSCXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 22:23:43 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55277 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab0JSCXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 22:23:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4CBD00F7.3070503@jp.fujitsu.com>
Date: Tue, 19 Oct 2010 11:22:47 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] blk: fix a wrong accounting of hd_struct->in_flight
References: <4CB40281.1020403@jp.fujitsu.com> <4CB41A27.5080001@kernel.dk> <4CB6FC1C.3050801@jp.fujitsu.com> <4CB6FDB7.5010501@kernel.dk> <4CB8135E.1030100@jp.fujitsu.com> <4CB82720.8040708@kernel.dk> <4CBC0524.7060804@jp.fujitsu.com> <4CBC06B2.7070107@kernel.dk> <4CBC3B3A.9040300@jp.fujitsu.com> <4CBC3BE2.2020802@kernel.dk>
In-Reply-To: <4CBC3BE2.2020802@kernel.dk>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

> This version looks good, thanks for following through on this. What kind
> of testing did you do?

I did three kinds of test.

1. run a reproducer.
   I confirmed the problem was fixed using attached the reproducer.

2. remove and make a partition which is running I/O.
   I confirmed the kernel panic or hungup did not occur using following steps.

     # dd if=/dev/sda of=null &
     # while true
     > do
     > /sbin/parted /dev/sda rm 3 > /dev/null
     > /sbin/parted /dev/sda mkpart primary ext2 42.5GB 52.5GB > /dev/null
     > sleep 2
     > done

3. reload a partition which is running I/O.
   I confirmed the kernel panic or hungup did not occur using following steps.

     # dd if=/dev/sda of=null &
     # while true
     > do
     > /sbin/hdparm -z /dev/sda
     > sleep 2
     > done

--- <reproducer>
/*
 *  This test program continues to read 512 bytes data from specified arguments.
 *
 * 	Usage : read <sec_no> <blk_dev>
 * 		@sec_no  : sector number
 * 		@blk_dev : block device
 *
 *	ex) If you want to read 512 bytes data from sector number 100 of
 *	    /dev/sda
 *
 *	    # ./read 100 /dev/sda
 *
 *	How to build:
 *
 *	    $ gcc -D _GNU_SOURCE -o read read.c
 *
 *	How to occurs a problem which is a wrong accounting of
 *	hd_struct->in_flight:
 *
 *	    1. confirm a start sector of a partition
 *	       # cat /sys/block/sda/sda2/start
 *	       1044225
 *	    2. run the test program against sector no.1044225 of /dev/sda
 *	       # ./read 1044225 /dev/sda &
 *	    3. run the test program against sector no.1044224 of /dev/sda
 *	       # ./read 1044224 /dev/sda &
 *	    4. confirm the /proc/diskstats
 *	       # cat /proc/diskstats |grep sda
 *	          8       0 sda 90524 7579 102154 20464 0 0 0 0 0 14096 20089
 *	          8       1 sda1 19085 1352 21841 4209 0 0 0 0 4294967064 15689 4293424691
 *	          8       2 sda2 71252 3624 74891 15950 0 0 0 0 232 23995 1562390
 *	          8       3 sda3 54 487 2188 92 0 0 0 0 0 88 92
 *	          8       4 sda4 4 0 8 0 0 0 0 0 0 0 0
 *	          8       5 sda5 81 2027 2130 138 0 0 0 0 0 87 137
 */

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>

#include <sys/types.h>
#include <sys/stat.h>

#define SECTOR 512  // sector size
#define ALIGN  512  // for direct io

int main(int argc, char *argv[])
{
	int fd;
	int i;
	int sector_n;
	unsigned long ret;
	void *buf;

	if ( argc != 3 ) {
		printf("invalid argument\n");
		exit(1);
	}

	sector_n = atoi(argv[1]);
	printf("read 512 bytes data from setor no.%d\n", sector_n);

	ret = posix_memalign(&buf, ALIGN, SECTOR);
	if (ret != 0) {
		perror("posix_memalign");	
		exit(1);
	}

	fd = open(argv[2], O_RDONLY|O_DIRECT);

	if (fd < 0) {
		perror("open");	
		exit(1);
	}

	while (1) {
		ret = lseek(fd, 0, SEEK_SET);	
		if (ret < 0) {
			perror("lseek");
			printf("ret = %d\n", ret);
			exit(1);
		}
		for (i = 0; i < SECTOR; i++) {
			ret = lseek(fd, sector_n, SEEK_CUR);
			if (ret < 0) {
				perror("lseek");
				printf("ret = %d\n", ret);
				exit(1)	;
			}
		}

		ret = read(fd, buf, SECTOR);
		if (ret != SECTOR) {
			perror("read");
			exit(1);
		}
	}

	free(buf);
	close(fd);
}
---

Regards,
Yasuaki Ishimatsu



