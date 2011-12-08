Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab1LHWVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 17:21:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53963 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab1LHWVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 17:21:54 -0500
Date: Fri, 9 Dec 2011 02:21:49 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Vagin <avagin@openvz.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Introduce the /proc/<pid>/children entry v2
Message-ID: <20111208222149.GP21678@moon>
References: <20111206181026.GO29781@moon>
 <20111207185343.GA3209@redhat.com>
 <20111207190340.GP21678@moon>
 <20111208163535.GA25023@redhat.com>
 <20111208212853.GO21678@moon>
 <20111208135430.00730308.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111208135430.00730308.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 01:54:30PM -0800, Andrew Morton wrote:
> On Fri, 9 Dec 2011 01:28:53 +0400
> Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > On Thu, Dec 08, 2011 at 05:35:35PM +0100, Oleg Nesterov wrote:
> > ...
> > > 
> > > However, ->children list is not rcu-safe, this means that even
> > > list_for_each() itself is not safe. Either you need tasklist or
> > > we can probably make it rcu-safe...
> > > 
> > 
> > Andrew, Oleg, does the below one look more less fine? Note the
> > tasklist_lock is back and it worries me a bit since I imagine
> > one could be endlessly reading some /proc/<pid>/children file
> > increasing contention over this lock on the whole system
> > (regardless the fact that it's take for read only).
> 
> It is a potential problem, from the lock-hold point of view and
> also it can cause large scheduling latencies.  What's involved in
> making ->children an rcu-protected list?
> 

I think better to poke Oleg about it ;) Oleg?

> > ---
> > From: Cyrill Gorcunov <gorcunov@openvz.org>
> > Subject: [PATCH] fs, proc: Introduce the /proc/<pid>/children entry v4
> > 
> > There is no easy way to make a reverse parent->children chain
> > from arbitrary <pid> (while parent pid is provided in "PPid"
> > field of /proc/<pid>/status).
> > 
> > So instead of walking over all pids in the system to figure out which
> > children a task have -- we add explicit /proc/<pid>/children entry,
> > because kernel already has this kind of information but it is not
> > yet exported. This is a first level children, not the whole process
> > tree, neither the process threads are identified with this interface.
> 
> The changelog doesn't explain why we want the patch, so there's no
> reason to merge it!  Something to do with c/r, yes?

I though that "there is no easy way to make a reverse parent->children
chain" explains the problem -- ie when we do checkpoint of some task
we need to dump all its children and there is no easy and fast way to
find such topology. Parent of child can always be found from /proc/pid/status
but not the reverse.

> 
> If so, I guess the feature could/should be configurable.  Probably with
> a CONFIG_PROC_CHILDREN which is selected by CONFIG_CHECKPOINT_RESTORE. 
> Which is all getting a bit over the top, but I suppose we must do it.
> 

Yes, I can put it under CONFIG_CHECKPOINT_RESTORE, I thought to introduce
this config variable in prctl patch. But I think all might end up in mess,
so I guess better to make some patch series instead

 - Introduction of CONFIG_CHECKPOINT_RESTORE variable
 - /proc/pid/child patch
 - prctl patch
 - finally make map_files/ patch (which is in -mm already) being
   CONFIG_CHECKPOINT_RESTORE dependant as well

Sounds good in general?

Btw, any hint which Kconfig is a better place for CONFIG_CHECKPOINT_RESTORE,
definitely not Kconfig.cpu, nor the mm/Kconfig. Not sure which one should
be taken. I guess it should be somewhere on top level and at moment x86
dependant as well.

> Also, neither the changelog not the documentation mention the
> loss-of-data problem which might occur if/when the lock is dropped.
> 

Indeed. The number set is only valid while read, nothing else is guaranteed
after that (I dropped those part from doc which mentioned that task should
be ither frozen or stopped to get more-less consistent results). I'll
bring it back, sorry!

> The code now appears to be kinda-duplicating functionality which the
> seq_file library provides.  Shouldn't this have been
> changelogged/commented?  If it was, I wouldn't need to ask the next
> question.
> 
> Why is it kinda-duplicating seq_file functionality?  Can we strengthen
> the seq_file code so this is unnecessary?
> 

If no threads were involved then seq_list_start/next would be enough but
I need next_thread() helper here which doesn't allow me to use the former
seq engine helpers. Andrew, I fear changing seq code bring even more
complexity. At moment all helpers we use are grouped in a couple of code
lines, i think it's easier to read.

Actually I had some crazy idea to be able to pass a "hint" to seq_file.c
about how many memory we need to keep all pids printed, so seq_file would
kmalloc/vmalloc memory for us at once and we simply fill it all in one
pass but finally I got impression that it will bring more complexity
and except us noone in kernel would need this functionality.

	Cyrill
