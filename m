Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3AJLoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 06:44:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590Ab3AJLoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 06:44:17 -0500
Date: Thu, 10 Jan 2013 12:44:06 +0100
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC PATCH v2 3/4] uretprobes: return probe entry, prepare
 uretprobe
Message-ID: <20130110114406.GB12964@bandura.brq.redhat.com>
References: <1357730692-3928-1-git-send-email-anton@redhat.com>
 <1357730692-3928-4-git-send-email-anton@redhat.com>
 <20130109161701.GC27722@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130109161701.GC27722@redhat.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 05:17:01PM +0100, Oleg Nesterov wrote:
> On 01/09, Anton Arapov wrote:
> >
> > todo:
> >   protect uprobe
> 
> Yep ;)
> 
> >  static struct uprobe_task *get_utask(void)
> >  {
> > -	if (!current->utask)
> > +	if (!current->utask) {
> >  		current->utask = kzalloc(sizeof(struct uprobe_task), GFP_KERNEL);
> > +		INIT_HLIST_HEAD(&current->utask->return_uprobes);
> 
> What if kzalloc() fails?
:)

> 
> > +static void prepare_uretprobe(struct uprobe *uprobe, struct pt_regs *regs)
> > +{
> > +	struct return_uprobe_i *ri;
> > +	struct uprobe_task *utask;
> > +	struct xol_area *area;
> > +	unsigned long rp_trampoline_vaddr = 0;
> > +
> > +	area = get_xol_area();
> > +	if (area)
> > +		rp_trampoline_vaddr = area->rp_trampoline_vaddr;
> > +	if (!rp_trampoline_vaddr) {
> > +		rp_trampoline_vaddr = xol_get_trampoline_slot();
> 
> This is obviously racy. But again, so far I think we can simply remove
> this.
working on this...

> >  static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
> >  {
> > +	int rc = 0;
> >  	struct uprobe_consumer *uc;
> >  	int remove = UPROBE_HANDLER_REMOVE;
> >  
> >  	down_read(&uprobe->register_rwsem);
> >  	for (uc = uprobe->consumers; uc; uc = uc->next) {
> > -		int rc = uc->handler(uc, regs);
> > +		if (uc->handler)
> > +			rc = uc->handler(uc, regs);
> > +
> > +		if (uc->rp_handler)
> > +			prepare_uretprobe(uprobe, regs); /* put bp at return */
> 
> This doesn't look right. prepare_uretprobe() should not be called
> multiple times.
Overlooked this issue, thanks for catching. 

Anton.
> 
> Oleg.
> 
