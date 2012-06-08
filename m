Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab2FHOGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:06:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756555Ab2FHOGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:06:21 -0400
Date: Fri, 8 Jun 2012 16:03:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Jones <davej@redhat.com>, David Rientjes <rientjes@google.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: oom-killer is crazy? (Was: [PATCH 0/3] uprobes fixes for 3.5)
Message-ID: <20120608140328.GA26650@redhat.com>
References: <20120607165942.GA31966@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120607165942.GA31966@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07, Oleg Nesterov wrote:
>
> This doesn't depend on other uprobes patches I sent, and I think
> this is 3.5 material.

And during the testing I found another thing which should be fixed
in 3.5 imho. I noticed that oom-killer goes crazy. In the simplest
case, when there is the single and "obvious" memory hog it kills
sshd daemon.

Hmm. oom_badness() does

	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
		points -= 30 * totalpages / 1000;

very nice, but what if this underflows? points is unsigned long.
points += p->signal->oom_score_adj... looks suspicious too.

Looks like we should remove "unsigned" from oom_badness() and
its callers? Probably not, it does "return points ? points : 1".

Confused.

Oleg.

