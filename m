Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab2DDL3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 07:29:14 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57947 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab2DDL3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 07:29:13 -0400
Date: Wed, 4 Apr 2012 04:29:09 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Galbraith <mgalbraith@suse.de>
cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <paul@paulmenage.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] cgroups: disallow attaching kthreadd
In-Reply-To: <1333535915.7188.18.camel@marge.simpson.net>
Message-ID: <alpine.DEB.2.00.1204040419450.23137@chino.kir.corp.google.com>
References: <1333475906.7439.7.camel@marge.simpson.net> <alpine.DEB.2.00.1204040008040.5356@chino.kir.corp.google.com> <1333535915.7188.18.camel@marge.simpson.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2012, Mike Galbraith wrote:

> > We've been through this several times now iterating between two different 
> > functional changes.  I appreciate the persistence, but please, again, 
> > explain why you are doing this at the cgroups level rather than the 
> > cpusets level?
> > 
> > The last time we discussed this, you had proposed a patch to only do this 
> > for cpusets after the points I'm about to bring up for the fifth time.  
> > Peter ended up not responding and as I remember it didn't have strong 
> > feelings against doing it only for cpusets.  And here we are, yet again, 
> > back to the cgroups version.
> 
> Suggest a third version.
> 

I've already acked your kernel/cpuset.c version as an extension of 
6d7b2f5f9e88 ("cpusets: prevent PF_THREAD_BOUND tasks from attaching 
to non-root cpusets") which took care of PF_THREAD_BOUND attachment back 
in 2.6.30.

The undeniable fact is that PF_THREAD_BOUND is special for cpusets since 
we can't possibly allow its cpu affinity to change after kthread_bind() 
and we don't want inconsistencies in our cpusets whereas threads attached 
to a cpuset can have a disjoint set of allowable nodes.  Do we special 
case PF_THREAD_BOUND for any other cgroup?  No.  And that's what you're 
trying to introduce here and it's completely unnecessary.

> Ok, so you NAK this way, Peter NAKS the other way, and the bug lives on
> forever.  So be it.
> 

I've never seen a nack from Peter on this, I only remember discussing 
whether this needs to be isolated to only cpusets or whether it needs to 
be a generic cgroup thing and I've always argued in favor of localizing it 
to cpusets because that cgroup happens to care about cpu affinity where 
others don't and this is why cgroups have ->can_attach() functions.  If a 
cgroup were created to have nothing to do with cpu affinity (only for 
collecting statistics for threads within it, for example), there's 
absolutely no reason why we need to exclude kthreadd.

You know I've been very supportive of getting this fix included for 
cpusets in the past and I very much appreciate your time and patience in 
the review cycle.  I'm hoping we can finally do this.
