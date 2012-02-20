Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab2BTAQq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:16:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57288 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab2BTAQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:16:42 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com
Subject: [PATCH 17/30] x32: Add x32 system calls to syscall/syscall_64.tbl
Date: Sun, 19 Feb 2012 16:07:55 -0800
Message-Id: <1329696488-16970-18-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:16:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Split the 64-bit system calls into "64" (64-bit only) and "common"
(64-bit or x32) and add the x32 system call numbers.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/asm-offsets_64.c |    2 +
 arch/x86/kernel/syscall_64.c     |    3 +
 arch/x86/syscalls/Makefile       |    2 +-
 arch/x86/syscalls/syscall_64.tbl |  579 ++++++++++++++++++++------------------
 arch/x86/um/sys_call_table_64.c  |    3 +
 arch/x86/um/user-offsets.c       |    2 +
 6 files changed, 317 insertions(+), 274 deletions(-)

diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 834e897..c3354f7 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -1,6 +1,8 @@
 #include <asm/ia32.h>
 
 #define __SYSCALL_64(nr, sym, compat) [nr] = 1,
+#define __SYSCALL_COMMON(nr, sym, compat) [nr] = 1,
+#define __SYSCALL_X32(nr, sym, compat) /* Not yet */
 static char syscalls_64[] = {
 #include <asm/syscalls_64.h>
 };
diff --git a/arch/x86/kernel/syscall_64.c b/arch/x86/kernel/syscall_64.c
index 7ac7943..26c4ca1 100644
--- a/arch/x86/kernel/syscall_64.c
+++ b/arch/x86/kernel/syscall_64.c
@@ -5,6 +5,9 @@
 #include <linux/cache.h>
 #include <asm/asm-offsets.h>
 
+#define __SYSCALL_COMMON(nr, sym, compat) __SYSCALL_64(nr, sym, compat)
+#define __SYSCALL_X32(nr, sym, compat) /* Not yet */
+
 #define __SYSCALL_64(nr, sym, compat) extern asmlinkage void sym(void) ;
 #include <asm/syscalls_64.h>
 #undef __SYSCALL_64
diff --git a/arch/x86/syscalls/Makefile b/arch/x86/syscalls/Makefile
index 564b247..89dd958 100644
--- a/arch/x86/syscalls/Makefile
+++ b/arch/x86/syscalls/Makefile
@@ -24,7 +24,7 @@ syshdr_pfx_unistd_32_ia32 := ia32_
 $(out)/unistd_32_ia32.h: $(syscall32) $(syshdr)
 	$(call if_changed,syshdr)
 
-syshdr_abi_unistd_64 := 64
+syshdr_abi_unistd_64 := common,64
 $(out)/unistd_64.h: $(syscall64) $(syshdr)
 	$(call if_changed,syshdr)
 
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index b440a8f..4aecc7e 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -4,317 +4,350 @@
 # The format is:
 # <number> <abi> <name> <entry point>
 #
-# The abi is always "64" for this file (for now.)
+# The abi is "common", "64" or "x32" for this file.
 #
-0	64	read			sys_read
-1	64	write			sys_write
-2	64	open			sys_open
-3	64	close			sys_close
-4	64	stat			sys_newstat
-5	64	fstat			sys_newfstat
-6	64	lstat			sys_newlstat
-7	64	poll			sys_poll
-8	64	lseek			sys_lseek
-9	64	mmap			sys_mmap
-10	64	mprotect		sys_mprotect
-11	64	munmap			sys_munmap
-12	64	brk			sys_brk
+0	common	read			sys_read
+1	common	write			sys_write
+2	common	open			sys_open
+3	common	close			sys_close
+4	common	stat			sys_newstat
+5	common	fstat			sys_newfstat
+6	common	lstat			sys_newlstat
+7	common	poll			sys_poll
+8	common	lseek			sys_lseek
+9	common	mmap			sys_mmap
+10	common	mprotect		sys_mprotect
+11	common	munmap			sys_munmap
+12	common	brk			sys_brk
 13	64	rt_sigaction		sys_rt_sigaction
