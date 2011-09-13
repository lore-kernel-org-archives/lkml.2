Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab1IMOwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 10:52:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119Ab1IMOwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 10:52:13 -0400
Message-ID: <4E6F6E0E.6070202@redhat.com>
Date: Tue, 13 Sep 2011 17:51:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 8/5] llist: Remove cpu_relax() usage in cmpxchg loops
References: <1315461646-1379-1-git-send-email-ying.huang@intel.com>   <1315836358.26517.43.camel@twins> <4E6E1693.7080606@redhat.com>  <1315837930.26517.49.camel@twins> <4E6F41EB.1040106@redhat.com> <1315923724.5977.15.camel@twins>
In-Reply-To: <1315923724.5977.15.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2011 05:22 PM, Peter Zijlstra wrote:
> On Tue, 2011-09-13 at 14:43 +0300, Avi Kivity wrote:
>
> >  Another issue is that hypervisors use PAUSE to detect a spinning guest
> >  and issue a directed yield to another vcpu.  But for cmpxchg loops, the
> >  "spinner" would just commit on the next loop, no?  So I think there's no
> >  objection from that front.
>
> Right, we shouldn't ever spend a significant amount spinning on a
> cmpxchg. If we do we need to fix that instead.

I hate arguing while agreeing, but the issue isn't that we don't spend a 
significant time spinning, but that there is no owner.  Should the other 
cpu go away, we just pick up a new copy of oldval and complete the 
transaction.

With spinlocks, even if you hold it for just a single guest cycle, the 
situation is different.  If the vcpu that holds the spinlock is 
preempted, the spinner is forced to spin until the owner is rescheduled.

-- 
error compiling committee.c: too many arguments to function

