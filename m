Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab2IEPFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:05:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757067Ab2IEPFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:05:45 -0400
Date: Wed, 5 Sep 2012 18:07:08 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, gleb@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 1/2] kvm: Use a reserved IRQ source ID for irqfd
Message-ID: <20120905150707.GA11058@redhat.com>
References: <20120821190800.24958.74812.stgit@bling.home>
 <20120821192903.24958.90138.stgit@bling.home>
 <504765B9.7010406@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504765B9.7010406@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 05:46:17PM +0300, Avi Kivity wrote:
> On 08/21/2012 10:29 PM, Alex Williamson wrote:
> > KVM_IRQFD currently uses the reserved KVM_USERSPACE_IRQ_SOURCE_ID
> > which is also shared with userspace injection methods like
> > KVM_IRQ_LINE.  This can cause a conflict if an irqfd triggers on
> > a GSI asserted through KVM_IRQ_LINE.  Move irqfd to it's own
> > reserved IRQ source ID.  Add a capability for userspace to test
> > for this fix.
> 
> I don't think we need a cap, rather a backport if we identify real cases
> where an edge gsi is shared among several devices.  Otherwise it is just
> a theoretical bug before level irqfd is introduced.

In that case, I think it's safer to preserve the "bug" as is: we are
changing userspace-visible behaviour for edge interrupts otherwise.
For example if userspace uses kvm_irq_line for an edge
interrupt, set it to 1, previously it could then
continue to send any number of interrupts with irqfd,
now it can't.

Basically the logical OR functionality of source IDs
does not make sense for edge.

How about we do
	 if (flags&RESAMPLE)
		source_id = USERSPACE
	else
		source_id = IRQFD

> -- 
> error compiling committee.c: too many arguments to function