-14	64	rt_sigprocmask		sys_rt_sigprocmask
+14	common	rt_sigprocmask		sys_rt_sigprocmask
 15	64	rt_sigreturn		stub_rt_sigreturn
 16	64	ioctl			sys_ioctl
-17	64	pread64			sys_pread64
-18	64	pwrite64		sys_pwrite64
+17	common	pread64			sys_pread64
+18	common	pwrite64		sys_pwrite64
 19	64	readv			sys_readv
 20	64	writev			sys_writev
-21	64	access			sys_access
-22	64	pipe			sys_pipe
-23	64	select			sys_select
-24	64	sched_yield		sys_sched_yield
-25	64	mremap			sys_mremap
-26	64	msync			sys_msync
-27	64	mincore			sys_mincore
-28	64	madvise			sys_madvise
-29	64	shmget			sys_shmget
-30	64	shmat			sys_shmat
-31	64	shmctl			sys_shmctl
-32	64	dup			sys_dup
-33	64	dup2			sys_dup2
-34	64	pause			sys_pause
-35	64	nanosleep		sys_nanosleep
-36	64	getitimer		sys_getitimer
-37	64	alarm			sys_alarm
-38	64	setitimer		sys_setitimer
-39	64	getpid			sys_getpid
-40	64	sendfile		sys_sendfile64
-41	64	socket			sys_socket
-42	64	connect			sys_connect
-43	64	accept			sys_accept
-44	64	sendto			sys_sendto
+21	common	access			sys_access
+22	common	pipe			sys_pipe
+23	common	select			sys_select
+24	common	sched_yield		sys_sched_yield
+25	common	mremap			sys_mremap
+26	common	msync			sys_msync
+27	common	mincore			sys_mincore
+28	common	madvise			sys_madvise
+29	common	shmget			sys_shmget
+30	common	shmat			sys_shmat
+31	common	shmctl			sys_shmctl
+32	common	dup			sys_dup
+33	common	dup2			sys_dup2
+34	common	pause			sys_pause
+35	common	nanosleep		sys_nanosleep
+36	common	getitimer		sys_getitimer
+37	common	alarm			sys_alarm
+38	common	setitimer		sys_setitimer
+39	common	getpid			sys_getpid
+40	common	sendfile		sys_sendfile64
+41	common	socket			sys_socket
+42	common	connect			sys_connect
+43	common	accept			sys_accept
+44	common	sendto			sys_sendto
 45	64	recvfrom		sys_recvfrom
 46	64	sendmsg			sys_sendmsg
 47	64	recvmsg			sys_recvmsg
-48	64	shutdown		sys_shutdown
-49	64	bind			sys_bind
-50	64	listen			sys_listen
-51	64	getsockname		sys_getsockname
-52	64	getpeername		sys_getpeername
-53	64	socketpair		sys_socketpair
-54	64	setsockopt		sys_setsockopt
-55	64	getsockopt		sys_getsockopt
-56	64	clone			stub_clone
-57	64	fork			stub_fork
-58	64	vfork			stub_vfork
+48	common	shutdown		sys_shutdown
+49	common	bind			sys_bind
+50	common	listen			sys_listen
+51	common	getsockname		sys_getsockname
+52	common	getpeername		sys_getpeername
+53	common	socketpair		sys_socketpair
+54	common	setsockopt		sys_setsockopt
+55	common	getsockopt		sys_getsockopt
+56	common	clone			stub_clone
+57	common	fork			stub_fork
+58	common	vfork			stub_vfork
 59	64	execve			stub_execve
