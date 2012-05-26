Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225Ab2EZGhp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 02:37:45 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:56772 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750786Ab2EZGho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 02:37:44 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX184+EVfDTg4EHjPOohzBQxAIMa4Dd7w1d4iWBurLf
	VSKt6aWhRdR9K9
Message-ID: <1338014259.7302.26.camel@marge.simpson.net>
Subject: Re: [rfc][patch] select_idle_sibling() inducing bouncing on westmere
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, Arjan Van De Ven <arjan@linux.intel.com>
Date: Sat, 26 May 2012 08:37:39 +0200
In-Reply-To: <1337926468.5415.48.camel@marge.simpson.net>
References: <1337857490.7300.19.camel@marge.simpson.net>
	 <1337865431.9783.148.camel@laptop> <1337865641.9783.149.camel@laptop>
	 <1337926468.5415.48.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 08:14 +0200, Mike Galbraith wrote: 
> On Thu, 2012-05-24 at 15:20 +0200, Peter Zijlstra wrote: 
> > On Thu, 2012-05-24 at 15:17 +0200, Peter Zijlstra wrote:
> > > For power7 with 4 smt it would end up as 1230 I guess.
> > 
> > One more thing, in light of that, can't you simplify the core stuff to
> > be a simple shift as well? map them 123450, does it really matter to
> > pair them off like 103254 ?
> 
> In my head it does.  Buddies need to be glued together so we can use
> them as a team to convert overlap and kick butt on ramp up.

Ew. 3.4 went broke for Q6600, and performance went... far far away.

[    0.200057] CPU0 attaching sched-domain:
[    0.204016]  domain 0: span 0-3 level MC
[    0.208015]   groups: 0 1 2 3
[    0.210970] CPU1 attaching sched-domain:
[    0.212014]  domain 0: span 0-3 level MC
[    0.216016]   groups: 1 2 3 0
[    0.220016] CPU2 attaching sched-domain:
[    0.224015]  domain 0: span 0-3 level MC
[    0.228016]   groups: 2 3 0 1
[    0.232015] CPU3 attaching sched-domain:
[    0.236016]  domain 0: span 0-3 level MC
[    0.240017]   groups: 3 0 1 2

11.791806 usecs/loop -- avg 11.534552 173.4 KHz

Cause: sometimes during boot, hw Siamese twins are 0-1 2-3, and
sometimes, as in this boot, 0-3 1-2, so busted groups above does the
worst thing possible.  When twins are 0-1 2-3, busted groups doesn't
matter with $subject patch applied, it glues Siamese twins back
together.  During this boot, it created Siamese aliens from hell.

-Mike

