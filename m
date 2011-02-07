Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab1BGSbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 13:31:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425Ab1BGSbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 13:31:40 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: alan@lxorguk.ukuu.org.uk, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/2] tty,vcs: lseek/VC-release race fix
Date: Mon,  7 Feb 2011 19:31:24 +0100
Message-Id: <1297103485-8319-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1297103485-8319-1-git-send-email-jolsa@redhat.com>
References: <1297103485-8319-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

there's a race between vcs's lseek handler and VC release.

The lseek handler does not hold console_lock and touches
VC's size info. If during this the VC got released, there's
an access violation.

Following program triggers the issue for me:

[SNIP]
#define _BSD_SOURCE
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <linux/vt.h>
#include <unistd.h>
#include <errno.h>

static int run_seek(void)
{
        while(1) {
                int fd;
                fd = open("./vcs30", O_RDWR);
                while(lseek(fd, 0, 0) != -1);
                close(fd);
        }
}

static int open_ioctl_tty(void)
{
        return open("/dev/tty1", O_RDWR);
}

static int do_ioctl(int fd, int req, int i)
{
        return ioctl(fd, req, i);
}

#define INIT(i) do_ioctl(ioctl_fd, VT_ACTIVATE, i)
#define SHUT(i) do_ioctl(ioctl_fd, VT_DISALLOCATE, i)

int main(int argc, char **argv)
{
        int ioctl_fd = open_ioctl_tty();

        if (ioctl < 0) {
                perror("open tty1 failed\n");
                return -1;
        }

        if ((-1 == mknod("vcs30", S_IFCHR|0666, makedev(7, 30))) &&
            (errno != EEXIST)) {
                printf("errno %d\n", errno);
                perror("failed to create vcs30");
                return -1;
        }

        do_ioctl(ioctl_fd, VT_LOCKSWITCH, 0);

        if (!fork())
                run_seek();

        while(1) {
                INIT(30);
                SHUT(30);
        }

        return 0;
}
[SNIP]

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 drivers/tty/vt/vc_screen.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index a672ed1..3c27c4b 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -159,7 +159,13 @@ static loff_t vcs_lseek(struct file *file, loff_t offset, int orig)
 	int size;
 
 	mutex_lock(&con_buf_mtx);
+	console_lock();
 	size = vcs_size(file->f_path.dentry->d_inode);
+	console_unlock();
+	if (size < 0) {
+		mutex_unlock(&con_buf_mtx);
+		return size;
+	}
 	switch (orig) {
 		default:
 			mutex_unlock(&con_buf_mtx);
@@ -237,6 +243,12 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		 * could sleep.
 		 */
 		size = vcs_size(inode);
+		if (size < 0) {
+			if (read)
+				break;
+			ret = size;
+			goto unlock_out;
+		}
 		if (pos >= size)
 			break;
 		if (count > size - pos)
@@ -436,6 +448,12 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 		 * Return data written up to now on failure.
 		 */
 		size = vcs_size(inode);
+		if (size < 0) {
+			if (written)
+				break;
+			ret = size;
+			goto unlock_out;
+		}
 		if (pos >= size)
 			break;
 		if (this_round > size - pos)
-- 
1.7.1