-60	64	exit			sys_exit
-61	64	wait4			sys_wait4
-62	64	kill			sys_kill
-63	64	uname			sys_newuname
-64	64	semget			sys_semget
-65	64	semop			sys_semop
-66	64	semctl			sys_semctl
-67	64	shmdt			sys_shmdt
-68	64	msgget			sys_msgget
-69	64	msgsnd			sys_msgsnd
-70	64	msgrcv			sys_msgrcv
-71	64	msgctl			sys_msgctl
-72	64	fcntl			sys_fcntl
-73	64	flock			sys_flock
-74	64	fsync			sys_fsync
-75	64	fdatasync		sys_fdatasync
-76	64	truncate		sys_truncate
-77	64	ftruncate		sys_ftruncate
-78	64	getdents		sys_getdents
-79	64	getcwd			sys_getcwd
-80	64	chdir			sys_chdir
-81	64	fchdir			sys_fchdir
-82	64	rename			sys_rename
-83	64	mkdir			sys_mkdir
-84	64	rmdir			sys_rmdir
-85	64	creat			sys_creat
-86	64	link			sys_link
-87	64	unlink			sys_unlink
-88	64	symlink			sys_symlink
-89	64	readlink		sys_readlink
-90	64	chmod			sys_chmod
-91	64	fchmod			sys_fchmod
-92	64	chown			sys_chown
-93	64	fchown			sys_fchown
-94	64	lchown			sys_lchown
-95	64	umask			sys_umask
-96	64	gettimeofday		sys_gettimeofday
-97	64	getrlimit		sys_getrlimit
-98	64	getrusage		sys_getrusage
-99	64	sysinfo			sys_sysinfo
+60	common	exit			sys_exit
+61	common	wait4			sys_wait4
+62	common	kill			sys_kill
+63	common	uname			sys_newuname
+64	common	semget			sys_semget
+65	common	semop			sys_semop
+66	common	semctl			sys_semctl
+67	common	shmdt			sys_shmdt
+68	common	msgget			sys_msgget
+69	common	msgsnd			sys_msgsnd
+70	common	msgrcv			sys_msgrcv
+71	common	msgctl			sys_msgctl
+72	common	fcntl			sys_fcntl
+73	common	flock			sys_flock
+74	common	fsync			sys_fsync
+75	common	fdatasync		sys_fdatasync
+76	common	truncate		sys_truncate
+77	common	ftruncate		sys_ftruncate
+78	common	getdents		sys_getdents
+79	common	getcwd			sys_getcwd
+80	common	chdir			sys_chdir
+81	common	fchdir			sys_fchdir
+82	common	rename			sys_rename
+83	common	mkdir			sys_mkdir
+84	common	rmdir			sys_rmdir
+85	common	creat			sys_creat
+86	common	link			sys_link
+87	common	unlink			sys_unlink
+88	common	symlink			sys_symlink
+89	common	readlink		sys_readlink
+90	common	chmod			sys_chmod
+91	common	fchmod			sys_fchmod
+92	common	chown			sys_chown
+93	common	fchown			sys_fchown
+94	common	lchown			sys_lchown
+95	common	umask			sys_umask
+96	common	gettimeofday		sys_gettimeofday
+97	common	getrlimit		sys_getrlimit
+98	common	getrusage		sys_getrusage
+99	common	sysinfo			sys_sysinfo
 100	64	times			sys_times
-101	64	ptrace			sys_ptrace
-102	64	getuid			sys_getuid
-103	64	syslog			sys_syslog
-104	64	getgid			sys_getgid
-105	64	setuid			sys_setuid
-106	64	setgid			sys_setgid
-107	64	geteuid			sys_geteuid
-108	64	getegid			sys_getegid
-109	64	setpgid			sys_setpgid
-110	64	getppid			sys_getppid
-111	64	getpgrp			sys_getpgrp
-112	64	setsid			sys_setsid
-113	64	setreuid		sys_setreuid
-114	64	setregid		sys_setregid
-115	64	getgroups		sys_getgroups
-116	64	setgroups		sys_setgroups
-117	64	setresuid		sys_setresuid
-118	64	getresuid		sys_getresuid
-119	64	setresgid		sys_setresgid
-120	64	getresgid		sys_getresgid
-121	64	getpgid			sys_getpgid
-122	64	setfsuid		sys_setfsuid
-123	64	setfsgid		sys_setfsgid
-124	64	getsid			sys_getsid
-125	64	capget			sys_capget
-126	64	capset			sys_capset
+101	common	ptrace			sys_ptrace
+102	common	getuid			sys_getuid
+103	common	syslog			sys_syslog
+104	common	getgid			sys_getgid
+105	common	setuid			sys_setuid
+106	common	setgid			sys_setgid
+107	common	geteuid			sys_geteuid
+108	common	getegid			sys_getegid
+109	common	setpgid			sys_setpgid
+110	common	getppid			sys_getppid
+111	common	getpgrp			sys_getpgrp
+112	common	setsid			sys_setsid
+113	common	setreuid		sys_setreuid
+114	common	setregid		sys_setregid
+115	common	getgroups		sys_getgroups
+116	common	setgroups		sys_setgroups
+117	common	setresuid		sys_setresuid
+118	common	getresuid		sys_getresuid
+119	common	setresgid		sys_setresgid
+120	common	getresgid		sys_getresgid
+121	common	getpgid			sys_getpgid
+122	common	setfsuid		sys_setfsuid
+123	common	setfsgid		sys_setfsgid
+124	common	getsid			sys_getsid
+125	common	capget			sys_capget
+126	common	capset			sys_capset
 127	64	rt_sigpending		sys_rt_sigpending
 128	64	rt_sigtimedwait		sys_rt_sigtimedwait
 129	64	rt_sigqueueinfo		sys_rt_sigqueueinfo
