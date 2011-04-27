Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300Ab1D0XvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:51:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:17361 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab1D0XvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:51:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=azqL/6FdFIOnfK0f2Nl80Q70PGoQAJkiAT3WzmqQY2caHToWZ6UveAGtinmmDMkYJi
         tK+tNZdTmLQbiVKeI0gg==
Date: Wed, 27 Apr 2011 16:51:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: john stultz <johnstul@us.ibm.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] break out page allocation warning code
In-Reply-To: <1303846026.2816.117.camel@work-vm>
Message-ID: <alpine.DEB.2.00.1104271641350.25369@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1104201317410.31768@chino.kir.corp.google.com> <1303331695.2796.159.camel@work-vm> <20110421103009.731B.A69D9226@jp.fujitsu.com> <1303846026.2816.117.camel@work-vm>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011, john stultz wrote:

> Sorry if this somehow got off on the wrong foot. Its just surprising to
> see such passion bubble up after almost two years of quiet since the
> proc patch went in.
> 

It hasn't been two years, it hasn't even been 18 months.

	$ git diff 4614a696bd1c.. | grep "^+.*current\->comm" | wc -l
	42

Apparently those dozens of new references directly to current->comm since 
the change also were unaware of the need to use get_task_comm() to avoid a 
racy writer.  I don't think there's any code in the kernel that is ok with 
corrupted task names being printed: those messages are usually important.

> So I'm not proposing comm be totally lock free (Dave Hansen might do
> that for me, we'll see :) but when the original patch was proposed, the
> idea that transient empty or incomplete comms would be possible was
> brought up and didn't seem to be a big enough issue at the time to block
> it from being merged.
> 

I'm not really interested in the discussion that happened at the time, I'm 
concerned about racy readers of any thread's comm that result in corrupted 
strings being printed or used in the kernel.

> Its just having a more specific case where these transient
> null/incomplete comms causes an issue would help prioritize the need for
> correctness.
> 

It doesn't seem like there was any due diligence to ensure other code 
wasn't broken.  When comm could only be changed by prctl(), we needed no 
protection for current->comm and so code naturally will reference it 
directly.  Since that's now changed, no audit was done to ensure the 300+ 
references throughout the tree doesn't require non-racy reads.

> In the meantime, I'll put some effort into trying to protect unlocked
> current->comm acccess using get_task_comm() where possible. Won't happen
> in a day, and help would be appreciated. 
> 

We need to stop protecting ->comm with ->alloc_lock since it is used for 
other members of task_struct that may or may not be held in a function 
that wants to read ->comm.  We should probably introduce a seqlock.
