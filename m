Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab3AJQ3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 11:29:12 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47000 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753090Ab3AJQ3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:29:11 -0500
Date: Thu, 10 Jan 2013 17:29:07 +0100
From: Florian Westphal <fw@strlen.de>
To: Alan Cox <alan@linux.intel.com>
Cc: Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        gaowanlong@cn.fujitsu.com, gregkh@linuxfoundation.org,
        frank@lichtenheld.de
Subject: Re: regression, bisected: openpty fails from 3.7 onwards without
 devpts
Message-ID: <20130110162907.GB26279@breakpoint.cc>
References: <20130110144626.GA26279@breakpoint.cc>
 <20130110155058.12f66e73@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <20130110155058.12f66e73@bob.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Alan Cox <alan@linux.intel.com> wrote:
> On Thu, 10 Jan 2013 15:46:26 +0100
> Florian Westphal <fw@strlen.de> wrote:
> > Frank Lichtenheld discovered that openpty() doesn't work anymore when
> > /dev/pts is not present.
> > 
> > We bisected this down to
> > 
> > commit bbb63c514a3464342967237a51a21ea8f61ab951
> > Author: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> > Subject: drivers:tty:fix up ENOIOCTLCMD error handling

[..]

> > #include <stdio.h>
> > #include <pty.h>
> > int main(void) {
> >  int pty_fd, tty_fd;
> >  if (openpty(&pty_fd, &tty_fd, NULL, NULL, NULL) != 0) {
> >   perror("openpty");
> >   return 1;
> >  }
> > return 0;
> > }
> > ----
> > [ compile with cc -lutil pty.c -o pty ]
> > 
> > If devpts is available or above commit reverted openpty works again.
> 
> The commit is fairly general - what we need to do here is to figure out
> which specific thing trips up openpty so we can put the error on that
> back as it was (or find a better way) so it still works.
> 
> Can you attach an strace of the working/failing cases without /dev/pts 

Sure, attached.  /dev/pts is not present.
Both traces are from the same machine, with same kernel version (except
above commit reverted).

--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="openpty.ok.trace.txt"

