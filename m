Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab1DVHpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 03:45:23 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:49398 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab1DVHpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 03:45:21 -0400
X-Nat-Received: from [202.181.97.72]:52998 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1303458289.20177
Message-Id: <201104220744.p3M7indA004922@www262.sakura.ne.jp>
Subject: Re: [RFC][PATCH 0/7] lockdep: Support recurise-read locks
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: yong.zhang0@gmail.com
Cc: a.p.zijlstra@chello.nl, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 22 Apr 2011 16:44:49 +0900
References: <20110417094505.865828233@chello.nl> <201104180341.p3I3fnxc000638@www262.sakura.ne.jp> <BANLkTikYwWe6E6mb3PLE3L7a3VHWdtEvfQ@mail.gmail.com>
In-Reply-To: <BANLkTikYwWe6E6mb3PLE3L7a3VHWdtEvfQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 22042011 #5325729, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yong Zhang wrote:
> > Also, something is still wrong because lockdep fails to detect the problem
> > for "cat /proc/locktest1 /proc/locktest2" and
> > "cat /proc/locktest3 /proc/locktest4" cases.
> 
> It fails because we never add the recursive read to prev->after evev if
> it passed the validation.
> 
Thanks. But why "cat /proc/locktest1 /proc/locktest2" is "the recursive read"
and "cat /proc/locktest2 /proc/locktest1" is not "the recursive read"?
Both are serialized. Both hold and release the same lock.
The only difference is which function was called first,
and lockdep alart depends on which function was called first.

It sounds to me that Documentation/lockdep-design.txt says
timing (i.e. which function was called first) is not important.

172 Proof of 100% correctness:
173 --------------------------
174 
175 The validator achieves perfect, mathematical 'closure' (proof of locking
176 correctness) in the sense that for every simple, standalone single-task
177 locking sequence that occurred at least once during the lifetime of the
178 kernel, the validator proves it with a 100% certainty that no
179 combination and timing of these locking sequences can cause any class of
180 lock related deadlock. [*]
181 
182 I.e. complex multi-CPU and multi-task locking scenarios do not have to
183 occur in practice to prove a deadlock: only the simple 'component'
184 locking chains have to occur at least once (anytime, in any
185 task/context) for the validator to be able to prove correctness. (For
186 example, complex deadlocks that would normally need more than 3 CPUs and
187 a very unlikely constellation of tasks, irq-contexts and timings to
188 occur, can be detected on a plain, lightly loaded single-CPU system as
189 well!)
