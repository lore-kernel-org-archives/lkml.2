Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab0LJEfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 23:35:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801Ab0LJEfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 23:35:16 -0500
Message-ID: <4D01ADE6.3010508@redhat.com>
Date: Thu, 09 Dec 2010 23:34:46 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
References: <20101202144129.4357fe00@annuminas.surriel.com> <20101202144423.3ad1908d@annuminas.surriel.com> <1291382619.32004.2124.camel@laptop> <20101203133056.GF27994@linux.vnet.ibm.com> <1291385010.32004.2165.camel@laptop> <20101203140607.GA9800@linux.vnet.ibm.com>
In-Reply-To: <20101203140607.GA9800@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2010 09:06 AM, Srivatsa Vaddagiri wrote:
> On Fri, Dec 03, 2010 at 03:03:30PM +0100, Peter Zijlstra wrote:
>> No, because they do receive service (they spend some time spinning
>> before being interrupted), so the respective vruntimes will increase, at
>> some point they'll pass B0 and it'll get scheduled.
>
> Is that sufficient to ensure that B0 receives its fair share (1/3 cpu in this
> case)?

I have a rough idea for a simpler way to ensure
fairness.

At yield_to time, we could track in the runqueue
structure that a task received CPU time (and on
the other runqueue that a task donated CPU time).

The balancer can count time-given-to CPUs as
busier, and donated-time CPUs as less busy,
moving tasks away in the unlikely event that
the same task gets keeping CPU time given to
it.

Conversely, it can move other tasks onto CPUs
that have tasks on them that cannot make progress
right now and are just donating their CPU time.

Most of the time the time-given and time-received
should balance out and there should be little to
no influence on the load balancer. This code would
just be there to deal with exceptional circumstances,
to avoid the theoretical worst case people have
described.

-- 
All rights reversed
