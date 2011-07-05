Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab1GEN04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 09:26:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52047 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab1GEN0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:26:55 -0400
Date: Tue, 5 Jul 2011 17:26:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Don Zickus <dzickus@redhat.com>, Stephane Eranian <eranian@google.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip, final] perf, x86: Add hw_watchdog_set_attr() in a
 sake of nmi-watchdog on P4
Message-ID: <20110705132651.GA3859@sun>
References: <20110705102017.GA12458@elte.hu>
 <20110705103403.GN17941@sun>
 <20110705105959.GA14435@elte.hu>
 <20110705110550.GQ17941@sun>
 <20110705112002.GA15654@elte.hu>
 <20110705113620.GS17941@sun>
 <20110705114437.GC15654@elte.hu>
 <20110705114944.GT17941@sun>
 <20110705121421.GU17941@sun>
 <20110705131005.GA5843@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110705131005.GA5843@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 03:10:05PM +0200, Ingo Molnar wrote:
> 
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > perf, x86: P4 PMU - Add hw_watchdog_set_attr helper to simulate cpu-cycles counting in nmi-watchdog
> > 
> > Because of constraints existed in Netburst PMU counting
> > cpu cycles is allowed for one consumer only.
> > 
> > If the kernel is booted up with nmi-watchdog enabled
> > the watchdog become a consumer of such event and there
> > is no more room left for "perf top" and friends (ie any
> > attempts to count cpu cycles simultaneously with nmi-watchdog
> > doomed to fail).
> 
> Hm, what is the symptom - 'perf top' reports nothing?

Exactly, last time I had access to p4 machine (about 2 month
ago I think) with nmi-watchdog enabled perf top simply rendered
empty screen with standart header on top.

> 
> If multiple users request cycles then perf will time-share them - 
> this is what happens if you run many 'perf top' or 'perf stat' 
> sessions in parallel for example. For example i just tried to run six 
> separate 'perf top' in parallel - and all six worked fine.
> 
> So the question is, why does the NMI watchdog prevent 'perf top' from 
> working on a P4?
>

Because core and nehalem can use two cpu-cycles counters simultaneously
counting same event, and when nmi-watchdog is enabled on such pmus the one
counter assigned to nmi-watchdog, a second counter assigned to perf top and friends.
And nmi-watchdog event is "never released" event as far as I remember,
it runs all the time while system works.

In P4 every event has a restriction on which counter it can run and which
assitional registers it can use. So once nmi-watchdog has borrowed an event
(and associated resurses) noone else can access to these resources forever,
and hence perf top fails since it tries to gain access to same event.

	Cyrill
