Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab1I2Qli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 12:41:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938Ab1I2Qlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 12:41:37 -0400
Date: Thu, 29 Sep 2011 18:37:24 +0200
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
Message-ID: <20110929163724.GA23773@redhat.com>
References: <cover.1317110948.git.mhocko@suse.cz> <65d9dff7ff78fad1f146e71d32f9f92741281b46.1317110948.git.mhocko@suse.cz> <alpine.DEB.2.00.1109271133590.17876@chino.kir.corp.google.com> <20110928104445.GB15062@tiehlicka.suse.cz> <20110929115105.GE21113@tiehlicka.suse.cz> <20110929120517.GA10587@redhat.com> <20110929130204.GG21113@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929130204.GG21113@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29, Michal Hocko wrote:
>
> On Thu 29-09-11 14:05:17, Oleg Nesterov wrote:
>
> > But of course this can't help if freeze_task() is called later.
> > May be freezable() should check TIF_MEMDIE...
>
> Wouldn't it be easier to ignore try_to_freeze when fatal signals are
> pending in get_signal_to_deliver?

Oh, I don't think so. For what? This doesn't close other races, and
in fact the fatal_signal_pending() this patch adds is itself racy,
SIGKILL can come in between.

> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -48,6 +48,11 @@ void refrigerator(void)
>  	current->flags |= PF_FREEZING;
>
>  	for (;;) {
> +		if (fatal_signal_pending(current)) {
> +			if (freezing(current) || frozen(current))
> +				thaw_process(current);

Ah, I didn't mean refrigerator() should check freezing/frozen.

I meant, oom_kill can do this before thaw thaw_process(), afaics
this should fix the particular race you described (but not others).

And. It is simply wrong to return from refrigerator() after we set
PF_FROZEN, this can fool try_to_freeze_tasks(). Sure, thaw_process()
from oom_kill is not nice too, but at least this is the special case,
we already have the problem.

Oleg.

