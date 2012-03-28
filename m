Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755Ab2C1WBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 18:01:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53677 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758110Ab2C1WBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 18:01:30 -0400
Date: Thu, 29 Mar 2012 00:01:26 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Mandeep Singh Baines <msb@chromium.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Paul Menage <paul@paulmenage.org>, Kay Sievers <kay.sievers@vrfy.org>
Subject: cgroups commit 61d1d219c4 breaks systemd
Message-ID: <alpine.LNX.2.00.1203282354440.25526@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am not able to boot current Linus' tree on system which is using 
systemd. In the early boot phase I get

	Failed to create root cgroup hierarchy: No such process
	Failed to allocate manager object: No such process

and that's it, the system is completely unusable afterwards (not having 
any console spawned, no networking, etc).

Bisection pointed to

	commit 61d1d219c4c0761059236a46867bc49943c4d29d
	Author: Mandeep Singh Baines <msb@chromium.org>
	Date:   Mon Jan 30 12:51:56 2012 -0800

	    cgroup: remove extra calls to find_existing_css_set

and I have verified that reverting this single commit on top of current 
Linus' tree makes the problem go away and the system boots properly.

strace output shows that with 61d1d219c applied, systemd is failing while 
trying to add itself to the systemd cgroup:

mkdir("/sys", 0755)                     = -1 EEXIST (File exists)
mkdir("/sys/fs", 0755)                  = -1 EEXIST (File exists)
mkdir("/sys/fs/cgroup", 0755)           = -1 EEXIST (File exists)
mkdir("/sys/fs/cgroup/systemd", 0755)   = -1 EEXIST (File exists)
mkdir("/sys/fs/cgroup/systemd/system", 0755) = 0
open("/sys/fs/cgroup/systemd/system/tasks", O_WRONLY|O_CREAT|O_TRUNC|O_CLOEXEC, 0666) = 6
fstat(6, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f60c4ecb000
write(6, "357\n", 4)                    = -1 ESRCH (No such process)
close(6)                                = 0
munmap(0x7f60c4ecb000, 4096)            = 0
writev(3, [{"<27>", 4}, {"systemd", 7}, {"[357]: ", 7}, {"Failed to create root cgroup hierarchy: No such process", 55}, {"\n", 1}], 5) = 74
open("/sys/fs/cgroup/systemd/system/tasks", O_RDONLY|O_CLOEXEC) = 6
fstat(6, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f60c4ecb000
read(6, "357\n", 4096)                  = 4
open("/sys/fs/cgroup/systemd/tasks", O_WRONLY|O_CREAT|O_TRUNC|O_CLOEXEC, 0666) = 7
fstat(7, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f60c4eca000
write(7, "357\n", 4)                    = -1 ESRCH (No such process)
close(7)                                = 0
munmap(0x7f60c4eca000, 4096)            = 0
read(6, "", 4096)                       = 0
close(6)                                = 0
munmap(0x7f60c4ecb000, 4096)            = 0
open("/sys/fs/cgroup/systemd/system/tasks", O_RDONLY|O_CLOEXEC) = 6
fstat(6, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f60c4ecb000
read(6, "", 4096)                       = 0
close(6)                                = 0
munmap(0x7f60c4ecb000, 4096)            = 0
open("/sys/fs/cgroup/systemd/system", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 6
getdents(6, /* 7 entries */, 32768)     = 240
getdents(6, /* 0 entries */, 32768)     = 0
lstat("/sys/fs/cgroup/systemd/system/tasks", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
rmdir("/sys/fs/cgroup/systemd/system")  = 0
close(6)                                = 0
close(4)                                = 0
close(5)                                = 0
close(0)                                = 0
writev(3, [{"<27>", 4}, {"systemd", 7}, {"[357]: ", 7}, {"Failed to allocate manager object: No such process", 50}, {"\n", 1}], 5) = 69

-- 
Jiri Kosina
SUSE Labs
