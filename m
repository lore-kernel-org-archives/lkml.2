Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab1AYNF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:05:27 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:40840 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753446Ab1AYNFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:05:25 -0500
X-Authenticated: #15668376
X-Provags-ID: V01U2FsdGVkX192dgNGGZl2SiGs++xBFOtphU4TEOhbTb3pf7K31V
	18DFBSxRBjGE1/
From: Emil Langrock <emil.langrock@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Recursive deactivation of local bottom halves
Date: Tue, 25 Jan 2011 14:05:14 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-trunk-686; KDE/4.4.5; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101251405.18157.emil.langrock@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wanted or more or less had to do following:

...
spin_lock_bh(lock1);
....
	spin_lock_bh(lock2);
	...
	spin_unlock_bh(lock2);
....
spin_unlock_bh(lock1);
....

Now some weird behavior were noticed by a second person and he fixed it by 
removing the _bh from the inner spinlocks. I checked what the difference is 
and here is the previous example without the common spin_lock behaviour:

...
local_bh_disable();
....
	local_bh_disable();
	...
	local_bh_enable();
....
local_bh_enable();
....

According to http://people.netfilter.org/rusty/unreliable-guides/kernel-
hacking/routines-softirqs.html it makes no difference how often I use the pair 
local_bh_disable/local_bh_enable inside local_bh_disable/local_bh_enable. So 
was this changed?

I also couldn't find any indication in the kernel/softirq.c in the 
local_bh_enable functionality that the counting in local_bh_disable makes any 
difference.

Can somebody tell me if that is legal or not (on smp and uniprocessor)? And 
maybe can show me the related source code why is it may or may not be legal?

Kind regards,
Emil
