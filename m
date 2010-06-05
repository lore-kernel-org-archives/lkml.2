Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab0FEDRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 23:17:49 -0400
Received: from crca.org.au ([74.207.252.120]:36657 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab0FEDRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 23:17:48 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C09C1D5.2030603@crca.org.au>
Date: Sat, 05 Jun 2010 13:17:41 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Pavel Machek <pavel@ucw.cz>, pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [SUSPECTED SPAM] Re: [linux-pm] Proposal for a new algorithm
 for reading & writing a hibernation image.
References: <9rpccea67yy402c975fqru8r.1275576653521@email.android.com>	 <1275694775.3853.29.camel@maxim-laptop>  <4C09930E.20306@crca.org.au>	 <1275698169.10045.8.camel@maxim-laptop>  <4C099E8C.7070302@crca.org.au> <1275700569.18384.12.camel@maxim-laptop>
In-Reply-To: <1275700569.18384.12.camel@maxim-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 05/06/10 11:16, Maxim Levitsky wrote:
>
>> If the memory it writes to isn't protected, there'll be no recursive
>> page fault and no problem, right? I'm imagining this page fault handler
>> will only set a flag to record that the page needs to be atomically
>> copied, copy the original contents to a page previously prepared for the
>> purpose, remove the write protection for the page and allow the write to
>> continue. That should be okay, right?
> I think so, although I have no experience yet to comment on such things.
> Despite that I think you might run out of 'page previously prepared for
> the purpose'
> However you can adopt a retrial process, like you do today in tuxonce.
> Just abort suspend, and do it again.

Yeah. I'm expecting that it will be reasonably predictable - at least 
ballpark. I guess there's only one way to find out...

>>> Of course the sucky part will be how to edit the page tables.
>>> You might need to write your own code to do so to be sure.
>>> And this has to be arch specific.
>>
>> Yeah. I wondered whether the code that's already used for creating page
>> tables for the atomic restore could be reused, at least in part.
> This is very dangerous.
> The code might work now, and tomorrow somebody will add a code that does
> memory writes.
> The point is that you must be sure that there are no recursive faults,
> or somehow deal with them (this is probably too dangerous to even think
> of)

That shouldn't be too hard - after all, we're going to know what memory 
we're using to record the info. As long as we don't do anything silly 
like protecting our own data, we should be right.

>>> Since userspace is frozen, you can be sure that faults can only be
>>> caused by access to WO memory or kernel bugs.
>>
>> Userspace helpers or uswsusp shouldn't be forgotten.
> This is especially bad. because a fault in userspace will mean swapping.
> You won't get away with custom page fault for this.
> You could assure before suspend that all relevant userspace is not
> swapped, or forget about userspace, because its minor thing compared to
> speed increases of full memory write.

Mmm, but existing userspace helpers for TuxOnIce are carefully designed 
so everything is in memory before we start work, and so that nothing is 
done which will compromise the integrity of the image. I assume the same 
applies to uswsusp. I'm more concerned just to make sure that we don't 
forget to modify the page tables for these userspace processes (at least 
the TuxOnIce ones) so that any modifications to kernel memory made while 
in their process context are also caught.

Regards,

Nigel
