Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab1FBNBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 09:01:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:59072 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab1FBNA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 09:00:58 -0400
Subject: Re: [tip:sched/urgent] sched: Fix cross-cpu clock sync on remote
 wakeups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Borislav Petkov <bp@amd64.org>, Borislav Petkov <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "markus@trippelsdorf.de" <markus@trippelsdorf.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
In-Reply-To: <BANLkTikT6OT-HDi-DR+_ZWEhfp_CYWJ3Hg@mail.gmail.com>
References: <1306835745.2353.3.camel@twins>
	 <tip-f01114cb59d670e9b4f2c335930dd57db96e9360@git.kernel.org>
	 <20110531125621.GA24439@gere.osrc.amd.com> <1306847516.2353.80.camel@twins>
	 <20110601070547.GB3368@liondog.tnic> <1306924612.2353.176.camel@twins>
	 <20110601155017.GD24028@aftab>
	 <BANLkTikT6OT-HDi-DR+_ZWEhfp_CYWJ3Hg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Jun 2011 15:04:26 +0200
Message-ID: <1307019866.2497.675.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-02 at 15:52 +0800, Yong Zhang wrote:
> In sched_clock_local(), clock is calculated around ->tick_gtod even if
> that ->tick_gtod is stale for long time because we stays in idle state. 
> You know ->tick_gtod is only updated in sched_clock_tick();

(well, no, there's idle callbacks as you said below)

> IOW, when a cpu goes out of idle, sched_clock_tick() is called from
> tick_nohz_stop_idle() which is later than interrupt.

Gah, that would be awefull and mean wakeups from interrupts were already
borken. /me goes look at code.

irq_enter() -> tick_check_idle() -> tick_check_nohz() ->
tick_nohz_stop_idle() -> sched_clock_idle_wakeup_event()

should update the thing before we run any isrs, right?

> So if we have any site which call sched_clock() in interrupt on an
> idle cpu, it could get incorrect clock.
> 
> I'm not sure how to teach sched_clock() about this special case, Peter?

isn't anything to teach afaict.

