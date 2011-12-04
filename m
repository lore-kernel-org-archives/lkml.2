Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab1LDUkr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 15:40:47 -0500
Received: from science.horizon.com ([71.41.210.146]:63537 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755353Ab1LDUkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 15:40:46 -0500
Date: 4 Dec 2011 15:40:44 -0500
Message-ID: <20111204204044.10290.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux-kernel@vger.kernel.org
Subject: Is there a reason hard links from /proc/$PID/fd/$NUM are disallowed?
Cc: linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was trying to save a large file that was in mid-download that I had
accidentally deleted (as part of making space in /tmp to hold the file!).

Since it was being held open by the download process, I tried

ln /proc/$PID/fd/$FD /tmp/bigfile.mp4

And got complaints about a cross-device link.

Then I tried cp -l, and got the same error.

Running strace, it appears that cp thinks it should be able to do it,
because the files really *are* on the same file system, but can't:

stat64("/tmp/foo.mp4", 0xbfba74a4)      = -1 ENOENT (No such file or directory)
stat64("/proc/3137/fd/70", {st_mode=S_IFREG|0644, st_size=13796248, ...}) = 0
lstat64("/tmp/foo.mp4", 0xbfba7210)     = -1 ENOENT (No such file or directory)
linkat(AT_FDCWD, "/proc/3137/fd/70", AT_FDCWD, "/tmp/foo.mp4", 0) = -1 EXDEV (Invalid cross-device link)

I notice that other people have tried to do the same thing:
http://lwn.net/Articles/209900/

But generally solutions are based on cp, which is awkward for a file
that's being actively downloaded and will be closed the instant it's
complete.  I really need a hard link.

This seems a silly unnecessary restriction, but before I figure out how
to remove it (I know it'll be FS-specific, but should be easy enough for
tmpfs), is there some important reason why it has to stay?  Are there
some bad security implications to providing this ability?

Now that my panic is over, I realize I could have just done a "sleep
100000 < /proc/$PID/fd/70 &" to hold on to the file descriptor, waited
until the download finished, and copied it *then*.  Or, if I had such a
utility prepared, I could have used a server that held the file open
and provided access to it via FUSE.

So I don't *think* it should allow any new attacks.  But maybe there's
something subtle?
