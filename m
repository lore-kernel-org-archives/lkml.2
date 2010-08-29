Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab0H2PjW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 11:39:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63514 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab0H2PjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 11:39:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Vev5rwuOtp7QeYIvRdGI7AGcWQnp31jTi3kAHOFXKVi6JZV/4UnFSRPngNFrbuwhW2
         V8KbPsy2iDcA1X332LD7NMsc9tOinTYhgdwz/YZw8jeJuRuZsHTfEinksDjQ8c/JJT7l
         5SA062B8t3Ntc0xdkgGXsbIWUOK3sv5VX0LP0=
MIME-Version: 1.0
Date: Sun, 29 Aug 2010 10:39:18 -0500
Message-ID: <AANLkTikwLwYkoBLKgJ0Hu+ML+QK3n9R1-mBbHuQLpkkP@mail.gmail.com>
Subject: PROBLEM: setkey PF tagging
From: Scott Helvick <scott.helvick@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to add an SPD entry using a PF tag (netfilter mark?), using
the syntax:

spdadd tagged "tag1" -P in none;

But am receiving "Invalid argument" errors from what appears to be the
PF_KEY socket (see strace below).  The syntax is correct based on what
I can discern from the little documentation available about this
feature.

####################

# scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux sr4 2.6.35.4 #1 SMP Sun Aug 29 08:36:43 CDT 2010 x86_64 x86_64
x86_64 GNU/Linux

Gnu C                  4.4.3
Gnu make               3.81
binutils               2.20
util-linux             2.17
mount                  support
module-init-tools      3.11.1
e2fsprogs              1.41.10
Linux C Library        2.11.1
Dynamic linker (ldd)   2.11.1
Linux C++ Library      6.0.13
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.1
Sh-utils               8.4
Modules Loaded

####################

# cat test.conf
#!/usr/sbin/setkey -f

spdadd tagged "tag1" -P in none;
spdadd tagged "tag2" -P out ipsec esp/transport//require;

####################

