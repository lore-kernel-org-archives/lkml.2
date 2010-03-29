Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689Ab0C2Mae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 08:30:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35330 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab0C2Mad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 08:30:33 -0400
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jiri Kosina <jkosina@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, jblunck@suse.de,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       gregkh@suse.de
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock II
From: Andi Kleen <andi@firstfloor.org>
References: <201003242240.54907.arnd@arndb.de>
	<8739zk1529.fsf@basil.nowhere.org>
	<87tys0yly7.fsf_-_@basil.nowhere.org>
	<201003291348.37997.arnd@arndb.de>
Date: Mon, 29 Mar 2010 14:30:28 +0200
In-Reply-To: <201003291348.37997.arnd@arndb.de> (Arnd Bergmann's message of "Mon, 29 Mar 2010 12:48:37 +0100")
Message-ID: <87fx3jqpi3.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

>> - The seek function in uhci-debug.c probably is still racy.
>
> That function could be removed in favor of using generic_file_ioctl
> and setting i_size to up->size.

Does that lock against read in libfs? 

> Also, the race is only between concurrent calls of llseek on
> the same file descriptor, which is undefined anyway.
> The current code also doesn't protect you against partial updates
> of f_pos during ->read() on 32 bit systems (nothing ever does),

That is not what I meant.

> and it even fails to protect against the concurrent llseek race
> because the assignment is done outside of the f_pos update.

I wasn't sure it would protect against parallel reads.

Does it?

> The patch looks correct, but I probably wouldn't bother with the rename,
> and simply drop the BKL in the caller.

I think a rename is better, I take compile errors over subtle
breakage any day.

>>Author: Andi Kleen <ak@linux.intel.com>
>>Date:   Mon Mar 29 01:15:32 2010 +0200
>>
>>    USB-BKL: Remove BKL from usb serial drivers ioctl handlers
>>
>>    I audited all the low level serial ioctl handlers and none of them
>>    actually need the BKL.
>>
>>    To make sure all code is checked change the usb_serial_driver ->ioctl
>> field to ->unlocked_ioctl
>>
>>    Note this is still called for now with BKL held because tty drivers
>>    don't have a ->unlocked_ioctl from the tty layer in mainline.
>>    This could be trivially changed now though.
>>
>>    Signed-off-by: Andi Kleen <ak@linux.intel.com>
>
> The serial_ioctl function is already called without the BKL, depite the
> name. tty_operations->ioctl was converted a long time ago, so I guess this
> patch can be dropped from your series.

Ok.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
