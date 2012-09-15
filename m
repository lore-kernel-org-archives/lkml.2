Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab2IOQRF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 12:17:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:59111 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126Ab2IOQRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 12:17:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,428,1344236400"; 
   d="scan'208";a="193416643"
From: Andi Kleen <andi@firstfloor.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to 3.6-rc5 on AMD chipsets - bisected
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	<20120914212717.GA29307@liondog.tnic>
	<CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
	<1347680006.4340.142.camel@marge.simpson.net>
Date: Sat, 15 Sep 2012 09:16:59 -0700
In-Reply-To: <1347680006.4340.142.camel@marge.simpson.net> (Mike Galbraith's
	message of "Sat, 15 Sep 2012 05:33:26 +0200")
Message-ID: <m24nmzz2f8.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith <efault@gmx.de> writes:
>
> The only reason I can think of why pgbench might suffer is postgres's
> userspace spinlocks.  If you always look for an idle core, you improve
> the odds that the wakeup won't preempt a lock holder, sending others
> into a long spin.

User space spinlocks like this unfortunately have a tendency to break
with all kinds of scheduler changes. We've seen this frequently too
with other users. The best bet currently is to use the real time
scheduler, but with various tweaks to get its overhead down.

Ultimatively the problem is that user space spinlocks with CPU
oversubcription is a very unstable setup and small changes can
easily disturb it.

Just using futex is unfortunately not the answer either.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
