Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433Ab0FYFqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 01:46:21 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.96]:52555 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab0FYFqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 01:46:20 -0400
Date: Fri, 25 Jun 2010 01:45:41 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Cc: akpm@linux-foundation.org, bblum@andrew.cmu.edu, ebiederm@xmission.com,
       lizf@cn.fujitsu.com, matthltc@us.ibm.com, menage@google.com,
       oleg@redhat.com
Subject: [RFC] [PATCH v3 0/2] cgroups: implement moving a threadgroup's
 threads atomically with cgroup.procs
Message-ID: <20100625054541.GA20610@ghc01.ghc.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.4.9.4220
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_1400_1499 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, TO_NO_NAME 0, __CD 0, __CP_URI_IN_BODY 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_MAILTO 0, __URI_NO_WWW 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is a revision of http://lkml.org/lkml/2010/5/29/126 .

These patches use an rwlock in signal_struct which access is dependent
on Oleg's recent changes to signal_struct's lifetime rules.

It is okay to write the tid of any task in the threadgroup. This is
implemented by taking task->group_leader right after find_task_by_vpid
while still rcu_read-side. This makes it necessary to check if
thread_group_leader(leader) every time we want to iterate over
->thread_group; each of these checks can fail with -EAGAIN.
Unfortunately this also means I needed to put these checks in can_attach
for each subsystem that needs to check each thread in the group.

I handle EAGAIN in the file's write handler, since hey, it's a super
expensive operation, might as well make it unbounded-time to boot - this
is optional and would work just as well with -EAGAIN sent to userspace.

-- bblum

---
 Documentation/cgroups/cgroups.txt |   13 -
 include/linux/cgroup.h            |   15 -
 include/linux/init_task.h         |    9
 include/linux/sched.h             |   10
 kernel/cgroup.c                   |  449 +++++++++++++++++++++++++++++++++-----
 kernel/cgroup_freezer.c           |    4
 kernel/cpuset.c                   |    4
 kernel/fork.c                     |   10
 kernel/ns_cgroup.c                |    4
 kernel/sched.c                    |    4
 10 files changed, 462 insertions(+), 60 deletions(-)