-130	64	rt_sigsuspend		sys_rt_sigsuspend
+130	common	rt_sigsuspend		sys_rt_sigsuspend
 131	64	sigaltstack		stub_sigaltstack
-132	64	utime			sys_utime
-133	64	mknod			sys_mknod
+132	common	utime			sys_utime
+133	common	mknod			sys_mknod
 134	64	uselib
-135	64	personality		sys_personality
-136	64	ustat			sys_ustat
-137	64	statfs			sys_statfs
-138	64	fstatfs			sys_fstatfs
-139	64	sysfs			sys_sysfs
-140	64	getpriority		sys_getpriority
-141	64	setpriority		sys_setpriority
-142	64	sched_setparam		sys_sched_setparam
-143	64	sched_getparam		sys_sched_getparam
-144	64	sched_setscheduler	sys_sched_setscheduler
-145	64	sched_getscheduler	sys_sched_getscheduler
-146	64	sched_get_priority_max	sys_sched_get_priority_max
-147	64	sched_get_priority_min	sys_sched_get_priority_min
-148	64	sched_rr_get_interval	sys_sched_rr_get_interval
-149	64	mlock			sys_mlock
-150	64	munlock			sys_munlock
-151	64	mlockall		sys_mlockall
-152	64	munlockall		sys_munlockall
-153	64	vhangup			sys_vhangup
-154	64	modify_ldt		sys_modify_ldt
-155	64	pivot_root		sys_pivot_root
+135	common	personality		sys_personality
+136	common	ustat			sys_ustat
+137	common	statfs			sys_statfs
+138	common	fstatfs			sys_fstatfs
+139	common	sysfs			sys_sysfs
+140	common	getpriority		sys_getpriority
+141	common	setpriority		sys_setpriority
+142	common	sched_setparam		sys_sched_setparam
+143	common	sched_getparam		sys_sched_getparam
+144	common	sched_setscheduler	sys_sched_setscheduler
+145	common	sched_getscheduler	sys_sched_getscheduler
+146	common	sched_get_priority_max	sys_sched_get_priority_max
+147	common	sched_get_priority_min	sys_sched_get_priority_min
+148	common	sched_rr_get_interval	sys_sched_rr_get_interval
+149	common	mlock			sys_mlock
+150	common	munlock			sys_munlock
+151	common	mlockall		sys_mlockall
+152	common	munlockall		sys_munlockall
+153	common	vhangup			sys_vhangup
+154	common	modify_ldt		sys_modify_ldt
+155	common	pivot_root		sys_pivot_root
 156	64	_sysctl			sys_sysctl
