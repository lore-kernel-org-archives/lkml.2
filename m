Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab2CPRVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 13:21:05 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52775 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab2CPRVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 13:21:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6650"; a="173172869"
Message-ID: <4F63767E.3020706@codeaurora.org>
Date: Fri, 16 Mar 2012 10:21:02 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Dave Martin <dave.martin@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nicolas.pitre@linaro.org, catalin.marinas@arm.com,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] arm: Add unwinding support for memset and memzero.
References: <1331574027-28542-1-git-send-email-lauraa@codeaurora.org> <20120314111504.GA2033@linaro.org>
In-Reply-To: <20120314111504.GA2033@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/2012 4:15 AM, Dave Martin wrote:
>
> For functions like this, the unwinding requirements are different
> depending on where we are in the function.  But the unwinder annotations
> don't remember exact instruction locations; only the extent of the
> whole unwind block is recorded, along with the sequence (but not
> location) of unwinder directives.
>
> As is, the unwinding may be wrong depending on which part of the function
> is executing when the fault occurs.
>

Hmmmm, I thought I could get away with only one annotation based on the 
structure of memset/memzero but looking again you are right, it really 
requires multiple annotations to be correct.

> It may be possible to split the function into multiple unwind blocks,
> e.g.:
>
> ENTRY(somefunc)
> UNWIND(.fnstart)
>
> UNWIND(.save {r4,lr})
> 	stfmd	sp!, {r4,lr}
>
> 	/* check something */
>
> 	blt	_the_other_way
> 	/* maybe carry out our job this way */
>
> 	ldmfd	sp!, {r4,lr}
> UNWIND(.fnend)
>
> _the_other_way:
> UNWIND(.fnstart)
> UNWIND(.save {r4,lr})
> UNWIND(.save {r5-r8})
> 	stmfd	sp!, {r5-r8}	/* !! */
>
> 	/* carry out our job the other way */
>
> 	ldmfd	sp!, {r5-r8}
> 	ldmfd	sp!, {r4,pc}	/* !! */
> UNWIND(.fnend)
>
>
> This is still not exactly right (it's hard to be exactly right,
> since the unwind tables are not meant for handling asynchronous
> unwinding), but unwinding should be correct for the main bits of code
> where most time is spent and/or faults are most likely (the "carry out
> our job" comments).
>

Would a compiler be able to generate code such as this and still 
generate correct completely unwinding annotations? Or if the compiler 
knows unwinding is necessary, is the only option to generate code in 
'unwindable blocks'? (alternatively, no compiler is smart/stupid enough 
to generate this code?)

> You'd have to experiment to see whether the backtracer does something
> sensible with unwind tables like this.  It might need tweaking to
> find the correct function symbol if a fault occurs in the second
> unwind block for example ... that perhaps it will already do the
> right thing.
>

Yes, I'll look into this. memcpy is missing annotations as well but that 
code is significantly more convoluted.

> Cheers
> ---Dave
>

Thanks,
Laura

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
