Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab1GTTDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:03:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab1GTTDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:03:18 -0400
Date: Wed, 20 Jul 2011 21:00:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Cc: Balbir Singh <bsingharora@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] taskstats: add_del_listener() should ignore !valid
	listener's
Message-ID: <20110720190036.GB21753@redhat.com>
References: <20110720185959.GA21749@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110720185959.GA21749@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When send_cpu_listeners() finds the orphaned listener it marks
it as !valid and drops listeners->sem. Before it takes this sem
for wrinting, s->pid can be reused and add_del_listener() can
wrongly try to re-use this entry.

Change add_del_listener() to check ->valid = T.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/taskstats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- ts/kernel/taskstats.c~2_ck_valid	2011-07-20 20:18:19.000000000 +0200
+++ ts/kernel/taskstats.c	2011-07-20 20:18:47.000000000 +0200
@@ -304,7 +304,7 @@ static int add_del_listener(pid_t pid, c
 			listeners = &per_cpu(listener_array, cpu);
 			down_write(&listeners->sem);
 			list_for_each_entry(s2, &listeners->list, list) {
-				if (s2->pid == pid)
+				if (s2->pid == pid && s2->valid)
 					goto exists;
 			}
 			list_add(&s->list, &listeners->list);

