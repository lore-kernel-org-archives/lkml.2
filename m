Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab2FTNfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 09:35:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49493 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208Ab2FTNfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 09:35:40 -0400
Message-ID: <4FE1D1A2.5040605@suse.com>
Date: Wed, 20 Jun 2012 19:05:30 +0530
From: Suresh Jayaraman <sjayaraman@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Justin Lecher <jlec@gentoo.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-cachefs@redhat.com
Subject: Re: [PATCH] [RESEND] fs: cachefiles: Add support for large files
 in filesystem caching
References: <4FD5844D.4010900@suse.com> <20120618160408.8d0dd792.akpm@linux-foundation.org> <4FE00DBF.7080405@suse.com> <20120619005214.989e90a8.akpm@linux-foundation.org>
In-Reply-To: <20120619005214.989e90a8.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 01:22 PM, Andrew Morton wrote:
> On Tue, 19 Jun 2012 10:57:27 +0530 Suresh Jayaraman <sjayaraman@suse.com> wrote:
> 
>>> How extensively was this change tested?  Please describe the testing
>>> which was performed?
>>>
>>
>> The original patch was tested by mounting a NFS share with fscache
>> option enabled, do a md5sum on a nfs file larger than 2GB and ensure
>> that the file is getting cached by fscache (watch cache size growing)
>> on x86_64. 
> 
> Well it will need a lot more coverage testing than that.  truncate? 
> expanding truncate?  write, lseek, pwrite, pread(), mmap(MAP_SHARED),
> behavior at the new max file size (what is that?), etc.
> 

The changelog could be slightly misleading as the patch doesn't really
add LFS support. It just passes O_LARGEFILE flag to dentry_open() to make
VFS allow cachefiles to open larger files (instead of failing it with
-EOVERFLOW). Cachefiles is just a cache that uses the VFS/VM interfaces to
get another disk filesystem to do the requisite I/O on its behalf.
So, I doubt whether more coverage testing is required for this change.

Anyway, I'm attaching a quick and dirty test program that might help
(not well tested though). I'm unable to to test it as I have modified
my setup and have to redo it.

Justin, do you have the setup and can you get this tested?



/*
 * Few tests to ensure LFS (Large File Support) is working correctly.
 *
 * The requests (seek, truncate, write, mmap etc) that extend beyond the offset
 * maximum (off_t) should succeed.
 *
 * Compile it with -D_FILE_OFFSET_BITS=64
 *
 * Run it like:
 * 	./lfs-tests large_file
 *
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>

#define BUF_SZ 32

#define err(msg) \
	do { perror(msg); exit(EXIT_FAILURE); } while (0)


void report_size(int fd, struct stat *st)
{
	fstat(fd, st);
	printf("size of file: %ld\n", st->st_size);

	return;
}

int main(int argc, char *argv[])
{
	int fd;
	int rc = 0;
	unsigned long offset = 0;
	struct stat stbuf;
	char buf[BUF_SZ];
	void *file_mem;

	if (argc != 2) {
		fprintf(stderr, "Usage: %s test_file\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	fd = open(argv[1], O_RDWR | O_APPEND);
	if (fd == -1)
		err("open");

	memset(buf, 0, sizeof(buf));

	/* seek to the end of file */
	offset = lseek(fd, 0, SEEK_END);
	if (offset < 0)
		err("lseek");

	/* seek past the end of file */
	offset = lseek(fd, BUF_SZ, SEEK_END);
	printf("%ld\n", offset);
	if (offset < 0)
		err("lseek");

	/* truncate it to < 2GB and report size */
	rc = ftruncate(fd, 2147483648 - BUF_SZ);
	if (rc != 0)
		err("ftruncate");

	report_size(fd, &stbuf);

	/* truncate it to a size larger than 2GB */
	rc = ftruncate(fd, 4294967360);
	if (rc != 0)
		err("ftruncate");

	report_size(fd, &stbuf);

	/* seek to the end of file */
	offset = lseek(fd, 0, SEEK_END);
	if (offset < 0)
		err("lseek");

	memset(buf, 'a', sizeof(buf));

	/* write past 4GB */
	rc = write(fd, buf, sizeof(buf));
	if (rc == -1)
		err("write");

	report_size(fd, &stbuf);

	offset = lseek(fd, 0, SEEK_END);
	if (offset < 0)
		err("lseek");

	/* pwrite and pread */
	rc = pread(fd, buf, BUF_SZ, offset);
	if (rc == -1)
		err("pread");

	rc = pwrite(fd, buf, sizeof(buf), offset);
	if (rc == -1) 
		err("pwrite");

	report_size(fd, &stbuf);

	/* page align offset */
	offset = offset & ~(sysconf(_SC_PAGE_SIZE) - 1);

	file_mem = mmap(0, BUF_SZ, PROT_WRITE, MAP_SHARED, fd, offset);
	if (file_mem == MAP_FAILED)
		err("mmap");

	munmap(file_mem, 64);

	close(fd);

	return EXIT_SUCCESS;
}
