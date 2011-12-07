Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab1LGJAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:00:01 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:58427 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab1LGI76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 03:59:58 -0500
X-Nat-Received: from [202.181.97.72]:58498 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1323248389.3153
Message-Id: <201112070859.pB78xn7x007845@www262.sakura.ne.jp>
Subject: Re: [git pull] apparmor fix for __d_path() misuse
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: viro@ZenIV.linux.org.uk
Cc: john.johansen@canonical.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Dec 2011 17:59:49 +0900
References: <20111207001643.GN2203@ZenIV.linux.org.uk> <20111207003922.GO2203@ZenIV.linux.org.uk> <CA+55aFyaz7K4V5xLmaQ9GK=5LA1mbRdVGCFspET=y6ode_i=jg@mail.gmail.com> <20111207011047.GQ2203@ZenIV.linux.org.uk> <20111207013720.GS2203@ZenIV.linux.org.uk> <201112070326.pB73QPZo042162@www262.sakura.ne.jp> <20111207034238.GX2203@ZenIV.linux.org.uk> <201112070501.pB751LoP064331@www262.sakura.ne.jp> <20111207051908.GA2203@ZenIV.linux.org.uk> <201112070544.pB75iX12072157@www262.sakura.ne.jp> <20111207065437.GB2203@ZenIV.linux.org.uk>
In-Reply-To: <20111207065437.GB2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 07122011 #5944925, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> BTW, what your current code does if you have a file bound on another
> file, open it, umount -l it, let the dust settle and then do some operation
> that triggers tomoyo_get_absolute_path() on it?  Because you'll be getting
> a vfsmount/dentry pair that has
> 	* dentry == vfsmount->mnt_root
> 	* vfsmount->mnt_parent == vfsmount
> 	* dentry->d_inode being a non-directory
> and there is nothing whatsoever in what remains of the pathname.  Not a single
> component.  IOW, you'll get "/" in buf.  Might be good in a testsuite - is
> there any code in security/tomoyo that would be relying on assumption that
> only directory might have a name entirely without components?

TOMOYO assumes that only directory ends with '/'.

I wrote a test program and compared among below cases.

   current code
   current code + your patch
   current code + your patch + my patch (attached at the bottom)

---------- test1.c ----------
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/mount.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#define MNT_DETACH 2

static void die(const char *msg)
{
        fprintf(stderr, "%s\n", msg);
        exit(1);
}

int main(int argc, char *argv[])
{
        int fd;
        if (mount("/tmp/", "/tmp", "tmpfs", 0, NULL))
                die("Can't mount");
        fd = open("/tmp/file1", O_WRONLY | O_CREAT, 0600);
        if (fd == EOF)
                die("Can't create /tmp/file1");
        close(fd);
        fd = open("/tmp/file2", O_WRONLY | O_CREAT, 0600);
        if (fd == EOF)
                die("Can't create /tmp/file2");
        close(fd);
        if (mount("/tmp/file1", "/tmp/file2", NULL, MS_BIND, 0))
                die("Can't bind mount");
        fd = open("/tmp/file2", O_RDONLY | O_CREAT, 0600);
        if (fd == EOF)
                die("Can't open /tmp/file2");
        if (umount2("/tmp/file2", MNT_DETACH))
                die("Can't unmount 2");
        ioctl(fd, 0);
        close(fd);
        return 0;
}
---------- test1.c ----------

Below are the policy checked by TOMOYO.

---- linux b835c0f4 ----
    0: file create  /tmp/file1 0600
    1: file create  /tmp/file2 0600
    2: file ioctl   / 0x0
    3: file mount   /tmp/ /tmp/ tmpfs 0x0
    4: file mount   /tmp/file1 /tmp/file2 --bind 0x0
    5: file read    /tmp/file2
    6: file unmount /tmp/file2
    7: file write   /tmp/file1
    8: file write   /tmp/file2

ioctl() handled but its pathname is wrong.

---- linux b835c0f4 with your patch ----
    0: file create  /tmp/file1 0600
    1: file create  /tmp/file2 0600
    2: file mount   /tmp/ /tmp/ tmpfs 0x0
    3: file mount   /tmp/file1 /tmp/file2 --bind 0x0
    4: file read    /tmp/file2
    5: file unmount /tmp/file2
    6: file write   /tmp/file1
    7: file write   /tmp/file2

ioctl() failed (i.e. regression) because tomoyo_get_absolute_path() failed.
The error message was

  ERROR: Out of memory at tomoyo_realpath_from_path.

---- linux b835c0f4 with your patch and my patch ----
    0: file create  /tmp/file1 0600
    1: file create  /tmp/file2 0600
    2: file ioctl   tmpfs:/file1 0x0
    3: file mount   /tmp/ /tmp/ tmpfs 0x0
    4: file mount   /tmp/file1 /tmp/file2 --bind 0x0
    5: file read    /tmp/file2
    6: file unmount /tmp/file2
    7: file write   /tmp/file1
    8: file write   /tmp/file2

ioctl() handled using pathname returned by tomoyo_get_local_path().

> The real question is what pathname do you _want_ in this situation.  Define
> that and we'll be able to do something about it;

Among above three results, the last one will be the best.

[PATCH] TOMOYO: Fix pathname handling of disconnected paths.

Current tomoyo_realpath_from_path() implementation returns strange pathname
when calculating pathname of a file which belongs to lazy unmounted tree.
Use local pathname rather than strange absolute pathname in that case.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

--- a/security/tomoyo/realpath.c
+++ b/security/tomoyo/realpath.c
@@ -293,8 +293,16 @@ char *tomoyo_realpath_from_path(struct path *path)
 			pos = tomoyo_get_local_path(path->dentry, buf,
 						    buf_len - 1);
 		/* Get absolute name for the rest. */
-		else
+		else {
 			pos = tomoyo_get_absolute_path(path, buf, buf_len - 1);
+			/*
+			 * Fall back to local name if absolute name is not
+			 * available.
+			 */
+			if (pos == ERR_PTR(-EINVAL))
+				pos = tomoyo_get_local_path(path->dentry, buf,
+							    buf_len - 1);
+		}
 encode:
 		if (IS_ERR(pos))
 			continue;
