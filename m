Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561Ab0DGL6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 07:58:50 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:33184 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923Ab0DGL6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 07:58:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lzRsy+HmgKKhZwuxtxy7WvCz+xOLlGku+7t/N87PdxxtAKKxnQCG27MmTZzYRI8dBh
         zJW4FwiZtUT/wv85EM9oztrALMReoaFuseG7N9Kz6mPF3dPAL0QOQW/4mwSUagBJjbOb
         aMYfAIBCY7KlHY27NXSAQHJ6dhDIT75dGhbYo=
Date: Wed, 7 Apr 2010 13:58:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf: Store active software events in a hashlist
Message-ID: <20100407115839.GE5143@nowhere>
References: <1270476502-6214-1-git-send-regression-fweisbec@gmail.com> <1270567653.20295.11.camel@laptop> <1270631093.5109.569.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270631093.5109.569.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 11:04:53AM +0200, Peter Zijlstra wrote:
> On Tue, 2010-04-06 at 17:27 +0200, Peter Zijlstra wrote:
> > On Mon, 2010-04-05 at 16:08 +0200, Frederic Weisbecker wrote:
> > > Each time a software event triggers, we need to walk through
> > > the entire list of events from the current cpu and task contexts
> > > to retrieve a running perf event that matches.
> > > We also need to check a matching perf event is actually counting.
> > > 
> > > This walk is wasteful and makes the event fast path scaling
> > > down with a growing number of events running on the same
> > > contexts.
> > > 
> > > To solve this, we store the running perf events in a hashlist to
> > > get an immediate access to them against their type:event_id when
> > > they trigger. 
> > 
> > So we have a hash-table per-cpu, each event takes a ref on the hash
> > table, when the thing is empty we free it.
> > 
> > When the event->cpu == -1 (all cpus) we take a ref on all possible cpu's
> > hash-table (should be online I figure, but that requires adding a
> > hotplug handler).
> > 
> > Then on event enable/disable we actually add the event to the hash-table
> > belonging to the cpu the event/task gets scheduled on, since each event
> > can only ever be active on one cpu.
> > 
> > Right?
> > 
> > So looks good, altough I think we want to do that online/hotplug thing.
> 
> Alternatively, you can simply but the hash table into the per-cpu
> structure and not allocate it, its only a single page (half a page if
> you use 32bit or actually use 8 bits.


As you prefer. This would indeed make it more simple, but that would also
make these pages unused most of the time.

