Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab1LGHut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 02:50:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43017 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab1LGHus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 02:50:48 -0500
Date: Wed, 7 Dec 2011 08:49:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] lockdep, rtmutex, bug: Show taint flags on
 error
Message-ID: <20111207074901.GD16942@elte.hu>
References: <1319773015.6759.30.camel@deadeye>
 <tip-fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013@git.kernel.org>
 <1323185640.7454.269.camel@deadeye>
 <1323193731.32012.81.camel@twins>
 <20111206175558.3215907c@lxorguk.ukuu.org.uk>
 <20111206175919.GA5386@elte.hu>
 <20111206181715.GG3366@decadent.org.uk>
 <20111206182847.GB12094@elte.hu>
 <20111206191458.GA25568@elte.hu>
 <20111206211342.GI3366@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206211342.GI3366@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ben Hutchings <ben@decadent.org.uk> wrote:

> So what I would like to do is either:
> 
> 1. No longer disable lock debugging due to any taint
> or
> 2. Disable lock debugging only when TAINT_PROPRIETARY_MODULE is set

I'd like a whitelist - i.e. disable on taint by default, but 
allow case by case exceptions such as OOT_MODULE.

Nor am i singling out bin-only modules, look at the current set 
of taint flags:

#define TAINT_PROPRIETARY_MODULE        0
#define TAINT_FORCED_MODULE             1
#define TAINT_UNSAFE_SMP                2
#define TAINT_FORCED_RMMOD              3
#define TAINT_MACHINE_CHECK             4
#define TAINT_BAD_PAGE                  5
#define TAINT_USER                      6
#define TAINT_DIE                       7
#define TAINT_OVERRIDDEN_ACPI_TABLE     8
#define TAINT_WARN                      9
#define TAINT_CRAP                      10
#define TAINT_FIRMWARE_WORKAROUND       11
#define TAINT_OOT_MODULE                12

*all* except TAINT_FIRMWARE_WORKAROUND, TAINT_CRAP and OOT 
should result in lockdep disabling. (perhaps 
OVERRIDDEN_ACPI_TABLE, as a variant of FIRMWARE_WORKAROUND, 
could be added as an exception too)

Module forcing causes various lifetime issues and lockdep tracks 
lifetime so can get confused on that. Unsafe SMP - enough said. 
Lockdep also wants to disable on the first WARN_ON() - which is 
typically the sign of some initial badness, which should be 
investigated before any lockdep splat is looked into.

Since most of the taint flags show deep kernel or hardware 
troubles i'd like most new taint flags to be lockdep off by 
default. As new taint flags are introduced they can be added to 
the whitelist when justified.

Thanks,

	Ingo
