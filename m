Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1C1RQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:16:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37091 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab1C1RQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:16:41 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=XYJHFtupD_QA:10 a=hHK822mBKeAA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=IW32Ly0jwWZy_HkfmAwA:9 a=G36mDGpXYhW-gRWX5ckA:7 a=uQ1JIYnekKdQISudk-3_wT5JpP0A:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Mon, 28 Mar 2011 13:16:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: scxby <scxby@163.com>
Cc: linux-kernel@vger.kernel.org, Darren Hart <darren@dvhart.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM:a bug about pi-futex maybe let the program going to
 hang
Message-ID: <20110328171640.GB8529@home.goodmis.org>
References: <A97FC25C3A4B47D2A3C623C690CA5FC5@xiewentao>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A97FC25C3A4B47D2A3C623C690CA5FC5@xiewentao>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the report, I added Cc to people that may be able to help.

-- Steve

On Sat, Mar 26, 2011 at 12:19:03PM +0800, scxby wrote:
> hi, all.
>  
>   Maybe, there is a bug about pi-futex, it would let the program in user-space going to hang.
>  
>   We have a board: CPU is powerpc 8572, two core. after ran one month, the state of pi-futex in user-space got bad: mutex->__data.__lock is 0x8000023e, mutex->__data.__count is 0, mutex->__data.__owner is 0.
>  
>   then, I review file "kernel/funtex.c"(the version is linux 2.6.38), found a case:
>  
>   if there are 3 thread, named threadA, threadB, threadC??thread A hold mutexM, threadB and threadC is waiting mutexM. They run as fllow steps:
>  
>   1. threadB and threadC sleep at line 1984.
>   2. threadB receive a signal, then it will be wake up.
>   3. threadA unlock mutexM, and give mutexM to threadB. 
>   4. threadB call fixup_owner, try to give mutex to threadC.
>   5. at line 1580, threadB trigger a addr-fault, then goto handle_fault.
>   6. at line 1617, threadB release spinlock, then handle fault.
>   7. threadC got spinlock, and call fixup_owner, and got mutexM.
>   8. threadC give mutexM to threadB.
>   9. threadB re-got spinlock, it will found "pi_state->owner == oldowner" and retry to fixup.
>   10. threadB give mutexM to threadC, that's a bad thing.
>  
>   we have wrote a program, this program can prove all above

