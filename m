Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab1KAQtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 12:49:50 -0400
Received: from mx2.netapp.com ([216.240.18.37]:23978 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754863Ab1KAQtt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 12:49:49 -0400
X-IronPort-AV: E=Sophos;i="4.69,439,1315206000"; 
   d="scan'208";a="594190146"
Subject: Re: [RFC PATCH] freezer: revert 27920651fe "PM / Freezer: Make
 fake_signal_wake_up() wake TASK_KILLABLE tasks too"
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Layton <jlayton@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Steve French <sfrench@samba.org>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, linux-pm@vger.kernel.org,
        linux-cifs@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
        Neil Brown <neilb@suse.de>, linux-nfs@vger.kernel.org
Date: Tue, 01 Nov 2011 12:49:31 -0400
In-Reply-To: <20111101163059.GR18855@google.com>
References: <20111031221743.GA18855@google.com>
	 <201111010024.16659.rjw@sisk.pl> <20111031233059.GI18855@google.com>
	 <20111101005505.GO18855@google.com>
	 <20111101041337.39077229@tlielax.poochiereds.net>
	 <20111101065958.50addab5@tlielax.poochiereds.net>
	 <20111101163059.GR18855@google.com>
Organization: NetApp Inc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1320166171.5019.1.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-OriginalArrivalTime: 01 Nov 2011 16:49:31.0874 (UTC) FILETIME=[3A6F3C20:01CC98B6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-01 at 09:30 -0700, Tejun Heo wrote: 
> Hello, Jeff.
> 
> On Tue, Nov 01, 2011 at 06:59:58AM -0400, Jeff Layton wrote:
> > > I suppose we could look at going back to the world of complicated
> > > signal handling and TASK_INTERRUPTIBLE, but that's not a trivial change
> > > either. The TASK_WAKE_FREEZABLE flag you mention might make more sense
> > > than doing that.
> 
> I see.
> 
> > Also, since task state and signal handling clearly isn't my forte...can
> > you clarify what the main difference is in using a TASK_KILLABLE sleep
> > vs. TASK_INTERRUPTIBLE with all signals but SIGKILL blocked?
> >
> > I know that the process state would end up different (S vs. D state).
> > Is there anything else we'd need to be concerned with if we converted
> > all these call sites to use such a scheme in lieu of a new
> > TASK_WAKE_FREEZABLE flag or similar?
> 
> Manipulating sigmask would work in most cases but there are corner
> cases (e.g. debug signals will force the mask off) and diddling with
> sigmask in kernel generally isn't a good idea.
> 
> If TASK_KILLABLE is only used for killable && freezable, that probably
> would be the cleanest solution but given the name and the fact that
> people are in general much more aware of SIGKILL's then freezer, I
> think adding such assumption is likely to cause very subtle bugs.  For
> example, mem_cgroup_handle_oom() seems to assume that if it's waken
> from TASK_KILLABLE either the condition it was waiting for is true or
> it is dying.
> 
> If there are only a handful sites which need this type of behavior,
> wouldn't something like the following work?
> 
> #define wait_event_freezekillable(wq, condition)			\
> do {									\
> 	DEFINE_WAIT(__wait);						\
> 	for (;;) {							\
> 		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
> 		if (condition || fatal_signal_pending(current))		\
> 			break;						\
> 		schedule();						\
> 		try_to_freeze();					\
> 	}								\
> 	finish_wait(&wq, &__wait);					\
> } while (0)

Err... Won't this end up busy-waiting if a non-fatal signal is received?

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

