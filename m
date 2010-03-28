Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab0C1V7A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 17:59:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34213 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab0C1V7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 17:59:00 -0400
To: Jiri Kosina <jkosina@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, jblunck@suse.de,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       gregkh@suse.de
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
From: Andi Kleen <andi@firstfloor.org>
References: <201003242240.54907.arnd@arndb.de>
	<alpine.LRH.2.00.1003251354200.16443@twin.jikos.cz>
Date: Sun, 28 Mar 2010 23:58:54 +0200
In-Reply-To: <alpine.LRH.2.00.1003251354200.16443@twin.jikos.cz> (Jiri Kosina's message of "Thu, 25 Mar 2010 13:55:17 +0100 (CET)")
Message-ID: <8739zk1529.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina <jkosina@suse.cz> writes:

> On Wed, 24 Mar 2010, Arnd Bergmann wrote:
>
>> I've spent some time continuing the work of the people on Cc and many others
>> to remove the big kernel lock from Linux and I now have bkl-removal branch
>> in my git tree at git://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git
>> that lets me run a kernel on my quad-core machine with the only users of the BKL
>> being mostly obscure device driver modules.
>
> 	config USB
> 	        tristate "Support for Host-side USB"
> 	        depends on USB_ARCH_HAS_HCD && BKL
>
> Well, that's very interesting definition of "obscure" :)

>From a quick grep at least EHCI doesn't seem to need it?

Except for those two guys in core/*.c:

                        /* keep API that guarantees BKL */
                        lock_kernel();
                        retval = driver->ioctl(intf, ctl->ioctl_code, buf);
                        unlock_kernel();
                        if (retval == -ENOIOCTLCMD)
                                retval = -ENOTTY;

I guess that could be just moved into the low level modules with unlocked_ioctl

And one use in the usbfs which seems quite bogus and can be probably removed.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
