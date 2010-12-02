Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854Ab0LBQeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 11:34:07 -0500
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:41668 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757303Ab0LBQeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 11:34:05 -0500
Subject: Re: [patch v2 4/4] taskstats: Export "cdata_wait" CPU times with
 taskstats
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Oleg Nesterov <oleg@redhat.com>
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
In-Reply-To: <20101201185128.GA7656@redhat.com>
References: <20101129164237.522034198@linux.vnet.ibm.com>
	 <20101129164435.903722027@linux.vnet.ibm.com>
	 <20101201185128.GA7656@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Thu, 02 Dec 2010 17:34:01 +0100
Message-ID: <1291307641.1928.125.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 19:51 +0100, Oleg Nesterov wrote:
> But in fact I don't really understand this anyway. This is called
> before we reparent our children. This means that ac_cutime/ac_cstime
> can be changed after that (multithreading, or full_cdata_enabled).
> 
> Say, taskstats_exit()->fill_stats()->bacct_add_tsk(). Every thread
> does this, including the group_leader. But, it is possible that
> group_leader exits first, before other threads. IOW, what
> stats->ac_cXtime actually mean?

Because I worked mostly with the ptop tool, I was not so much focused on
the taskstats exit events, but instead more on the taskstats commands to
query data for running tasks.

For the query scenario stats->ac_cXtime means:

1) full_cdata=0: "Sum of CPU time of exited child processes where
   sys_wait() have been done (up to this time)"
2) full_cdata=1: "Sum of CPU time of exited child processes where
   sys_wait() have been done plus exited child processes where
   the parents ignored SIGCHLD or have set SA_NOCLDWAIT (up to
   this time)"

Regarding taskstats_exit(): Do you have something like the following
scenario in mind?

1) You have a thread group with several threads
2) Thread group leader dies and reports cdata_wait in taskstats_exit()
3) Thread group leader stays around as zombie until the thread
   group dies
4) Other forked processes of this thread group die
5) cdata_wait of thread group is increased
6) The new cdata is not reported by any exit event of the thread group

So maybe we should remove the thread_group_leader() check and report
cdata_wait for all threads and not only for the thread group leader? We
also should add ac_tgid to taskstats so that userspace can find the
corresponding thread group for each thread.

When the last thread exits and the process/thread group dies,
taskstats_exit() sends an additional taskstats struct to userspace that
aggregates the thread accounting data. Currently only the delay
accounting data is aggregated (see
taskstats_exit->fill_tgid_exit->delayacct_add_tsk). Not sure, why the
other information is not aggregated. We perhaps also should include
ac_cXtime in the aggregated taskstats.

Michael



