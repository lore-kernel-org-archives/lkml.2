Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934162Ab2LIPJy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 10:09:54 -0500
Received: from plane.gmane.org ([80.91.229.3]:49977 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934066Ab2LIPJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 10:09:53 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tristan Wibberley <tristan.wibberley@gmail.com>
Subject: New system call wanted: fdreopen
Date: Sun, 9 Dec 2012 15:03:30 +0000 (UTC)
Message-ID: <ka2982$ra3$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 87.112.131.179
User-Agent: Pan/0.139 (Sexual Chocolate; GIT bf56508
	git://git.gnome.org/pan2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'd like to propose a system call called "fdreopen":

  int fdreopen(int src_fd, int dst_fd, int flags);


I am willing to try implementing this system call given some suggestions 
where to start and what locking to watch out for. I have given a brief of 
the behaviour below, and a description of the class of problem that it 
solves at the end.

Does anybody know any reasons why this system call would be impossible/
impractical or otherwise unacceptable?

Any improvements I should consider before trying to implement it?


Behaviour
=========

This system call would be like dup3 except for these things:

 - if dst_fd is -1 then the lowest available file descriptor is allocated
   rather than returning EBADF as dup3 does.

 - the new file descriptor points to a *new* entry in the file table much
   as if the original file had been opened again via open or openat. This
   means that two large independent libraries can seek and read without
   synchronising even when they cannot open a file by its path.

 - O_RDWR access can be reduced to O_RDONLY or O_WRONLY:
    int src_fd = open("/file", O_RDWR | O_CLOEXEC);
    new_fd = fdreopen(src_fd, -1, O_CLOEXEC | O_RDONLY);

 - it would be async signal safe.


Why
===

A common idiom on Linux is to open a file and keep the fd open so that 
the underlying file can be unlinked from its directory. But if the file 
needs to be read from several different parts of the codebase then due to 
the file descriptor having exactly one read pointer those different parts 
must be synchronised which is a relatively difficult task.

I think that this new system call is required to achieve that neatly and 
simply:

- dup does not solve this problem because it only allows the new file
  descriptor to have its own flags (eg O_CLOEXEC).

- /proc/self/fd/* does not solve this problem because the file might no
  longer be available at the same place in the filesystem. In some
  otherwise simple message passing or ReSTful IPC a different file will
  be available at that path.

I suspect that user space has been solving this problem with otherwise 
unnecessary levels of either synchronisation or difficult to reproduce 
occasional bugs.

-- 
Tristan Wibberley

