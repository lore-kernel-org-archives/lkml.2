Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977Ab2BNLKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:10:15 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40725 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab2BNLKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:10:13 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 14 Feb 2012 20:08:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 6/6 v4] memcg: fix performance of
 mem_cgroup_begin_update_page_stat()
Message-Id: <20120214200842.df132ab1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <CAHH2K0baOnU6BE5c16cR0KiMvM3Hz+ngcBCs5e4+xJ_dcoeOww@mail.gmail.com>
References: <20120214120414.025625c2.kamezawa.hiroyu@jp.fujitsu.com>
	<20120214121631.782352f2.kamezawa.hiroyu@jp.fujitsu.com>
	<CAHH2K0baOnU6BE5c16cR0KiMvM3Hz+ngcBCs5e4+xJ_dcoeOww@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Feb 2012 23:22:50 -0800
Greg Thelen <gthelen@google.com> wrote:

> On Mon, Feb 13, 2012 at 7:16 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > From 3377fd7b6e23a5d2a368c078eae27e2b49c4f4aa Mon Sep 17 00:00:00 2001
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Date: Mon, 6 Feb 2012 12:14:47 +0900
> > Subject: [PATCH 6/6] memcg: fix performance of mem_cgroup_begin_update_page_stat()
> >
> > mem_cgroup_begin_update_page_stat() should be very fast because
> > it's called very frequently. Now, it needs to look up page_cgroup
> > and its memcg....this is slow.
> >
> > This patch adds a global variable to check "a memcg is moving or not".
> 
> s/a memcg/any memcg/
> 
yes.

> > By this, the caller doesn't need to visit page_cgroup and memcg.
> 
> s/By/With/
> 
ok.

> > Here is a test result. A test program makes page faults onto a file,
> > MAP_SHARED and makes each page's page_mapcount(page) > 1, and free
> > the range by madvise() and page fault again.  This program causes
> > 26214400 times of page fault onto a file(size was 1G.) and shows
> > shows the cost of mem_cgroup_begin_update_page_stat().
> 
> Out of curiosity, what is the performance of the mmap program before
> this series?
> 

Score of 3 runs underlinux-next.
==
[root@bluextal test]# time ./mmap 1G

real    0m21.041s
user    0m6.146s
sys     0m14.625s
[root@bluextal test]# time ./mmap 1G

real    0m21.063s
user    0m6.019s
sys     0m14.776s
[root@bluextal test]# time ./mmap 1G

real    0m21.178s
user    0m6.000s
sys     0m14.849s
==

My program is attached. This program is for checking cost of updating FILE_MAPPED.
I guess sys_time scores's error rate will be 0.2-0.3 sec.

Thanks,
-Kame
==
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

