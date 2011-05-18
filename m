Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab1ERDQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 23:16:09 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:58553 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253Ab1ERDQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 23:16:08 -0400
X-Nat-Received: from [202.181.97.72]:53330 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1305688566.17116
Message-Id: <201105180316.p4I3G6f2094560@www262.sakura.ne.jp>
Subject: Re: [PATCH 0/3] v4 Improve task->comm locking situation
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: john.stultz@linaro.org
Cc: tytso@mit.edu, mina86@mina86.com, jirislaby@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, dave@linux.vne,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 18 May 2011 12:16:06 +0900
References: <1305580757-13175-1-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1305580757-13175-1-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 17052011 #5420884, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What about replacing
	char comm[TASK_COMM_LEN];
with
	char *rcu_commname;
and switching it atomically using RCU?

Advantages:
  Readers can use RCU read lock rather than spinlock.
  Makes task_struct smaller.

Disadvantages:
  Need to allocate TASK_COMM_LEN bytes upon dup_task_struct() and set_task_comm().
  Need to rewrite all task_struct.comm readers (steps shown below).

Steps to rewrite task_struct.comm readers

(1) Introduce a temporary accessor (say, task_comm).

    #define task_comm(tsk) (tsk)->comm

(2) Rewrite all tsk->comm users to task_comm(tsk).

(3) Replace sizeof(tsk->comm) with TASK_COMM_LEN.

(4) Temporarily rename from

    char comm[TASK_COMM_LEN];

    to

    char comm_access_me_via_task_comm[TASK_COMM_LEN];

    for blocking new tsk->comm users.

(5) Convert to use RCU.

(6) Rename from

    char comm_access_me_via_task_comm[TASK_COMM_LEN];

    to

    char *rcu_commname;

    .

(7) Rewrite task_comm(tsk) to use %ptc .

(8) Remove the temporary accessor.