-157	64	prctl			sys_prctl
-158	64	arch_prctl		sys_arch_prctl
-159	64	adjtimex		sys_adjtimex
-160	64	setrlimit		sys_setrlimit
-161	64	chroot			sys_chroot
-162	64	sync			sys_sync
-163	64	acct			sys_acct
-164	64	settimeofday		sys_settimeofday
-165	64	mount			sys_mount
-166	64	umount2			sys_umount
-167	64	swapon			sys_swapon
-168	64	swapoff			sys_swapoff
-169	64	reboot			sys_reboot
-170	64	sethostname		sys_sethostname
-171	64	setdomainname		sys_setdomainname
-172	64	iopl			stub_iopl
-173	64	ioperm			sys_ioperm
+157	common	prctl			sys_prctl
+158	common	arch_prctl		sys_arch_prctl
+159	common	adjtimex		sys_adjtimex
+160	common	setrlimit		sys_setrlimit
+161	common	chroot			sys_chroot
+162	common	sync			sys_sync
+163	common	acct			sys_acct
+164	common	settimeofday		sys_settimeofday
+165	common	mount			sys_mount
+166	common	umount2			sys_umount
+167	common	swapon			sys_swapon
+168	common	swapoff			sys_swapoff
+169	common	reboot			sys_reboot
+170	common	sethostname		sys_sethostname
+171	common	setdomainname		sys_setdomainname
+172	common	iopl			stub_iopl
+173	common	ioperm			sys_ioperm
 174	64	create_module
-175	64	init_module		sys_init_module
-176	64	delete_module		sys_delete_module
+175	common	init_module		sys_init_module
+176	common	delete_module		sys_delete_module
 177	64	get_kernel_syms
 178	64	query_module
-179	64	quotactl		sys_quotactl
+179	common	quotactl		sys_quotactl
 180	64	nfsservctl
-181	64	getpmsg
-182	64	putpmsg
-183	64	afs_syscall
-184	64	tuxcall
-185	64	security
-186	64	gettid			sys_gettid
-187	64	readahead		sys_readahead
-188	64	setxattr		sys_setxattr
-189	64	lsetxattr		sys_lsetxattr
-190	64	fsetxattr		sys_fsetxattr
-191	64	getxattr		sys_getxattr
-192	64	lgetxattr		sys_lgetxattr
-193	64	fgetxattr		sys_fgetxattr
-194	64	listxattr		sys_listxattr
-195	64	llistxattr		sys_llistxattr
-196	64	flistxattr		sys_flistxattr
-197	64	removexattr		sys_removexattr
-198	64	lremovexattr		sys_lremovexattr
-199	64	fremovexattr		sys_fremovexattr
-200	64	tkill			sys_tkill
-201	64	time			sys_time
-202	64	futex			sys_futex
-203	64	sched_setaffinity	sys_sched_setaffinity
-204	64	sched_getaffinity	sys_sched_getaffinity
+181	common	getpmsg
+182	common	putpmsg
+183	common	afs_syscall
+184	common	tuxcall
+185	common	security
+186	common	gettid			sys_gettid
+187	common	readahead		sys_readahead
+188	common	setxattr		sys_setxattr
+189	common	lsetxattr		sys_lsetxattr
+190	common	fsetxattr		sys_fsetxattr
+191	common	getxattr		sys_getxattr
+192	common	lgetxattr		sys_lgetxattr
+193	common	fgetxattr		sys_fgetxattr
+194	common	listxattr		sys_listxattr
+195	common	llistxattr		sys_llistxattr
+196	common	flistxattr		sys_flistxattr
+197	common	removexattr		sys_removexattr
+198	common	lremovexattr		sys_lremovexattr
+199	common	fremovexattr		sys_fremovexattr
+200	common	tkill			sys_tkill
+201	common	time			sys_time
+202	common	futex			sys_futex
+203	common	sched_setaffinity	sys_sched_setaffinity
+204	common	sched_getaffinity	sys_sched_getaffinity
 205	64	set_thread_area
-206	64	io_setup		sys_io_setup
-207	64	io_destroy		sys_io_destroy
-208	64	io_getevents		sys_io_getevents
-209	64	io_submit		sys_io_submit
-210	64	io_cancel		sys_io_cancel
+206	common	io_setup		sys_io_setup
+207	common	io_destroy		sys_io_destroy
+208	common	io_getevents		sys_io_getevents
+209	common	io_submit		sys_io_submit
+210	common	io_cancel		sys_io_cancel
 211	64	get_thread_area
-212	64	lookup_dcookie		sys_lookup_dcookie
-213	64	epoll_create		sys_epoll_create
+212	common	lookup_dcookie		sys_lookup_dcookie
+213	common	epoll_create		sys_epoll_create
 214	64	epoll_ctl_old
 215	64	epoll_wait_old
