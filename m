Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab0LJN0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 08:26:25 -0500
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:42739 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129Ab0LJN0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 08:26:24 -0500
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
In-Reply-To: <20101208202308.GA1804@redhat.com>
References: <20101129164237.522034198@linux.vnet.ibm.com>
	 <20101129164435.903722027@linux.vnet.ibm.com>
	 <20101201185128.GA7656@redhat.com>
	 <1291307641.1928.125.camel@holzheu-laptop>
	 <20101208202308.GA1804@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Fri, 10 Dec 2010 14:26:20 +0100
Message-ID: <1291987580.1933.10.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Oleg,

On Wed, 2010-12-08 at 21:23 +0100, Oleg Nesterov wrote:
> Oh, sorry for the delay. Again ;)

No problem, I know this can be exhausting ;-)

> On 12/02, Michael Holzheu wrote:
> > When the last thread exits and the process/thread group dies,
> > taskstats_exit() sends an additional taskstats struct to userspace that
> > aggregates the thread accounting data. Currently only the delay
> > accounting data is aggregated (see
> > taskstats_exit->fill_tgid_exit->delayacct_add_tsk). Not sure, why the
> > other information is not aggregated. We perhaps also should include
> > ac_cXtime in the aggregated taskstats.
> 
> Not sure I understand... Do you mean
> 
> 	if (is_thread_group)
> 		fill_tgid_exit(tsk);
> 
> ? Afaics, this is not "When the last thread exits", this is
> "this program is multithreaded, it has (or had) other threads".

fill_tgid_exit() adds the data of the dying thread to the thread group
data (tsk->signal->stats). Currently only for delay accounting.

But the accumulated data is sent to userspace only after the last thread
has died:

        if (!is_thread_group || >>>!group_dead<<<)
                goto send;

        stats = mk_reply(rep_skb, TASKSTATS_TYPE_TGID, tsk->tgid);
        if (!stats)
                goto err;

Michael

