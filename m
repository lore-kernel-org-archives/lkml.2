Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab1DSHWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 03:22:23 -0400
Received: from ext190.halfdog.net ([88.116.147.190]:50244 "EHLO
	mail.halfdog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab1DSHWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 03:22:20 -0400
X-Greylist: delayed 679 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Apr 2011 03:22:18 EDT
Message-ID: <4DAD361D.1010602@halfdog.net>
Date: Tue, 19 Apr 2011 07:13:33 +0000
From: halfdog <me@halfdog.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:2.0b8pre) Gecko/20101210 Firefox/4.0b8pre SeaMonkey/2.1b2pre
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Opinions on open/exec syscalls and security
X-Enigmail-Version: 1.2a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello List,

Quite a few programs, that have to traverse directory trees recursively,
do not treat symlinks correctly, e.g. most backup applications I tested
allowed inclusion of arbitrary files. Although this could just be seen
as a problem of application security, I think that the suboptimal kernel
interface to filesystem makes it hard to code correctly, hence
increasing the number of vulnerable programs of some type (e.g. backup
programs).

The problem is, that is hard to open a file in a user-controlled
directory, e.g. for backup, and apply some policy to that, e.g. that no
component in the path is a symlink. Otherwise, the sequence

readdir /home/user/somedir/
open  /home/user/somedir/shadow

in a backup program might cause inclusion of real password, if somedir
was moved and relinked to /etc in between the two calls, a race that is
very easy to win. If the backup program would do only openat/stat pairs
for every component in the path, the program then might run out of
filedescriptors easily (DOS).

- From my opinion, the system api, that makes it too hard to check, if
problematic symlinks (or user space filesystem mounts) are included in a
path. To provide really time-race free api, an open-and-check operation
could be useful. An implementation of a "secure" file open library call,
e.g. in libc, would also be an option, but it might be rather hard to
provide the same level of security, because the library routine has no
atomic syscall to rely on, and hence implementation might be racy,
altough the window of opportunity might be very small. Without this
system support, it is quite tricky to write 100% correct code and one
might introduce other flaws, e.g. DOS via reaching max. open file
descriptors.

Could a new syscall or modified syscall options make it easier for
developers, so that they to not have to keep numerous fds open and apply
all the policy checks in user space, e.g. using inode numbers, dev
references?

See http://www.halfdog.net/Security/2010/FilesystemRecursionAndSymlinks/
for a short writeup on that topic (still work in progress).

- -- 
http://www.halfdog.net/
PGP: 156A AE98 B91F 0114 FE88  2BD8 C459 9386 feed a bee
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFNrTVdxFmThv7tq+4RAprNAJ9nTTy2s2zjS4zy6wUk7SZPkN10nwCgh061
mNiOTFp9x0mhvkA418AHDgo=
=6LcN
-----END PGP SIGNATURE-----
