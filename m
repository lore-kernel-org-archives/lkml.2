Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab1DFNaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 09:30:14 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:33212 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755870Ab1DFNaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 09:30:13 -0400
Date: Wed, 6 Apr 2011 14:30:10 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: [RFC][PATCH 1/5] signals: Always place SIGCONT and SIGSTOP on
 'shared_pending'
Message-ID: <20110406143010.2a0bccd0@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110406130928.GF4142@mtj.dyndns.org>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org>
	<1302031310-1765-2-git-send-email-matt@console-pimps.org>
	<20110405201958.GA1404@redhat.com>
	<20110405215003.636e950b@mfleming-mobl1.ger.corp.intel.com>
	<20110406125757.GA12099@redhat.com>
	<20110406130928.GF4142@mtj.dyndns.org>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Apr 2011 06:09:28 -0700
Tejun Heo <tj@kernel.org> wrote:

> Hey, guys.
> 
> On Wed, Apr 06, 2011 at 02:57:57PM +0200, Oleg Nesterov wrote:
> > But even SIGSTOP should be routed properly. If the process is
> > ptraced, the tracee reports SIGSTOP to the debugger first. This
> > means that tkill(SIGSTOP) should be delivered to the right target.
> 
> I think the more important part is that there really isn't much point
> in optimizing SIGSTOP/CONT.  They inherently involve heavy,
> walk-every-thread operations of putting them to sleep and reversing it
> and there isn't much point in optimizing sending SIGSTOP to stopped
> processes or CONT to running ones.  In addition, STOP/CONT interaction
> is already scary enough so I'd like to avoid adding complexities there
> if at all possible.
> 
> I think it would be better to concentrate on more usual signals.

Fair point. Note that none of the other patches try to optimize
SIGSTOP/CONT paths.

This patch was also my attempt to make my brain not explode while
figuring out the locking order. This was the first patch I wrote in
the series and it was before I'd decided on the order. In other words,
I was trying to eliminate any code where we'd do,

    tsk->sighand->action_lock
        tsk->siglock
            [Dequeue STOP signal from tsk->pending]
                tsk->sighand->siglock

because that complicates the locking order and this patch seemed like a
worthwhile cleanup. As it turns out, it's not a worthwhile/correct
cleanup so I'll have to think how I can handle those paths safely with
a different locking order.

-- 
Matt Fleming, Intel Open Source Technology Center
