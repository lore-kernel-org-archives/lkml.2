Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab1HYQrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:47:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55305 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab1HYQrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:47:00 -0400
Date: Thu, 25 Aug 2011 18:46:49 +0200
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Anders Eriksson <aeriksson@fastmail.fm>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        linux-kernel@vger.kernel.org
Subject: Re: mtrr failure, 3.1-rc1
Message-ID: <20110825164649.GL2803@mtj.dyndns.org>
References: <20110825070335.3095B3BC183@tippex.mynet.homeunix.org>
 <CA+55aFzndqkSC1z3==HqUGC8hP=pw62ro3CWYtovk95_cYAKsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzndqkSC1z3==HqUGC8hP=pw62ro3CWYtovk95_cYAKsA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 25, 2011 at 08:55:12AM -0700, Linus Torvalds wrote:
> Hmm. Some of those commits are marked for stable too.
> 
> I'm adding appropriate parties to the discussion (authors and
> sign-offs from the five commits that that merge brings in), but it
> would also be great if you could bisect exactly which commit broke for
> you. You can make it quick by just doing
> 
>   git bisect start
>   git bisect bad dc43d9fa73d82083656fb9c02f4823bcdcfb9f91
>   git bisect good dc43d9fa73d82083656fb9c02f4823bcdcfb9f91^
> 
> and it should take just a couple of tests. I *assume* it's the
> stop_machine changes by Tejun &co, but who knows..
> 
> Anders, is this a single-CPU system?

Indeed, while removing custom rendezvous code and switching to
stop_machine, commit 192d8857427d "x86, mtrr: use stop_machine APIs
for doing MTRR rendezvous" completely dropped mtrr setting code on
!CONFIG_SMP.

Anders, if your kernel didn't have SMP turned on, can you please
verify the following patch fixes the problem?

Thanks.

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 08119a3..6b96110 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -149,7 +149,6 @@ struct set_mtrr_data {
  */
 static int mtrr_rendezvous_handler(void *info)
 {
-#ifdef CONFIG_SMP
 	struct set_mtrr_data *data = info;
 
 	/*
@@ -171,7 +170,6 @@ static int mtrr_rendezvous_handler(void *info)
 	} else if (mtrr_aps_delayed_init || !cpu_online(smp_processor_id())) {
 		mtrr_if->set_all();
 	}
-#endif
 	return 0;
 }
 
