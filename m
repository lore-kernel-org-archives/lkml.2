Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759706Ab2IEWZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 18:25:04 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36191 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab2IEWZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 18:25:01 -0400
MIME-Version: 1.0
Date: Thu, 6 Sep 2012 00:25:00 +0200
Message-ID: <CAF9-tdzJ-TTfho-VujDRjQKy2yjjSyvy90Y5hE58Y-kCxcqCrw@mail.gmail.com>
Subject: Dirty inodes remain in cache for a long time in 2.6.23.17
From: Mikael Liljeroth <mikael.liljeroth@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I'm running Linux 2.6.23.17 (sh4) on an embedded system with
limited RAM (<100MB).
Unfortunately I do not have the possibility to upgrade to a later
kernel version.

Files get truncated on my JFS filesystem upon power failure after 20
days of uptime.
The files can be more than a week old. There are a lot of (constant)
disk activity.

Suddenly (around day 20) Dirty in /proc/meminfo starts increasing
above its limits in /proc/sys/vm. All files created after this looks
fine and can be very large (300MB+) but will become empty after a
power failure. Multiple sync calls before the "reboot" do not seem to
affect the dirty value.

This problem is very hard to reproduce and it takes a long time. So I
tried to analyse the mounted filesystem with a kernel module. From
what I can tell there are many inodes in my superblock's s_io list
(2000+) where some are more than a week old (inode->dirtied_when).
Some of them have no opened filedescriptors in any running process.

Should this be possible?

I have no previous experience with the kernel source code so I was
hoping that someone more experienced could help me.

I have tried to gather some information about the inodes in sb->s_io:

- There are more than 2000 inodes in the s_io list
- Most inodes (>95%) have i_state == 7 (all dirty)
- No inode is "bad" (is_bad_inode)
- No inode is locked (I_LOCK)
- Almost all (except maybe 3 or 4) have a dirtied_when value that is
more than 30 second old.
- A lot of inodes (100+) can have a dirtied_when value older than 10 days

Each time I check, the majority of inodes in s_io are the same as last
time I checked (seconds, minutes even hours in between checks).
sb->s_dirty only contains a handfull of inodes each time I check.

I can not see any errors in the kernel log.

I have also tried to explicitly call writeback_inodes_sb from my
module (not sure if this is a bad thing to do) with the writeback
control sync_mode set to WB_SYNC_ALL and nonblocking to 0 but nothing
happened in regards to the Dirty value. I increased the JFS debug
level to trace calls to the super operation write_inode
(jfs_write_inode) in jfs_commit_inode for each inode with state !=
I_DIRTY_PAGES (most of the inodes) but I did not see any traces in the
log when calling writeback_inodes_sb.

Best Regards
Mikael Liljeroth
