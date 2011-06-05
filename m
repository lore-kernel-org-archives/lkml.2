Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab1FET2n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 15:28:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49286 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab1FET2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 15:28:42 -0400
MIME-Version: 1.0
Message-ID: <703fddf1-223f-409c-a8d1-bc9468537429@default>
Date: Sun, 5 Jun 2011 12:28:18 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Hugh Dickins <hughd@google.com>
Cc: Luis Henriques <luis.henrix@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [RFC] "mustnotsleep"
References: <87hb87lsb0.fsf@gmail.com>
 <58c0ab81-5c63-4d41-957b-df02e15aeba5@default
 BANLkTiko0AUtGYqXcYxv1KpUKY8t+tvqf1bczSN-qa9uSWtPTg@mail.gmail.com>
In-Reply-To: <BANLkTiko0AUtGYqXcYxv1KpUKY8t+tvqf1bczSN-qa9uSWtPTg@mail.gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DEBD8E8.0154:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Luis is surely on the right lines, but maybe CONFIG_DEBUG_PREEMPT was
> not the crucial option.
> 
> You should be building with CONFIG_PREEMPT and
> CONFIG_DEBUG_SPINLOCK_SLEEP for best testing, and it would be good to
> throw in CONFIG_DEBUG_PREEMPT too.
> 
> You need to preempt_disable() instead of mustnotsleep_start(), and
> preempt_enable() instead of mustnotsleep_done().  You cannot even
> safely use their smp_processor_id() without disabling preemption -
> otherwise that task might on a different cpu by the time you get to
> use the cpu it told you.  It's essential to disable preemption if you
> cannot bear to be rescheduled.
> 
> Then, if I've read the ifdefs correctly (please verify),
> cond_resched() will include a __might_sleep() to report "BUG: sleeping
> function called from invalid context..." from cond_resched() and other
> useful places.

Excellent!  Thanks, I will give it a try!  In my case,
preemption is indeed already disabled for all this code
(but irq's and bottom halves are enabled).
 
> But please don't disable preemption unnecessarily, nor for very long:
> it's better to remain preemptible wherever possible.

Sure, but what I'm arguing is that in many cases (and contrary
to conventional wisdom), a "somewhat fast" access to a page of data
with preemption DISabled is better than a "slow" disk read
with preemption ENabled.  Naturally this depends on if
all of the CPUs have useful work to do while waiting for the
disk read to complete... but as cores proliferate, CPU saturation
is becoming less likely.

Thanks again!
Dan
