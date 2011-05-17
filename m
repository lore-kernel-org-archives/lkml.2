Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1EQHQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 03:16:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40822 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab1EQHQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 03:16:54 -0400
Date: Tue, 17 May 2011 09:16:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Marcin Slusarz <marcin.slusarz@gmail.com>,
        Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 4/4] watchdog: configure nmi watchdog period based on
 watchdog_thresh
Message-ID: <20110517071642.GF22305@elte.hu>
References: <1305588901-8141-1-git-send-email-msb@chromium.org>
 <1305588901-8141-4-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305588901-8141-4-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mandeep Singh Baines <msb@chromium.org> wrote:

> Before the conversion of the NMI watchdog to perf event, the watchdog
> timeout was 5 seconds. Now it is 60 seconds. For my particular application,
> netbooks, 5 seconds was a better timeout. With a short timeout, we
> catch faults earlier and are able to send back a panic. With a 60 second
> timeout, the user is unlikely to wait and will instead hit the power
> button, causing us to lose the panic info.

That's an interesting observation. Have you been able to measure/observe this 
effect somehow, or do you presume that users find 60 seconds too long?

This would be a concern for upstream as well i guess.

> This change configures the NMI period based on the watchdog_thresh.

Hm, our tolerance for the two thresholds is not just human but technical: hard 
lockup warnings should indeed be triggered after just a few seconds, soft 
lockups can have false positives under extreme conditions.

So we generally want a higher threshold for soft lockups than for hard lockups.

So how about we couple the thresholds with a factor: we make the soft threshold 
twice the amount of time the hard threshold is? Then we could change the 
upstream default as well i think: lets change the NMI timeout to 10 seconds 
(and thus have the soft threshold at 20 seconds). Is 20 seconds short enough 
for most users to not hit reset?

We might want to change another aspect of the NMI watchdog: right now it tries 
to abort the offending task - which is really nasty if there was a spuriously 
long irqs-off section somewhere in the kernel. How about we just print a 
warning instead?

Thanks,

	Ingo
