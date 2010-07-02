Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab0GBHmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 03:42:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab0GBHmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 03:42:08 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, eric.dumazet@gmail.com, oleg@redhat.com,
       Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] time/fs - file's time race with vgettimeofday
Date: Fri,  2 Jul 2010 09:41:59 +0200
Message-Id: <1278056519-5008-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

there's a race among calling gettimeofday(2) and a file's time
updates.  Following test program expose the race.

run it in the while loop
	while [ 1 ]; do ./test1 || break; done

--- SNIP ---
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>

int main (void)
{
	struct stat st;
	struct timeval tv;

	unlink("./file");

	gettimeofday(&tv, NULL);

	if (-1 == creat("./file", O_RDWR)) {
		perror("creat");
		return -1;
	}

	if (stat("./file", &st) != 0) {
		perror("stat");
		return -1;
	}

	printf("USER gtod: %ld\n", (long)tv.tv_sec);
	printf("USER file: %ld.%09u\n",
			(long) st.st_mtime,
			(unsigned) st.st_mtim.tv_nsec);

	return tv.tv_sec <= st.st_mtime ? 0 : -1;
}
--- SNIP ---


The point is that the stat call returns time that
sometime precedes time from gettimeofday.

The reason follows.

	- inode's time is initialized by CURRENT_TIME_SEC macro,
	  which returns tv_sec portion of xtime variable
	- the xtime is updated by update_wall_time being called
	  each tick (not that often for NO_HZ)
	- vgettimeofday reads the actuall clocksource tick
	  and computes the time

Thus while the inode's time is based on the xtime update
by the update_wall_time function, the vgettimeofday computes
the time correctly each time it's called.

Thus the race is triggered within 2 update_wall_time updates,
when in between the gettimeofday and creat calls happened.



ticks                   CPU                   update_wall_time executed
-------------------------------------------------------------------------------
 t1                                                         
                                                        update 1
                                           (xtime is computed based on tick t1)


 t2

       |         gettimeofday           |
       | (returns time based on tick 2) |
       |                                |
       |            creat               |
       |   (set time based on tick 1)   |


                                                        update 2
                                           (xtime is computed based on tick t2)
 t3
-------------------------------------------------------------------------------



This issue was described in the BZ 244697 

	Time goes backward - gettimeofday() vs. rename()
	https://bugzilla.redhat.com/show_bug.cgi?id=244697


It's not just issue of the creat but few others like rename.


The following patch will prevent the race by adding the
CURRENT_TIME_SEC_REAL macro, which will return seconds from
the getnstimeofday call, ensuring it's computed on current tick.
It fixes the 'creat' case for ext4.


I'm not sure how much trouble is having this race unfixed compared
to the performance impact the fix might have. Maybe there're
better ways to fix this.


thanks for any ideas,
jirka



Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index 938dbc7..7a0a2fc 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -558,7 +558,7 @@ got:
 
 	inode->i_ino = ino;
 	inode->i_blocks = 0;
-	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC_REAL;
 	memset(ei->i_data, 0, sizeof(ei->i_data));
 	ei->i_flags =
 		ext2_mask_flags(mode, EXT2_I(dir)->i_flags & EXT2_FL_INHERITED);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 19a4de5..2c2925c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1157,7 +1157,7 @@ static inline struct ext4_inode_info *EXT4_I(struct inode *inode)
 static inline struct timespec ext4_current_time(struct inode *inode)
 {
 	return (inode->i_sb->s_time_gran < NSEC_PER_SEC) ?
-		current_fs_time(inode->i_sb) : CURRENT_TIME_SEC;
+		current_fs_time(inode->i_sb) : CURRENT_TIME_SEC_REAL;
 }
 
 static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
diff --git a/include/linux/time.h b/include/linux/time.h
index ea3559f..f390687 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -109,12 +109,14 @@ void timekeeping_init(void);
 extern int timekeeping_suspended;
 
 unsigned long get_seconds(void);
+unsigned long get_seconds_real(void);
 struct timespec current_kernel_time(void);
 struct timespec __current_kernel_time(void); /* does not hold xtime_lock */
 struct timespec get_monotonic_coarse(void);
 
 #define CURRENT_TIME		(current_kernel_time())
 #define CURRENT_TIME_SEC	((struct timespec) { get_seconds(), 0 })
+#define CURRENT_TIME_SEC_REAL	((struct timespec) { get_seconds_real(), 0 })
 
 /* Some architectures do not supply their own clocksource.
  * This is mainly the case in architectures that get their
diff --git a/kernel/time.c b/kernel/time.c
index 848b1c2..ce10dae 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -227,7 +227,8 @@ SYSCALL_DEFINE1(adjtimex, struct timex __user *, txc_p)
  */
 struct timespec current_fs_time(struct super_block *sb)
 {
-	struct timespec now = current_kernel_time();
+	struct timespec now;
+	getnstimeofday(&now);
 	return timespec_trunc(now, sb->s_time_gran);
 }
 EXPORT_SYMBOL(current_fs_time);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index caf8d4d..7ebfe23 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -897,6 +897,14 @@ unsigned long get_seconds(void)
 }
 EXPORT_SYMBOL(get_seconds);
 
+unsigned long get_seconds_real(void)
+{
+	struct timespec ts;
+	getnstimeofday(&ts);
+	return ts.tv_sec;
+}
+EXPORT_SYMBOL(get_seconds_real);
+
 struct timespec __current_kernel_time(void)
 {
 	return xtime;
