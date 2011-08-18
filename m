Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab1HRMTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 08:19:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab1HRMTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 08:19:00 -0400
From: Lukas Czerner <lczerner@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: [RFC][PATCH 0/5] Add netlink file system notification interface
Date: Thu, 18 Aug 2011 14:18:21 +0200
Message-Id: <1313669906-14931-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

this is my proposal to add netlink notification interface which can be used
by file system to send various warning messages to user space via netlink.
This is actually the same what quota uses to send warnings about exceeding
quota and it can be eventually merged into this interface so we have just
one netlink messaging system for file systems.

The first PATCH adds the netlink interface itself and the rest of the
patches wire it up into the file systems (ext3,ext4,xfs,btrfs). So far it
can only send information about data and metadata ENOSPC, but it can be
easily extended, for example for using quota notification.


Here is a description of the first patch:

 There might be a lot of crazy things happening inside the file systems
 but it might result in bogus error code returned to the user space. And
 sometimes it is hard to figure out what just happened. This
 commit adds the interface which can be used by file systems to send
 better information to the user space via netlink interface, because it
 is not bound with error codes.

 Also applications might not report problems with the file systems
 correctly, hence the administrator will never know about the problem
 unless it is already too late. Also in the case of ENOSPC conditions
 even if we are checking 'df' output from cronjob, we might miss some
 ENOSPC states because it just takes snapshots of the state. Those are
 just examples.

 With this interface file system can send a message via netlink interface
 at the moment when the problem arises.

 In order to use this file system must register the netlink
 interface with init_fs_nl_family() on module initialization and the in
 can send messages with fs_nl_send_warning().

 At this point there are only two types of warning FS_NL_ENOSPC_WARN,
 which should be used in situations when file system does not have enough
 space to reserve data blocks and FS_NL_META_ENOSPC_WARN, for situations
 when file system does not have enough space to reserve metadata blocks.
 But more can be added in the future.

 The code has been based on fs/quota/netlink.c which is used to send
 quota warnings to the user space. Eventually it can be merged into this
 interface.

I have tested this with a simple tool which is testing various enospc
situations and with fallocate. You can find the tool bellow (alloc_test)

For the user space to receive the messages I have written a simple tool
(based on quota_nld code), you can find it bellow (fsmfg).

Thanks!
-Lukas

--- 
[PATCH 1/5] fs: add netlink notification interface
[PATCH 2/5] ext3: use fs netlink interface for ENOSPC conditions
[PATCH 3/5] ext4: use fs netlink interface for ENOSPC conditions
[PATCH 4/5] xfs: use fs netlink interface for ENOSPC conditions
[PATCH 5/5] btrfs: use fs netlink interface for ENOSPC conditions

fs/Makefile                  |    2 +-
fs/btrfs/extent-tree.c       |   13 ++++-
fs/btrfs/super.c             |    1 +
fs/ext3/acl.c                |    5 +-
fs/ext3/balloc.c             |   10 +++-
fs/ext3/inode.c              |    4 +-
fs/ext3/namei.c              |   10 ++--
fs/ext3/super.c              |    1 +
fs/ext3/xattr.c              |    2 +-
fs/ext4/acl.c                |    5 +-
fs/ext4/balloc.c             |   15 ++++--
fs/ext4/ext4.h               |    3 +-
fs/ext4/extents.c            |    2 +-
fs/ext4/indirect.c           |    2 +-
fs/ext4/inode.c              |   10 ++--
fs/ext4/namei.c              |   10 ++--
fs/ext4/super.c              |    1 +
fs/ext4/xattr.c              |    2 +-
fs/netlink.c                 |  107 ++++++++++++++++++++++++++++++++++++++++++
fs/xfs/linux-2.6/xfs_file.c  |    2 +
fs/xfs/linux-2.6/xfs_super.c |    1 +
fs/xfs/xfs_vnodeops.c        |   10 +++-
include/linux/ext3_fs.h      |    3 +-
include/linux/fs.h           |   11 ++++
24 files changed, 193 insertions(+), 39 deletions(-)

--- 

alloc_test.c
------------
#define _GNU_SOURCE

#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <stdint.h>
#include <limits.h>
#include <string.h>
#include <linux/types.h>


#define BSIZE 4096
#define FILECOUNT 9000000

unsigned long long
do_write(int fd, char *data, int size)
{
        unsigned long long count = 0, len = 0;
        while (1) {
                len = write(fd, data, size);
                if (errno) {
                        perror("errno");
                        break;
                }
                count += len;
        }
	fsync(fd);
        return count;
}

void write_test(char *filename, int flag)
{
	int err, fd, ps = getpagesize();
        unsigned long long count = 0;
        void *data;

	fd = open(filename, flag );
        if (fd < 0) {
                perror("open");
                exit(1);
        }

        err = posix_memalign(&data, ps, BSIZE);
        if (err) {
                perror("posix_memalign");
                exit(1);
        }
        memset(data, 0, BSIZE);
        count = do_write(fd, data, BSIZE);   
        printf("%llu Bytes written\n", count);
        close(fd);

	remove(filename);
	sync();
	errno = 0;
}

