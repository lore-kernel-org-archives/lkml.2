Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab0EAAMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 20:12:23 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52442 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab0EAAMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 20:12:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=pb1m41rWAHGAEKNmDII1a1F/vA1rYHyWzYFuc+wQk1JoEGriaOXCvjDhM9++Pkp6mK
         6oWJQy0uKql/aQzjli7QkERHtaxf+3Zc6AZ1hI2elkz+SGGqZbv5xYqqskg5+3GFgo/w
         BFMHBGLzkK6j64QWKIG1AcVUgWf3lEp0BF+ho=
Date: Fri, 30 Apr 2010 16:12:13 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Bcache: version 4
Message-ID: <20100501001212.GA31135@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got some documentation incorporated since the last posting. The
user documentation should be sufficient; the code could probably use
more but it's hard for me to say what, so I'll try and add whatever
people find unclear.

Most of the basic functionality is now there; the most visible thing is
it's now correctly saving all the metadata, so you can unload a cache
and then reload it, and everything will still be there. I plan on
having read/write in the next version; barring the unexpected version 5
should be good enough for people to start playing with.

The performance issues I was seeing that I posted about in the last
version completely vanished when I tested it outside of kvm - there was
no visible overhead. I don't know what's going on with kvm, it must be
triggering a pathalogical corner case somewhere - performance varies
wildly for no good reason. Unfortunately, I don't have the hardware to
do any real performance testing, but from what I've seen so far it's
plenty fast.

Program to make a cache device is attached; the rest is split out more
or less by function. There's more comments along with the hooks patch.


#define _XOPEN_SOURCE 500

#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>

static const char bcache_magic[] = {
	0xc6, 0x85, 0x73, 0xf6, 0x4e, 0x1a, 0x45, 0xca,
	0x82, 0x65, 0xf5, 0x7f, 0x48, 0xba, 0x6d, 0x81 };

struct cache_sb {
	uint8_t  magic[16];
	uint32_t version;
	uint16_t block_size;		/* sectors */
	uint16_t bucket_size;		/* sectors */
	uint32_t journal_start;		/* buckets */
	uint32_t first_bucket;		/* start of data */
	uint64_t nbuckets;		/* device size */
	uint64_t btree_root;
	uint16_t btree_level;
};

struct bucket_disk {
	uint16_t	priority;
	uint8_t		generation;
} __attribute((packed));

struct btree_node_header {
	uint32_t	csum;
	uint32_t	nkeys;
	uint64_t	random;
};

char zero[4096];

int main(int argc, char **argv)
{
	int fd, random, i;
	struct stat statbuf;
	struct cache_sb sb;
	struct bucket_disk b;
	struct btree_node_header n = { .nkeys = 0, };

	if (argc < 2) {
		printf("Please supply a device\n");
		return 0;
	}

	fd = open(argv[1], O_RDWR);
	if (!fd) {
		perror("Can't open dev\n");
		return 0;
	}

	random = open("/dev/urandom", O_RDONLY);
	if (!random) {
		perror("Can't open urandom\n");
		return 0;
	}

	if (fstat(fd, &statbuf)) {
		perror("stat error\n");
		return 0;
	}

	memcpy(sb.magic, bcache_magic, 16);
	sb.version = 0;
	sb.block_size = 8;
	sb.bucket_size = 32;
	sb.nbuckets = statbuf.st_size / (sb.bucket_size * 512);

	do
		sb.first_bucket = ((--sb.nbuckets * sizeof(struct bucket_disk))
				   + 4096 * 3) / (sb.bucket_size * 512) + 1;
	while ((sb.nbuckets + sb.first_bucket) * sb.bucket_size * 512
	       > statbuf.st_size);

	sb.journal_start = sb.first_bucket;

	sb.btree_root = sb.first_bucket * sb.bucket_size;
	sb.btree_level = 0;

	printf("block_size:		%u\n"
	       "bucket_size:		%u\n"
	       "journal_start:		%u\n"
	       "first_bucket:		%u\n"
	       "nbuckets:		%ju\n",
	       sb.block_size,
	       sb.bucket_size,
	       sb.journal_start,
	       sb.first_bucket,
	       sb.nbuckets);

	/* Zero out priorities */
	lseek(fd, 4096, SEEK_SET);
	for (i = 8; i < sb.first_bucket * sb.bucket_size; i++)
		if (write(fd, zero, 512) != 512)
			goto err;

	if (pwrite(fd, &sb, sizeof(sb), 4096) != sizeof(sb))
		goto err;

	b.priority = ~0;
	b.generation = 1;
	if (pwrite(fd, &b, sizeof(b), 4096 * 3) != sizeof(b))
		goto err;

	if (read(random, &n.random, 8) != 8)
		goto err;

	if (pwrite(fd, &n, sizeof(n), sb.btree_root * 512) != sizeof(n))
		goto err;

	return 0;
err:
	perror("write error\n");
	return 1;
}
