Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab0KXAYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:24:48 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48971 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab0KXAYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:24:46 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [resend][PATCH 4/4] oom: don't ignore rss in nascent mm
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>
In-Reply-To: <20101123143427.GA30941@redhat.com>
References: <20101025122914.9173.A69D9226@jp.fujitsu.com> <20101123143427.GA30941@redhat.com>
Message-Id: <20101124085022.7BDF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 24 Nov 2010 09:24:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> On 10/25, KOSAKI Motohiro wrote:
> >
> > Because execve() makes new mm struct and setup stack and
> > copy argv. It mean the task have two mm while execve() temporary.
> > Unfortunately this nascent mm is not pointed any tasks, then
> > OOM-killer can't detect this memory usage. therefore OOM-killer
> > may kill incorrect task.
> >
> > Thus, this patch added signal->in_exec_mm member and track
> > nascent mm usage.
> 
> Stupid question.
> 
> Can't we just account these allocations in the old -mm temporary?
> 
> IOW. Please look at the "patch" below. It is of course incomplete
> and wrong (to the point inc_mm_counter() is not safe without
> SPLIT_RSS_COUNTING), and copy_strings/flush_old_exec are not the
> best places to play with mm-counters, just to explain what I mean.
> 
> It is very simple. copy_strings() increments MM_ANONPAGES every
> time we add a new page into bprm->vma. This makes this memory
> visible to select_bad_process().
> 
> When exec changes ->mm (or if it fails), we change MM_ANONPAGES
> counter back.
> 
> Most probably I missed something, but what do you think?

Because, If the pages of argv is swapping out when processing execve,
This accouing doesn't work.

Of cource, changing swapping-out logic is one of way. But I did hope
no VM core logic change. taking implict mlocking argv area during execve
is also one of option. But I did think implicit mlocking is more risky.

Is this enough explanation? Please don't hesitate say "no". If people
don't like my approach, I don't hesitate change my thinking.

Thanks.


