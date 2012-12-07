Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab2LGXz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 18:55:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106Ab2LGXz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 18:55:57 -0500
Message-ID: <50C2820B.5060005@redhat.com>
Date: Sat, 08 Dec 2012 00:55:55 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Read O_DIRECT regression in 3.7-rc8 (bisected)
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

seems this commit in 3.7-rc8 caused regression for O_DIRECT
read near the end of the device.

bbec0270bdd887f96377065ee38b8848b5afa395 is the first bad commit
commit bbec0270bdd887f96377065ee38b8848b5afa395
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Nov 29 12:31:52 2012 -0800

    blkdev_max_block: make private to fs/buffer.c


With reproducer below (tested on i386), read should return
half of the buffer (8192 bytes), with patch above it fails
completely.

Milan

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

#define BLOCK 8192
int main (int argc, char *argv[])
{
        char *buf;
        int fd, r;

        if (posix_memalign((void*)&buf, 4096, 2 * BLOCK)) {
                printf("alloc fail\n");
                return 1;
        }

        fd = open("/dev/sdb", O_RDONLY|O_DIRECT);
        if (fd == -1) {
                printf("open fail\n");
                return 1;
        }

        if (lseek(fd, -BLOCK, SEEK_END) < 0) {
                printf("seek fail\n");
                close(fd);
                return 2;
        }

        r = read(fd, buf, 2 * BLOCK);
        printf("Read returned %d.\n", r);

        close(fd);
        return 0;
}
