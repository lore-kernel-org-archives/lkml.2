Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab1FCAAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 20:00:51 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24586 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab1FCAAu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 20:00:50 -0400
MIME-Version: 1.0
Message-ID: <58c0ab81-5c63-4d41-957b-df02e15aeba5@default>
Date: Thu, 2 Jun 2011 17:00:29 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Luis Henriques <luis.henrix@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: RE: [RFC] "mustnotsleep"
References: <1af7a43d-84fa-47c4-a145-409e5bac585b@default
 87hb87lsb0.fsf@gmail.com>
In-Reply-To: <87hb87lsb0.fsf@gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DE82431.00BA:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Luis Henriques [mailto:luis.henrix@gmail.com]
> Subject: Re: [RFC] "mustnotsleep"
> 
> Dan Magenheimer <dan.magenheimer@oracle.com> writes:
> 
> > In development of RAMster, I have frequently been bitten
> > by indirect use of existing kernel subsystems that
> > unexpectedly sleep.  As such, I have hacked the
> > following "debug" code fragments for use where I need to
> > ensure that doesn't happen.
> >
> > DEFINE_PER_CPU(int, mustnotsleep_count);
> >
> > void mustnotsleep_start(void)
> > {
> > 	int cpu = smp_processor_id();
> > 	per_cpu(mustnotsleep_count, cpu)++;
> > }
> >
> > void mustnotsleep_done(void)
> > {
> > 	int cpu = smp_processor_id();
> > 	per_cpu(mustnotsleep_count, cpu)--;
> > }
> >
> > and in schedule.c in schedule():
> >
> > if (per_cpu(mustnotsleep_count))
> > 	panic("scheduler called in mustnotsleep code");
> >
> > This has enabled me to start identifying code that
> > is causing me problems.  (I know this is a horrible
> > hack, but that's OK right now.)
> 
> I'm pretty sure I'm missing something here but... what if you just use
> CONFIG_DEBUG_PREEMPT?  Isn't that good enough?

Thanks for the reply Luis.

Looking at the code enabled by CONFIG_DEBUG_PREEMPT,
I don't think it does what I'm looking for.  I need
to ensure that no code called inside the boundaries
of mustnotsleep_start/done ever calls the scheduler,
e.g. cond_resched is never called etc.
