Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab0E3Buf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 21:50:35 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.61]:49486 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab0E3Bud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 21:50:33 -0400
X-Greylist: delayed 1191 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 May 2010 21:50:33 EDT
Date: Sat, 29 May 2010 21:30:02 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Cc: akpm@linux-foundation.org, bblum@andrew.cmu.edu, ebiederm@xmission.com,
       lizf@cn.fujitsu.com, matthltc@us.ibm.com, menage@google.com,
       oleg@redhat.com
Subject: [RFC] [PATCH v2 0/2] cgroups: implement moving a threadgroup's
 threads atomically with cgroup.procs
Message-ID: <20100530013002.GA762@ghc01.ghc.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.5.30.11817
X-SMTP-Spam-Clean: 8% (
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1100_1199 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, TO_NO_NAME 0, __CD 0, __CP_URI_IN_BODY 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_MAILTO 0, __URI_NO_WWW 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is a revision of http://lkml.org/lkml/2010/1/3/51 and
http://lkml.org/lkml/2010/1/3/52 .

The rwsem in the fork path has been moved to signal_struct to simplify
the locking code in the cgroup_attach_proc side. This depends on Oleg's
recentish changes to signal_struct's lifetime rules (which don't seem to
appear when I check out mmotm with git clone, so I wasn't able to do any
more than basic testing).

There is still a race with exec in the case where the threadgroup leader
changes. To solve this, this implementation checks if the race occurred
after all previous set-up has been done and all necessary locks are
held, and if so, returns -EAGAIN which is handled by the calling
function by looping until a different value is returned.

-- bblum

---
 Documentation/cgroups/cgroups.txt |    9
 include/linux/cgroup.h            |   15 -
 include/linux/init_task.h         |    9
 include/linux/sched.h             |   10
 kernel/cgroup.c                   |  435 +++++++++++++++++++++++++++++++++-----
 kernel/fork.c                     |   10
 6 files changed, 431 insertions(+), 57 deletions(-)
