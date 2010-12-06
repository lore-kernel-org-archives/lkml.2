Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab0LFNRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 08:17:49 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33274 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab0LFNRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 08:17:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=OLRTRFTw80TCNi9T2OJglYDGa1z8s9xSnFtfBIHTRRBSxoSNSgKm5bP3aCEkDFI7SG
         vDCRGKKc0BXTHUfoWsAvcwwuruGakLg3iNj9x3QaTtS6edqjHzOVDf8u8J/8e4080wIK
         OsVZ3V8eSh5bWZ/X/FbkZhqX6lLDvYYJv6tcw=
MIME-Version: 1.0
From: Avery Pennarun <apenwarr@gmail.com>
Date: Mon, 6 Dec 2010 05:17:24 -0800
Message-ID: <AANLkTikV+uqwrCpmXywB6GqrFtOdR7LLWVJGp_VeSZg6@mail.gmail.com>
Subject: posix_fadvise(POSIX_FADV_WILLNEED) waits before returning?
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I assume I'm doing something totally stupid here, but if so, I would
love if someone could tell me exactly what.

My understanding is that readahead() is synchronous (it reads the
pages, then it returns), but posix_fadvise(POSIX_FADV_WILLNEED) is
asynchronous (it enqueues the pages for reading, but returns
immediately).  The latter is the behaviour I want.  However, AFAICT
the latter function is running synchronously - it does exactly the
same thing as readahead() - which kind of defeats the point.  I've
searched around in Google and everybody seems to claim that this
function really does work in the background as it should, so I'm
mystified.

madvise(MADV_WILLNEED) is also synchronous in my test.

I'm using Linux 2.6.36 (unmodified Linus tagged version) on x86 with
large memory support (6GB of RAM).  My root filesystem is:

    /dev/root / ext3 rw,relatime,errors=remount-ro,barrier=0,data=writeback 0 0

cat /sys/block/sda/queue/scheduler
    noop [cfq] deadline


Reproduction steps are as follows.

First, create fadvtest.c:

#define _GNU_SOURCE
#include <fcntl.h>

int main()
{
    int fd = open("bigfile", O_RDONLY);
    posix_fadvise(fd, 0, 100*1000*1000, POSIX_FADV_WILLNEED);
    return 0;
}


And now:

gcc -Wall -o fadvtest fadvtest.c
dd if=/dev/zero of=bigfile bs=1000000 count=100
sync
echo 3 >/proc/sys/vm/drop_caches
strace -tt ./fadvtest


The strace output on my system is as follows:

05:11:27.208345 execve("./fadvtest", ["./fadvtest"], [/* 34 vars */]) = 0
05:11:27.242254 brk(0)                  = 0x804a000
05:11:27.242316 access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No
such file or directory)
05:11:27.242389 mmap2(NULL, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb787d000
05:11:27.242444 access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No
such file or directory)
05:11:27.242633 open("/etc/ld.so.cache", O_RDONLY) = 3
05:11:27.243152 fstat64(3, {st_mode=S_IFREG|0644, st_size=74622, ...}) = 0
05:11:27.243237 mmap2(NULL, 74622, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb786a000
05:11:27.243277 close(3)                = 0
05:11:27.243318 access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No
such file or directory)
05:11:27.243379 open("/lib/i686/cmov/libc.so.6", O_RDONLY) = 3
05:11:27.243436 read(3,
"\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\260e\1\0004\0\0\0\4"...,
512) = 512
05:11:27.243499 fstat64(3, {st_mode=S_IFREG|0755, st_size=1413540, ...}) = 0
05:11:27.243574 mmap2(NULL, 1418864, PROT_READ|PROT_EXEC,
MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb770f000
05:11:27.243616 mmap2(0xb7864000, 12288, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x155) = 0xb7864000
05:11:27.243669 mmap2(0xb7867000, 9840, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7867000
05:11:27.243717 close(3)                = 0
05:11:27.243767 mmap2(NULL, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb770e000
05:11:27.243835 set_thread_area({entry_number:-1 -> 6,
base_addr:0xb770e6b0, limit:1048575, seg_32bit:1, contents:0,
read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
05:11:27.243952 mprotect(0xb7864000, 4096, PROT_READ) = 0
05:11:27.243994 munmap(0xb786a000, 74622) = 0
05:11:27.244062 open("bigfile", O_RDONLY) = 3
05:11:27.244132 fadvise64(3, 0, 100000000, POSIX_FADV_WILLNEED) = 0
05:11:28.326734 exit_group(0)           = ?


Note the very long time that fadvise64() has taken to run.  Running
'vmstat 1' in parallel in another window (especially with even larger
input files) confirms that the kernel has read in *all* the data from
the file before fadvise64() returns.

Any hints?

Thanks,

Avery