void dir_create(char *dir, long count)
{
	int fd, err = 0;
	char fname[256];
	long i = count;

	printf("0/%ld", count);
	while (i) {
		sprintf(fname, "%s/testfile_%ld", dir, i);
		fd = mkdir(fname, 0);
		if (fd < 0) {
			perror("open");
			err = 1;
			goto cleanup;
		}
		close(fd);
		i--;
		if (!(i % 10000))
			printf("\r%ld/%ld", count -i, count);
	}
	sync();
cleanup:
	printf("\n%ld files created in the directory %s\n", count -i, dir);
	while (i < count) {
		i++;
		sprintf(fname, "%s/testfile_%ld", dir, i);
		fd = rmdir(fname);
		if (fd < 0) {
			printf("name %s\n", fname);
			perror("unlink");
			exit(1);
		}
		if (!(i % 10000))
			printf("\r%ld/%ld", count -i, count);
	}
	printf("\r\n");
	sync();
}

void file_create(char *dir, long count)
{
	int fd, err = 0;
	char fname[256];
	long i = count;

	printf("0/%ld", count);
	while (i > 0) {
		sprintf(fname, "%s/testfile_%ld", dir, i);
		fd = creat(fname, 0);
		if (fd < 0) {
			perror("creat");
			err = 1;
			goto cleanup;
		}
		close(fd);
		i--;
		if (!(i % 10000))
			printf("\r%ld/%ld", count -i, count);
	}
	sync();
cleanup:
	printf("\n%ld files created in the directory %s\n", count -i, dir);
	while (i < count) {
		i++;
		sprintf(fname, "%s/testfile_%ld", dir, i);
		fd = unlink(fname);
		if (fd < 0) {
			printf("name %s\n", fname);
			perror("unlink");
			exit(1);
		}
		if (!(i % 10000))
			printf("\r%ld/%ld", count -i, count);
	}
	printf("\r\n");
	sync();
}

void test_all(char *dir)
{
	char fname[256];

	sprintf(fname, "%s/testfile", dir);

	printf("[+] Buffered write test\n");
	write_test(fname, O_RDWR | O_CREAT | O_TRUNC);
	write_test(fname, O_RDWR | O_CREAT | O_TRUNC);

	printf("[+] Direct write test\n");
	write_test(fname, O_RDWR | O_CREAT | O_TRUNC | O_DIRECT);
	write_test(fname, O_RDWR | O_CREAT | O_TRUNC | O_DIRECT);

	printf("[+] File creation test\n");
	file_create(dir, FILECOUNT);
	file_create(dir, FILECOUNT);

	printf("[+] Directory creation test\n");
	dir_create(dir, FILECOUNT);
	dir_create(dir, FILECOUNT);
}

int main(int argc, char **argv)
{
        int type;
	long count = FILECOUNT;
	char fname[256];

        if (argc < 2) {
                printf("Usage: %s <filename> n\n", argv[0]);
                printf("n=1 buffered write\nn=2 direct write\nn=3 file creation\n");
                exit(1);
        }


	if (argc == 2) {
		test_all(argv[1]);
		return 0;
	}

	sprintf(fname, "%s/testfile", argv[1]);
        type = atoi(argv[2]);
        switch (type) {
                case 1:
			printf("[+] Buffered write test\n");
                        write_test(fname, O_RDWR | O_CREAT | O_TRUNC);
                        break;
                case 2:
			printf("[+] Direct write test\n");
                        write_test(fname, O_RDWR | O_CREAT | O_TRUNC | O_DIRECT);
			break;
		case 3:
			printf("[+] File creation test\n");
			if (argc == 4) {
				count = atol(argv[3]);
			}
			file_create(argv[1], count);
			break;
		case 4:
			printf("[+] Directory creation test\n");
			if (argc == 4) {
				count = atol(argv[3]);
			}
			dir_create(argv[1], count);
			break;
		default:
			printf("Type not recognised\n");
			exit(1);
        }
        return 0;
}

fsmsg.c
-------
#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <unistd.h>
#include <getopt.h>
#include <utmp.h>
#include <errno.h>
#include <string.h>
#include <fcntl.h>
#include <limits.h>
#include <inttypes.h>

#include <netlink/genl/genl.h>
#include <netlink/genl/ctrl.h>

char *progname;

/*
 * Definition for fs netlink interface
 */
#define FS_NL_NOWARN		0
#define FS_NL_ENOSPC_WARN	1
#define FS_NL_META_ENOSPC_WARN	2

enum {
       FS_NL_A_UNSPEC,
       FS_NL_A_WARNING,
       FS_NL_A_DEV_MAJOR,
       FS_NL_A_DEV_MINOR,
       FS_NL_A_CAUSED_ID,
       __FS_NL_A_MAX,
};
#define FS_NL_A_MAX (__FS_NL_A_MAX - 1)

