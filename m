Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab1CYEj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 00:39:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750927Ab1CYEjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 00:39:25 -0400
MIME-Version: 1.0
In-Reply-To: <20110325033956.GB9313@home.goodmis.org>
References: <20110323153727.GB12003@htj.dyndns.org> <20110324094119.GD12038@htj.dyndns.org>
 <20110324094151.GE12038@htj.dyndns.org> <20110325033956.GB9313@home.goodmis.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 Mar 2011 21:38:58 -0700
Message-ID: <AANLkTikayCJyYVo1MNpg1EN+88bSQNOu=NPW5s_j4shD@mail.gmail.com>
Subject: Re: [PATCH 2/2] mutex: Apply adaptive spinning on mutex_trylock()
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 8:39 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> But now, mutex_trylock(B) becomes a spinner too, and since the B's owner
> is running (spinning on A) it will spin as well waiting for A's owner to
> release it. Unfortunately, A's owner is also spinning waiting for B to
> release it.
>
> If both A and B's owners are real time tasks, then boom! deadlock.

Hmm. I think you're right. And it looks pretty fundamental - I don't
see any reasonable approach to avoid it.

I think the RT issue is a red herring too - afaik, you can get a
deadlock with two perfectly normal processes too. Of course, for
non-RT tasks, any other process will eventually disturb the situation
and you'd get kicked out due to need_resched(), but even that might be
avoided for a long time if there are other CPU's - leading to tons of
wasted CPU time.

                       Linus
