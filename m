Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab0ELPvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 11:51:00 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:53677 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163Ab0ELPu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 11:50:58 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
Subject: [PATCH -V7 0/8] Generic name to handle and open by handle syscalls 
Date: Wed, 12 May 2010 21:20:35 +0530
Message-Id: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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

I guess v7 address all the review comments. If I have missing some please let me
know. I am also looking at getting xfsprogs libhandle.so on top of these syscalls.
Let me know if you have any objection towards merging this patchset upstream.

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
----------------
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
#define AT_SYMLINK_NOFOLLOW	0x100

static int name_to_handle(const char *name, struct file_handle  *fh)
{
	return syscall(338, AT_FDCWD, name, fh, 0);
}

static int lname_to_handle(const char *name, struct file_handle  *fh)
{
	return syscall(338, AT_FDCWD, name, fh, AT_SYMLINK_NOFOLLOW);
}

static int open_by_handle(struct file_handle *fh,  int flags)
{
	return syscall(339, fh, flags);
}

static int freadlink(int fd, char *buf, size_t bufsiz)
{
	return syscall(340, fd, buf, bufsiz);
}

#define BUFSZ 100
int main(int argc, char *argv[])
{
        int ret;
	int handle_sz;
	struct stat bufstat;
        int fd, dirfd;
        char buf[BUFSZ];
        struct file_handle *fh = NULL;;
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
                perror("Error:");
		printf("Found the handle size needed to be %d\n", fh->handle_size);
		printf("Trying again..\n");
		goto again;
        } else if (ret) {
                perror("Error:");
		exit(1);
	}
        fd = open_by_handle(fh, O_RDONLY);
        if (fd <= 0 ) {
                perror("Error:");
                exit(1);
        }
	fstat(fd, &bufstat);
	ret = S_ISLNK(bufstat.st_mode);
	if (ret) {
	        memset(buf, 0 , BUFSZ);
		freadlink(fd, buf, BUFSZ);
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




