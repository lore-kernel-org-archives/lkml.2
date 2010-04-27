Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab0D0Jlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:41:39 -0400
Received: from mx1.emlix.com ([193.175.82.87]:54911 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab0D0Jlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:41:37 -0400
Message-ID: <4BD6B13C.6020406@emlix.com>
Date: Tue, 27 Apr 2010 11:41:16 +0200
From: =?ISO-8859-1?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>
Organization: emlix GmbH
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] gpio: potential null dereference
References: <20100426192520.GU29093@bicker> <20100426230515.GA1388@emlix.com> <20100427090533.GZ29093@bicker>
In-Reply-To: <20100427090533.GZ29093@bicker>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2010 11:05 AM, Dan Carpenter wrote:
> On Tue, Apr 27, 2010 at 01:05:15AM +0200, Daniel Glöckner wrote:
>> On Mon, Apr 26, 2010 at 09:25:20PM +0200, Dan Carpenter wrote:
>>> Smatch found a potential null dereference in gpio_setup_irq().  The 
>>> "pdesc" variable is allocated with idr_find() that can return NULL.  If
>>> gpio_setup_irq() is called with 0 as gpio_flags and "pdesc" is null, it
>>> would OOPs here.
>> idr_find() doesn't allocate, idr_get_new_above() does.
>> Assuming idr_find() never fails for an id if idr_get_new_above()
>> successfully allocated that id, I don't think we can reach that
>> line with pdesc being NULL:
>>
>> - There are two gotos leading to free_sd
>> - #2 is after a block that allocates pdesc
>> - #1 is in an if (!gpio_flags) block
>> - We exit early if ((desc->flags & GPIO_TRIGGER_MASK) == gpio_flags)
>> - Therefore (desc->flags & GPIO_TRIGGER_MASK) must be != 0 to reach #1
>> - Trigger flags are added to desc->flags only after we have
>>   successfully allocated pdesc (i.e. right before return 0)
>> - We start off with no trigger flags set
>>
> 
> Are you sure?  If we know that the call to idr_find() returns a valid 
> pointer we could remove a lot of error handling code...

It returns a valid pointer iff (desc->flags & GPIO_TRIGGER_MASK).

When !(desc->flags & GPIO_TRIGGER_MASK) it returns NULL and everything
gets allocated (unless !gpio_flags as well). What you wanted to remove
is the allocation code, not error handling code. It is always run when
the trigger is set from "none" to something else.

  Daniel

-- 
Dipl.-Math. Daniel Glöckner, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax -11, Bahnhofsallee 1b, 37081 Göttingen, Germany
Sitz der Gesellschaft: Göttingen, Amtsgericht Göttingen HR B 3160
Geschäftsführer: Dr. Uwe Kracke, Ust-IdNr.: DE 205 198 055

emlix - your embedded linux partner
