Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab1HYVO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 17:14:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:47978 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab1HYVOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 17:14:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=sZf1yPe0fMAniIzA0JJ0ea1hM6Q9SQcUHz1zOoLdtXhqNZ4Wi1Uh4Pd/Vyl4efTlK
	BjA2jswmH9f3ApdXr+myw==
Date: Thu, 25 Aug 2011 14:14:20 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Oleg Nesterov <oleg@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] oom: skip frozen tasks
In-Reply-To: <20110825164758.GB22564@tiehlicka.suse.cz>
Message-ID: <alpine.DEB.2.00.1108251404130.18747@chino.kir.corp.google.com>
References: <20110823073101.6426.77745.stgit@zurg> <alpine.DEB.2.00.1108231313520.21637@chino.kir.corp.google.com> <20110824101927.GB3505@tiehlicka.suse.cz> <alpine.DEB.2.00.1108241226550.31357@chino.kir.corp.google.com> <20110825091920.GA22564@tiehlicka.suse.cz>
 <20110825151818.GA4003@redhat.com> <20110825164758.GB22564@tiehlicka.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011, Michal Hocko wrote:

> > > > That's obviously false since we call oom_killer_disable() in 
> > > > freeze_processes() to disable the oom killer from ever being called in the 
> > > > first place, so this is something you need to resolve with Rafael before 
> > > > you cause more machines to panic.
> > >
> > > I didn't mean suspend/resume path (that is protected by oom_killer_disabled)
> > > so the patch doesn't make any change.
> > 
> > Confused... freeze_processes() does try_to_freeze_tasks() before
> > oom_killer_disable() ?
> 
> Yes you are right, I must have been blind. 
> 
> Now I see the point. We do not want to panic while we are suspending and
> the memory is really low just because all the userspace is already in
> the the fridge.
> Sorry for confusion.
> 
> I still do not follow the oom_killer_disable note from David, though.
> 

oom_killer_disable() was added to that path for a reason when all threads 
are frozen: memory allocations still occur in the suspend path in an oom 
condition and adding the oom_killer_disable() will cause those 
allocations to fail rather than sending pointless SIGKILLs to frozen 
threads.

Now consider if the only _eligible_ threads for oom kill (because of 
cpusets or mempolicies) are those that are frozen.  We certainly do not 
want to panic because other cpusets are still getting work done.  We'd 
either want to add a mem to the cpuset or thaw the processes because the 
cpuset is oom.

You can't just selectively skip certain threads when their state can be 
temporary without risking a panic.  That's why this patch is a 
non-starter.

A much better solution would be to lower the badness score that the oom 
killer uses for PF_FROZEN threads so that they aren't considered a 
priority for kill unless there's nothing else left to kill.
