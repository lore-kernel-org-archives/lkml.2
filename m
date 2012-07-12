Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030598Ab2GLDgD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 23:36:03 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:57809
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758640Ab2GLDf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 23:35:26 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz98dI1432I1447Izz1202h1082kzz8275dhz2dh2a8h668h839h944hd25hf0ah107ah)
Date: Thu, 12 Jul 2012 11:26:25 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH 2/2] irq: add irq_desc_initialize to remove some
 duplicated lines
Message-ID: <20120712032624.GC22640@shlinux2.ap.freescale.net>
References: <1340182831-10477-1-git-send-email-b29396@freescale.com>
 <1340182831-10477-2-git-send-email-b29396@freescale.com>
 <alpine.LFD.2.02.1207120017590.32033@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1207120017590.32033@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Thanks for the review firstly.

On Thu, Jul 12, 2012 at 06:19:18AM +0800, Thomas Gleixner wrote:
> On Wed, 20 Jun 2012, Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > There're two copies of irq_desc initialization code, reform them into
> > an irq_desc_initialize function to call.
> > 
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > ---
> >  kernel/irq/irqdesc.c |   51 +++++++++++++++++++++++++++----------------------
> >  1 files changed, 28 insertions(+), 23 deletions(-)
> 
> We add more code by removing redundant copies?
> 
I also had this strange question.
I looked the code a bit more, i guess the main problem is that the redundant copies
is not too big, so we can not see great savings.

Compare to the init code of irq_desc in original alloc_desc function,
the new irq_desc_initialize function saves 4 lines.
However, the new function also add 4 lines for defining extra function name,
parameter and etc.
And alloc_desc still needs to call irq_desc_initialize and checking return value
which needs extra 6 lines.
The main saving is another copy of irq_desc initialization in early_irq_init,
but this copy does not check any return values which cause we did not save too much,
only about 4 lines.
Plus extra blan lines added, so totally it does not save more than new added.

However, i was thinking it could make code looks a bit better.
So i sent out this RFC patch.
Do you think if it's reasonable?

BTW, there's an issue in my patch, should change like:
        if (alloc_masks(desc, GFP_KERNEL, node)) {
-               kfree(desc->kstat_irqs);
+               free_percpu(desc->kstat_irqs);
                return -ENOMEM;
        }

Regards
Dong Aisheng

