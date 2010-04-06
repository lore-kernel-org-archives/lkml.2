Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab0DFQV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:21:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab0DFQVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:21:22 -0400
Message-ID: <4BBB5F52.4000403@redhat.com>
Date: Tue, 06 Apr 2010 19:20:34 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Darren Hart <dvhltc@us.ibm.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH V2 0/6][RFC] futex: FUTEX_LOCK with optional adaptive
 spinning
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> <4BBA5305.7010002@redhat.com> <4BBA5C00.4090703@us.ibm.com> <4BBA6279.20802@redhat.com> <4BBA6B6F.7040201@us.ibm.com> <4BBB36FA.4020008@redhat.com> <1270560931.1595.342.camel@laptop> <20100406145128.6324ac9a@lxorguk.ukuu.org.uk> <4BBB531A.4070500@us.ibm.com> <4BBB5C0D.8050602@redhat.com> <alpine.LFD.2.00.1004061809080.32352@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1004061809080.32352@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 07:14 PM, Thomas Gleixner wrote:
>
>> IMO the best solution is to spin in userspace while the lock holder is
>> running, fall into the kernel when it is scheduled out.
>>      
> That's just not realistic as user space has no idea whether the lock
> holder is running or not and when it's scheduled out without a syscall :)
>    

The kernel could easily expose this information by writing into the 
thread's TLS area.

So:

- the kernel maintains a current_cpu field in a thread's tls
- lock() atomically writes a pointer to the current thread's current_cpu 
when acquiring
- the kernel writes an invalid value to current_cpu when switching out
- a contended lock() retrieves the current_cpu pointer, and spins as 
long as it is a valid cpu

-- 
error compiling committee.c: too many arguments to function

