Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab0LHUq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:46:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755747Ab0LHUqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:46:55 -0500
Date: Wed, 8 Dec 2010 21:39:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [patch v2 4/4] taskstats: Export "cdata_wait" CPU times with
	taskstats
Message-ID: <20101208203938.GB1804@redhat.com>
References: <20101129164237.522034198@linux.vnet.ibm.com> <20101129164435.903722027@linux.vnet.ibm.com> <20101201185128.GA7656@redhat.com> <1291718708.1910.63.camel@holzheu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291718708.1910.63.camel@holzheu-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07, Michael Holzheu wrote:
>
> On Wed, 2010-12-01 at 19:51 +0100, Oleg Nesterov wrote:
> > On 11/29, Michael Holzheu wrote:
> > >
> > > * I left the struct signal locking in the patch, because I think
> > >   that in order to get consistent data this is necessary.
> >
> > OK, I guess you mean that we want to read utime/stime "atomically",
> > and thus we need ->siglock to prevent the race with __exit_signal().
>
> Yes.
>
> But I changed my mind. If I understand the code right, currently no
> locking is done for reading the tasks statistics in both the taskstats
> and also in the procfs interface. So e.g. it is not guaranteed to get a
> consistent set of data when reading /proc/<pid>/stat, because of the
> race with account_user/system/whatever_time() and other accounting
> functions.

Not sure, I think account_user/system/whatever_time() is a bit different.
And, say, do_task_stat() takes ->siglock for thread_group_times(). Btw,
I tried to remove this lock_task_sighand(), and I still hope we can
do this ;) But the patch wasn't acked (iiuc) exactly because it can
make top unhappy..

> Because you said that since 2.6.35 accessing the signal_struct is save,
> I think now also for cdata it is not necessary to lock anything. As a
> result of this and the discussion regarding the group leader and cdata I
> would propose the following patch:

To me, this certainly makes sense. I do not really understand why
it is so important to prevent the case when, say, bacct_add_tsk()
sees the updated .utime and !updated .stime.

If we can race with the exiting tasks, then these numbers are not
"final" anyway.

But again, this all is up to you.

Oleg.

