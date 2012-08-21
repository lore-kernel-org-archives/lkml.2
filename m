Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328Ab2HUSMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 14:12:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14643 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab2HUSMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 14:12:16 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=qkHp1cYU9ngA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=A_osGyS-vk0A:10 a=meVymXHHAAAA:8 a=KNaezN3EGSPTaKAtNlcA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345572733.5069.9.camel@gandalf.local.home>
Subject: Re: Using random in interrupts for RT
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>,
        RT <linux-rt-users@vger.kernel.org>, Theodore Tso <tedtso@gmail.com>
Date: Tue, 21 Aug 2012 14:12:13 -0400
In-Reply-To: <1344954649.6724.13.camel@gandalf.stny.rr.com>
References: <1344954649.6724.13.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-14 at 10:30 -0400, Steven Rostedt wrote:
> Thomas,
> 
> Ben Hutchings asked me if we still need "genirq: Disable random call on
> preempt-rt" for -rt? With commit 902c098a366 "random: use lockless
> techniques in the interrupt path" there is no more locks used. But does
> it still produce high latencies?

Ben,

Looks that the #ifndef can't be removed just yet. The code is not
totally lockless...


add_interrupt_randomness ->
	credit_entropy_bits ->
		kill_fasync ->
			kill_fasync_rcu ->
				spin_lock_irqsave(&fa->fa_lock, flags)

to make things worse, that spinlock turns into a mutex on -rt, so it may
crash the box if triggered.

-- Steve


