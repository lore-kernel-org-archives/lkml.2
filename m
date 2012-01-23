Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab2AWVpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:45:41 -0500
Received: from queue02.mail.zen.net.uk ([212.23.3.27]:39196 "EHLO
	queue02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab2AWVpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:45:40 -0500
Message-ID: <4F1DD4C1.2070704@cantab.net>
Date: Mon, 23 Jan 2012 21:44:33 +0000
From: David Vrabel <dvrabel@cantab.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
References: <1327347145-16439-1-git-send-email-david.vrabel@citrix.com> <20120123195047.GA11002@phenom.dumpdata.com>
In-Reply-To: <20120123195047.GA11002@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.70.146.43
X-SA-Exim-Mail-From: dvrabel@cantab.net
Subject: Re: [Xen-devel] [PATCH] x86: xen: size struct xen_spinlock to always
 fit in arch_spinlock_t
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:26:47 +0000)
X-SA-Exim-Scanned: Yes (on pear)
X-Originating-Smarthost02-IP: [82.70.146.41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/2012 19:50, Konrad Rzeszutek Wilk wrote:
> On Mon, Jan 23, 2012 at 07:32:25PM +0000, David Vrabel wrote:
>> From: David Vrabel<david.vrabel@citrix.com>
>>
>> If NR_CPUS<  256 then arch_spinlock_t is only 16 bits wide but struct
>> xen_spinlock is 32 bits.  When a spin lock is contended and
>> xl->spinners is modified the two bytes immediately after the spin lock
>> would be corrupted.
>>
>> This is a regression caused by 84eb950db13ca40a0572ce9957e14723500943d6
>> (x86, ticketlock: Clean up types and accessors) which reduced the size
>> of arch_spinlock_t.
>>
>> Fix this by making xl->spinners a u8 if NR_CPUS<  256.  A
>> BUILD_BUG_ON() is also added to check the sizes of the two structures
>> are compatible.
>>
>> In many cases this was not noticable as there would often be padding
>> bytes after the lock (e.g., if any of CONFIG_GENERIC_LOCKBREAK,
>> CONFIG_DEBUG_SPINLOCK, or CONFIG_DEBUG_LOCK_ALLOC were enabled).
>>
>> The bnx2 driver is affected. In struct bnx2, phy_lock and
>> indirect_lock may have no padding after them.  Contention on phy_lock
>> would corrupt indirect_lock making it appear locked and the driver
>> would deadlock.
>
> Nice find. I think it also affected the ahci driver, and some of the USB
> ones - at least those I saw starting to hang with:

It's possible but keep in mind that this isn't a recent regression.  I 
think it's been around since 3.0 and maybe even earlier.

David
