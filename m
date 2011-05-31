Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab1EaSBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:01:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753216Ab1EaSBO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:01:14 -0400
MIME-Version: 1.0
In-Reply-To: <20110531174430.GG2393@linux.vnet.ibm.com>
References: <20110531162726.GA15162@elte.hu> <BANLkTi=aWc2c18OohJVmVn_aniyxDKO9Rw@mail.gmail.com>
 <20110531174430.GG2393@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Jun 2011 02:52:59 +0900
Message-ID: <BANLkTimapK+1vDwB-Akw0eVimM4gHBdqaw@mail.gmail.com>
Subject: Re: [GIT PULL] RCU fix
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 2:44 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> The reason for the switch is to allow threads blocked in TREE_PREEMPT_RCU
> and TINY_PREEMPT_RCU RCU read-side critical sections to have their
> priority boosted in order to avoid OOM.  People have made these OOMs
> happen, so this is not longer just a theoretical concern.

Quite frankly, that doesn't make much sense.

First off, the default for priority boosting is off (and you cannot
even select it unless you have RT_MUTEX and PREEMPT_RCU), so why the
heck do we still use the threads even when we don't support the
boosting at all?

Secondly, if a process is in danger of exhausting the RCU resources,
and it is preemptable, why doesn't the rcu_read_unlock() logic just
try to force a reschedule and thus an rcu idle period? Using processes
and process priorities for this seems to be just stupid.

I dunno. After RCU_TINY showed how fragile it was to use kernel
threads for this, and after this subtle issue just re-inforced that
conclusion, I just cannot begin to believe that using a thread was the
right thing to do. It just seems stupid.

                         Linus
