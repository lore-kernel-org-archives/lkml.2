Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab1GHHju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 03:39:50 -0400
Received: from smtp-out.google.com ([74.125.121.67]:63230 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab1GHHjs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 03:39:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=sTbjS+1JWoUi4TAwnuP+1lZ99zTeony2jNrjJAbN8Dczg+BPr+PN6taxhil9A6mvi
	Tju2PDnXGMHOmZUmP5Upg==
MIME-Version: 1.0
In-Reply-To: <1310049528.3282.583.camel@twins>
References: <20110707053036.173186930@google.com> <20110707112302.GB8227@elte.hu>
 <1310049528.3282.583.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Fri, 8 Jul 2011 00:39:15 -0700
Message-ID: <CAPM31RKH8m1CpVWmRVLi8bMNSgdQU+Qzc2sTaWbx4r1b2fHF7w@mail.gmail.com>
Subject: Re: [patch 00/17] CFS Bandwidth Control v7.1
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@openvz.org>, Hu Tao <hutao@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 7:38 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2011-07-07 at 13:23 +0200, Ingo Molnar wrote:
>>
>> The +1.5% increase in vanilla kernel context switching performance is
>> unfortunate - where does that overhead come from?
>
> Looking at the asm output, I think its partly because things like:
>
> @@ -602,6 +618,8 @@ static void update_curr(struct cfs_rq *c
>                cpuacct_charge(curtask, delta_exec);
>                account_group_exec_runtime(curtask, delta_exec);
>        }
> +
> +       account_cfs_rq_runtime(cfs_rq, delta_exec);
>  }
>
>
> +static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
> +               unsigned long delta_exec)
> +{
> +       if (!cfs_rq->runtime_enabled)
> +               return;
> +
> +       cfs_rq->runtime_remaining -= delta_exec;
> +       if (cfs_rq->runtime_remaining > 0)
> +               return;
> +
> +       assign_cfs_rq_runtime(cfs_rq);
> +}
>
> generate a call, only to then take the first branch out, marking that
> function __always_inline would cure the call problem.

Indeed!  I looked at this today, fixing this inlining recovers ~50% of
the cost; however, my numbers are not directly comparable to Hu's (~2%
originally, improving to ~1%).

>  Going beyond that
> would be using static_branch() to track if there is any bandwidth
> tracking required at all.
>

I spent some time examining this option as well.  Our toolchain
apparently is stuck on gcc-4.4 which left me scratching my head at the
supposed jump label assembly being omitted until I realized
CC_HAS_ASM_GOTO was missing.  I will roll this up also and benchmark
tomorrow.
