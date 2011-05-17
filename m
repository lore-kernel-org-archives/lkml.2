Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab1EQJ0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 05:26:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50264 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450Ab1EQJ0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 05:26:39 -0400
Date: Tue, 17 May 2011 11:26:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 5/9] HWPoison: add memory_failure_queue()
Message-ID: <20110517092620.GI22093@elte.hu>
References: <1305619719-7480-1-git-send-email-ying.huang@intel.com>
 <1305619719-7480-6-git-send-email-ying.huang@intel.com>
 <20110517084622.GE22093@elte.hu>
 <4DD23750.3030606@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD23750.3030606@intel.com>
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


* Huang Ying <ying.huang@intel.com> wrote:

> On 05/17/2011 04:46 PM, Ingo Molnar wrote:
> > 
> > * Huang Ying <ying.huang@intel.com> wrote:
> > 
> >> memory_failure() is the entry point for HWPoison memory error
> >> recovery.  It must be called in process context.  But commonly
> >> hardware memory errors are notified via MCE or NMI, so some delayed
> >> execution mechanism must be used.  In MCE handler, a work queue + ring
> >> buffer mechanism is used.
> >>
> >> In addition to MCE, now APEI (ACPI Platform Error Interface) GHES
> >> (Generic Hardware Error Source) can be used to report memory errors
> >> too.  To add support to APEI GHES memory recovery, a mechanism similar
> >> to that of MCE is implemented.  memory_failure_queue() is the new
> >> entry point that can be called in IRQ context.  The next step is to
> >> make MCE handler uses this interface too.
> >>
> >> Signed-off-by: Huang Ying <ying.huang@intel.com>
> >> Cc: Andi Kleen <ak@linux.intel.com>
> >> Cc: Wu Fengguang <fengguang.wu@intel.com>
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> ---
> >>  include/linux/mm.h  |    1 
> >>  mm/memory-failure.c |   92 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >>  2 files changed, 93 insertions(+)
> > 
> > I have to say i disagree with how this is designed and how this is exposed to 
> > user-space - and i pointed this out before.
> > 
> > It's up to Len whether you muck up drivers/acpi/ but here you are patching mm/ 
> > again ...
> > 
> > I just had a quick look into the current affairs of mm/memory-inject.c and it 
> > has become an *even* nastier collection of hacks since the last time i 
> > commented on its uglies.
> > 
> > Special hack upon special hack, totally disorganized code, special-purpose, 
> > partly ioctl driven opaque information extraction to user-space using the 
> > erst-dbg device interface. We have all the maintenance overhead and little of 
> > the gains from hw error event features...
> 
> Like the name suggested, erst-dbg is only for debugging. [...]

Great, if printk does everything then can the debugging code be removed so that 
tooling does not accidentally make non-debugging use of it? I can write a patch 
for that.

> [...]  It is not a user space interface.  The user space interface used by 
> APEI now is printk.

We definitely want printks obviously and primarily - often that is the only 
thing the admin sees, and most of the time there's no automatable 'policy 
action' anyway: human intervention is still the most common 'action' that is 
performed on exceptional system events.

Does all the (unspecified) tooling you are enabling here work based off on 
printk only, or does it perhaps make use of the erst-dbg hack? :-)

[ Wrt. printks we definitely would like to have a printk free-form-ASCII event 
  gateway for tooling wants to use printk events in the regular flow of events 
  that are not available via the syslog - Steve sent a print-string-event patch 
  for that some time ago and that works well. ]

> > In this patch you add:
> > 
> > +struct memory_failure_entry {
> > +       unsigned long pfn;
> > +       int trapno;
> > +       int flags;
> > +};
> > 
> > Instead of exposing this event to other users who might be interested in these 
> > events - such as the RAS daemon under development by Boris.
> > 
> > We have a proper framework (ring-buffer, NMI execution, etc.) for reporting 
> > events, why are you not using (and extending) it instead of creating this nasty 
> > looking, isolated, ACPI specific low level feature?
> 
> This patch has nothing to do with hardware error event reporting.  It is just 
> about hardware error recovering.

Hardware error event reporting and recovery go hand in hand. First is the 
event, the second is the action.

Your structure demonstrates this already: it's called memory_failure_entry. It 
does:

+ * This function is called by the low level hardware error handler
+ * when it detects hardware memory corruption of a page. It schedules
+ * the recovering of error page, including dropping pages, killing
+ * processes etc.

So based off an error event it does one from a short list of in-kernel policy 
actions.

If put into a proper framework this would be a lot more widely useful: we could 
for example trigger the killing of tasks (and other policy action) if other 
(bad) events are triggered - not just the ones that fit into the narrow ACPI 
scheme you have here.

Certain fatal IO errors would be an example, or SLAB memory corruptions or OOM 
errors - or any other event we are able to report today.

So why are we not working towards integrating this into our event 
reporting/handling framework, as i suggested it from day one on when you 
started posting these patches?

Thanks,

	Ingo
