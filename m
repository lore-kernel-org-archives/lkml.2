Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab1I3Peu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 11:34:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab1I3Pes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 11:34:48 -0400
Date: Fri, 30 Sep 2011 17:30:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <htejun@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] oom: thaw threads if oom killed thread is frozen
	before deferring
Message-ID: <20110930153036.GA19095@redhat.com>
References: <cover.1317110948.git.mhocko@suse.cz> <65d9dff7ff78fad1f146e71d32f9f92741281b46.1317110948.git.mhocko@suse.cz> <alpine.DEB.2.00.1109271133590.17876@chino.kir.corp.google.com> <20110928104445.GB15062@tiehlicka.suse.cz> <20110929115105.GE21113@tiehlicka.suse.cz> <20110929120517.GA10587@redhat.com> <20110929130204.GG21113@tiehlicka.suse.cz> <20110929163724.GA23773@redhat.com> <20110929180021.GA27999@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929180021.GA27999@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29, Michal Hocko wrote:
>
> On Thu 29-09-11 18:37:24, Oleg Nesterov wrote:
> >
> > Oh, I don't think so. For what? This doesn't close other races, and
> > in fact the fatal_signal_pending() this patch adds is itself racy,
> > SIGKILL can come in between.
>
> OK, I think I see your point. You mean that oom will send KILL after
> both fatal_signal_pending in refrigerator and signal_pending check in
> schedule, right?

No, schedule()->signal_pending_state(TASK_UNINTERRUPTIBLE) doesn't check
the signals. I simply meant

	if (fatal_signal_pending())
					// <--- SIGKILL from oom
		try_to_freeze();

> This is what the follow up fix from David is doing. Check frozen in
> select_bad_process if the task is TIF_MEMDIE and thaw the process.
>
> And it seems that the David's follow up fix is sufficient so let's leave
> refrigerator alone.

Agreed, afaics this should fix all races (although I didn't read the
whole discussion, perhaps I missed something else).

And in this case we do not even need to modify oom_kill_task/etc,
select_bad_process() will be called again and notice the frozen task
eventually. Afaics.

Or, as Tejun suggests, we can implement the race-free kill-even-if-frozen
later.

Oleg.