-216	64	remap_file_pages	sys_remap_file_pages
-217	64	getdents64		sys_getdents64
-218	64	set_tid_address		sys_set_tid_address
-219	64	restart_syscall		sys_restart_syscall
-220	64	semtimedop		sys_semtimedop
-221	64	fadvise64		sys_fadvise64
+216	common	remap_file_pages	sys_remap_file_pages
+217	common	getdents64		sys_getdents64
+218	common	set_tid_address		sys_set_tid_address
+219	common	restart_syscall		sys_restart_syscall
+220	common	semtimedop		sys_semtimedop
+221	common	fadvise64		sys_fadvise64
 222	64	timer_create		sys_timer_create
-223	64	timer_settime		sys_timer_settime
-224	64	timer_gettime		sys_timer_gettime
-225	64	timer_getoverrun	sys_timer_getoverrun
-226	64	timer_delete		sys_timer_delete
-227	64	clock_settime		sys_clock_settime
-228	64	clock_gettime		sys_clock_gettime
-229	64	clock_getres		sys_clock_getres
-230	64	clock_nanosleep		sys_clock_nanosleep
-231	64	exit_group		sys_exit_group
-232	64	epoll_wait		sys_epoll_wait
-233	64	epoll_ctl		sys_epoll_ctl
-234	64	tgkill			sys_tgkill
-235	64	utimes			sys_utimes
+223	common	timer_settime		sys_timer_settime
+224	common	timer_gettime		sys_timer_gettime
+225	common	timer_getoverrun	sys_timer_getoverrun
+226	common	timer_delete		sys_timer_delete
+227	common	clock_settime		sys_clock_settime
+228	common	clock_gettime		sys_clock_gettime
+229	common	clock_getres		sys_clock_getres
+230	common	clock_nanosleep		sys_clock_nanosleep
+231	common	exit_group		sys_exit_group
+232	common	epoll_wait		sys_epoll_wait
+233	common	epoll_ctl		sys_epoll_ctl
+234	common	tgkill			sys_tgkill
+235	common	utimes			sys_utimes
 236	64	vserver
-237	64	mbind			sys_mbind
-238	64	set_mempolicy		sys_set_mempolicy
-239	64	get_mempolicy		sys_get_mempolicy
-240	64	mq_open			sys_mq_open
-241	64	mq_unlink		sys_mq_unlink
-242	64	mq_timedsend		sys_mq_timedsend
-243	64	mq_timedreceive		sys_mq_timedreceive
+237	common	mbind			sys_mbind
+238	common	set_mempolicy		sys_set_mempolicy
+239	common	get_mempolicy		sys_get_mempolicy
+240	common	mq_open			sys_mq_open
+241	common	mq_unlink		sys_mq_unlink
+242	common	mq_timedsend		sys_mq_timedsend
+243	common	mq_timedreceive		sys_mq_timedreceive
 244	64	mq_notify		sys_mq_notify
-245	64	mq_getsetattr		sys_mq_getsetattr
+245	common	mq_getsetattr		sys_mq_getsetattr
 246	64	kexec_load		sys_kexec_load
 247	64	waitid			sys_waitid
