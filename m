Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab1J1P0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 11:26:19 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48989 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab1J1P0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 11:26:18 -0400
MIME-Version: 1.0
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 28 Oct 2011 17:25:57 +0200
Message-ID: <CAK1hOcN1ocnFh+HJWMONbUmoGtnxGvfrkxjRVs8zNmurz1xdrA@mail.gmail.com>
Subject: rename("a", "b") would not always remove "a" on success. ?!!
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Engelmayer <christian.engelmayer@frequentis.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

One of my users stumbled over a problem when power failure
hit his system at rename() and the filesystem he uses
(I don't know which) ended up having both old and new
file names in the directory. Basically, he ended up with
one file with two hardlinks pointing to it.

IOW: the scenario does not require unlucky power offs
to reproduce, just "ln a b" would do.

In his case these two particular hardlinks were pointing
to rotated log files.

When system restarted, it eventually tried to rotate files
again, via rename("a", "b").
rename succeeded, but since they are hardlinks, rename
did NOT remove "a".
Which made the logger process very confused.


The user dug into it and discovered that SUS actually
specifies this insane behavior:

http://pubs.opengroup.org/onlinepubs/9699919799/functions/rename.html

'If the old argument and the new argument resolve to either .... or different
directory entries for the same existing file, rename() shall return
successfully and perform no other action.'

It's incredible they had audacity to put such nonsense into standard.

The page says in "RATIONALE" section:

'The specification that if old and new refer to the same file is
intended to guarantee that:

rename("x", "x");

does not remove the file.'

Why didn't they just explicitly say that they actually want THIS
particular case to work correctly, not OTHER cases to be fucked up?!


Anyway. My question is, does it really need to be implemented in Linux?
It looks bogus to me, and it basically requires any program
to contain a work-around for this case. For example, mv from util-linux
apparently already has a workaround:

$ touch a; ln a b
$ strace mv a b
...
stat64("b", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
lstat64("a", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
lstat64("b", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
geteuid32()                             = 0
unlink("a")                             = 0
close(0)                                = 0
close(1)                                = 0
close(2)                                = 0
exit_group(0)                           = ?

-- 
vda
