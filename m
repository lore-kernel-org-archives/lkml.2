Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330Ab0GGEhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 00:37:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56683 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab0GGEhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 00:37:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aUHww73Rlhv0s0l8Zuo/F+JROJTU/U9NjkS/JR/0JM4X6sUy2dIJC/Pi3pRxg+sUny
         yD88pg0W5EI20GX5gGhNA5ZYgYKyULb8ahUl0HzamcbDDj3bG2k1aLN1pblg2S24V3Mp
         8JJdMASGi7ivTKZXIOXHNg2bgxZSf2eIHgWjM=
Subject: Re: 2.6.35-rc4 - include/linux/fdtable.h:85 invoked
 rcu_dereference_check()  without protection!
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1278477257.2445.2.camel@edumazet-laptop>
References: <AANLkTinDWl1qJzK-H9Qw3jjKs9zdUYE1Hh3hTaDw8asd@mail.gmail.com>
	 <1278477257.2445.2.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Jul 2010 06:37:28 +0200
Message-ID: <1278477448.2445.4.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 07 juillet 2010 à 06:34 +0200, Eric Dumazet a écrit :

> Miles, you already posted this three times, and a fix is known.
> 
> BTW, I dont know why it's not already in, Paul submitted it several
> times, but nobody cares.
> 
> http://kerneltrap.org/mailarchive/linux-kernel/2010/6/17/4584014
> 
> I am going to Ack it, maybe some other guys can help to.
> 

Ah, its in Andrew tree since 6 days, it should be sent to Linus promptly
now...

The patch titled
     vfs: fix RCU-lockdep false positive due to /proc
has been added to the -mm tree.  Its filename is
     vfs-fix-rcu-lockdep-false-positive-due-to-proc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code
***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at
http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: fix RCU-lockdep false positive due to /proc
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

If a single-threaded process does a file-descriptor operation, and some
other process accesses that same file descriptor via /proc, the current
rcu_dereference_check_fdtable() can give a false-positive RCU-lockdep
splat due to the reference count being increased by the /proc access
after
the reference-count check in fget_light() but before the check in
rcu_dereference_check_fdtable().

This commit prevents this false positive by checking for a
single-threaded
process.  To avoid #include hell, this commit uses the wrapper for
thread_group_empty(current) defined by rcu_my_thread_group_empty()
provided in a separate commit.

Located-by: Miles Lane <miles.lane@gmail.com>
Located-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fdtable.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN
include/linux/fdtable.h~vfs-fix-rcu-lockdep-false-positive-due-to-proc
include/linux/fdtable.h
---
a/include/linux/fdtable.h~vfs-fix-rcu-lockdep-false-positive-due-to-proc
+++ a/include/linux/fdtable.h
@@ -62,7 +62,8 @@ struct files_struct {
        (rcu_dereference_check((fdtfd), \
                               rcu_read_lock_held() || \
                               lockdep_is_held(&(files)->file_lock) || \
-                              atomic_read(&(files)->count) == 1))
+                              atomic_read(&(files)->count) == 1 || \
+                              rcu_my_thread_group_empty()))
 
 #define files_fdtable(files) \
                (rcu_dereference_check_fdtable((files), (files)->fdt))
_

Patches currently in -mm which might be from
paulmck@linux.vnet.ibm.com are

origin.patch
fs-fcntlc-kill_fasync_rcu-fa_lock-must-be-irq-safe.patch
linux-next.patch
vfs-fix-rcu-lockdep-false-positive-due-to-proc.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch




