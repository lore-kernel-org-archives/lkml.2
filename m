Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab2J2MnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 08:43:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932332Ab2J2Mm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 08:42:59 -0400
Date: Mon, 29 Oct 2012 13:43:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] uprobes/powerpc: Don't clear TIF_UPROBE in
	do_notify_resume()
Message-ID: <20121029124325.GA31397@redhat.com>
References: <20121028173900.GA14621@redhat.com> <20121028173925.GA14642@redhat.com> <20121029052707.GA3400@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121029052707.GA3400@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29, Ananth N Mavinakayanahalli wrote:
>
> On Sun, Oct 28, 2012 at 06:39:25PM +0100, Oleg Nesterov wrote:
>
> Hi Oleg,
>
> > Cleanup. No need to clear TIF_UPROBE, do_notify_resume() does this.
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > ---
> >  arch/powerpc/kernel/signal.c |    4 +---
> >  1 files changed, 1 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
> > index a2dc757..3b99711 100644
> > --- a/arch/powerpc/kernel/signal.c
> > +++ b/arch/powerpc/kernel/signal.c
> > @@ -158,10 +158,8 @@ static int do_signal(struct pt_regs *regs)
> >
> >  void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
>
> But this _is_ do_notify_resume()...

Argh. I'll fix the changelog, see v2 below.

> I don't see this flag cleared
> anywhere else.
>
> Did you have something else in mind?

Sorry for confusion.

As Srikar explained, it is cleared by uprobe_notify_resume(). See db023ea5
"uprobes: Move clear_thread_flag(TIF_UPROBE) to uprobe_notify_resume()", it
is already in Linus's tree.

Oleg.

------------------------------------------------------------------------------
Subject: [PATCH 1/4] uprobes/powerpc: Don't clear TIF_UPROBE in do_notify_resume()

Cleanup. No need to clear TIF_UPROBE, uprobe_notify_resume() does this.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/powerpc/kernel/signal.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
index a2dc757..3b99711 100644
--- a/arch/powerpc/kernel/signal.c
+++ b/arch/powerpc/kernel/signal.c
@@ -158,10 +158,8 @@ static int do_signal(struct pt_regs *regs)
 
 void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
 {
-	if (thread_info_flags & _TIF_UPROBE) {
-		clear_thread_flag(TIF_UPROBE);
+	if (thread_info_flags & _TIF_UPROBE)
 		uprobe_notify_resume(regs);
-	}
 
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
-- 
1.5.5.1


