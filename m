Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934338Ab0HEU13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:27:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934317Ab0HEU1R convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:27:17 -0400
MIME-Version: 1.0
In-Reply-To: <m1zkx04y40.fsf@fess.ebiederm.org>
References: <20100729114549.29508.44899.stgit@warthog.procyon.org.uk> 
	<20100729114555.29508.4525.stgit@warthog.procyon.org.uk> <20100802204000.GH2405@linux.vnet.ibm.com> 
	<201008030055.o730tgXK091413@www262.sakura.ne.jp> <30552.1280828047@redhat.com> 
	<AANLkTikwM0+cxJqgQ+N_svzyyc+FKreO8XPr8oYNh6OU@mail.gmail.com> 
	<m1d3txzfuq.fsf@fess.ebiederm.org> <AANLkTikavQKkvmdY5=8jh8KSV7vit=WcmDHWjnZfVWnv@mail.gmail.com> 
	<m1zkx04y40.fsf@fess.ebiederm.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Aug 2010 13:26:21 -0700
Message-ID: <AANLkTim=VMoC+wG6Hikzic95Avooi=-9Fu=mjSCxNXEZ@mail.gmail.com>
Subject: Re: [PATCH 2/2] CRED: Fix __task_cred()'s lockdep check and banner 
	comment
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 1:13 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> I think it is totally reasonable to add a per pid lock,
> that would protect the pid->task[...] hlist.  That would make
> things clearer and finer grained without a lot of effort.  Just
> a little more struct pid bloat, and a little extra care in fork,
> when we add to those lists.

Hmm. Have you taken a look at Nick Piggin's VFS scalability patches?
They introduce this "RCU-safe hash chain lock", where each hashchain
has a lock-bit in the low bit. I wonder if that would be the right
thing to use?

> Even with the per-pgrp lock we still need a lock on the global process
> list for the kill -KILL -1 case.  Which suggests that tasklist_lock is
> still needed for part of kill_something_info.

Well, that -1 case is special anyway. The fact that we might want to
use the tasklist_lock there is not very relevant, I think. That is
_not_ a hotpath, really (at least not under any relevant loads, I'm
sure you could make a silly benchmark of "kill(-1,0)").

                          Linus