-248	64	add_key			sys_add_key
-249	64	request_key		sys_request_key
-250	64	keyctl			sys_keyctl
-251	64	ioprio_set		sys_ioprio_set
-252	64	ioprio_get		sys_ioprio_get
-253	64	inotify_init		sys_inotify_init
-254	64	inotify_add_watch	sys_inotify_add_watch
-255	64	inotify_rm_watch	sys_inotify_rm_watch
-256	64	migrate_pages		sys_migrate_pages
-257	64	openat			sys_openat
-258	64	mkdirat			sys_mkdirat
-259	64	mknodat			sys_mknodat
-260	64	fchownat		sys_fchownat
-261	64	futimesat		sys_futimesat
-262	64	newfstatat		sys_newfstatat
-263	64	unlinkat		sys_unlinkat
-264	64	renameat		sys_renameat
-265	64	linkat			sys_linkat
-266	64	symlinkat		sys_symlinkat
-267	64	readlinkat		sys_readlinkat
-268	64	fchmodat		sys_fchmodat
-269	64	faccessat		sys_faccessat
-270	64	pselect6		sys_pselect6
-271	64	ppoll			sys_ppoll
-272	64	unshare			sys_unshare
+248	common	add_key			sys_add_key
+249	common	request_key		sys_request_key
+250	common	keyctl			sys_keyctl
+251	common	ioprio_set		sys_ioprio_set
+252	common	ioprio_get		sys_ioprio_get
+253	common	inotify_init		sys_inotify_init
+254	common	inotify_add_watch	sys_inotify_add_watch
+255	common	inotify_rm_watch	sys_inotify_rm_watch
+256	common	migrate_pages		sys_migrate_pages
+257	common	openat			sys_openat
+258	common	mkdirat			sys_mkdirat
+259	common	mknodat			sys_mknodat
+260	common	fchownat		sys_fchownat
+261	common	futimesat		sys_futimesat
+262	common	newfstatat		sys_newfstatat
+263	common	unlinkat		sys_unlinkat
+264	common	renameat		sys_renameat
+265	common	linkat			sys_linkat
+266	common	symlinkat		sys_symlinkat
+267	common	readlinkat		sys_readlinkat
+268	common	fchmodat		sys_fchmodat
+269	common	faccessat		sys_faccessat
+270	common	pselect6		sys_pselect6
+271	common	ppoll			sys_ppoll
+272	common	unshare			sys_unshare
 273	64	set_robust_list		sys_set_robust_list
 274	64	get_robust_list		sys_get_robust_list
-275	64	splice			sys_splice
-276	64	tee			sys_tee
-277	64	sync_file_range		sys_sync_file_range
+275	common	splice			sys_splice
+276	common	tee			sys_tee
+277	common	sync_file_range		sys_sync_file_range
 278	64	vmsplice		sys_vmsplice
 279	64	move_pages		sys_move_pages
-280	64	utimensat		sys_utimensat
-281	64	epoll_pwait		sys_epoll_pwait
-282	64	signalfd		sys_signalfd
-283	64	timerfd_create		sys_timerfd_create
-284	64	eventfd			sys_eventfd
-285	64	fallocate		sys_fallocate
-286	64	timerfd_settime		sys_timerfd_settime
-287	64	timerfd_gettime		sys_timerfd_gettime
-288	64	accept4			sys_accept4
-289	64	signalfd4		sys_signalfd4
-290	64	eventfd2		sys_eventfd2
-291	64	epoll_create1		sys_epoll_create1
-292	64	dup3			sys_dup3
-293	64	pipe2			sys_pipe2
-294	64	inotify_init1		sys_inotify_init1
+280	common	utimensat		sys_utimensat
+281	common	epoll_pwait		sys_epoll_pwait
+282	common	signalfd		sys_signalfd
+283	common	timerfd_create		sys_timerfd_create
+284	common	eventfd			sys_eventfd
+285	common	fallocate		sys_fallocate
+286	common	timerfd_settime		sys_timerfd_settime
+287	common	timerfd_gettime		sys_timerfd_gettime
+288	common	accept4			sys_accept4
+289	common	signalfd4		sys_signalfd4
+290	common	eventfd2		sys_eventfd2
+291	common	epoll_create1		sys_epoll_create1
+292	common	dup3			sys_dup3
+293	common	pipe2			sys_pipe2
+294	common	inotify_init1		sys_inotify_init1
 295	64	preadv			sys_preadv
 296	64	pwritev			sys_pwritev
 297	64	rt_tgsigqueueinfo	sys_rt_tgsigqueueinfo
-298	64	perf_event_open		sys_perf_event_open
+298	common	perf_event_open		sys_perf_event_open
 299	64	recvmmsg		sys_recvmmsg
