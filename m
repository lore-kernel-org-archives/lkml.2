Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357Ab1BNGMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 01:12:46 -0500
Received: from smtp-out.google.com ([74.125.121.67]:36603 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab1BNGMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 01:12:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=oWL26w30wcidOrzf6QyM7SVN8ugpg83ivl1qPhnStzZWFXXoREpcT5LmRJwKO71ld+
         ngNhaUQg5ZEN/MlF9tMw==
MIME-Version: 1.0
In-Reply-To: <20110210100210.adf09c49.kamezawa.hiroyu@jp.fujitsu.com>
References: <20101226120919.GA28529@ghc17.ghc.andrew.cmu.edu>
 <20110208013542.GC31569@ghc17.ghc.andrew.cmu.edu> <20110209151046.89e03dcd.akpm@linux-foundation.org>
 <20110210100210.adf09c49.kamezawa.hiroyu@jp.fujitsu.com>
From: Paul Menage <menage@google.com>
Date: Sun, 13 Feb 2011 22:12:19 -0800
Message-ID: <AANLkTikD6YKO4C-uOHtsUWk1XMr5yXozvHL2BgbwSVAX@mail.gmail.com>
Subject: Re: [PATCH v8 0/3] cgroups: implement moving a threadgroup's threads
 atomically with cgroup.procs
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ben Blum <bblum@andrew.cmu.edu>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        oleg@redhat.com, Miao Xie <miaox@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>, ebiederm@xmission.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 5:02 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> So, I think it's ok to have 'procs' interface for cgroup if
> overhead/impact of patch is not heavy.
>

Agreed - it's definitely an operation that comes up as either
confusing or annoying for users, depending on whether or not they
understand how threads and cgroups interact. (We've been getting
people wanting to do this internally at Google, and I'm guessing that
we're one of the bigger users of cgroups.)

In theory it's something that could be handled in userspace, in one of two ways:

- repeatedly scan the old cgroup's tasks file and sweep any threads
from the given process into the destination cgroup, until you complete
a clean sweep finding none. (Possibly even this is racy if a thread is
being slow to fork)

- use a process event notifier to catch thread fork events and keep
track of any newly created threads that appear after your first sweep
of threads, and be prepared to handle them for some reasonable length
of time (tens of milliseconds?) after the last thread has been
apparently moved.

(The alternative approach, of course, is to give up and never try to
move a process into a cgroup except right when you're in the middle of
forking it, before the exec(), when you know that it has only a single
thread and you're in control of it.)

These are both painful procedures, compared to the very simple
approach of letting the kernel move the entire process atomically.

It's true that it's a pretty heavyweight operation, but that weight is
only paid when you actually use it on a very large process (and which
would be even more expensive to do in userspace). For the rest of the
kernel, it's just an extra read lock in the fork path on a semaphore
in a structure that's pretty much guaranteed to be in cache.

Paul
