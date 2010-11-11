Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab0KKLNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:13:36 -0500
Received: from smtp-out.google.com ([74.125.121.35]:48186 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab0KKLNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:13:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=wDhKKU0f0pNRcPioL0iIEBwS0lQae3zSw9PZq5N5E4aIlOSFRwqlrjNH8nGNOfkome
         0bvHAV27ES/HSFuRVzMQ==
MIME-Version: 1.0
In-Reply-To: <20101110.205001.226775444.davem@davemloft.net>
References: <20101111035005.443640006@google.com> <20101111035051.156752259@google.com>
 <20101110.204704.193706279.davem@davemloft.net> <20101110.205001.226775444.davem@davemloft.net>
From: Paul Turner <pjt@google.com>
Date: Thu, 11 Nov 2010 03:13:00 -0800
Message-ID: <AANLkTimj2bc4_5OVhq7JSFtXVG8s=sAWcL3twOYfg2gA@mail.gmail.com>
Subject: Re: [tg_shares_up rewrite v2 10/11] sched: allow update_cfs_load to
 update global load
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu,
        vatsa@in.ibm.com, cfriesen@nortel.com, svaidy@linux.vnet.ibm.com,
        pbourdon@excellency.fr, bharata@linux.vnet.ibm.com, kmr@us.ibm.com,
        balbir@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah, I should have checked that, sorry.

I've fixed these errors for a v3.  But in fixing them I've realized I
think we have a race in sched_destroy_group() (in patch 2/11).

While it's true that we are safe for a subsequent enqueue in the same
group, we're not protected against a list element being removed due to
decay in the update shares path.  Or from a another group being
enqueued (via wake-up).

Might as well fix this at the same time so I'll fix it and send out in
the morning.

Thanks!

On Wed, Nov 10, 2010 at 8:50 PM, David Miller <davem@davemloft.net> wrote:
> From: David Miller <davem@davemloft.net>
> Date: Wed, 10 Nov 2010 20:47:04 -0800 (PST)
>
>> From: Paul Turner <pjt@google.com>
>> Date: Wed, 10 Nov 2010 19:50:15 -0800
>>
>>> Refactor the global load updates from update_shares_cpu() so that
>>> update_cfs_load() can update global load when it is more than ~10% out of sync.
>>>
>>> The new global_load parameter allows us to force an update, regardless of
>>> the error factor so that we can synchronize w/ update_shares().
>>>
>>> Signed-off-by: Paul Turner <pjt@google.com>
>>
>> This patch breaks the build, you didn't update the arguments of
>> update_cfs_load() in the !CONFIG_FAIR_GROUP_SCHED case.
>
> And even with this fixed there are even larger problems, as you're
> making access to structure members such as 'load_unacc_exec_time'
> which only exist when CONFIG_FAIR_GROUP_SCHED is set, but you're doing
> it in code that is built unconditionally.
>
> Please fix all of these build problems, as I want to test your changes
> without all of the group scheduler bloat turned on.
>
> Thanks.
>
