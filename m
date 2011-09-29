Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab1I2MJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 08:09:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab1I2MJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 08:09:32 -0400
Date: Thu, 29 Sep 2011 14:05:17 +0200
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
Message-ID: <20110929120517.GA10587@redhat.com>
References: <cover.1317110948.git.mhocko@suse.cz> <65d9dff7ff78fad1f146e71d32f9f92741281b46.1317110948.git.mhocko@suse.cz> <alpine.DEB.2.00.1109271133590.17876@chino.kir.corp.google.com> <20110928104445.GB15062@tiehlicka.suse.cz> <20110929115105.GE21113@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929115105.GE21113@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29, Michal Hocko wrote:
>
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -48,6 +48,10 @@ void refrigerator(void)
>  	current->flags |= PF_FREEZING;
>  
>  	for (;;) {
> +		if (fatal_signal_pending(current)) {
> +			current->flags &= ~PF_FROZEN;

We can't do this.

If PF_FROZEN was set, we must not modify current->flags, this can
race with, say, thaw_process().

OK, we can take task_lock(), but this doesn't close other races.
Say, a SIGKILL'ed task can do try_to_freeze(). Perhaps we should
simply call thaw_process() unconditionally, this also clears
TIF_FREEZE. Or check freezing() || frozen(). Afacis this solves
the race you described.

But of course this can't help if freeze_task() is called later.
May be freezable() should check TIF_MEMDIE...

Oleg.

