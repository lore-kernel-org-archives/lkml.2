Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab1BIINy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 03:13:54 -0500
Received: from nm13.bullet.mail.sp2.yahoo.com ([98.139.91.83]:42214 "HELO
	nm13.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752579Ab1BIINx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 03:13:53 -0500
X-Yahoo-Newman-Id: 444932.57875.bm@smtp106.mail.gq1.yahoo.com
X-Yahoo-SMTP: 3G2OMZyswBAHlq13edkkiGmBS7dWxo4eAs_M
X-YMail-OSG: u6fsk5YVM1mPspLZOqo6G9fIWJ0o400Xe.WKm2NxL5eSUzl
 1sbo44jzeO1v1N_1Qrcd4zDb.6rDaxur1cutRkMT.jd9ISGQAq5gkeD0VeYG
 KSqQYY9KJhHaoeC8l32qMOpb4PqO2JIvzSCJvuVzCm655Ir1vUgHEeVCI.by
 PY2HmZuKgdu3lu3EvXf0F6gWFg7XTJAXgqxOXWH64xdXe0afAIFLGosutnDe
 vZaTi3gmI6P0kzeSvOmNrlwCWX68iWqQdk2zNW23NAx2paA5AiyfBemAIjLq
 5gvuB90zppRjj5zygFpfu1FKSo3al4ok74sfczA24VViac6b9Pa_ROR9LeDy
 Z_INElBnytVzq04rkzbcQpw--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4D524CBE.2020300@yahoo.se>
Date: Wed, 09 Feb 2011 09:13:50 +0100
From: anders franzen <anders.franzen@yahoo.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v3] Only honor the FIGETBSZ ioctl for regular files and
 directories
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Vad happened with the patch below. It was ''signed off'' more than half 
a year ago, and it is not in any of the latest kernel yet.

I ask, because I spend a week debugging the 'dvbloopback' driver, which 
uses '2' as a private ioctl for a read command. Not easy to find.

Can a driver not have private ioctls?
Should this be fixed in the driver?, I have now RESERVED the value 2 in 
the driver. But this does not
guarantee that someone invents FIGETBSZ_V2 and assigned the value 3 to it.

Regards
   /Anders




FIGETBSZ has an ioctl number of _IO(0x00,2) == 2, which can conflict
with device driver ioctls. Let's avoid the potential for problems by
only honoring the ioctl number for files where this ioctl is likely
going to be useful: for regular files and directories

Thanks to Johannes Stezenbach for pointing this consequence of commit
19ba0559.

Signed-off-by: "Theodore Ts'o" <tytso@xxxxxxx>
Cc: Al Viro <viro@xxxxxxxxxxxxxxxxxx>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@xxxxxxxxxxxxxxxxxx>
Cc: Johannes Stezenbach <js@xxxxxxxxx>
---

Fixed up commit description

fs/compat_ioctl.c | 6 +++++-
fs/ioctl.c | 5 ++++-
2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 641640d..b8607fe 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1715,8 +1715,12 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, 
unsigned int cmd,
goto out_fput;
#endif
- case FIBMAP:
case FIGETBSZ:
+ if (S_ISDIR(filp->f_path.dentry->d_inode->i_mode))
+ break;
+ /*FALL THROUGH */
+
+ case FIBMAP:
case FIONREAD:
if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
break;
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 2d140a7..e578dab 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -597,7 +597,10 @@ int do_vfs_ioctl(struct file *filp, unsigned int 
fd, unsigned int cmd,
{
struct inode *inode = filp->f_path.dentry->d_inode;
int __user *p = (int __user *)arg;
- return put_user(inode->i_sb->s_blocksize, p);
+
+ if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode))
+ return put_user(inode->i_sb->s_blocksize, p);
+ /* FALL THROUGH */
}

default:
-- 
1.7.0.4

