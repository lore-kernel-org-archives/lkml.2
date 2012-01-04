Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042Ab2ADVlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 16:41:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757028Ab2ADVlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 16:41:53 -0500
Message-ID: <4F04C789.40209@redhat.com>
Date: Wed, 04 Jan 2012 23:41:29 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Rik van Riel <riel@redhat.com>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        vatsa@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com>  <20111219112326.GA15090@elte.hu> <87sjke1a53.fsf@abhimanyu.in.ibm.com>  <4EF1B85F.7060105@redhat.com> <877h1o9dp7.fsf@linux.vnet.ibm.com>  <20111223103620.GD4749@elte.hu> <4EF701C7.9080907@redhat.com>  <20111230095147.GA10543@elte.hu> <878vlu4bgh.fsf@linux.vnet.ibm.com>  <87pqf5mqg4.fsf@abhimanyu.in.ibm.com> <4F017AD2.3090504@redhat.com>  <87mxa3zqm1.fsf@abhimanyu.in.ibm.com> <4F046536.5080207@redhat.com>  <4F048295.1050907@redhat.com>  <4F04898B.1080600@redhat.com> <1325712710.3084.10.camel@laptop>
In-Reply-To: <1325712710.3084.10.camel@laptop>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2012 11:31 PM, Peter Zijlstra wrote:
> On Wed, 2012-01-04 at 19:16 +0200, Avi Kivity wrote:
> > 
> > 
> > I think we can solve it at the guest level.  The paravirt ticketlock
> > stuff introduces wait/wake calls (actually wait is just a HLT
> > instruction); we could spin for a while, then HLT until the other side
> > wakes us.  We should do this for all sites that busy wait.
> > 
> This is all TLB invalidates, right?
>
> So why wait for non-running vcpus at all? That is, why not paravirt the
> TLB flush such that the invalidate marks the non-running VCPU's state so
> that on resume it will first flush its TLBs. That way you don't have to
> wake it up and wait for it to invalidate its TLBs.

That's what Xen does, but it's tricky.  For example
get_user_pages_fast() depends on the IPI to hold off page freeing, if we
paravirt it we have to take that into consideration.

> Or am I like totally missing the point (I am after all reading the
> thread backwards and I haven't yet fully paged the kernel stuff back
> into my brain).

You aren't, and I bet those kernel pages are unswappable anyway.

> I guess tagging remote VCPU state like that might be somewhat tricky..
> but it seems worth considering, the whole wake and wait for flush thing
> seems daft.

It's nasty, but then so is paravirt.  It's hard to get right, and it has
a tendency to cause performance regressions as hardware improves.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

