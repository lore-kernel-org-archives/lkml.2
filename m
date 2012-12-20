Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab2LTSCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 13:02:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24621 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2LTSCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 13:02:05 -0500
X-Authority-Analysis: v=2.0 cv=YruNtvkX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=r9gpABO-FZcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ih1sZ2JY46UA:10 a=iGmb2HFwAAAA:8 a=pGLkceISAAAA:8 a=DL_eQ94TJHWsBH-GoIgA:9 a=PUjeQqilurYA:10 a=dqk98ENcwZsA:10 a=MSl-tDqOz04A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1356026521.5896.55.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH RT] rtmutex: Use raw_spin_trylock() in
 rt_mutex_slowlock() to ease possible live locks
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: RT <linux-rt-users@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Carsten Emde <cbe@osadl.org>, Clark Williams <clark@redhat.com>,
        John Kacur <jkacur@redhat.com>, Mike Galbraith <bitbucket@online.de>
Date: Thu, 20 Dec 2012 13:02:01 -0500
In-Reply-To: <1355967118.5896.52.camel@gandalf.local.home>
References: <1355967118.5896.52.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-19 at 20:31 -0500, Steven Rostedt wrote:

Talking with Thomas, the proper solution is:

> Then we have this lovely code:
> 
> block/blk-ioc.c: put_io_context_active()
> 
> retry:
>         spin_lock_irqsave_nested(&ioc->lock, flags, 1);
>         hlist_for_each_entry(icq, n, &ioc->icq_list, ioc_node) {
>                 if (icq->flags & ICQ_EXITED)
>                         continue;
>                 if (spin_trylock(icq->q->queue_lock)) {
>                         ioc_exit_icq(icq);
>                         spin_unlock(icq->q->queue_lock);
>                 } else {
>                         spin_unlock_irqrestore(&ioc->lock, flags);
>                         cpu_relax();

s/cpu_relax/cpu_chill/

-- Steve

>                         goto retry;
>                 }
>         }
> 


