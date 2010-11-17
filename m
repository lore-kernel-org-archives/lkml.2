Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935104Ab0KQRlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 12:41:13 -0500
Received: from claw.goop.org ([74.207.240.146]:54828 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933709Ab0KQRlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 12:41:11 -0500
Message-ID: <4CE413B3.3010207@goop.org>
Date: Wed, 17 Nov 2010 09:41:07 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Eric Dumazet <dada1@cosmosbay.com>, xiyou.wangcong@gmail.com,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Avi Kivity <avi@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] Re: [PATCH 09/14] xen/pvticketlock: Xen	 implementation
 for PV ticket locks
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com><cover.1289940821.git.jeremy.fitzhardinge@citrix.com> <aa32da076143b8e13c23c1f589d7e6cbedb22907.1289940821.git.jeremy.fitzhardinge@citrix.com> <4CE39C3C0200007800022AE2@vpn.id2.novell.com> <4CE397E7.2010107@goop.org> <4CE3A714.9010509@goop.org> <4CE3BDCF0200007800022BF1@vpn.id2.novell.com>
In-Reply-To: <4CE3BDCF0200007800022BF1@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 02:34 AM, Jan Beulich wrote:
>> Actually, on second thoughts, maybe it doesn't matter so much.  The main
>> issue is making sure that the interrupt will make the VCPU drop out of
>> xen_poll_irq() - if it happens before xen_poll_irq(), it should leave
>> the event pending, which will cause the poll to return immediately.  I
>> hope.  Certainly disabling interrupts for some of the function will make
>> it easier to analyze with respect to interrupt nesting.
> That's not my main concern. Instead, what if you get interrupted
> anywhere here, the interrupt handler tries to acquire another
> spinlock and also has to go into the slow path? It'll overwrite part
> or all of the outer context's state.

That doesn't matter if the outer context doesn't end up blocking.  If it
has already blocked then it will unblock as a result of the interrupt;
if it hasn't yet blocked, then the inner context will leave the event
pending and cause it to not block.  Either way, it no longer uses or
needs that per-cpu state: it will return to the spin loop and (maybe)
get re-entered, setting it all up again.

I think there is a problem with the code as posted because it sets up
the percpu data before clearing the pending event, so it can end up
blocking with bad percpu data.

>> Another issue may be making sure the writes and reads of "w->want" and
>> "w->lock" are ordered properly to make sure that xen_unlock_kick() never
>> sees an inconsistent view of the (lock,want) tuple.  The risk being that
>> xen_unlock_kick() sees a random, spurious (lock,want) pairing and sends
>> the kick event to the wrong VCPU, leaving the deserving one hung.
> Yes, proper operation sequence (and barriers) is certainly
> required here. If you allowed nesting, this may even become
> simpler (as you'd have a single write making visible the new
> "head" pointer, after having written all relevant fields of the
> new "head" structure).

Yes, simple nesting should be quite straightforward (ie allowing an
interrupt handler to take some other lock than the one the outer context
is waiting on).

    J
