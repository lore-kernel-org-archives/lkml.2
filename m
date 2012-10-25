Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992516Ab2JYRgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:36:39 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55635 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992464Ab2JYRgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:36:36 -0400
Date: Thu, 25 Oct 2012 10:36:32 -0700
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] freezer: change ptrace_stop/do_signal_stop to use
 freezable_schedule()
Message-ID: <20121025173632.GI11442@htj.dyndns.org>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <1350426526-14254-3-git-send-email-tj@kernel.org>
 <20121022174404.GA21553@redhat.com>
 <20121022211317.GD5951@atj.dyndns.org>
 <20121023153919.GA16201@redhat.com>
 <20121024185710.GA12182@atj.dyndns.org>
 <20121025163941.GA3801@redhat.com>
 <20121025163959.GB3801@redhat.com>
 <20121025171812.GE11442@htj.dyndns.org>
 <20121025173433.GA7650@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025173433.GA7650@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Oct 25, 2012 at 07:34:33PM +0200, Oleg Nesterov wrote:
> > I think it would be great if the description is more detailed.  This
> > code path always makes my head spin and I think we can definitely use
> > some more guiding in understanding this dang thing. :)
> 
> Do you mean describe the race in more details? OK, will do and resend
> tomorrow.

Yeah and maybe explain briefly how schedule_freezable() gets us out of
the trouble.

> > > @@ -2092,7 +2085,7 @@ static bool do_signal_stop(int signr)
> > >  		}
> > >
> > >  		/* Now we don't run again until woken by SIGCONT or SIGKILL */
> > > -		schedule();
> > > +		freezable_schedule();
> >
> > This makes me wonder whether we still need try_to_freeze() in
> > get_signal_to_deliver() right after the relock: label.  Freezer no
> > longer treats STOPPED/TRACED special and both sleeping sites in signal
> > deliver path are marked freezable_schedule().  We shouldn't need the
> > explicit try_to_freeze(), right?
> 
> OOPS.
> 
> I'd say this doesn't really matter but yes we can move it up,
> get_signal_to_deliver() will be called again.

Right, we can't remove it.  That's our main freezing point for
userland tasks.

> But! the comment above try_to_freeze() becomes misleading with
> this patch, so this really needs v2.

But, yeah, I think we should move it above relock: and update the
comment to explain that that's the usual freezing site.

Thanks.

-- 
tejun
