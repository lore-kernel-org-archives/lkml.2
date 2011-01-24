Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab1AXT6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:58:18 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46436 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1AXT6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:58:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc
         :content-type;
        b=PALxPLSQcL4s9+cVjei1+zmbBefQ+XPyIbFrjwg1fY9xNlLpcUQwbVWr8bbG3VyKnn
         EdYDp5Tc4P2aGdNvNyjyXj63h/laDplXFkvHL4gMSU3Fh7O7X+ucCCXEZgjI1I9L65MM
         OD4QCkHVJAbAJCNAUYuH7M6ilsIAq7WCa/unU=
MIME-Version: 1.0
Reply-To: linasvepstas@gmail.com
From: Linas Vepstas <linasvepstas@gmail.com>
Date: Mon, 24 Jan 2011 13:57:56 -0600
Message-ID: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com>
Subject: [BUG] Generic syscalls -- chmod vs. fchmodat
To: Chris Metcalf <cmetcalf@tilera.com>, Arnd Bergmann <arnd@arndb.de>
Cc: GLIBC Devel <libc-alpha@sourceware.org>, linux-kernel@vger.kernel.org,
        libc-ports@sourceware.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris, Arnd, all,

Found a bug/incompatibility in the generic syscalls chmod implementation;
not sure if this is a kernel bug or a glibc bug, or how to correctly resolve it.

The new "generic chmod" implementation for glibc sends chmod to the
kernel call sys_fchmodat with  AT_FDCWD, instead of using the older
"deprecated" chmod syscall.  These two behave slightly differently:  with
the new implementation, the file "" (i.e. string of length zero) gets
interpreted
as . and so the syscall succeeds, setting perms on .  The old syscall would
return an errno=2 No such file or directory for this filename.

My gut instinct is that this is a kernel bug, but am not so sure; perhaps this
is "working as designed".  I thought of submitting a patch to fs/namei.c to
fix this, but then got lost in the details: there didn't seem to be
any particularly
good place to add this check.  Meanwhile, a glibc test case (posix/tst-chmod.c)
is failing as a result.

Should we put a check for this funky non-filename into the glibc
generic code, or into sys_chmodat? Recommendations?

--linas
