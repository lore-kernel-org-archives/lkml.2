Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab1F0Rmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 13:42:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab1F0Rmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 13:42:36 -0400
Date: Mon, 27 Jun 2011 19:40:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: penguin-kernel@i-love.sakura.ne.jp
Cc: roland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: arch_ptrace_attach() without ptrace_traceme()?
Message-ID: <20110627174041.GA13983@redhat.com>
References: <201106270720.p5R7Kd9E095193@www262.sakura.ne.jp> <20110627133420.GA3527@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110627133420.GA3527@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27, Oleg Nesterov wrote:
>
> On 06/27, penguin-kernel@i-love.sakura.ne.jp wrote:
> >
> > Regarding commit f1671f6d "ptrace: fix exit_ptrace() vs ptrace_traceme() race",
> > is calling arch_ptrace_attach() when ptrace_traceme() returned 0 without doing
> > anything (due to PF_EXITING race) expected behavior?
>
> Hmm. Good point, I thinks this should be fixed.

But it is not clear how we can fix this, perhaps we should ignore this
problem...

arch_ptrace_attach() is inherently racy when PTRACE_TRACEME is called.
Please note that f1671f6d did not introduce this race, although I have
to admit I didn't notice this problem when I did this patch.

The race with PF_EXITING you described doesn't differ from another
scenario. PF_EXITING is not set, ptrace_traceme() actually attaches
the caller, but its paren exits and untraces it before it does
arch_ptrace_attach().

If only I knew what arch_ptrace_attach() can do in general ;) But
probably it should be paired with ptrace_disable(), and it is not
called when the tracer detaches on exit anyway. So I think we can
ignore this race.

Oleg.

