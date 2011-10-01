Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab1JAOBo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 10:01:44 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63807 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab1JAOBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 10:01:36 -0400
MIME-Version: 1.0
Date: Sat, 1 Oct 2011 22:01:35 +0800
Message-ID: <CABqxG0feuZCmx=RfxU-50uFK9-P2vNbAMqJUdWM5RhuJifD5Ow@mail.gmail.com>
Subject: [BUG] copy file result with zero
From: Dave Young <hidave.darkstar@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Weird problem, when I build app from source,
make; make install
run the command, but got "cannot execute binary file"

hexdump shows the installed binary is full of zero

Is it related to ext4 fiemap problem described below?
http://lwn.net/Articles/429349/

I finally managed to find the way to reproduce this:
just cp a elf binary A  to file B, then cp B to file C,  then you will get:
A == B != C

ie.
cp /bin/ls ls1
cp ls1 ls2

ls2 will be filled with zero

Below is a strace log of install, kernel version is 3.1.0-rc6+
geteuid()                               = 0
umask(0)                                = 022
stat("/tmp/vpnc", 0x7fff85363710)       = -1 ENOENT (No such file or directory)
stat("vpnc", {st_mode=S_IFREG|0755, st_size=368662, ...}) = 0
lstat("/tmp/vpnc", 0x7fff85363250)      = -1 ENOENT (No such file or directory)
open("vpnc", O_RDONLY)                  = 3
fstat(3, {st_mode=S_IFREG|0755, st_size=368662, ...}) = 0
open("/tmp/vpnc", O_WRONLY|O_CREAT|O_EXCL, 0755) = 4
fstat(4, {st_mode=S_IFREG|0755, st_size=0, ...}) = 0
uname({sys="Linux", node="darkstar", ...}) = 0
ioctl(3, FS_IOC_FIEMAP, 0x7fff85361f60) = 0
ftruncate(4, 368662)                    = 0
fsetxattr(4, "system.posix_acl_access",
"\x02\x00\x00\x00\x01\x00\x06\x00\xff\xff\xff\xff\x04\x00\x00\x00\xff\xff\xff\xff
\x00\x00\x00\xff\xff\xff\xff", 28, 0) = 0
close(4)                                = 0
close(3)                                = 0
chmod("/tmp/vpnc", 0755)                = 0
close(0)                                = 0
close(1)                                = 0
close(2)                                = 0
exit_group(0)                           = ?
-- 
Regards
Dave
