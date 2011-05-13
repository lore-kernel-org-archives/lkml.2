Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113Ab1EMRXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 13:23:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918Ab1EMRXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 13:23:11 -0400
Date: Fri, 13 May 2011 19:21:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 09/11] job control: reorganize wait_task_stopped()
Message-ID: <20110513172117.GA30243@redhat.com>
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-10-git-send-email-tj@kernel.org> <20110511154854.GB23688@redhat.com> <20110511192902.GC24245@mtj.dyndns.org> <20110512154247.GC18599@redhat.com> <20110512160253.GK1030@htj.dyndns.org> <20110512172506.GA23033@redhat.com> <20110512173228.GO1030@htj.dyndns.org> <20110512183326.GA26042@redhat.com> <20110513084611.GB6500@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513084611.GB6500@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/13, Tejun Heo wrote:
>
> On Thu, May 12, 2011 at 08:33:26PM +0200, Oleg Nesterov wrote:
>
> > At first glance, do_wait() does
> >
> > 	wait_task_stopped();
> > 	wait_task_continued();
> >
> > and the state can be changed CONTINIUED -> STOPPED in between, right?
> > Or something else?
>
> Yeah and exit transitions too.

I am not sure... but probably this depends on definition.

We already checked ->exit_state != ZOMBIE, and we are holding tasklist.
The child can't exit. I mean, it can't change its ->exit_state.

However, SIGKILL can clear SIGNAL_STOP_STOPPED, and we can "miss" it.
But this looks correct, the child is no longer stopped but it is still
not dead. So I think in this case wait(WNOHANG | WEXITED | WSTOPPED)
can fail, notabug.

OTOH, perhaps SIGKILL should set SIGNAL_STOP_CONTINUED in this case?
And keep it if it was already set.

> There simply is no synchronization
> there.  We can probably solve it without acquiring siglock by adding
> "clear this before making state transitions" flag followed by a mb()

perhaps even simpler if ->EXIT transition is fine.

Oleg.

