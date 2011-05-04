Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab1EDG7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 02:59:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46255 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab1EDG7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 02:59:01 -0400
Date: Wed, 4 May 2011 08:58:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: [PATCH 4/4] x86, mce: Have MCE persistent event off by default
 for now
Message-ID: <20110504065843.GC20828@elte.hu>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
 <1304357691-14354-5-git-send-email-bp@amd64.org>
 <20110503064505.GF7751@elte.hu>
 <20110503072302.GC18979@aftab>
 <987664A83D2D224EAE907B061CE93D5301C53670E0@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301C53670E0@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> > Ok, the problem I see with it is that people without a RAS daemon
> > running will have the mechanism collecting MCEs in the background, using
> > up resources (4 pages per CPU is the buffer) and not doing anything (in
> > the best case that is, when we're not broken otherwise).
> 
> Can the kernel detect whether anyone is listening to the
> persistent MCE event?  If so, then the kernel could printk()
> something to let the user with no RAS daemon (or a dead
> daemon) that stuff is happening that they might like to
> know about.
> 
> Probably make some sense to delay such a message (so that in
> the boot case we give the daemon a chance to get started before
> complaining that it hasn't shown up for work).

Yes, i definitely think a gateway to printk would be useful, so that the system 
can log MCE events the syslog way as well. This probably makes sense for 
persistent events in general, not just MCE events.

Btw., as a sidenote, the much more interesting direction is the reverse 
direction: we want a gateway of printk into the RAS daemon as well - in form of 
a special 'printk events' that contain:

 - the log level of the kernel when the message was generated
 - the log level of the message
 - the printk timestamp
 - plus the printk message itself, as a free-form string

This would allow RAS functionality to dispatch off printk events immediately 
and transparently, without having to separately worry about how to talk to 
syslogd/klogd how to get its logs ...

printk itself could become a persistent event. (Transparently and without 
breaking compatible syslogd/klogd functionality.)

This would also allow the RAS daemon to log printk messages around suspicious 
MCE events, in a time-serialized way via a single event channel - so post 
mortem can be done using a single facility.

There's ongoing work to timestamp perf events with GTOD timestamps - that way 
global log analysis becomes possible as well.

Thanks,

	Ingo
