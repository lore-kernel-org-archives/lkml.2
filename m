Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab0DGSo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 14:44:27 -0400
Received: from soto.provo.novell.com ([137.65.250.214]:37053 "EHLO
	soto.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758049Ab0DGSoZ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ghaskins@novell.com:12:1>);
	Wed, 7 Apr 2010 14:44:25 -0400
Message-Id: <4BBC9A3B0200005A00063E34@soto.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 07 Apr 2010 12:44:11 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Darren Hart" <dvhltc@us.ibm.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Eric Dumazet" <eric.dumazet@gmail.com>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Peter Morreale" <PMorreale@novell.com>,
       "Sven Dietrich" <SDietrich@novell.com>,
       "Chris Mason" <chris.mason@oracle.com>, "Avi Kivity" <avi@redhat.com>,
       "Rik van Riel" <riel@redhat.com>, "Chris Wright" <chrisw@sous-sol.org>,
       "John Cooper" <john.cooper@third-harmonic.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] futex: handle timeout inside adaptive lock
	 spin
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
 <1270499039-23728-6-git-send-email-dvhltc@us.ibm.com>
 <alpine.LFD.2.00.1004061022080.32352@localhost.localdomain>
 <4BBCC174.7020409@us.ibm.com>
In-Reply-To: <4BBCC174.7020409@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 4/7/2010 at 01:31 PM, in message <4BBCC174.7020409@us.ibm.com>, Darren Hart
<dvhltc@us.ibm.com> wrote: 
> Thomas Gleixner wrote:
>> On Mon, 5 Apr 2010, Darren Hart wrote:
>> 
>>> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>

>>> +		if (timeout) {
>>> +			now = ktime_get();
>> 
>>   Hmm. Calling that in every iteration might hurt especially on non
>>   TSC systems, but well...
> 
> I haven't come across a better alternative since arming the timer before 
> setting TASK_INTERRUPTIBLE isn't appropriate.

Hey Darren,

I remember we tried something similar in early versions of the adaptive locks and this was definitely bad. :(

It ended up putting so much contention on the xtime_lock (IIRC) that it resulted in adaptive locks hurting overall performance verses not using adaptive at all.  Alternative mechanisms employed a hybrid where the inner loops used a pseudo calibrated counter loop, and the outer loop checks periodically against a real clock.  It all plays into "you are burning CPU cycles anyway, so might as well put them to use" theory.  Hacky, yes, but it did relieve the pressure on the time subsystem locks and freed up a _lot_ of performance.  Without this, the concept of timeouts+adaptive was unworkable.  I think Steven ultimately rejected the timeout related patches outright when he merged adaptive to -rt, but I think Sven pulled them into SLERT if you would like a potential code reference to a working solution.

-Greg



