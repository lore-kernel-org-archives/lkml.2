Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935953Ab2JYRda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:33:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759429Ab2JYRd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:33:28 -0400
Date: Thu, 25 Oct 2012 19:34:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] freezer: change ptrace_stop/do_signal_stop to use
	freezable_schedule()
Message-ID: <20121025173433.GA7650@redhat.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org> <1350426526-14254-3-git-send-email-tj@kernel.org> <20121022174404.GA21553@redhat.com> <20121022211317.GD5951@atj.dyndns.org> <20121023153919.GA16201@redhat.com> <20121024185710.GA12182@atj.dyndns.org> <20121025163941.GA3801@redhat.com> <20121025163959.GB3801@redhat.com> <20121025171812.GE11442@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025171812.GE11442@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25, Tejun Heo wrote:
>
> Hello, Oleg.
>
> On Thu, Oct 25, 2012 at 06:39:59PM +0200, Oleg Nesterov wrote:
> > Change ptrace_stop() and do_signal_stop() to use freezable_schedule()
> > rather than rely on subsequent try_to_freeze().
> >
> > This allows to remove the task_is_stopped_or_traced() checks from
> > try_to_freeze_tasks() and update_if_frozen(), and this fixes the
> > unlikely race with ptrace_stop(). If the tracee does not schedule()
> > it can miss a freezing condition.
>
> I think it would be great if the description is more detailed.  This
> code path always makes my head spin and I think we can definitely use
> some more guiding in understanding this dang thing. :)

Do you mean describe the race in more details? OK, will do and resend
tomorrow.

> > @@ -2092,7 +2085,7 @@ static bool do_signal_stop(int signr)
> >  		}
> >
> >  		/* Now we don't run again until woken by SIGCONT or SIGKILL */
> > -		schedule();
> > +		freezable_schedule();
>
> This makes me wonder whether we still need try_to_freeze() in
> get_signal_to_deliver() right after the relock: label.  Freezer no
> longer treats STOPPED/TRACED special and both sleeping sites in signal
> deliver path are marked freezable_schedule().  We shouldn't need the
> explicit try_to_freeze(), right?

OOPS.

I'd say this doesn't really matter but yes we can move it up,
get_signal_to_deliver() will be called again.

But! the comment above try_to_freeze() becomes misleading with
this patch, so this really needs v2.

Thanks.

Oleg.

