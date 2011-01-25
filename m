Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab1AYOaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 09:30:03 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:59537 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab1AYOaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 09:30:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linasvepstas@gmail.com
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
Date: Tue, 25 Jan 2011 15:29:24 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        GLIBC Devel <libc-alpha@sourceware.org>, linux-kernel@vger.kernel.org,
        libc-ports@sourceware.org, linux-api@vger.kernel.org,
        Roland McGrath <roland@redhat.com>, Mike Frysinger <vapier@gentoo.org>
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com>
In-Reply-To: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101251529.24779.arnd@arndb.de>
X-Provags-ID: V02:K0:pWiWKilFUvUzTQlDGlh2uYUHUe/BLsBb0syb9smIHME
 sGkQVc5iXzQXtGGKz9KfmwVWx2915VGrjX+vAXS2qwV3t8yv0u
 x7zuqj0NX+gQ4yZfbLsNw7Ptr8773+OGUZdHBO1y7UiPFaeNpp
 LYwGozK9UWWzFbg7iu/ie+HR2+zx1aVg4zQJhItUyalePzS8TH
 rPclZXraDjEhwlmNOGV1Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 January 2011, Linas Vepstas wrote:
> Chris, Arnd, all,

[adding linux-api list]

> Found a bug/incompatibility in the generic syscalls chmod implementation;
> not sure if this is a kernel bug or a glibc bug, or how to correctly resolve it.
> 
> The new "generic chmod" implementation for glibc sends chmod to the
> kernel call sys_fchmodat with  AT_FDCWD, instead of using the older
> "deprecated" chmod syscall.  These two behave slightly differently:  with
> the new implementation, the file "" (i.e. string of length zero) gets
> interpreted
> as . and so the syscall succeeds, setting perms on .  The old syscall would
> return an errno=2 No such file or directory for this filename.
> 
> My gut instinct is that this is a kernel bug, but am not so sure; perhaps this
> is "working as designed".  I thought of submitting a patch to fs/namei.c to
> fix this, but then got lost in the details: there didn't seem to be
> any particularly
> good place to add this check.  Meanwhile, a glibc test case (posix/tst-chmod.c)
> is failing as a result.
> 
> Should we put a check for this funky non-filename into the glibc
> generic code, or into sys_chmodat? Recommendations?

My feeling is that it should be in glibc: as Mike mentioned, we don't normally
change the behavior of existing system calls unless they are obviously
broken to start with. If we want to keep fchmodat getting the implicit
"." directory, and at the same time keep fchmod returning an error, the fchmod
wrapper around fchmodat is the only place that can enforce this.

	Arnd
