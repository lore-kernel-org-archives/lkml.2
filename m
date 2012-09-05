Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894Ab2IEPf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:35:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156Ab2IEPf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:35:27 -0400
Message-ID: <5047713C.3080602@redhat.com>
Date: Wed, 05 Sep 2012 18:35:24 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Alex Williamson <alex.williamson@redhat.com>, gleb@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 1/2] kvm: Use a reserved IRQ source ID for irqfd
References: <20120821195813.GD9027@redhat.com> <1345579579.29292.67.camel@ul30vt.home> <20120821204125.GF9027@redhat.com> <1345583694.29292.91.camel@ul30vt.home> <20120822004138.GM9027@redhat.com> <5047633F.9020405@redhat.com> <20120905145153.GA11048@redhat.com> <504768E2.3020706@redhat.com> <20120905151348.GC11058@redhat.com> <50476E51.5020005@redhat.com> <20120905152832.GE11058@redhat.com>
In-Reply-To: <20120905152832.GE11058@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2012 06:28 PM, Michael S. Tsirkin wrote:

>> gsi 3 is configured as edge in the ioapic.  It has (unusually) two
>> inputs: one driven by userspace, the other by irqfd.
>> 
>> cpu 0                    cpu 1
>> ------------------------ -------------------------
>> irqfd: set to 1
>> ioapic: recognize edge
>> inject irq
>> EOI
>>                          KVM_IRQ_LINE: set to 1
>>                          ioapic: ignore
>>                          KVM_IRQ_LINE: set to 0
>> irqfd: set to 0
>> 
>> We had two edges with an EOI between them, but injected just on interrupt.
> 
> I see. Makes sense, ACK this patch.

Actually it's wrong.  The two sources are not synchronized, so there is
no way for them to know the two edges did not coalesce.  On real
hardware, after all, edge interrupts have a non-zero pulse width, and
kvm faithfully emulates this.

But this patch makes sense for level irqfd, so we might as well keep it
with a different description.

-- 
error compiling committee.c: too many arguments to function
