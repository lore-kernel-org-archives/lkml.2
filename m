Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab1ISXdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 19:33:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33270 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab1ISXda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 19:33:30 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=6lHFLA3--6UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=PuvxfXWCAAAA:8 a=QqxoWt5gbJtEw92sbj4A:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=o70cNcPx40UA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH 4/5] printk: Have wake_up_klogd() use
 __this_cpu_write()
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>
In-Reply-To: <alpine.DEB.2.00.1109191653460.19059@router.home>
References: <20110919212040.745370781@goodmis.org>
	 <20110919212641.302263742@goodmis.org>
	 <alpine.DEB.2.00.1109191653460.19059@router.home>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 19 Sep 2011 19:33:28 -0400
Message-ID: <1316475208.29966.2.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-19 at 16:54 -0500, Christoph Lameter wrote:
> On Mon, 19 Sep 2011, Steven Rostedt wrote:
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> >
> > The wake up code that triggers klogd does not really matter which
> > CPU it enables the wake up on. Every CPU will be doing a printk_tick()
> > and check the current CPU. As long as one of the CPUs triggers the
> > wakeup we are fine. Use __this_cpu_write() instead of this_cpu_write()
> > to show that we do not care.
> 
> printk_needs_cpu() is always called from context where we have disabled
> interrupts therefore this is safe to do.

hehe, the patch is deceiving ;)

@@ -1225,7 +1225,7 @@ int printk_needs_cpu(int cpu)
 void wake_up_klogd(void)
 {
        if (waitqueue_active(&log_wait))



The printk_needs_cpu may be in the patch header there, but the real
function name happened to be in the call itself. "wake_up_klogd()".
Note, just because something is always in a location that preemption is
disabled, does not mean it should use the __this_cpu*() variants.
Because if things change, it may become a problem later on.

-- Steve

> 
> Reviewed-by: Christoph Lameter <cl@gentwo.org>


