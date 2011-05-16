Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab1EPM5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:57:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25772 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab1EPM53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:57:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=s3jc4sPw9UVI+rMFSffg+NfVvXO4cHgj21E9aD65dCoIgPEWaS7cNDsCt5+IDB/BbN
         SWj7fETgro/6Syy85kgQ==
MIME-Version: 1.0
In-Reply-To: <1305541088.2466.4102.camel@twins>
References: <20110503092846.022272244@google.com> <20110503092904.895444153@google.com>
 <1305541088.2466.4102.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Mon, 16 May 2011 05:56:56 -0700
Message-ID: <BANLkTinRErBM_C=PB9BxH8QDVoNWJ_AdTA@mail.gmail.com>
Subject: Re: [patch 05/15] sched: add a timer to handle CFS bandwidth refresh
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 3:18 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-05-03 at 02:28 -0700, Paul Turner wrote:
>> @@ -1003,6 +1003,8 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
>>
>>         if (cfs_rq->nr_running == 1)
>>                 list_add_leaf_cfs_rq(cfs_rq);
>> +
>> +       start_cfs_bandwidth(cfs_rq);
>>  }
>>
>>  static void __clear_buddies_last(struct sched_entity *se)
>> @@ -1220,6 +1222,8 @@ static void put_prev_entity(struct cfs_r
>>                 update_stats_wait_start(cfs_rq, prev);
>>                 /* Put 'current' back into the tree. */
>>                 __enqueue_entity(cfs_rq, prev);
>> +
>> +               start_cfs_bandwidth(cfs_rq);
>>         }
>>         cfs_rq->curr = NULL;
>>  }
>
> OK, so while the first made sense the second had me go wtf?!, now I
> _think_ you do that because do_sched_cfs_period_timer() can return idle
> and stop the timer when no bandwidth consumption is seen for a while,
> and thus we need to re-start the timer when we put the entity to sleep,
> since that could have been a throttle.
>
> If that's so then neither really do make sense and a big fat comment is
> missing.
>
> So why not start on the same (but inverse) condition that makes it stop?
>

This was originally to guard the case that an entity was running on
stale (from a previous period) quota resulting in cfs_bandwidth->idle
and the timer not being re-instantiated.

Now that expiration is properly integrated I think the two cases are
analogous and that this can be dropped (and the start moved into the
(nr_running == 1) entity case on enqueue).

I think this is correct but my brain's a little fuzzy right now, will
confirm in the morning.
