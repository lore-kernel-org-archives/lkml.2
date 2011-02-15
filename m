Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab1BOOBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 09:01:06 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43600 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab1BOOBF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 09:01:05 -0500
Subject: Re: Question about clearing of tsk->robust_list in clone
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Kenneth Albanowski (Palm GBU)" <Kenneth.Albanowski@palm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>,
        Andreas Schwab <schwab@linux-m68k.org>
In-Reply-To: <alpine.LFD.2.00.1102151233330.26192@localhost6.localdomain6>
References: <23C1F4DA0B73684F85AD25A73E4BB50315252BD7@ushqwmb09>
	 <alpine.LFD.2.00.1102151233330.26192@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 15 Feb 2011 15:00:50 +0100
Message-ID: <1297778450.2413.11.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-15 at 14:16 +0100, Thomas Gleixner wrote:
> 
> And I do not buy the argument about "complex glibc code" at all. glibc
> already handles it for pthread_create() so why the hell can't it
> handle it for fork() ? 

Going by comment #9 they think calling sys_set_robust_list() on every
fork() is too expensive for them, but realistically we cannot do
anything about it, ->robust_list is strictly task state.

I also think their suggestion in comment #11 (lazy state) is flawed,
what if the parent never users robust futexes, in that case the state
will indicate not to initialize the robust state for its children, again
leading to the observed wreckage.

Realistically libpthread should register an on_fork() callback to ensure
the state is properly propagated.
