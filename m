Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab0EQFeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 01:34:09 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:36674 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab0EQFeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 01:34:04 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
Subject: [PATCH -V8 0/9] Generic name to handle and open by handle syscalls 
Date: Mon, 17 May 2010 11:03:43 +0530
Message-Id: <1274074432-29695-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.78.g212f0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The below set of patches implement open by handle support using exportfs
operations. This allows user space application to map a file name to file 
handle and later open the file using handle. This should be usable
for userspace NFS [1] and 9P server [2]. XFS already support this with the ioctls
XFS_IOC_PATH_TO_HANDLE and XFS_IOC_OPEN_BY_HANDLE.

[1] http://nfs-ganesha.sourceforge.net/
[2] http://thread.gmane.org/gmane.comp.emulators.qemu/68992

Changes from V7:
a) open_by_handle now use mountdirfd to identify the vfsmount.
b) We don't validate the UUID passed as a part of file handle in open_by_handle.
   UUID is provided as a part of file handle as an easy way for userspace to
   use the kernel returned handle as it is. It also helps in finding the 16 byte
   filessytem UUID in userspace without using file system specific libraries to
   read file system superblock. If a particular file system doesn't support UUID
   or any form of unique id this field in the file handle will be zero filled.
c) drop freadlink syscall. Instead use readlinkat with NULL pathname to indicate
   read the link target name of the link pointed by fd. This is similar to
   sys_utimensat
d) Instead of opencoding all the open flag related check use helper functions.
   Did finish_open_by_handle similar to finish_open.
c) Fix may_open to not return ELOOP for symlink when we are called from handle open.
   open(2) still returns error as expected. 

Changes from V6:
a) Add uuid to vfsmount lookup and drop uuid to superblock lookup
b) Return -EOPNOTSUPP in sys_name_to_handle if the file system returned uuid
   doesn't give the same vfsmount on lookup. This ensure that we fail
   sys_name_to_handle when we have multiple file system returning same UUID.

Changes from V5:
a) added sys_name_to_handle_at syscall which takes AT_SYMLINK_NOFOLLOW flag 
   instead of two syscalls sys_name_to_handle and sys_lname_to_handle.
b) addressed review comments from Niel Brown
c) rebased to b91ce4d14a21fc04d165be30319541e0f9204f15
d) Add compat_sys_open_by_handle

Chages from V4:
a) Changed the syscal arguments so that we don't need compat syscalls
   as suggested by Christoph
c) Added two new syscall sys_lname_to_handle and sys_freadlink to work with
   symlinks
d) Changed open_by_handle to work with all file types
e) Add ext3 support

Changes from V3:
a) Code cleanup suggested by Andreas
b) x86_64 syscall support
c) add compat syscall

Chages from V2:
a) Support system wide unique handle.

Changes from v1:
a) handle size is now specified in bytes
b) returns -EOVERFLOW if the handle size is small
c) dropped open_handle syscall and added open_by_handle_at syscall
   open_by_handle_at takes mount_fd as the directory fd of the mount point
   containing the file
e) handle will only be unique in a given file system. So for an NFS server
   exporting multiple file system, NFS server will have to internally track the
   mount point to which a file handle belongs to. We should be able to do it much
   easily than expecting kernel to give a system wide unique file handle. System
   wide unique file handle would need much larger changes to the exportfs or VFS
   interface and I was not sure whether we really need to do that in the kernel or
   in the user space
f) open_handle_at now only check for DAC_OVERRIDE capability


Example program: (x86_32). (x86_64 would need a different syscall number)
---
CC -D_GNU_SOURCE <source.c>
----
#include <stdio.h>
#include <stdlib.h>

#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>

struct uuid {
	unsigned char uuid[16];
};

struct file_handle {
        int handle_size;
        int handle_type;
	struct uuid fsid;
        unsigned char handle[0];
};

#define AT_FDCWD		-100
#define AT_SYMLINK_FOLLOW	0x400

static int name_to_handle(const char *name, struct file_handle  *fh)
{
	return syscall(338, AT_FDCWD, name, fh, AT_SYMLINK_FOLLOW);
}

static int lname_to_handle(const char *name, struct file_handle  *fh)
{
	return syscall(338, AT_FDCWD, name, fh, 0);
}

static int open_by_handle(int mountfd, struct file_handle *fh,  int flags)
{
	return syscall(339, mountfd, fh, flags);
}

#define BUFSZ 100
int main(int argc, char *argv[])
{
        int fd;
        int ret;
	int mountfd;
	int handle_sz;
	struct stat bufstat;
        char buf[BUFSZ];
        struct file_handle *fh = NULL;;
	if (argc != 3 ) {
		printf("Usage: %s <filename> <mount-dir-name>\n", argv[0]);
		exit(1);
	}
again:
	if (fh && fh->handle_size) {
		handle_sz = fh->handle_size;
		free(fh);
		fh = malloc(sizeof(struct file_handle) + handle_sz);
		fh->handle_size = handle_sz;
	} else {
		fh = malloc(sizeof(struct file_handle));
		fh->handle_size = 0;
	}
        errno  = 0;
        ret = lname_to_handle(argv[1], fh);
        if (ret && errno == EOVERFLOW) {
		printf("Found the handle size needed to be %d\n", fh->handle_size);
		goto again;
        } else if (ret) {
                perror("Error:");
		exit(1);
	}
	printf("Waiting for input");
	getchar();
	mountfd = open(argv[2], O_RDONLY | O_DIRECTORY);
	if (mountfd <= 0) {
                perror("Error:");
                exit(1);
        }
        fd = open_by_handle(mountfd, fh, O_RDWR);
        if (fd <= 0 ) {
                perror("Error:");
                exit(1);
        }
	printf("Reading the content now \n");
	fstat(fd, &bufstat);
	ret = S_ISLNK(bufstat.st_mode);
	if (ret) {
		memset(buf, 0 , BUFSZ);
		readlinkat(fd, NULL, buf, BUFSZ);
		printf("%s is a symlink pointing to %s\n", argv[1], buf);
	}
        memset(buf, 0 , BUFSZ);
	while (1) {
		ret = read(fd, buf, BUFSZ -1);
		if (ret <= 0)
			break;
		buf[ret] = '\0';
                printf("%s", buf);
                memset(buf, 0 , BUFSZ);
        }
        return 0;
}

-aneesh

