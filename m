Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab0FZJpo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 05:45:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:48873 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824Ab0FZJpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 05:45:42 -0400
Message-ID: <4C25CC18.2070507@kernel.org>
Date: Sat, 26 Jun 2010 11:44:56 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       stern@rowland.harvard.edu, gregkh@suse.de, khali@linux-fr.org
Subject: Re: [PATCH 11/12] libata: use IRQ expecting
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-12-git-send-email-tj@kernel.org> <4C23F6C1.7070603@garzik.org> <4C245E50.7090701@kernel.org> <4C2577F2.4030005@garzik.org> <4C25BAD2.4070705@kernel.org> <4C25C551.8000404@garzik.org>
In-Reply-To: <4C25C551.8000404@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 26 Jun 2010 09:44:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jeff.

On 06/26/2010 11:16 AM, Jeff Garzik wrote:
> On 06/26/2010 04:31 AM, Tejun Heo wrote:
>> Well, it can indicte the start of cluster of completions, which is the
>> necessary information anyway.  From the second call on, it's a simple
>> flag test and return.  I doubt it will affect anything even w/ high
>> performance SSDs but please read on.
> 
> Yes, and your patch calls unexpect_irq() at the _start_ of a cluster of
> completions.  That is nonsensical, because it reflects the /opposite/ of
> the present ATA bus state, when multiple commands are in flight.

That's actually what we wanna know.  I'll talk about it below.

>> ata_qc_complete_multiple() call [un]expect_irq() only once by
>> introducing an internal completion function w/o irq expect handling,
>> say ata_qc_complete_raw() and making both ata_qc_complete() and
>> ata_qc_complete_multiple() simple wrapper around it w/ irq expect
>> handling.
> 
> Yes, this fixes problem, but it is better to create a wrapper path for
> the legacy PATA/SATA1 that uses irq-expecting, and a fast path for
> modern controllers that do not use it.
> 
>> On 06/26/2010 05:45 AM, Jeff Garzik wrote:
>>> We don't want to  burden modern SATA drivers with the overhead of
>>> dealing with silly PATA/SATA1 legacy irq nastiness, particularly the
>>> ugliness of calling
>>
>> I think we're much better off applying it to all the drivers.  IRQ
>> expecting is very cheap and scalable and there definitely are plenty
>> of IRQ delivery problems with modern controllers although their
>> patterns tend to be different from legacy ones.  Plus, it will also be
>> useful for power state predictions.
> 
> Modern SATA/SAS controllers, and their drivers, already have well
> defined methods of acknowledging interrupts, even unexpected ones, in
> ways that do not need this core manipulation.  This is over-engineering,
> punishing all modern chipsets moving forward regardless of their design,
> by unconditionally requiring this behavior of all libata drivers.

Unacked irqs are primarily handled by spurious IRQ handling.  IRQ
expecting is more about lost interrupts and we have enough lost
interrupt cases even on new controllers w/ native interface, both
transient and non-transient.

One of the goals of this whole IRQ exception handling was to make it
dumb easy for drivers to use which also included makes things cheap
enough so that they can be called from hot paths.  Both expect and
unexpect_irq() are very cheap once the IRQ delivery is verified.  If
the processor is taking an interrupt in the first place, this amount
of logic shouldn't matter at all.  There really isn't punishment to
avoid and IMHO not doing it for native controllers is an over
optimization.  It gains almost nothing while losing meaningful
protection.

> Just like the rest of libata's layered driver architecture, it should be
> straightforward to apply this only to SFF/BMDMA chipsets, then tackle
> odd cases as needs arise.
>
> Modern controllers acknowledge interrupts sanely, and always "expect" an
> interrupt when you include interrupt events like hotplug, even if the
> ATA bus itself is idle.  There is no need to burden the millions of ahci
> users with irq-expecting, for example.

I'm not saying applying it to only SFF/BMDMA is difficult, just that
it's better to apply it to all drivers in this case.  IRQ expecting is
to protect against misdelivered / lost IRQs and we do have them for
ahci, sil24 or whatever too.  It would of course be silly to pay
significant performance overhead for such protection but as I stated
above, it's _really_ cheap.  If the driver is taking an interrupt and
accessing harddware and even if compared only against the general
complexity of generic IRQ and libata code, the cost of IRQ [un]expect
is negligible and designed precisely that way to allow use cases like
this.

> With regards to power state predictions, it is only useful if you are
> accurately reflecting the ATA bus state (idle or not) at all times.  As
> mentioned above, this patch clearly creates a condition where
> unexpect_irq() is called when commands remain in flight, and libata is
> expecting further command completions.
>
> IOW, patch #11 says "we are not expecting irq" when we are.
> 
> At least a halfway sane approach would be to track bus-idle status, and
> trigger useful code when that status changes (idle->active or
> active->idle).  Perhaps LED, power state, and irq-expecting could all
> use such a triggering mechanism.

Continuing from the response to the first paragraph.  The IRQ
expecting code isn't interested in the bus state, it's interested only
in the IRQ events and that's what it's expecting.  The same applies to
power state prediction too, so please consider the following NCQ
command execution sequence.

1. issue tags 0, 1, 2, 3
2. IRQ triggers, tags 0, 2 complete
3. IRQ triggers, tags 1, 3 completes

For IRQ expecting, both 1-2 and 2-3 are segments to expect for and for
power state transition too, as it's IRQ itself which forces the cpu to
come out of sleep state.  The reason why I said unexpect in
ata_qc_complete() is okay is that it can still delimit each segment as
long as we have proper irq_expect() call at the beginning of each
segment (all other unexpect calls are ignored).  But, that's kind of
moot point as we can easily do single pair.

Thanks.

-- 
tejun
