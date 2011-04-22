Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab1DVIcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 04:32:09 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:61525 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab1DVIcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 04:32:06 -0400
X-Nat-Received: from [202.181.97.72]:59328 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1303461102.2222
Message-Id: <201104220831.p3M8VgAO017323@www262.sakura.ne.jp>
Subject: Re: [RFC][PATCH 0/7] lockdep: Support recurise-read locks
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: yong.zhang0@gmail.com
Cc: a.p.zijlstra@chello.nl, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 22 Apr 2011 17:31:42 +0900
References: <20110417094505.865828233@chello.nl> <201104180341.p3I3fnxc000638@www262.sakura.ne.jp> <BANLkTikYwWe6E6mb3PLE3L7a3VHWdtEvfQ@mail.gmail.com> <201104220744.p3M7indA004922@www262.sakura.ne.jp> <BANLkTikXSz-AK6BFvnDGEr6Qhx-dekzOQg@mail.gmail.com>
In-Reply-To: <BANLkTikXSz-AK6BFvnDGEr6Qhx-dekzOQg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 22042011 #5325729, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yong Zhang wrote:
> When you are using spin_acquire()/spin_release() in read_seqbegin2()/
> read_seqretry2(), if you call locktest2/locktest4 firstly, the chain will
> be established, so when call locktest1/locktest3, lockdep warns on it.

This part is OK.

> But if you call locktest1/locktest2 firstly, the chain will not be established
> just because recursive read is not added to prev->after.

This part is not OK. At least, I think lockdep should be able to establish the
chain when locktest1 is called AGAIN after locktest2 is called (i.e.
"cat /proc/locktest1 /proc/locktest2 /proc/locktest1" case). But lockdep can
establish the chain for only "cat /proc/locktest2 /proc/locktest1" case.
I think there is a bug that prevents the lockdep from establishing the chain
when locktest1 is called AGAIN after locktest2 is called. If we can't fix the
bug, we should consider periodically (or upon printing stall warning messages)
revalidating already established chains.