execve("./ptytest", ["./ptytest"], [/* 7 vars */]) = 0
brk(0)                                  = 0x1d04000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe6784d0000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=15432, ...}) = 0
mmap(NULL, 15432, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fe6784cc000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libutil.so.1", O_RDONLY) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20\16\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=10640, ...}) = 0
mmap(NULL, 2105608, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fe6780b0000
mprotect(0x7fe6780b2000, 2093056, PROT_NONE) = 0
mmap(0x7fe6782b1000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1000) = 0x7fe6782b1000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\300\357\1\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1595408, ...}) = 0
mmap(NULL, 3709016, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fe677d26000
mprotect(0x7fe677ea6000, 2097152, PROT_NONE) = 0
mmap(0x7fe6780a6000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x180000) = 0x7fe6780a6000
mmap(0x7fe6780ab000, 18520, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fe6780ab000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe6784cb000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe6784ca000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe6784c9000
arch_prctl(ARCH_SET_FS, 0x7fe6784ca700) = 0
mprotect(0x7fe6780a6000, 16384, PROT_READ) = 0
mprotect(0x7fe6782b1000, 4096, PROT_READ) = 0
mprotect(0x7fe6784d2000, 4096, PROT_READ) = 0
munmap(0x7fe6784cc000, 15432)           = 0
open("/dev/ptmx", O_RDWR)               = -1 ENOSPC (No space left on device)
open("/dev/ptyp0", O_RDWR)              = 3
ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
ioctl(3, TIOCGPTN, [0])                 = -1 EINVAL (Invalid argument)
fstat(3, {st_mode=S_IFCHR|S_ISVTX|0666, st_rdev=makedev(2, 0), ...}) = 0
stat("/dev/ttyp0", {st_mode=S_IFCHR|S_ISVTX|0660, st_rdev=makedev(3, 0), ...}) = 0
getuid()                                = 0
socket(PF_FILE, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 4
connect(4, {sa_family=AF_FILE, path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(4)                                = 0
socket(PF_FILE, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 4
connect(4, {sa_family=AF_FILE, path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(4)                                = 0
brk(0)                                  = 0x1d04000
brk(0x1d25000)                          = 0x1d25000
open("/etc/nsswitch.conf", O_RDONLY)    = 4
fstat(4, {st_mode=S_IFREG|0644, st_size=475, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe6784cf000
read(4, "# /etc/nsswitch.conf\n#\n# Example"..., 4096) = 475
read(4, "", 4096)                       = 0
close(4)                                = 0
munmap(0x7fe6784cf000, 4096)            = 0
open("/etc/ld.so.cache", O_RDONLY)      = 4
fstat(4, {st_mode=S_IFREG|0644, st_size=15432, ...}) = 0
mmap(NULL, 15432, PROT_READ, MAP_PRIVATE, 4, 0) = 0x7fe6784cc000
close(4)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libnss_compat.so.2", O_RDONLY) = 4
read(4, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`\22\0\0\0\0\0\0"..., 832) = 832
fstat(4, {st_mode=S_IFREG|0644, st_size=31584, ...}) = 0
mmap(NULL, 2127048, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0x7fe677b1e000
mprotect(0x7fe677b25000, 2093056, PROT_NONE) = 0
mmap(0x7fe677d24000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x6000) = 0x7fe677d24000
close(4)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libnsl.so.1", O_RDONLY) = 4
read(4, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0 @\0\0\0\0\0\0"..., 832) = 832
fstat(4, {st_mode=S_IFREG|0644, st_size=89056, ...}) = 0
mmap(NULL, 2194128, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0x7fe677906000
mprotect(0x7fe67791b000, 2093056, PROT_NONE) = 0
mmap(0x7fe677b1a000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x14000) = 0x7fe677b1a000
mmap(0x7fe677b1c000, 6864, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fe677b1c000
close(4)                                = 0
mprotect(0x7fe677b1a000, 4096, PROT_READ) = 0
mprotect(0x7fe677d24000, 4096, PROT_READ) = 0
munmap(0x7fe6784cc000, 15432)           = 0
open("/etc/ld.so.cache", O_RDONLY)      = 4
fstat(4, {st_mode=S_IFREG|0644, st_size=15432, ...}) = 0
mmap(NULL, 15432, PROT_READ, MAP_PRIVATE, 4, 0) = 0x7fe6784cc000
close(4)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libnss_nis.so.2", O_RDONLY) = 4
read(4, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0  \0\0\0\0\0\0"..., 832) = 832
fstat(4, {st_mode=S_IFREG|0644, st_size=43552, ...}) = 0
mmap(NULL, 2139320, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0x7fe6776fb000
mprotect(0x7fe677705000, 2093056, PROT_NONE) = 0
mmap(0x7fe677904000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x9000) = 0x7fe677904000
close(4)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libnss_files.so.2", O_RDONLY) = 4
read(4, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\200!\0\0\0\0\0\0"..., 832) = 832
fstat(4, {st_mode=S_IFREG|0644, st_size=47616, ...}) = 0
mmap(NULL, 2143624, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0x7fe6774ef000
mprotect(0x7fe6774fa000, 2093056, PROT_NONE) = 0
mmap(0x7fe6776f9000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0xa000) = 0x7fe6776f9000
close(4)                                = 0
mprotect(0x7fe6776f9000, 4096, PROT_READ) = 0
mprotect(0x7fe677904000, 4096, PROT_READ) = 0
munmap(0x7fe6784cc000, 15432)           = 0
open("/etc/group", O_RDONLY|O_CLOEXEC)  = 4
lseek(4, 0, SEEK_CUR)                   = 0
fstat(4, {st_mode=S_IFREG|0644, st_size=578, ...}) = 0
mmap(NULL, 578, PROT_READ, MAP_SHARED, 4, 0) = 0x7fe6784cf000
lseek(4, 578, SEEK_SET)                 = 578
munmap(0x7fe6784cf000, 578)             = 0
close(4)                                = 0
chown("/dev/ttyp0", 0, 5)               = 0
chmod("/dev/ttyp0", 0620)               = 0
ioctl(3, TIOCSPTLCK, [0])               = 0
ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
ioctl(3, TIOCGPTN, [0])                 = -1 EINVAL (Invalid argument)
fstat(3, {st_mode=S_IFCHR|S_ISVTX|0666, st_rdev=makedev(2, 0), ...}) = 0
stat("/dev/ttyp0", {st_mode=S_IFCHR|0620, st_rdev=makedev(3, 0), ...}) = 0
open("/dev/ttyp0", O_RDWR|O_NOCTTY)     = 4
fstat(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(5, 1), ...}) = 0
ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, {B9600 opost isig icanon echo ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe6784cf000
write(1, "got 3 4\n", 8)                = 8
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigaction(SIGCHLD, NULL, {SIG_DFL, [], 0}, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
nanosleep({100, 0}, 0x7fffa8389270)     = 0
exit_group(0)                           = ?

--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="openpty.fail.trace.txt"

execve("./ptytest", ["./ptytest"], [/* 7 vars */]) = 0
brk(0)                            = 0x1df4000
access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f207c0e4000
access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=15432, ...}) = 0
mmap(NULL, 15432, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f207c0e0000
close(3)                          = 0
access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libutil.so.1", O_RDONLY) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20\16\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=10640, ...}) = 0
mmap(NULL, 2105608, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f207bcc4000
mprotect(0x7f207bcc6000, 2093056, PROT_NONE) = 0
mmap(0x7f207bec5000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1000) = 0x7f207bec5000
close(3)                          = 0
access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\300\357\1\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1595408, ...}) = 0
mmap(NULL, 3709016, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f207b93a000
mprotect(0x7f207baba000, 2097152, PROT_NONE) = 0
mmap(0x7f207bcba000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x180000) = 0x7f207bcba000
mmap(0x7f207bcbf000, 18520, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f207bcbf000
close(3)                          = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f207c0df000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f207c0de000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f207c0dd000
arch_prctl(ARCH_SET_FS, 0x7f207c0de700) = 0
mprotect(0x7f207bcba000, 16384, PROT_READ) = 0
mprotect(0x7f207bec5000, 4096, PROT_READ) = 0
mprotect(0x7f207c0e6000, 4096, PROT_READ) = 0
munmap(0x7f207c0e0000, 15432)     = 0
open("/dev/ptmx", O_RDWR)         = -1 ENOSPC (No space left on device)
open("/dev/ptyp0", O_RDWR)        = 3
ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
ioctl(3, TIOCGPTN, [0])           = -1 ENOTTY (Inappropriate ioctl for device)
stat("", 0x7fff02b175d0)          = -1 ENOENT (No such file or directory)
fcntl(3, F_GETFD)                 = 0
close(3)                          = 0
dup(2)                            = 3
fcntl(3, F_GETFL)                 = 0x8002 (flags O_RDWR|O_LARGEFILE)
brk(0)                            = 0x1df4000
brk(0x1e15000)                    = 0x1e15000
fstat(3, {st_mode=S_IFCHR|0600, st_rdev=makedev(5, 1), ...}) = 0
ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, {B9600 opost isig icanon echo ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f207c0e3000
lseek(3, 0, SEEK_CUR)             = -1 ESPIPE (Illegal seek)
write(3, "openpty: No such file or directo"..., 35) = 35
close(3)                          = 0
munmap(0x7f207c0e3000, 4096)      = 0
fstat(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(5, 1), ...}) = 0
ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, {B9600 opost isig icanon echo ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f207c0e3000
write(1, "got -1 -1\n", 10)       = 10
exit_group(1)                     = ?

--envbJBWh7q8WU6mo--
