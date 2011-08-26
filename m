Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab1HZSNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 14:13:46 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49348 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab1HZSNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 14:13:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=o9Y7wZW7LBV07J1FTbaNPsaZcJG4HzTNpAuw0yVRpNp1SkqvIYoZTqrZBzMWs3AQH
	fU5s8DbJ5wE2Dc9V52W5A==
Date: Fri, 26 Aug 2011 11:13:40 -0700 (PDT)
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
In-Reply-To: <20110826095356.GB9083@tiehlicka.suse.cz>
Message-ID: <alpine.DEB.2.00.1108261110020.13943@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1108231313520.21637@chino.kir.corp.google.com> <20110824101927.GB3505@tiehlicka.suse.cz> <alpine.DEB.2.00.1108241226550.31357@chino.kir.corp.google.com> <20110825091920.GA22564@tiehlicka.suse.cz> <20110825151818.GA4003@redhat.com>
 <20110825164758.GB22564@tiehlicka.suse.cz> <alpine.DEB.2.00.1108251404130.18747@chino.kir.corp.google.com> <20110826070946.GA7280@tiehlicka.suse.cz> <20110826085610.GA9083@tiehlicka.suse.cz> <alpine.DEB.2.00.1108260218050.14732@chino.kir.corp.google.com>
 <20110826095356.GB9083@tiehlicka.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011, Michal Hocko wrote:

> > I do like the idea of automatically thawing the task though and if that's 
> > possible then I don't think we need to manipulate the badness heuristic at 
> > all.  I know that wouldn't be feasible when we've frozen _all_ threads and 
> 
> Why it wouldn't be feasible for all threads? If you have all tasks
> frozen (suspend going on, whole cgroup or all tasks in a cpuset/nodemask
> are frozen) then the selection is more natural because all of them are
> equal (with or without a bonus). The bonus tries to reduce thawing if
> not all of them are frozen.

Yeah, this comment wasn't in reference to your heuristic change, it was in 
reference to the fact that if all threads are frozen then there is little 
hope for us recovering from the situation without a user response.  I 
think that's why we want oom_killer_disable() so that we avoid looping 
forever and can actually fail allocations in the hope that we'll bring 
ourselves out of suspend.

> I am not saying the bonus is necessary, though. It depends on what
> the freezer is used for (e.g. freeze a process which went wild and
> debug what went wrong wouldn't welcome that somebody killed it or other
> (mis)use which relies on D state).
> 

I'd love to be able to do a thaw on a PF_FROZEN task in the oom killer 
followed by a SIGKILL if that task is selected for oom kill without an 
heuristic change.  Not sure if that's possible, so we'll wait for Rafael 
to chime in.

If it actually does come down to a heuristic change, then it need not 
happen in the oom killer: the freezing code would need to use 
test_set_oom_score_adj() to temporarily reduce the oom_score_adj for that 
task until it comes out of the refrigerator.  We already use that in ksm 
and swapoff to actually prefer threads, but we can use it to bias against 
threads as well.
