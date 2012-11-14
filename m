Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423230Ab2KNStH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 13:49:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423191Ab2KNStF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 13:49:05 -0500
Date: Wed, 14 Nov 2012 19:49:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Arapov <anton@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/1] uprobes: Use percpu_rw_semaphore to fix
	register/unregister vs dup_mmap() race
Message-ID: <20121114184929.GA6977@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

The same patch I sent before, the only difference is that it uses
percpu_rw_semaphore instead of brw_mutex.

Srikar, I'll hope you can ack v2 too, and unless someone objects
I'll ask Ingo to pull this fix.

Tejun, recently we briefly discussed signal->group_rwsem, please
see the note about cgroups below.

Note:

	- The current implementation of percpu_rw_semaphore is not
	  optimal, register/unregister will block fork() completely
	  while it sleeps in msleep() and synchronize_sched().

	  So this patch assumes that

	  	percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessarily.patch
	  	http://marc.info/?l=linux-mm-commits&m=135240650828875

	  will be applied eventually (and the new implementation can be
	  improved).

	- This patch adds percpu_down_read/up_read around dup_mmap()
	  for uprobes.

	  Given that it is very cheap (and assuming the optimizations
	  above), _perhaps_ we can turn this dup_mmap_sem into fork_sem
	  and use it instead of threadgroup_change_begin/end, so that
	  uprobes and cgroups can use it.

	- Compared to v1, percpu_rw_semaphore doesn't support multi-
	  writers. I hope we can tolerate this, register/unregister
	  are system-wide and rare events anyway. And _perhaps_ we
	  can add percpu_down_write_nonexclusive() later.

	- Given that currently percpu_down_write() is exclusive, this
	  patch almost dismisses the purpose of uprobes_mutex[] array.

	  Yes, but we need to rework this locking anyway for filtering.

Oleg.

