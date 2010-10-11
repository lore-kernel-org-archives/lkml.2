Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab0JKWO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 18:14:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756699Ab0JKWO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 18:14:26 -0400
Subject: fanotify: disable fanotify syscalls
From: Eric Paris <eparis@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andreas Gruenbacher <agruen@suse.de>,
        David Daney <ddaney@caviumnetworks.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <4CAF9448.7070906@zytor.com>
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com>
	 <201010081406.10190.agruen@suse.de> <4CAF47F3.3070800@caviumnetworks.com>
	 <201010082350.01135.agruen@suse.de>  <4CAF9448.7070906@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 18:13:31 -0400
Message-ID: <1286835211.28329.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch disables the fanotify syscalls by just not building them and
letting the cond_syscall() statements in kernel/sys_ni.c redirect them
to sys_ni_syscall().

It was pointed out by Tvrtko Ursulin that the fanotify interface did not
include an explicit prioritization between groups.  This is necessary
for fanotify to be usable for hierarchical storage management software,
as they must get first access to the file, before inotify-like notifiers
see the file.

This feature can be added in an ABI compatible way in the next release
(by using a number of bits in the flags field to carry the info) but it
was suggested by Alan that maybe we should just hold off and do it in
the next cycle, likely with an (new) explicit argument to the syscall.
I don't like this approach best as I know people are already starting to
use the current interface, but Alan is all wise and noone on list backed
me up with just using what we have.  I feel this is needlessly ripping
the rug out from under people at the last minute, but if others think it
needs to be a new argument it might be the best way forward.

Three choices:
Go with what we got (and implement the new feature next cycle).  Add a
new field right now (and implement the new feature next cycle).  Wait
till next cycle to release the ABI (and implement the new feature next
cycle).  This is number 3.

Signed-off-by: Eric Paris <eparis@redhat.com>

---

 fs/notify/Kconfig    |    2 +-
 include/linux/Kbuild |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/notify/Kconfig b/fs/notify/Kconfig
index 22c629e..b388443 100644
--- a/fs/notify/Kconfig
+++ b/fs/notify/Kconfig
@@ -3,4 +3,4 @@ config FSNOTIFY
 
 source "fs/notify/dnotify/Kconfig"
 source "fs/notify/inotify/Kconfig"
-source "fs/notify/fanotify/Kconfig"
+#source "fs/notify/fanotify/Kconfig"
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 626b629..4e8ea8c 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -118,7 +118,6 @@ header-y += eventpoll.h
 header-y += ext2_fs.h
 header-y += fadvise.h
 header-y += falloc.h
-header-y += fanotify.h
 header-y += fb.h
 header-y += fcntl.h
 header-y += fd.h


