Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab2EGKGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 06:06:38 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:32923 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab2EGKGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 06:06:36 -0400
MIME-Version: 1.0
Date: Mon, 7 May 2012 03:06:36 -0700
Message-ID: <CAHo-OoxRj-sP1Tcy3oJ7DE3BOGSTnsWHZ5Q3hdmnK8A5jfjFcQ@mail.gmail.com>
Subject: setuid and RLIMIT_NPROC and 3.1+
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: James Morris <jmorris@namei.org>, neilb@suse.de,
        Vasiliy Kulikov <segoon@openwall.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 72fa59970f8698023045ab0713d66f3f4f96945c
Author: Vasiliy Kulikov <segoon@openwall.com>
Date:   Mon Aug 8 19:02:04 2011 +0400

    move RLIMIT_NPROC check from set_user() to do_execve_common()

intentionally 'breaks' error return codes from setuid and friends in
the presence of RLIMIT_NPROC.

3.0.30:
setresuid(0, 0, 0)                      = 0
setrlimit(RLIMIT_NPROC, {rlim_cur=1, rlim_max=1}) = 0
clone(Process 20070 attached
child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD,
child_tidptr=0x1344b30) = 20070  [fork() succeeds only because we're
root]
[pid 20069] setuid(65534)               = 0
[pid 20070] setuid(65534)      = -1 EAGAIN (Resource temporarily unavailable)

3.1:
setresuid(0, 0, 0)                      = 0
setrlimit(RLIMIT_NPROC, {rlim_cur=1, rlim_max=1}) = 0
clone(Process 13507 attached
child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD,
child_tidptr=0x135cb30) = 13507 [fork() succeeds only because we're
root]
[pid 13506] setuid(65534)      = 0
[pid 13507] setuid(65534)      = 0

Having read the commit in question I get what it is trying to prevent,
but perhaps the setuid call should still be returning an error code
[E2BIG? EBUSY? EOVERFLOW? ENAVAIL?] for those programs that do bother
to check, even though it would 'succeed' in changing uid?

(In my case there is no exec following the setuid...)

- Maciej
