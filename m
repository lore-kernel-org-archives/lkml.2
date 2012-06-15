Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab2FOARD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:17:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40003 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab2FOARB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:17:01 -0400
Message-ID: <4FDA7EDE.3070408@zytor.com>
Date: Thu, 14 Jun 2012 17:16:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Hans Rosenfeld <hans.rosenfeld@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
        robert.richter@amd.com, andreas.herrmann3@amd.com
Subject: Re: [RFC] x86, fpu: unify signal handling code paths for x86 and
 x86_64 kernels
References: <1339545814.28766.148.camel@sbsiddha-desk.sc.intel.com>  <20120614143727.GF7922@escobedo.osrc.amd.com> <1339719035.3475.52.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1339719035.3475.52.camel@sbsiddha-desk.sc.intel.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 05:10 PM, Suresh Siddha wrote:
> 
> For the above mentioned reason, I guess the current usage of
> is_ia32_task() in copy_siginfo_to_user32() (added recently for x32
> support) is broken, as the TS_COMPAT flag may not be set for the x86
> compat mode apps in those paths.
> 
> Peter offline suggested that the signal  delivery path should probably
> set/clear the TS_COMPAT flag (just like we do it for syscall paths), so
> that is_ia32_task() will work in those paths.
> 
> But the exception paths for the 32bit and 64bit apps in the 64-bit
> kernel is same. So I really need to use something like TIF_IA32 to find
> out the compat mode of the task. Anyways, the comment in the below patch
> explains the problem ;) What should we do? Just remove the
> is_ia32_task() checks in signal paths and just use TIF_IA32 or do
> something like below.
> 
> My personal preference is to use TIF_IA32 check and avoid  the usage of
> is_ia32_task() in the signal delivery paths.

That is the quick fix, but...

> Signal return goes through a system call which already sets the
> TS_COMPAT. It is the signal delivery that is causing the asymmetry.

Yes, and I think you missed some aspects of my statement: the notion
would be that TS_COMPAT would be set from the TIF_IA32 flag at the time
we decide to deliver a signal, the signal being a pseudo-system-call.
However, the more I wonder about if that will confuse the crap out of
ptrace, so using TIF_IA32 might just be the best thing anyway.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

