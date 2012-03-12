Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab2CLJoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 05:44:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966Ab2CLJoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 05:44:04 -0400
Message-ID: <4F5DC560.4050103@redhat.com>
Date: Mon, 12 Mar 2012 17:44:00 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: mtosatti@redhat.com, avi@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [PATCH] kvm: ioapic: conditionally delay irq delivery during
 eoi broadcast
References: <20120312090734.8414.21043.stgit@amd-6168-8-1.englab.nay.redhat.com> <20120312092354.GT17882@redhat.com>
In-Reply-To: <20120312092354.GT17882@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 05:23 PM, Gleb Natapov wrote:
> On Mon, Mar 12, 2012 at 05:07:35PM +0800, Jason Wang wrote:
>> >  Currently, we call ioapic_service() immediately when we find the irq is still
>> >  active during eoi broadcast. But for real hardware, there's some dealy between
>> >  the EOI writing and irq delivery (system bus latency?). So we need to emulate
>> >  this behavior. Otherwise, for a guest who haven't register a proper irq handler
>> >  , it would stay in the interrupt routine as this irq would be re-injected
>> >  immediately after guest enables interrupt. This would lead guest can't move
>> >  forward and may miss the possibility to get proper irq handler registered (one
>> >  example is windows guest resuming from hibernation).
>> >  
> Yes, I saw this behaviour with Windows NICs, but it looks like the
> guest bug. Does this happen with other kind of devices too? Because
> if it does not then the correct hack would be to add a delay between
> Windows enabling PHY and sending first interrupt to a guest. This will
> model what happens on real HW. NIC does not start receiving packets at
> the same moment PHY is enabled. Some time is spent bring up the link.
>

Looks common for any unhandled level irq but I haven't tried. What I've 
tested is running a similar test program by hacking the card driver and 
let it run in both real physical machine and a kvm guest,  and see what 
happens if there's no irq handled:

- In real hardware, there's a gap between two successive irqs injected 
by eoi broadcast, and OS can move forward.
- In a kvm guest, no gap, guest can't move forward and would always stay 
in the irq context forever.
