Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab0EOL5N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 07:57:13 -0400
Received: from mail.gmx.net ([213.165.64.20]:40508 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751832Ab0EOL5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 07:57:12 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/NC+EHuJ7Na0yercRtMA1yGQv0sAkn5ihnr8fiPZ
	SvXHoIbWTODkFm
Subject: commit e9e9250b: sync wakeup bustage when waker is an RT task
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 15 May 2010 13:57:08 +0200
Message-Id: <1273924628.10630.24.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

This commit excluded RT tasks from rq->load, was that intentional?  The
comment in struct rq states that load reflects *all* tasks, but since
this commit, that's no longer true.

Looking at lmbench lat_udp in a PREEMPT_RT kernel, I noticed that
wake_affine() is failing for sync wakeups when it should not.  It's
doing so because the waker in this case is an RT kernel thread
(sirq-net-rx) - we subtract the sync waker's weight, when it was never
added in the first place, resulting in this_load going gaga.  End result
is quite high latency numbers due to tasks jabbering cross-cache.

If the exclusion was intentional, I suppose I can do a waker class check
in wake_affine() to fix it.

	-Mike


