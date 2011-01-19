Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab1ASB2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 20:28:30 -0500
Received: from claw.goop.org ([74.207.240.146]:53357 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab1ASB23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 20:28:29 -0500
Message-ID: <4D363E39.2050100@goop.org>
Date: Tue, 18 Jan 2011 17:28:25 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Jan Beulich <JBeulich@novell.com>, Avi Kivity <avi@redhat.com>,
        Xen-devel <xen-devel@lists.xensource.com>, suzuki@in.ibm.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH RFC 09/12] xen/pvticketlock: Xen implementation for PV
 ticket locks
References: <cover.1279328276.git.jeremy.fitzhardinge@citrix.com> <32e63cc978ec4b3f36c7f641ce48b3d86aed22ed.1279328276.git.jeremy.fitzhardinge@citrix.com> <20100926113910.GA6719@linux.vnet.ibm.com> <4C9FCA8F.4070802@goop.org> <20110118162717.GA18234@linux.vnet.ibm.com>
In-Reply-To: <20110118162717.GA18234@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2011 08:27 AM, Srivatsa Vaddagiri wrote:
>> No, interrupts are disabled while waiting to take the lock, so it isn't
>> possible for an interrupt to come in.
> Where are we disabling interrupts? Is it in xen_poll_irq()?

No, they're already disabled in the generic spinlock code. 
arch_spin_lock_flags() can re-enable them if it wants.

>>  With the old-style locks it was
>> reasonable to leave interrupts enabled while spinning, but with ticket
>> locks it isn't.
>>
>> (I haven some prototype patches to implement nested spinning of ticket
>> locks,
> Hmm ..where is nested spinning allowed/possible? Process context will
> disable interrupts/bh from wanting the same (spin-)lock it is trying to
> acquire?

If you're in an interrupt-enabled context at the time you're taking an
interrupt-safe spinlock (ie, using spin_lock_irq[save]), then it is (in
principle) valid to leave interrupts enabled until you actually acquire
the lock (obv you must avoid any window with the lock acquired and
interrupts enabled).

We did this with the old-style locks (both native and pv) - it seems
like it should be especially useful for interrupt latency if we end up
waiting for the lock a long time.  However, it can't be done with ticket
locks.  I also have no idea how often we ended up being able to it in
practice anyway.

    J
