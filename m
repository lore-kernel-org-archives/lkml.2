Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab0KMCnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 21:43:14 -0500
Received: from smtp-out.google.com ([216.239.44.51]:5749 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab0KMCnG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 21:43:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=tYXMUHaOrA8xLgBDL3J7Q7QtW0SCGXI5FZRonr+8SyFUw4M3/1f+Lkt4Bk66MYmX25
         6cMnJLP+YZtljhtg/LvQ==
MIME-Version: 1.0
In-Reply-To: <AANLkTi=vUs7f3bYE-0OM7fARzbNTbGEU4bDd1pcDoOq-@mail.gmail.com>
References: <20101112032405.657789056@google.com> <20101112032702.028843817@google.com>
 <1289559198.2084.214.camel@laptop> <AANLkTi=vUs7f3bYE-0OM7fARzbNTbGEU4bDd1pcDoOq-@mail.gmail.com>
From: Paul Turner <pjt@google.com>
Date: Fri, 12 Nov 2010 18:42:33 -0800
Message-ID: <AANLkTintRZjoYcGvadw7CVudFxF5bzhFYbCK_VkRfpZp@mail.gmail.com>
Subject: Re: [tg_shares_up rewrite v3 09/11] sched: demand based update_cfs_load()
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Karl Rister <kmr@us.ibm.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 5:01 PM, Paul Turner <pjt@google.com> wrote:
> On Fri, Nov 12, 2010 at 2:53 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> On Thu, 2010-11-11 at 19:24 -0800, Paul Turner wrote:
>>> +#ifdef CONFIG_FAIR_GROUP_SCHED
>>> +       cfs_rq->load_unacc_exec_time += delta_exec;
>>> +       if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window)
>>> {
>>> +               update_cfs_load(cfs_rq);
>>> +               update_cfs_shares(cfs_rq, 0);
>>
>> Why not:
>> +               cfs_rq->load_unacc_exec_time -= sysctl_sched_shares_window;
>>
>> (although you probably want to read the sysctl value into a local
>> variable using ACCESS_ONCE() and use that for both cases).
>>
>
> I think this is hard to do in a clean fashion (without a strange arg
> to update_cfs_load).
>
> I'm also not sure it's worth synchronizing on a shares_window change
> since, when we trigger an update from update_curr() is independent of
> folding that time into the load average anyway.
> (Note even: using sysctl_sched_shares_window is already a larger
> window than update_cfs_load will normally fold at since we fold at
> window/2 after the initial period, it just sets a grace period on
> computation without updates in the busy case.)
>

Let me know if you still think this warrants any changes and I'll (fix
accordingly) and repost with the "-p0" stripping fixed.

>>> +       }
>>> +#endif
>>>  }
>>>
>>>  static void update_curr(struct cfs_rq *cfs_rq)
>>> @@ -713,6 +724,7 @@ static void update_cfs_load(struct cfs_r
>>>         }
>>>
>>>         cfs_rq->load_stamp = now;
>>> +       cfs_rq->load_unacc_exec_time = 0;
>>
>> and drop this one?
>>
>
