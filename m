Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab1AFWN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:13:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786Ab1AFWNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:13:25 -0500
Date: Thu, 6 Jan 2011 17:13:03 -0500
From: Jason Baron <jbaron@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        hpa@linux.intel.com, suresh.b.siddha@intel.com, arjan@linux.intel.com,
        trenn@suse.de, kent.liu@intel.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH 2/2] apic: Add print error interrupt reason
Message-ID: <20110106221302.GC12913@redhat.com>
References: <1294284532-24285-1-git-send-email-youquan.song@intel.com> <1294284532-24285-2-git-send-email-youquan.song@intel.com> <1294284532-24285-3-git-send-email-youquan.song@intel.com> <1294288492.12561.46.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294288492.12561.46.camel@Joe-Laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 08:34:51PM -0800, Joe Perches wrote:
> On Thu, 2011-01-06 at 11:28 +0800, Youquan Song wrote:
> > End user worry about the error interrupt information and intend to know what
> > kind of error interrupts are generated, so this patch add printing out the
> > detail debug information of error interrupt. 
> > 
> > Signed-off-by: Youquan Song <youquan.song@intel.com>
> > ---
> >  arch/x86/kernel/apic/apic.c |   28 +++++++++++++++++++++++++++-
> >  1 files changed, 27 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> []
> > +static const char *error_interrupt_reason[] = {
> 
> static const char * const etc[]
> 
> > +	"Send CS error",
> > +	"Receive CS error",
> > +	"Send accept error",
> > +	"Receive accept error",
> > +	"Redirectable IPI",
> > +	"Send illegal vector",
> > +	"Received illegal vector",
> > +	"Illegal register address",
> > +};
> > +
> > +static void print_error_interrupt_reason(u32 reason)
> > +{
> > +	u32 i = 0;
> > +	reason = reason & 0xff;
> > +	do {
> > +		if (reason & 0x1)
> > +			pr_debug(" : %s", error_interrupt_reason[i]);
> 
> This isn't correct as it will emit <7> for each reason.
> 
> You want pr_cont surrounded by #ifdef DEBUG
> or some new #define pr_debug_cont in printk.h
> but that won't play well with dynamic_debug.
> 
> Jason?  Got a cure for this?
> 
> 

hmmm...right, we could introduce a pr_debug_cont(), but I think it would
be complex to implement, since we would have to pass a reference to
where we are continued from...the #ifdef DEBUG isn't great either, since
we need this for every pr_debug() statement which might be followed by a
pr_cont()...

perhaps, the simplest thing is just to code this explicitly as:
printk(KERN_DEBUG, blah), followed by the regular pr_cont()?

thanks,

-Jason
