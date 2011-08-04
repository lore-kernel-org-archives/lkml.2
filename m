Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab1HDLSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 07:18:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47390 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab1HDLRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 07:17:55 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 0/1] readlinkat() error code change for empty pathname
Date: Thu,  4 Aug 2011 12:00:33 +0100
Message-Id: <1312455634-16253-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the 3.0 kernel we seem to have a semantic change in the error
code returned by the readlink/readlinkat calls for the empty pathname.
Specifically is is now returning EINVAL whereas it used to return ENOENT.
This appears to be contrary to our documentation on the expected return
code for the empty pathname (path_resolution(7)):

   Empty pathname
       In the original Unix, the empty pathname referred to the current direc-
       tory.  Nowadays POSIX decrees  that  an  empty  pathname  must  not  be
       resolved successfully.  Linux returns ENOENT in this case.

It is also possible we are moving away from posix compliance if the
comments in the source are to believed (from the comments on do_getname
in fs/namei.c):

 * POSIX.1 2.4: an empty pathname is invalid (ENOENT).

This is causing a number of applications to fail to build in Ubuntu
(at least those including gnulib), mostly with test suite failures.
It seems that application writers are relying on this behaviour.

Doing a quick review of a selection of pathname related calls we also
seem now to be inconsistant in our return for readlink/readlinkat:

  open("", O_RDONLY) = -1 ENOENT (No such file or directory)
  chmod("", 0777) = -1 ENOENT (No such file or directory)
  readlink("", 0x7fff794533c0, 2048) = -1 EINVAL (Invalid argument)
  stat("", 0x7fff79453330) = -1 ENOENT (No such file or directory)
  rename("", "") = -1 ENOENT (No such file or directory)
  unlink("") = -1 ENOENT (No such file or directory)

This change was introduced in the commit below as part of the introduction
of O_PATH support, and occurs because the readlinkat() call does not have
a flags field to allow this to be an opt-in behaviour:

  commit 65cfc6722361570bfe255698d9cd4dccaf47570d
  Author: Al Viro <viro@zeniv.linux.org.uk>
  Date: Tue, 2 Aug 2011 15:16:23 +0100

    readlinkat(), fchownat() and fstatat() with empty relative pathnames
    
    For readlinkat() we simply allow empty pathname; it will fail unless
    we have dfd equal to O_PATH-opened symlink, so we are outside of
    POSIX scope here.  For fchownat() and fstatat() we allow AT_EMPTY_PATH;
    let the caller explicitly ask for such behaviour.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Following this email is a patch which attempts to paper over this
inconsistancy.  I am not very happy with it as it does expose some of
the internals of the getname processing.

Comments/thoughts/better ideas?

-apw

Andy Whitcroft (1):
  readlinkat: ensure we return ENOENT for the empty pathname for normal
    lookups

 fs/namei.c            |   24 +++++++++++++++++++-----
 fs/stat.c             |    5 +++--
 include/linux/namei.h |    1 +
 3 files changed, 23 insertions(+), 7 deletions(-)

-- 
1.7.4.1

