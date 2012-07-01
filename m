Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab2GAMBR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 08:01:17 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:36811 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932239Ab2GAMBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 08:01:15 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAJU78E9XQAxf/2dsb2JhbABFtliBCIIYAQEFJy8iARALFAQJFg8JAwIBAgEnHgYNAQUCAQGICwe6d4s7CYYRA5ZGhESKLYJhgVQCIw
Message-ID: <4FF03BDC.9070208@computer.org>
Date: Sun, 01 Jul 2012 14:00:28 +0200
From: Jan Ceuleers <jan.ceuleers@computer.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] [RFC] Potential fix for leapsecond caused futex related
 load spikes
References: <1341135371-45034-1-git-send-email-johnstul@us.ibm.com>
In-Reply-To: <1341135371-45034-1-git-send-email-johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2012 11:36 AM, John Stultz wrote:
> I believe this issue is due to the leapsecond being added without
> calling clock_was_set() to notify the hrtimer subsystem of the
> change. (Although I've not yet chased all the way down to the
> hrtimer code to validate exactly what's going on there).

For the benefit of -stable:

Am I right in thinking that, if the analysis is confirmed, this was
caused by the following commit:

commit 746976a301ac9c9aa10d7d42454f8d6cdad8ff2b
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Tue Jul 3 20:05:20 2007 +0200

NTP: remove clock_was_set() call to prevent deadlock

The clock_was_set() call in seconds_overflow() which happens only when
leap seconds are inserted / deleted is wrong in two aspects:

1. it results in a call to on_each_cpu() with interrupts disabled
2. it is potential deadlock source vs. call_lock in smp_call_function()

The only possible side effect of the removal might be, that an absolute
CLOCK_REALTIME timer fires 1 second too late, in the rare case of leap
second deletion and an absolute CLOCK_REALTIME timer which expires in
the affected time frame. It will never fire too early.

This was probably observed by the reporter of a June 30th -> July 1st
hang: http://lkml.org/lkml/2007/7/3/103

A similar problem was observed by Dave Jones, who provided a screen shot
with a lockdep back trace, which allowed to analyse the problem.

Sob: Thomas Gleixner <tglx@linutronix.de>
Ab: Ingo Molnar <mingo@elte.hu>
Sob: Linus Torvalds <torvalds@linux-foundation.org>
