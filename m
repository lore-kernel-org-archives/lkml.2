Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab1LHVyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 16:54:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab1LHVyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 16:54:32 -0500
Date: Thu, 8 Dec 2011 13:54:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Vagin <avagin@openvz.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Introduce the /proc/<pid>/children entry v2
Message-Id: <20111208135430.00730308.akpm@linux-foundation.org>
In-Reply-To: <20111208212853.GO21678@moon>
References: <20111206181026.GO29781@moon>
	<20111207185343.GA3209@redhat.com>
	<20111207190340.GP21678@moon>
	<20111208163535.GA25023@redhat.com>
	<20111208212853.GO21678@moon>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Dec 2011 01:28:53 +0400
Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On Thu, Dec 08, 2011 at 05:35:35PM +0100, Oleg Nesterov wrote:
> ...
> > 
> > However, ->children list is not rcu-safe, this means that even
> > list_for_each() itself is not safe. Either you need tasklist or
> > we can probably make it rcu-safe...
> > 
> 
> Andrew, Oleg, does the below one look more less fine? Note the
> tasklist_lock is back and it worries me a bit since I imagine
> one could be endlessly reading some /proc/<pid>/children file
> increasing contention over this lock on the whole system
> (regardless the fact that it's take for read only).

It is a potential problem, from the lock-hold point of view and
also it can cause large scheduling latencies.  What's involved in
making ->children an rcu-protected list?

> ---
> From: Cyrill Gorcunov <gorcunov@openvz.org>
> Subject: [PATCH] fs, proc: Introduce the /proc/<pid>/children entry v4
> 
> There is no easy way to make a reverse parent->children chain
> from arbitrary <pid> (while parent pid is provided in "PPid"
> field of /proc/<pid>/status).
> 
> So instead of walking over all pids in the system to figure out which
> children a task have -- we add explicit /proc/<pid>/children entry,
> because kernel already has this kind of information but it is not
> yet exported. This is a first level children, not the whole process
> tree, neither the process threads are identified with this interface.

The changelog doesn't explain why we want the patch, so there's no
reason to merge it!  Something to do with c/r, yes?

If so, I guess the feature could/should be configurable.  Probably with
a CONFIG_PROC_CHILDREN which is selected by CONFIG_CHECKPOINT_RESTORE. 
Which is all getting a bit over the top, but I suppose we must do it.

Also, neither the changelog not the documentation mention the
loss-of-data problem which might occur if/when the lock is dropped.

The code now appears to be kinda-duplicating functionality which the
seq_file library provides.  Shouldn't this have been
changelogged/commented?  If it was, I wouldn't need to ask the next
question.

Why is it kinda-duplicating seq_file functionality?  Can we strengthen
the seq_file code so this is unnecessary?

