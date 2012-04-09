Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800Ab2DITIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:08:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:46550 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757498Ab2DITIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:08:48 -0400
Message-ID: <4F8333BC.3050509@windriver.com>
Date: Mon, 9 Apr 2012 14:08:44 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][REGRESSION] panic: fix stack dump print on direct call
 to panic()
References: <1333992030-21181-1-git-send-email-jason.wessel@windriver.com> <4F832BC8.4090907@linux.intel.com>
In-Reply-To: <4F832BC8.4090907@linux.intel.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 01:34 PM, Andi Kleen wrote:
>> The proper way to resolve the problem that original commit tried to
>> solve is to avoid printing a stack dump from panic() when the either
>> of the following conditions is true:
>>
>>    1) TAINT_DIE has been set (this is done by oops_end())
>>       This indicates and oops has already been printed.
>>    2) oops_in_progress>  1
>>       This guards against the rare case where panic() is invoked
>>       a second time, or in between oops_begin() and oops_end()
> Oops. I guess can just revert it for now. Thanks for catching, Jason.
>
> The proper solution is probably some variant of
> http://git.kernel.org/?p=linux/kernel/git/ak/linux-mce-2.6.git;a=shortlog;h=refs/heads/mce/xpanic
>
> Let the caller pass in the proper action instead of all these hacks.

That is an interesting patch series, but I am not sure I agree about the caller propagating a flag to control what you see in panic.  I intentionally set CONFIG_DEBUG_VERBOSE=y for a reason, I want a stack trace if and when panic(), oops, BUG, etc... is ever called.  This might be a personal preference, but I do not wish to be searching on a string, to find out where the kernel execution terminated.  I want to see stack traces all the time, with the exception of the cases you pointed out in the original patch.

I had taken the time to instrument and the edge cases for the oops and panic() nesting.  I would agree that it is not useful to print further traces if the kernel has already processed an oops.  I also checked non-x86 archs to see that the original behavior was intact with the new version of the patch.  My opinion is that checking for the panic recursion is a necessary evil here, we just have to agree about the right approach.  :-)

Cheers,
Jason.
