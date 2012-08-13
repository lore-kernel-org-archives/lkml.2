Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab2HMMdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 08:33:51 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:46081 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446Ab2HMMdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 08:33:49 -0400
Subject: [PATCH v4 0/9] IPC: checkpoint/restore in userspace enhancements
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: manfred@colorfullife.com, a.p.zijlstra@chello.nl, arnd@arndb.de,
        hughd@google.com, linux-kernel@vger.kernel.org, cmetcalf@tilera.com,
        yeohc@au1.ibm.com, linux-security-module@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, hpa@zytor.com, casey@schaufler-ca.com,
        eparis@parisplace.org, devel@openvz.org
Date: Mon, 13 Aug 2012 16:31:30 +0400
Message-ID: <20120813122835.5581.70057.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v4:
1) If MSG_COPY flag is specified, then "mtype" is not a type, but message
number to copy.
2) MSG_SET_COPY logic for sys_msgctl() was removed.

v3:
1) Copy messages to user-space under spinlock was replaced by allocation of
dummy message before queue lock and then copy of desired message to the dummy
one instead of unlinking it from queue list.
I.e. the message queue copy logic was changed: messages can be retrived one by
one (instead of receiving of the whole list at once).

This patch set is aimed to provide additional functionality for all IPC objects,
which is required for migration of these objects by user-space
checkpoint/restore utils (CRIU).

The main problem here was impossibility to set up object id. This patch set
solves the problem in two steps:
1) Makes it possible to create new object (shared memory, semaphores set or
messages queue) with ID, equal to passed key.
2) Makes it possible to change existent object key.

Another problem was to peek messages from queues without deleting them.
This was achived by introducing of new MSG_COPY flag for sys_msgrcv() and
MSG_SET_COPY command for sys_msgctl() (which can be used to select message
number to copy).

The following series implements...

---

Stanislav Kinsbursky (9):
      ipc: remove forced assignment of selected message
      ipc: "use key as id" functionality for resource get system call introduced
      ipc: segment key change helper introduced
      ipc: add new SHM_SET command for sys_shmctl() call
      ipc: add new MSG_SET command for sys_msgctl() call
      ipc: add new SEM_SET command for sys_semctl() call
      IPC: message queue receive cleanup
      IPC: message queue copy feature introduced
      test: IPC message queue migration test


 arch/tile/kernel/compat.c            |   29 +++++++
 include/linux/compat.h               |    2 
 include/linux/ipc.h                  |    1 
 include/linux/msg.h                  |    7 +-
 include/linux/sem.h                  |    1 
 include/linux/shm.h                  |    1 
 ipc/compat.c                         |   42 ++++++---
 ipc/msg.c                            |  110 +++++++++++++++++++------
 ipc/msgutil.c                        |   38 +++++++++
 ipc/sem.c                            |   11 ++
 ipc/shm.c                            |   14 +++
 ipc/util.c                           |   59 ++++++++++++-
 ipc/util.h                           |    4 +
 security/selinux/hooks.c             |    3 +
 security/smack/smack_lsm.c           |    3 +
 tools/testing/selftests/ipc/msgque.c |  151 ++++++++++++++++++++++++++++++++++
 16 files changed, 424 insertions(+), 52 deletions(-)
 create mode 100644 tools/testing/selftests/ipc/msgque.c

