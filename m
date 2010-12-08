Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab0LHUau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:30:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273Ab0LHUat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:30:49 -0500
Date: Wed, 8 Dec 2010 21:23:08 +0100
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
Message-ID: <20101208202308.GA1804@redhat.com>
References: <20101129164237.522034198@linux.vnet.ibm.com> <20101129164435.903722027@linux.vnet.ibm.com> <20101201185128.GA7656@redhat.com> <1291307641.1928.125.camel@holzheu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291307641.1928.125.camel@holzheu-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, sorry for the delay. Again ;)

On 12/02, Michael Holzheu wrote:
>
> 1) You have a thread group with several threads
> 2) Thread group leader dies and reports cdata_wait in taskstats_exit()
> 3) Thread group leader stays around as zombie until the thread
>    group dies
> 4) Other forked processes of this thread group die
> 5) cdata_wait of thread group is increased
> 6) The new cdata is not reported by any exit event of the thread group

Yes.

> So maybe we should remove the thread_group_leader() check and report
> cdata_wait for all threads and not only for the thread group leader? We
> also should add ac_tgid to taskstats so that userspace can find the
> corresponding thread group for each thread.

I do not know. My only point was, this thread_group_leader() looks
a bit confusing, at least if we are talking about do_exit() path.

> When the last thread exits and the process/thread group dies,
> taskstats_exit() sends an additional taskstats struct to userspace that
> aggregates the thread accounting data. Currently only the delay
> accounting data is aggregated (see
> taskstats_exit->fill_tgid_exit->delayacct_add_tsk). Not sure, why the
> other information is not aggregated. We perhaps also should include
> ac_cXtime in the aggregated taskstats.

Not sure I understand... Do you mean

	if (is_thread_group)
		fill_tgid_exit(tsk);

? Afaics, this is not "When the last thread exits", this is
"this program is multithreaded, it has (or had) other threads".

Oleg.

