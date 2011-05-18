Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab1ERF1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 01:27:20 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63767 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab1ERF1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 01:27:19 -0400
X-Nat-Received: from [202.181.97.72]:61333 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1305696437.4962
Message-Id: <201105180527.p4I5RHGl032657@www262.sakura.ne.jp>
Subject: Re: [PATCH 0/3] v4 Improve task->comm locking situation
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: john.stultz@linaro.org
Cc: tytso@mit.edu, mina86@mina86.com, jirislaby@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, rientjes@google.com,
        dave@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 18 May 2011 14:27:17 +0900
References: <1305580757-13175-1-git-send-email-john.stultz@linaro.org> <201105180316.p4I3G6f2094560@www262.sakura.ne.jp> <1305692109.2915.139.camel@work-vm>
In-Reply-To: <1305692109.2915.139.camel@work-vm>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 17052011 #5420884, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stultz wrote:
> So I think this approach is definitely worth trying. However, I think
> converting to RCU will be much easier once we've first converted all
> current comm users to making use of the get_task_comm accessor
> functions. In this way my hope is my current proposal will serve as a
> cleanup step before further optimizations can be done.

OK. But I guess converting all current comm users to making use of the
get_task_comm accessor is not easy because using get_task_comm() changes
locking dependency.

I think replacing

  "%s", tsk->comm

with

  "%ptc", tsk

(without using get_task_comm() inside pointer() because introducing a new lock
 might cause problem since callers can be inside a delicate condition based on
 the assumption that vsnprintf() will not block) should come first in order to
minimize direct ->comm users who may not be ready for this change.

After that, trying to replace

  task->comm

with

  char buf[TASK_COMM_LEN];
  get_task_comm(task, buf)

(with cautions for already held locks) may be considered.



By the way,

  sprintf(current->comm, "drbd%d_receiver", minor);

in drivers/block/drbd/drbd_receiver.c may be off-by-one
because DRBD_MINOR_COUNT_MAX is 256.
