Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab1CaPXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:23:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50727 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab1CaPXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:23:21 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=XYJHFtupD_QA:10 a=Q3TRN94aEHEA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=64FLKib8zJ8yjf410YkA:9 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 31 Mar 2011 11:23:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, dzickus@redhat.com
Subject: Re: [PATCH]: Use cmpxchg() in WARN_*_ONCE() functions
Message-ID: <20110331152319.GC14441@home.goodmis.org>
References: <20110331124607.13219.33332.sendpatchset@prarit.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331124607.13219.33332.sendpatchset@prarit.bos.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 08:46:07AM -0400, Prarit Bhargava wrote:
> An issue popped up where WARN_ON_ONCE() was used in a callback function
> in smp_call_function().  This resulted in the WARN_ON executing multiple times
> when it should have only executed once.

But that is just once per cpu, correct?

> 
> I then did
> 
>         for (i = 0; i < 1000000; i++)
>                 on_each_cpu(prarit_callback, NULL, 0);
> 
> The current code, of course, explodes :).  That's the bug I'm trying to fix.

How exactly does it explode? How many CPUs do you have, and does this
still just print once per CPU?

> What is interesting in this test, however, is the impact that checking the
> !__warned flag has [Aside: Checking the !__warned flag is an enhancement
> and is not explicitly required for this code].
> 
> A run with just (!cmpxchg(&__warned, 0, 1)) results in an average of 21.323s,
> and a run with  (!__warned && !cmpxchg(&__warned, 0, 1)) results in an
> average of 20.233s.  Of course, the !__warned is not necessary for the code
> to work properly but it seems to be a significant impact to the time to run
> this code.

Yes adding the check for !__warned first should have obvious benefits.

I really do not see anything wrong with this patch, but personally, I
would rather fix what caused the WARN_ON_ONCE() than fix the warning
itself, as long as the warning itself does not really break anything
else.

-- Steve
