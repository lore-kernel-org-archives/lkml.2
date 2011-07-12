Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1GLRD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 13:03:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62796 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab1GLRD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 13:03:26 -0400
Date: Tue, 12 Jul 2011 19:03:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 3/6] perf: add reference time event
Message-ID: <20110712170311.GB9201@somewhere>
References: <1307490806-24548-1-git-send-email-dsahern@gmail.com>
 <1307490946-24673-1-git-send-email-dsahern@gmail.com>
 <20110617133230.GC25197@somewhere.redhat.com>
 <4DFB5F0B.4020903@gmail.com>
 <20110617141707.GE25197@somewhere.redhat.com>
 <4E1A7A0D.8000806@gmail.com>
 <20110712143024.GA9201@somewhere>
 <4E1C77C9.1060005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1C77C9.1060005@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 10:35:21AM -0600, David Ahern wrote:
> On 07/12/2011 08:30 AM, Frederic Weisbecker wrote:
> > Actually you first have to face a deeper problem. events are not stored
> > in order in the flow, but they are sorted from perf_session__process_events().
> > 
> > The bunch of sorted events is flushed periodically and sent to the consumer.
> > 
> > See flush_sample_queue().
> > 
> > And this sorting is made on top of the sample->time timestamps. So events
> > are first sorted on sample->time and only afterward you have access to your
> > gtod tracepoint samples. But if that gtod sample has been taken after a reboot
> > then its sample->time is not consistant with the rest. It is not well sorted
> > and thus the reftime won't be updated at the right moment.
> 
> I was aware of this function and the buffering /sorting it does; I have
> similar code in my local analysis tool (for older perf userspace). I had
> not stopped to consider the impacts on the append mode since I never use
> that option.
> 
> > So the problem is that reftime update already depends on a consistant cpu
> > timestamp.
> > 
> > I can't think about a sane way to work around that. Sorting on gtod + cpu timestamp
> > is not a solution because gtod can change.
> > 
> > I'd rather propose to refuse append mode as long as we have any timestamp. That includes
> > gtod but also sample timestamps. They are buggy if we reboot.
> 
> I'm fine with restricting append mode if samples have timestamps. In
> that case the time of day reference can be added to the header per the
> original patch set. The change in behavior does impact a lot of record
> use cases (system wide, raw).

Yep, sounds good.
