Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab0FVLno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 07:43:44 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39624 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab0FVLnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 07:43:43 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C20A1DE.2040503@s5r6.in-berlin.de>
Date: Tue, 22 Jun 2010 13:43:26 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100415 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Philippe De Muyter <phdm@macqel.be>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] firewire: core: no need to track irq flags in	bm_work
References: <tkrat.96072b90a5c06bb3@s5r6.in-berlin.de> <20100622093618.GC26304@frolo.macqel>
In-Reply-To: <20100622093618.GC26304@frolo.macqel>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe De Muyter wrote:
> On Mon, Jun 21, 2010 at 11:23:52PM +0200, Stefan Richter wrote:
>> This is a workqueue job and always entered with IRQs enabled.
> 
> did you mean 'disabled' ?

I meant enabled.

[...]
>> @@ -247,10 +246,10 @@ static void fw_card_bm_work(struct work_
>>  	bool root_device_is_cmc;
>>  	bool irm_is_1394_1995_only;
>>  
>> -	spin_lock_irqsave(&card->lock, flags);
>> +	spin_lock_irq(&card->lock);

  - spin_lock + spin_unlock don't influence whether IRQs on the current
    CPU are on or off.

  - spin_lock_irq + spin_unlock_irq always switch IRQs on the current
    CPU off and back on.  This is necessary if the lock could also be
    taken by an IRQ handler.  (Well, card->lock is actually only taken
    by process contexts and by tasklets.  Seems we could switch to
    spin_lock_bh + spin_unlock_bh for card->lock everywhere in the
    firewire stack.)

  - spin_lock_irqsave + spin_unlock_irqrestore switch IRQs on the
    current CPU off and back on only if used while IRQs are enabled;
    if used while local IRQs are already disabled they leave them
    disabled.

http://lwn.net/images/pdf/LDD3/ch05.pdf#page=14

Therefore some people prefer to use the safer spin_lock_irqsave()/
spin_unlock_irqrestore() everywhere.  However, their downsides are the
need to track IRQ state flags, and --- subjectively --- that their
appearance in the code could create an impression to a casual reader
that this code was meant to be able to run in IRQs-on context as well as
in IRQs-off context.  fw_card_bm_work() however definitely requires to
be called with IRQs on, notably to be able to wait for IEEE 1394
transactions to complete.
-- 
Stefan Richter
-=====-==-=- -==- =-==-
http://arcgraph.de/sr/
