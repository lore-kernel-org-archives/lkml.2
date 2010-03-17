Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab0CQTaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 15:30:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755619Ab0CQTaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 15:30:11 -0400
Date: Wed, 17 Mar 2010 20:28:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Veaceslav Falico <vfalico@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] signal_struct->count must die, initial changes
Message-ID: <20100317192847.GA2086@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

signal_struct->count in its current form must die.

	- it has no reasons to be atomic_t

	- it looks like a reference counter, but it is not

	- otoh, we really need to make task->signal refcountable,
	  just look at the extremely ugly task_rq_unlock_wait()
	  called from __exit_signals().

	- we should change the lifetime rules for task->signal,
	  it should be pinned to task_struct. We have a lot of
	  code which can be simplified after that.

	- it is not needed! while the code is correct, any usage
	  of this counter is artificial, except fs/proc uses it
	  correctly to show the number of threads.

This series removes the usage of sig->count from exit pathes.

Oleg.

