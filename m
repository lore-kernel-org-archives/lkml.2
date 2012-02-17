Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab2BQKGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 05:06:03 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35125 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab2BQKGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 05:06:01 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 17 Feb 2012 19:04:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Greg Thelen <gthelen@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 0/6] page cgroup diet v5
Message-Id: <20120217190433.7598a56e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120217182426.86aebfde.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120217182426.86aebfde.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Fri__17_Feb_2012_19_04_33_+0900_MKUFGOJfuClWukl+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Fri__17_Feb_2012_19_04_33_+0900_MKUFGOJfuClWukl+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 17 Feb 2012 18:24:26 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> 
> This patch set is for removing 2 flags PCG_FILE_MAPPED and PCG_MOVE_LOCK on
> page_cgroup->flags. After this, page_cgroup has only 3bits of flags.
> And, this set introduces a new method to update page status accounting per memcg.
> With it, we don't have to add new flags onto page_cgroup if 'struct page' has
> information. This will be good for avoiding a new flag for page_cgroup.
> 
> Fixed pointed out parts.
>  - added more comments
>  - fixed texts
>  - removed redundant arguments.
> 
> Passed some tests on 3.3.0-rc3-next-20120216.
> 

Here is a micro benchmark test before/after this series.
mmap 1G bytes twice and repeat fault->drop repeatedly. (test program is attached)

== Before == 3 runs after 1st run
[root@bluextal test]# time ./mmap 1G

real    0m21.053s
user    0m6.046s
sys     0m14.743s
[root@bluextal test]# time ./mmap 1G

real    0m21.302s
user    0m6.027s
sys     0m14.979s
[root@bluextal test]# time ./mmap 1G

real    0m21.061s
user    0m6.020s
sys     0m14.722s

== After == 3 runs after 1st run
[root@bluextal test]# time ./mmap 1G

real    0m20.969s
user    0m5.960s
sys     0m14.777s
[root@bluextal test]# time ./mmap 1G

real    0m20.968s
user    0m6.069s
sys     0m14.650s
[root@bluextal test]# time ./mmap 1G

real    0m21.164s
user    0m6.152s
sys     0m14.707s


I think there is no regression.


Thanks,
-Kame




--Multipart=_Fri__17_Feb_2012_19_04_33_+0900_MKUFGOJfuClWukl+
Content-Type: text/x-csrc;
 name="mmap.c"
Content-Disposition: attachment;
 filename="mmap.c"
Content-Transfer-Encoding: 7bit

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>

void reader(int fd, int size)
{
	int i, off, x;
	char *addr;

	addr = mmap(NULL, size, PROT_READ, MAP_SHARED, fd, 0);
	for (i = 0; i < 100; i++) {
		for(off = 0; off < size; off += 4096) {
			x += *(addr + off);
		}
		madvise(addr, size, MADV_DONTNEED);
	}
}

int main(int argc, char *argv[])
{
	int fd;
	char *addr, *c;
	unsigned long size;
	struct stat statbuf;

	fd = open(argv[1], O_RDONLY);
	if (fd < 0) {
		perror("cannot open file");
		return 1;
	}

	if (fstat(fd, &statbuf)) {
		perror("fstat failed");
		return 1;
	}
	size = statbuf.st_size;
	/* mmap in 2 place. */
	addr = mmap(NULL, size, PROT_READ, MAP_SHARED, fd, 0);
	mlock(addr, size);
	reader(fd, size);
}

--Multipart=_Fri__17_Feb_2012_19_04_33_+0900_MKUFGOJfuClWukl+--

