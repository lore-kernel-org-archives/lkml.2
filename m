Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab1EJBXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 21:23:53 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1748 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab1EJBXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 21:23:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 09 May 2011 18:23:50 -0700
Date: Mon, 9 May 2011 18:23:48 -0700
From: rmorell@nvidia.com
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: mmap vs. ctime bug?
Message-ID: <20110510012348.GJ3848@morell.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="H8ygTp4AXg6deix2"
Content-Disposition: inline
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H8ygTp4AXg6deix2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I tracked an intermittent failure in one of our build systems down to
questionable kernel behavior.

The makefile for the build seems completely reasonable.  It essentially does
this (greatly simplified):
output: $(OBJECTS)
        ld -o output $(OBJECTS)
        $(POSTPROCESS) output

tarball.tgz: output
        tar zcf tarball.tgz output

$(POSTPROCESS) in this case is just a program that modifies some ELF headers.
This program does so through libelf, but the important part is that libelf
operates on the file using mmap().

The problem is that the "tar" step sometimes fails with the error:
/bin/tar: output: file changed as we read it

As tar is adding a file to a tarball, it first stats the file, reads the entire
file, then stats it again.  It reports the above error if the ctime does not
match between the two stat calls.  In the case of the intermittent failure, the
ctime does not match for the file as reported by stat(1).

Adding a sync between the postprocess program's termination and the tar
invocation "fixes" the problem, but adds a significant delay to the overall
build time, so I'd prefer to not do that.

I was able to reproduce the behavior with a simple test case (attached) with
the latest git kernel built from 26822eebb25.  To run the test, simply
put test.c and the Makefile in a new directory and run "make runtest".
Note that the filesystem blocks and ctime change between the two stat
invocations, although the mtime remains the same:

# make runtest
gcc test.c -o test
rm -f out
./test out
stat out
  File: `out'
  Size: 268435456 	Blocks: 377096     IO Block: 4096   regular file
Device: 304h/772d	Inode: 655367      Links: 1
Access: (0600/-rw-------)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2011-05-09 18:06:24.000000000 -0700
Modify: 2011-05-09 18:06:27.000000000 -0700
Change: 2011-05-09 18:06:27.000000000 -0700
sync
stat out
  File: `out'
  Size: 268435456 	Blocks: 524808     IO Block: 4096   regular file
Device: 304h/772d	Inode: 655367      Links: 1
Access: (0600/-rw-------)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2011-05-09 18:06:24.000000000 -0700
Modify: 2011-05-09 18:06:27.000000000 -0700
Change: 2011-05-09 18:06:28.000000000 -0700

(note: depending on your system, you may need to tweak the "SIZE" constant in
test.c up to see ctime actually change at a resolution of 1s)


Does this seem like a bug to anyone else?  For the normal "make" flow to work
properly, files really need to be done changing by the time a process exits and
wait(3) returns to the parent.  The heavy-hammer workaround of adding a
sync(1) throws away a ton of potential benefit from the filesystem cache.
Adding an msync(MS_SYNC) in the toy test app also "fixes" the problem, but
that's not feasible in the production environment since libelf is doing the
modification internally and besides, it seems like it shouldn't be necessary.

If it matters, the filesystem is a dead simple ext3 with no special mount
flags, but I suspect this is not specific to FS:
# mount
/dev/hda4 on / type ext3 (rw)
[...]

Thanks,
Robert

--H8ygTp4AXg6deix2
Content-Type: text/x-c; charset=us-ascii
Content-Disposition: attachment; filename="test.c"

#include <unistd.h>
#include <stdio.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#define SIZE (256 * 1024 * 1024)

int main(int argc, char **argv)
{
	char *ptr;
	int fd, i;

	if (argc < 2) {
		printf("Usage: %s <filename>\n", argv[0]);
		return 1;
	}

	fd = open(argv[1], O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
	if (fd < 0) {
		perror("Failed to open file");
		return 1;
	}

	if (ftruncate(fd, SIZE)) {
		perror("Failed to truncate to full size");
		return 1;
	}

	ptr = mmap(NULL, SIZE, PROT_WRITE, MAP_SHARED, fd, 0);
	if (ptr == MAP_FAILED) {
		perror("Failed to mmap");
		return 1;
	}

	/* touch each page */
	for (i = 0; i < SIZE; i += 4096)
		ptr[i] = 1;

	/* Uncommenting the below line masks the problem */
	/* msync(ptr, SIZE, MS_SYNC); */

	if (munmap(ptr, SIZE)) {
		perror("Failed to munmap");
		return 1;
	}

	close(fd);

	return 0;
}

--H8ygTp4AXg6deix2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=Makefile

test: test.c
	gcc test.c -o test

runtest: test
	rm -f out
	./test out
	stat out
	sync
	stat out

.PHONY: runtest

--H8ygTp4AXg6deix2--
