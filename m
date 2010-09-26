Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab0IZWfA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 18:35:00 -0400
Received: from claw.goop.org ([74.207.240.146]:34386 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264Ab0IZWe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 18:34:59 -0400
Message-ID: <4C9FCA8F.4070802@goop.org>
Date: Sun, 26 Sep 2010 15:34:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Jan Beulich <JBeulich@novell.com>, Avi Kivity <avi@redhat.com>,
        Xen-devel <xen-devel@lists.xensource.com>, suzuki@in.ibm.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH RFC 09/12] xen/pvticketlock: Xen implementation for PV
 ticket locks
References: <cover.1279328276.git.jeremy.fitzhardinge@citrix.com> <32e63cc978ec4b3f36c7f641ce48b3d86aed22ed.1279328276.git.jeremy.fitzhardinge@citrix.com> <20100926113910.GA6719@linux.vnet.ibm.com>
In-Reply-To: <20100926113910.GA6719@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 09/26/2010 04:39 AM, Srivatsa Vaddagiri wrote:
> On Fri, Jul 16, 2010 at 06:03:04PM -0700, Jeremy Fitzhardinge wrote:
>> Replace the old Xen implementation of PV spinlocks with and implementation
>> of xen_lock_spinning and xen_unlock_kick.
> I see that the old implementation took care of a spinlock() call being
> interrupted by another spinlock (in interrupt handler), by saving/restoring 
> old lock of interest. We don't seem to be doing that in this new version?
> Won't that lead to loss of wakeup -> hang?

No, interrupts are disabled while waiting to take the lock, so it isn't
possible for an interrupt to come in.  With the old-style locks it was
reasonable to leave interrupts enabled while spinning, but with ticket
locks it isn't.

(I haven some prototype patches to implement nested spinning of ticket
locks, by allowing the nested taker to steal the queue position of the
outer lock-taker, and switch its ticket with a later one.  But there's a
fundamental problem with the idea: each lock taker needs to take a
ticket.  If you don't allow nesting, then the max amount of tickets
needed = number of cpus-1; however, with nesting, the max number of
tickets = ncpus * max-nesting-depth, so the size of the ticket type must
be larger for a given number of cpus, or the max number of cpus must be
reduced.)

> Also are you planning to push this series into mainline sometime soon?
>

I was planning on sending it out for another round of review shortly; I
got no comments on it at all the first time around.

    J
