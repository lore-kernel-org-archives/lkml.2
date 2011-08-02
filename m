Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab1HBAam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 20:30:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36889 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab1HBAag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 20:30:36 -0400
MIME-Version: 1.0
Date: Tue, 2 Aug 2011 02:30:35 +0200
Message-ID: <CAPwCz79UntBiAs4X+XSj62xvkpK0CW6cqQqhyCU97r4u5SmJ_g@mail.gmail.com>
Subject: [3.0.0+][Regression][Bisected] CIFS: getdents() broken for large dirs
From: Jan Seiffert <kaffeemonster@googlemail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jlayton@redhat.com
Cc: sfrench@us.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC, as not subscibed.

Looks like something broke CIFS.
Kernel 3.0.0 works, master after the CIFS merge does not ATM.

Example cifs mount is:
$ mount
...
//server/portage on /usr/portage type cifs (rw,mand)

Server is:
$ smbd --version
Version 3.4.12

Actual Output is:
$ ls -l /usr/portage/ | wc -l
ls: reading directory /usr/portage/: input/output error
1
$ ls -l /usr/portage/distfiles | wc -l
105

Expected Output:
$ ls -l /usr/portage/ | wc -l
170
$ ls -l /usr/portage/distfiles/ | wc -l
47470

/usr/portage contains a lot of directories, /usr/portage/distfiles
contains lots of files.

A bisect in fs/cifs gives:
$ git bisect bad
c4d3396b261473ded6f370edd1e79ba34e089d7e is the first bad commit
commit c4d3396b261473ded6f370edd1e79ba34e089d7e
Author: Jeff Layton <jlayton@redhat.com>
Date:   Tue Jul 26 12:20:18 2011 -0400

    cifs: advertise the right receive buffer size to the server

    Currently, we mirror the same size back to the server that it sends us.
    That makes little sense. Instead we should be sending the server the
    maximum buffer size that we can handle -- CIFSMaxBufSize minus the
    4 byte RFC1001 header.

    Signed-off-by: Jeff Layton <jlayton@redhat.com>
    Signed-off-by: Steve French <sfrench@us.ibm.com>

:040000 040000 7a5015e0b47ca27538c4387a3b38470c86a42bae
c802cfda7d618f1073e45ce98efe65ce03cd0e79 M      fs

$ git bisect log
git bisect start '--' 'fs/cifs/'
# bad: [5f66d2b58ca879e70740c82422354144845d6dd3] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6
git bisect bad 5f66d2b58ca879e70740c82422354144845d6dd3
# good: [02f8c6aee8df3cdc935e9bdd4f2d020306035dbe] Linux 3.0
git bisect good 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe
# good: [3ca30d40a91fb9b9871e61d5dea2c1a895906a15] CIFS: Fix oops
while mounting with prefixpath
git bisect good 3ca30d40a91fb9b9871e61d5dea2c1a895906a15
# bad: [1f1cff0be05f59d5939edf28ff5ca0c6fd0a8e1c] cifs: trivial: goto
out here is unnecessary
git bisect bad 1f1cff0be05f59d5939edf28ff5ca0c6fd0a8e1c
# good: [e010a5ef95b8b6a12b74b548578f7dcf93564347] [CIFS] Redundant
null check after dereference
git bisect good e010a5ef95b8b6a12b74b548578f7dcf93564347
# good: [1d87c28e680ce4ecb8c260d8ce070b8339d52abb] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6
git bisect good 1d87c28e680ce4ecb8c260d8ce070b8339d52abb
# bad: [c4d3396b261473ded6f370edd1e79ba34e089d7e] cifs: advertise the
right receive buffer size to the server
git bisect bad c4d3396b261473ded6f370edd1e79ba34e089d7e

A git revert of c4d3396b261473ded6f370edd1e79ba34e089d7e seems to resolve it.

If more info is needed, please let me know.

Greetings
Jan
