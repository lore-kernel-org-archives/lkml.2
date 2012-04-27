Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab2D0TrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 15:47:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729Ab2D0TrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 15:47:05 -0400
Message-ID: <4F9AF7AC.1010708@redhat.com>
Date: Fri, 27 Apr 2012 15:46:52 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, Larry Woodman <lwoodman@redhat.com>,
        Jason Baron <jbaron@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        john stultz <johnstul@us.ibm.com>
Subject: Re: [RFC PATCH] tty, add kref to sysrq handlers
References: <1335546920-28492-1-git-send-email-prarit@redhat.com> <20120427183922.47436912@pyramind.ukuu.org.uk>
In-Reply-To: <20120427183922.47436912@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/27/2012 01:39 PM, Alan Cox wrote:
>> If the lock were removed, however, there is one _unlikely_ circumstance in
>> which the array would be left unprotected.  That would be the situation in
>> which a module was loaded and the sysrq handler was registered during the
>> execution of the module.  Again, the possibility of the scenario is very
>> small and given the existing usage of unregister_sysrq_key() in the tree
>> it seems like removing the lock is sufficient.
> 
> It's asking for later disasters I think.

Yeah, you're right.

> 
> I'm not sure I see we need a kref - that looks like overkill, and its
> probably even more elegantly done with RCU ?

Possibly -- I'll look into it.

> 
>> Of course, I'm more than willing to hear additional suggestions.  A rw
>> lock still requires that it be taken with irqs disabled so IMO it is out
>> of the question.
> 
> One approach would be to defer the work. Is there any reason a slow sysrq
> handler shouldn't be expected to behave itself and schedule work to run
> later. 

The problem with this is, as lwoodman pointed out me privately, deferring a
sysrq-t is not the best idea.  When sysrq-t is issued we're trying to take a
snapshot of the system as it is at that particular moment, not after some
indeterminate amount of time.  And, if the work scheduler is somehow the problem
(and the reason you're doing a sysrq-t) you won't execute at all.

Thanks for the suggestion Alan -- as always it is much appreciated.  I'll see if
RCU is the solution here.

P.