enum {
	FS_NL_C_UNSPEC,
	FS_NL_C_WARNING,
	__FS_NL_C_MAX,
};
#define FS_NL_C_MAX (__FS_NL_C_MAX - 1)

static const struct option options[] = {
	{ "help", 0, NULL, 'h' },
	{ "no-daemon", 0, NULL, 'F' },
	{ NULL, 0, NULL, 0 }
};

static struct nla_policy fs_nl_warn_cmd_policy[FS_NL_A_MAX+1] = {
	[FS_NL_A_WARNING] = { .type = NLA_U32 },
	[FS_NL_A_DEV_MAJOR] = { .type = NLA_U32 },
	[FS_NL_A_DEV_MINOR] = { .type = NLA_U32 },
	[FS_NL_A_CAUSED_ID] = { .type = NLA_U64 },
};

/* User options */
#define FL_NODAEMON 1

int flags;

void show_help(void)
{
	printf("Usage: %s [options]\nOptions are:\n\
 -h --help         shows this text\n\
 -F --foreground   run daemon in foreground\n", progname);
}

void die(int err, const char *string)
{
	fprintf(stderr, "fsmsg: %s\n", string);
	exit(err);
}

static void parse_options(int argc, char **argv)
{
	int opt;

	while ((opt = getopt_long(argc, argv, "VhDCFb", options, NULL)) >= 0) {
		switch (opt) {
			case 'h':
				show_help();
				exit(0);
			case 'F':
				flags |= FL_NODAEMON;
				break;
			default:
				printf("Unknown option '%c'.\n", opt);
				show_help();
				exit(1);
		}
	}
}

static int fs_nl_parser(struct nl_msg *msg, void *arg)
{
	struct nlmsghdr *nlh = nlmsg_hdr(msg);
	struct genlmsghdr *ghdr;
	struct nlattr *attrs[FS_NL_A_MAX+1];
	int ret, warntype;
	char *warn_msg;

	if (!genlmsg_valid_hdr(nlh, 0))
                return 0;
        ghdr = nlmsg_data(nlh);
	if (ghdr->cmd != FS_NL_C_WARNING)
		return 0;

	ret = genlmsg_parse(nlh, 0, attrs, FS_NL_A_MAX, fs_nl_warn_cmd_policy);
	if (ret < 0) {
		printf("Error parsing netlink message.\n");
		return ret;
	}
	if (!attrs[FS_NL_A_WARNING] ||
	    !attrs[FS_NL_A_DEV_MAJOR] || !attrs[FS_NL_A_DEV_MAJOR] ||
	    !attrs[FS_NL_A_DEV_MINOR] || !attrs[FS_NL_A_CAUSED_ID]) {
		printf("Unknown format of kernel netlink message!\n"
		       "Maybe your fsmsg is too old?\n");
		return -EINVAL;
	}
	warntype = nla_get_u32(attrs[FS_NL_A_WARNING]);

	switch (warntype) {
		case FS_NL_ENOSPC_WARN:
			warn_msg = "no space left on the file system";
			break;
		case FS_NL_META_ENOSPC_WARN:
			warn_msg = "not enough space left for metadata";
			break;
		default:
			warn_msg = "unknown file system warning";
	}

	printf("VFS: on device (%u:%u) from UID=%" PRIu64 " %s.\n",
				     nla_get_u32(attrs[FS_NL_A_DEV_MAJOR]),
				     nla_get_u32(attrs[FS_NL_A_DEV_MINOR]),
				     nla_get_u64(attrs[FS_NL_A_CAUSED_ID]),
				     warn_msg);

	return 0;
}

static struct nl_handle *init_netlink(void)
{
	struct nl_handle *handle;
	int ret, family;

	handle = nl_handle_alloc();
	if (!handle)
		die(2, "Cannot allocate netlink handle!\n");
	nl_disable_sequence_check(handle);
	ret = genl_connect(handle);
	if (ret < 0)
		die(2, "Cannot connect to netlink socket\n");
	family = genl_ctrl_resolve(handle, "FS_MSG");
	if (ret < 0)
		die(2, "Cannot resolve fs netlink name\n");

	ret = nl_socket_add_membership(handle, family);
	if (ret < 0)
		die(2, "Cannot join fs multicast group\n");

	ret = nl_socket_modify_cb(handle, NL_CB_VALID, NL_CB_CUSTOM,
			fs_nl_parser, NULL);
	if (ret < 0)
		die(2, "Cannot register callback for"
			 " netlink messages\n");

	return handle;
}

static void run(struct nl_handle *nhandle)
{
	int ret;

	while (1) {
		ret = nl_recvmsgs_default(nhandle);
		if (ret < 0)
			printf("Failed to read or parse fs netlink"
				" message: %s\n", strerror(-ret));
	}
}

int main(int argc, char **argv)
{
	struct nl_handle *nhandle;

	progname = basename(argv[0]);
	parse_options(argc, argv);

	nhandle = init_netlink();
	if (!(flags & FL_NODAEMON)) {
		daemon(0, 0);
	}
	run(nhandle);
	return 0;
}
