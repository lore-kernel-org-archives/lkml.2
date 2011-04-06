Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab1DFCbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 22:31:51 -0400
Received: from smtp-out.google.com ([74.125.121.67]:54919 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab1DFCbu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 22:31:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=PsKI7dGsrpgAIIOyBHItsx7sjyTFVeQeKrvqg36Kgb9Mf1Ev8LSJgZK3C8zXOj6WMO
         J/Qyx8hfAwMEJwoUosDA==
MIME-Version: 1.0
In-Reply-To: <1302010092.2225.1317.camel@twins>
References: <20110323030326.789836913@google.com> <20110323030449.434436052@google.com>
 <1302010092.2225.1317.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Tue, 5 Apr 2011 19:31:17 -0700
Message-ID: <BANLkTimVz3pFEHNs-eqXwV8BGsDYpKoREg@mail.gmail.com>
Subject: Re: [patch 08/15] sched: migrate throttled tasks on HOTPLUG
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 5, 2011 at 6:28 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-03-22 at 20:03 -0700, Paul Turner wrote:
>> Throttled tasks are invisisble to cpu-offline since they are not eligible for
>> selection by pick_next_task().  The regular 'escape' path for a thread that is
>> blocked at offline is via ttwu->select_task_rq, however this will not handle a
>> throttled group since there are no individual thread wakeups on an unthrottle.
>>
>> Resolve this by unthrottling offline cpus so that threads can be migrated.
>
> Fair enough, the flip side is that they all can again increase their
> debt by a whole tick, right?
>

In the case where they enqueue on to a new rq and we can't catch the
bw condition until entity_tick I suppose it's possible to grab up to
an extra tick.

This is actually analogous to a task waking up when other cpus have
drained quota -- this case can be properly handled by an explicit
check/throttle in the enqueue_task_fair() path in the non-on-cpu case.
 Will add.