-300	64	fanotify_init		sys_fanotify_init
-301	64	fanotify_mark		sys_fanotify_mark
-302	64	prlimit64		sys_prlimit64
-303	64	name_to_handle_at	sys_name_to_handle_at
-304	64	open_by_handle_at	sys_open_by_handle_at
-305	64	clock_adjtime		sys_clock_adjtime
-306	64	syncfs			sys_syncfs
+300	common	fanotify_init		sys_fanotify_init
+301	common	fanotify_mark		sys_fanotify_mark
+302	common	prlimit64		sys_prlimit64
+303	common	name_to_handle_at	sys_name_to_handle_at
+304	common	open_by_handle_at	sys_open_by_handle_at
+305	common	clock_adjtime		sys_clock_adjtime
+306	common	syncfs			sys_syncfs
 307	64	sendmmsg		sys_sendmmsg
-308	64	setns			sys_setns
-309	64	getcpu			sys_getcpu
+308	common	setns			sys_setns
+309	common	getcpu			sys_getcpu
 310	64	process_vm_readv	sys_process_vm_readv
 311	64	process_vm_writev	sys_process_vm_writev
+#
+# x32-specific system call numbers start at 512 to avoid cache impact
+# for native 64-bit operation.
+#
+512	x32	rt_sigaction		sys32_rt_sigaction
+513	x32	rt_sigreturn		stub_x32_rt_sigreturn
+514	x32	ioctl			compat_sys_ioctl
+515	x32	readv			compat_sys_readv
+516	x32	writev			compat_sys_writev
+517	x32	recvfrom		compat_sys_recvfrom
+518	x32	sendmsg			compat_sys_sendmsg
+519	x32	recvmsg			compat_sys_recvmsg
+520	x32	execve			stub_x32_execve
+521	x32	times			compat_sys_times
+522	x32	rt_sigpending		sys32_rt_sigpending
+523	x32	rt_sigtimedwait		compat_sys_rt_sigtimedwait
+524	x32	rt_sigqueueinfo		sys32_rt_sigqueueinfo
+525	x32	sigaltstack		stub_x32_sigaltstack
+526	x32	timer_create		compat_sys_timer_create
+527	x32	mq_notify		compat_sys_mq_notify
+528	x32	kexec_load		compat_sys_kexec_load
+529	x32	waitid			compat_sys_waitid
+530	x32	set_robust_list		compat_sys_set_robust_list
+531	x32	get_robust_list		compat_sys_get_robust_list
+532	x32	vmsplice		compat_sys_vmsplice
+533	x32	move_pages		compat_sys_move_pages
+534	x32	preadv			compat_sys_preadv64
+535	x32	pwritev			compat_sys_pwritev64
+536	x32	rt_tgsigqueueinfo	compat_sys_rt_tgsigqueueinfo
+537	x32	recvmmsg		compat_sys_recvmmsg
+538	x32	sendmmsg		compat_sys_sendmmsg
+539	x32	process_vm_readv	compat_sys_process_vm_readv
+540	x32	process_vm_writev	compat_sys_process_vm_writev
diff --git a/arch/x86/um/sys_call_table_64.c b/arch/x86/um/sys_call_table_64.c
index fe626c3..9924776 100644
--- a/arch/x86/um/sys_call_table_64.c
+++ b/arch/x86/um/sys_call_table_64.c
@@ -35,6 +35,9 @@
 #define stub_sigaltstack sys_sigaltstack
 #define stub_rt_sigreturn sys_rt_sigreturn
 
+#define __SYSCALL_COMMON(nr, sym, compat) __SYSCALL_64(nr, sym, compat)
+#define __SYSCALL_X32(nr, sym, compat) /* Not supported */
+
 #define __SYSCALL_64(nr, sym, compat) extern asmlinkage void sym(void) ;
 #include <asm/syscalls_64.h>
 
diff --git a/arch/x86/um/user-offsets.c b/arch/x86/um/user-offsets.c
index 5edf4f4..ce7e360 100644
--- a/arch/x86/um/user-offsets.c
+++ b/arch/x86/um/user-offsets.c
@@ -15,6 +15,8 @@ static char syscalls[] = {
 };
 #else
 #define __SYSCALL_64(nr, sym, compat) [nr] = 1,
+#define __SYSCALL_COMMON(nr, sym, compat) [nr] = 1,
+#define __SYSCALL_X32(nr, sym, compat) /* Not supported */
 static char syscalls[] = {
 #include <asm/syscalls_64.h>
 };
-- 
1.7.6.5

