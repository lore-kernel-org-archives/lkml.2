Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab1CURJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 13:09:33 -0400
Received: from relay2.sgi.com ([192.48.179.30]:42568 "HELO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752220Ab1CURJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 13:09:31 -0400
Date: Mon, 21 Mar 2011 12:08:32 -0500
From: Jack Steiner <steiner@sgi.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
Message-ID: <20110321170832.GC12718@sgi.com>
References: <20110321160135.GA31562@sgi.com> <20110321161425.GC23614@elte.hu> <4D877C4B.9090602@gmail.com> <4D878042.9080708@gmail.com> <4D878445.6090709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D878445.6090709@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 08:00:53PM +0300, Cyrill Gorcunov wrote:
> On 03/21/2011 07:43 PM, Cyrill Gorcunov wrote:
> ...
> > 
> > I think Jack might need to setup priority for his notifier, like
> > 
> > static struct notifier_block uv_dump_stack_nmi_nb = {
> > 	.notifier_call	= uv_handle_nmi,
> > 	.priority	= NMI_LOCAL_HIGH_PRIOR+1,
> > };
> > 
> > so it would be called before perf nmi. Don, am I right?
> > 
> > Since for perf nmis we do have
> > 
> > static __read_mostly struct notifier_block perf_event_nmi_notifier = {
> > 	.notifier_call		= perf_event_nmi_handler,
> > 	.next			= NULL,
> > 	.priority		= NMI_LOCAL_LOW_PRIOR,
> > };
> > 
> 
>   I must admit I've missed the fact that Jack has tried NMIs priorities, right?
> x86_platform_ops seems to be a cleaner indeed (btw I think p4 pmu kgdb issue
> is exactly the same problem) but same time this might end up in over-swelled
> ideas behind this small code snippet. Dunno. Probably we need some per-cpu
> system status for nmi reasons other than unknown nmis...

We use KDB internally, and yes, it has the same issue. The version of the
patch that uses KDB OR's the "handled" status for both KDB & the UV NMI handler.
If either KDB or the UV NMI handler returns "handled", the code in traps.c exits
after the call to the first die notifier.

Not particularily pretty but I could not find a better way to do it.

--- jack
