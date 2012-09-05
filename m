Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892Ab2IEPPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:15:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab2IEPPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:15:05 -0400
Message-ID: <50476C76.6020008@redhat.com>
Date: Wed, 05 Sep 2012 18:15:02 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Alex Williamson <alex.williamson@redhat.com>, gleb@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 1/2] kvm: Use a reserved IRQ source ID for irqfd
References: <20120821190800.24958.74812.stgit@bling.home> <20120821192903.24958.90138.stgit@bling.home> <504765B9.7010406@redhat.com> <20120905150707.GA11058@redhat.com>
In-Reply-To: <20120905150707.GA11058@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2012 06:07 PM, Michael S. Tsirkin wrote:
> On Wed, Sep 05, 2012 at 05:46:17PM +0300, Avi Kivity wrote:
>> On 08/21/2012 10:29 PM, Alex Williamson wrote:
>> > KVM_IRQFD currently uses the reserved KVM_USERSPACE_IRQ_SOURCE_ID
>> > which is also shared with userspace injection methods like
>> > KVM_IRQ_LINE.  This can cause a conflict if an irqfd triggers on
>> > a GSI asserted through KVM_IRQ_LINE.  Move irqfd to it's own
>> > reserved IRQ source ID.  Add a capability for userspace to test
>> > for this fix.
>> 
>> I don't think we need a cap, rather a backport if we identify real cases
>> where an edge gsi is shared among several devices.  Otherwise it is just
>> a theoretical bug before level irqfd is introduced.
> 
> In that case, I think it's safer to preserve the "bug" as is: we are
> changing userspace-visible behaviour for edge interrupts otherwise.
> For example if userspace uses kvm_irq_line for an edge
> interrupt, set it to 1, previously it could then
> continue to send any number of interrupts with irqfd,
> now it can't.

If anyone did that, they should have reported a bug, since they surely
didn't expect edges if the line was held high.

> 
> Basically the logical OR functionality of source IDs
> does not make sense for edge.

Edge is only interpreted at the ioapic or pic input; the line is just a
line (an open collector line that ORs anything connected to it, or an
equivalent).

> 
> How about we do
> 	 if (flags&RESAMPLE)
> 		source_id = USERSPACE
> 	else
> 		source_id = IRQFD

Okay if we identify something that depends on the bug, otherwise not.

-- 
error compiling committee.c: too many arguments to function
