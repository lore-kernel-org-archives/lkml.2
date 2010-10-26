Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821Ab0JZUSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:18:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65365 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab0JZUSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 16:18:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: nfsd changes for 2.6.37
Date: Tue, 26 Oct 2010 22:18:36 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36+; KDE/4.5.1; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bryan Schumaker <bjschuma@netapp.com>
References: <20101026164549.GD19445@fieldses.org>
In-Reply-To: <20101026164549.GD19445@fieldses.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010262218.36940.arnd@arndb.de>
X-Provags-ID: V02:K0:wMRfm7sPG0ZGRpCb0cSzUrozZwfQOT0RD5pEMHEXMUW
 DaupmgabbHPkaanw6eBuWHfEum0cUY92y9Q0VP4EBPDFZ6+MmP
 kBwUyauHkViazQK4OUx7VxuoEXO3hUICeRLRT9MAqJv2eDegz8
 oiGIWlp6KaygsH8X2D9+iijKoj5bX/yN1I5A3WotARk58gXsi5
 WT8ti3zG36fsa/epj7j2Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 October 2010 18:45:50 J. Bruce Fields wrote:
> Bryan Schumaker (1):
>       lockd: Mostly remove BKL from the server

Could you explain the "mostly" part of this commit?

The commit message only says "This patch removes all
but one call to lock_kernel() from the server." This one
call is what keeps us from removing the BKL from fs/locks.c
because I can't tell if you still suspect that lockd
needs to lock against posix file locks or if there was
a different reason for leaving it in.

I can't think of anything else that this might be locking
against because everything that might interact with lockd
now does not use the BKL any more and lockd is
single-threaded by definition.

My guess is that the only thing that really needs to
lock_flocks() in lockd are the nlm_file_inuse and
nlm_traverse_locks functions because they traverse
the inode->i_flock list. All the exported functions
from fs/lock.c take care of locking in their own way
(possibly not lease_get_time, as I just discovered,
but that was never called under the BKL...).

	Arnd
