Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab2CXEZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 00:25:26 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34547 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab2CXEZZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 00:25:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120324041752.GE2450@linux.vnet.ibm.com>
References: <20120319152317.GA3932@gmail.com> <CA+55aFyezw6yW2g6hOAOeZ5vRm0xUNPQyD4eo0wRHMHiN3Z+kQ@mail.gmail.com>
 <20120320033300.GH2393@linux.vnet.ibm.com> <CA+55aFzXAdNRqNHm3-wx02au4b_Ze_WM-gCtOk+gJdGMsn3Zbg@mail.gmail.com>
 <20120323192143.GY2450@linux.vnet.ibm.com> <CA+55aFzgno-7AcHxKMWGYrr2QAwEzXOieSghnsEfPQJ5aed-yQ@mail.gmail.com>
 <20120323211638.GA2450@linux.vnet.ibm.com> <20120323212550.GA11791@linux.vnet.ibm.com>
 <20120324014755.GA4685@linux.vnet.ibm.com> <CA+55aFwgnhhoV=9PT3N0YToEwKDUB6pqOQhX3+6o3CeccC10=g@mail.gmail.com>
 <20120324041752.GE2450@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 23 Mar 2012 21:25:04 -0700
X-Google-Sender-Auth: dD-A14QsPI_pN-gnPQyZtpI1nzY
Message-ID: <CA+55aFxRJ+=j91vhZdDu0har8qvhLeP4fea_cSXzkaRE84wvvg@mail.gmail.com>
Subject: Re: [GIT PULL] RCU changes for v3.4
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 9:17 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> I must admit that __this_cpu_inc() would be nicer than __this_cpu_add(),
> though, will fix.  I need the leading "__" to avoid disabling preemption
> needlessly on non-x86 platforms.

Yeah, that's just bogus. Ok on that.

> The reason that the "__raw" forms are
> safe in this case is because the per-CPU variable is saved and restored
> at context-switch time.
>
> Or am I still missing something here?

It's not that the "__raw" forms are "safe". It's that they are SH*T.

Don't use them. They are crap. Why would you do

+       __raw_get_cpu_var(rcu_read_lock_nesting) =
+               current->rcu_read_lock_nesting_save;

which is just crazy and cannot use the actual sane "%fs:" segment
overrides, but instead has to do idiotic "ready the per-cpu offset
pointer and add it in".

 We've got "__this_cpu_write()" which generates the correct code.

Rule of thumb: there is _never_ any good reason to use
__raw_get_cpu_var. It's a broken interface.

                       Linus