# setkey -vx -f test.conf
sadb_msg{ version=2 type=14 errno=0 satype=0
  len=4 reserved=0 seq=0 pid=2579
sadb_ext{ len=2 type=18 }
sadb_x_policy{ type=1 dir=1 id=0 priority=2147483648 }

sadb_msg{ version=2 type=14 errno=22 satype=0
  len=2 reserved=0 seq=0 pid=2579

The result of line 3: Invalid argument.
sadb_msg{ version=2 type=14 errno=0 satype=0
  len=6 reserved=0 seq=0 pid=2579
sadb_ext{ len=4 type=18 }
sadb_x_policy{ type=2 dir=2 id=0 priority=2147483648 }
 { len=16 proto=50 mode=1 level=2 reqid=0
 }

sadb_msg{ version=2 type=14 errno=22 satype=0
  len=2 reserved=0 seq=0 pid=2579

The result of line 4: Invalid argument.

####################

# strace -fittTv -e all -s 1000 setkey -f test.conf
[...]
09:49:46.211062 [    7fbe51037940] open("test.conf", O_RDONLY) = 3 <0.000029>
09:49:46.211139 [    7fbe51044c97] socket(PF_KEY, SOCK_RAW, 2) = 4 <0.000024>
09:49:46.211212 [    7fbe51044c3a] setsockopt(4, SOL_SOCKET,
SO_SNDBUF, [131072], 4) = 0 <0.000023>
09:49:46.211281 [    7fbe51044c3a] setsockopt(4, SOL_SOCKET,
SO_RCVBUF, [131072], 4) = 0 <0.000022>
09:49:46.211346 [    7fbe51044c3a] setsockopt(4, SOL_SOCKET,
SO_RCVBUF, [262144], 4) = 0 <0.000026>
09:49:46.211417 [    7fbe51044c3a] setsockopt(4, SOL_SOCKET,
SO_RCVBUF, [524288], 4) = 0 <0.000023>
09:49:46.211485 [    7fbe51044c3a] setsockopt(4, SOL_SOCKET,
SO_RCVBUF, [1048576], 4) = 0 <0.000025>
09:49:46.211564 [    7fbe510161db] getpid() = 2630 <0.000020>
09:49:46.211629 [    7fbe51044ad2] sendto(4, "\2\7\0\0\2\0\0\0\0\0\0\0F\n\
0\0", 16, 0, NULL, 0) = 16 <0.019456>
09:49:46.231175 [    7fbe51044952] recvfrom(4,
"\2\7\0\0\21\0\0\0\0\0\0\0F\n\0\0", 16, MSG_PEEK, NULL, NULL) = 16
<0.000040>
09:49:46.231288 [    7fbe51044952] recvfrom(4,
"\2\7\0\0\21\0\0\0\0\0\0\0F\n\0\0\7\0\16\0
\0\214\0\373\0\0\0\0\0\0\0\2\0\200\0\200\0\0\0\3\0\240\0\240\0\0\0\5\0\0\1\0\1\0\0\6\0\200\1\200\1\0\0\7\0\0\2\0\2\0\0\10\0\17\0STM:\v\0\0\0\0\0\0\0\2\10@\0@\0\0\0\3\10\300\0\300\0\0\0\7\10(\0\300\1\0\0\f\10\200\0\0\1\0\0\374\10\200\0\0\1\0\0\375\10\200\0\0\1\0\0",
136, 0, NULL, NULL) = 136 <0.000032>
09:49:46.231445 [    7fbe5103c147] ioctl(3, SNDCTL_TMR_TIMEBASE or
TCGETS, 0x7fff0df51220) = -1 ENOTTY (Inappropriate ioctl for device)
<0.000033>
09:49:46.231556 [    7fbe510374b4] fstat(3, {st_dev=makedev(8, 2),
st_ino=292, st_mode=S_IFREG|0644, st_nlink=1, st_uid=0, st_gid=0,
st_blksize=4096, st_blocks=8, st_size=114,
st_atime=2010/08/29-09:45:43, st_mtime=2010/08/29-09:45:39,
st_ctime=2010/08/29-09:45:39}) = 0 <0.000032>
09:49:46.231661 [    7fbe510408aa] mmap(NULL, 4096,
PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0x7fbe52122000 <0.000041>
09:49:46.231757 [    7fbe51037b30] read(3, "#!/usr/sbin/setkey
-f\n\nspdadd tagged \"tag1\" -P in none;\nspdadd tagged \"tag2\" -P
out ipsec esp/transport//require;\n", 8192) = 114 <0.000031>
09:49:46.231912 [    7fbe51037b30] read(3, "", 4096) = 0 <0.000038>
09:49:46.232053 [    7fbe51044c3a] setsockopt(4, SOL_SOCKET,
SO_RCVTIMEO, "\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 16) = 0 <0.000037>
09:49:46.232164 [    7fbe51044ad2] sendto(4,
"\2\16\0\0\4\0\0\0\0\0\0\0F\n\0\0\2\0\22\0\1\0\1\0\0\0\0\0\0\0\0\200",
32, 0, NULL, 0) = 32 <0.000036>
09:49:46.232273 [    7fbe51044952] recvfrom(4,
"\2\16\26\0\2\0\0\0\0\0\0\0F\n\0\0", 32768, 0, NULL, NULL) = 16
<0.000031>
09:49:46.232406 [    7fbe510374b4] fstat(1, {st_dev=makedev(0, 9),
st_ino=3, st_mode=S_IFCHR|0620, st_nlink=1, st_uid=1000, st_gid=4,
st_blksize=1024, st_blocks=0, st_rdev=makedev(136, 0),
st_atime=2010/08/29-09:49:46, st_mtime=2010/08/29-09:49:46,
st_ctime=2010/08/29-08:38:36}) = 0 <0.000043>
09:49:46.232543 [    7fbe510408aa] mmap(NULL, 4096,
PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0x7fbe52121000 <0.000043>
09:49:46.232651 [    7fbe51037b90] write(1, "The result of line 3:
Invalid argument.\n", 40The result of line 3: Invalid argument.
) = 40 <0.000043>
09:49:46.232770 [    7fbe51044c3a] setsockopt(4, SOL_SOCKET,
SO_RCVTIMEO, "\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 16) = 0 <0.000039>
09:49:46.232868 [    7fbe51044ad2] sendto(4,
"\2\16\0\0\6\0\0\0\0\0\0\0F\n\0\0\4\0\22\0\2\0\2\0\0\0\0\0\0\0\0\200\20\0002\0\1\2\0\0\0\0\0\0\0\0\0\0",
48, 0, NULL, 0) = 48 <0.000043>
09:49:46.232994 [    7fbe51044952] recvfrom(4,
"\2\16\26\0\2\0\0\0\0\0\0\0F\n\0\0", 32768, 0, NULL, NULL) = 16
<0.000037>
09:49:46.233104 [    7fbe51037b90] write(1, "The result of line 4:
Invalid argument.\n", 40The result of line 4: Invalid argument.
) = 40 <0.000042>
09:49:46.233211 [    7fbe51037b30] read(3, "", 8192) = 0 <0.000036>
09:49:46.233310 [    7fbe5103c147] ioctl(3, SNDCTL_TMR_TIMEBASE or
TCGETS, 0x7fff0df51220) = -1 ENOTTY (Inappropriate ioctl for device)
<0.000039>
09:49:46.233439 [    7fbe510156a8] exit_group(0) = ?

####################

It looks to me like setkey is parsing the output and passing it to the
open socket, which returns an error.  Unfortunately, my knowledge of
this topic is not sufficient to offer much more, though I'm happy to
provide any further information you deem useful.

Thanks!
-Scott
