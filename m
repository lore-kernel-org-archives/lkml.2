Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab1GFNss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 09:48:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43883 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab1GFNsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 09:48:47 -0400
Date: Wed, 6 Jul 2011 14:48:06 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vitaly Kuzmichev <vkuzmichev@mvista.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>, Wim Van Sebroeck <wim@iguana.be>,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
        arm@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V2 3/6] mpcore_wdt: Fix WDIOC_SETOPTIONS handling
Message-ID: <20110706134806.GA8286@n2100.arm.linux.org.uk>
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com> <1309892440-3260-4-git-send-email-vkuzmichev@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309892440-3260-4-git-send-email-vkuzmichev@mvista.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 11:00:37PM +0400, Vitaly Kuzmichev wrote:
> According to the include/linux/watchdog.h WDIOC_SETOPTIONS is
> classified as 'read from device' ioctl call:
>   #define WDIOC_SETOPTIONS        _IOR(WATCHDOG_IOCTL_BASE, 4, int)
> 
> However, the driver 'mpcore_wdt' performs 'copy_from_user' only if
> _IOC_WRITE is set, thus the local variable 'uarg' which is used in
> WDIOC_SETOPTIONS handling remains uninitialized.
> 
> The proper way to fix this is to bind WDIOC_SETOPTIONS to _IOW,
> but this will break compatibility.
> So adding additional condition for performing 'copy_from_user'.

That looks like something which needs fixing in watchdog land.  And it's
not too difficult:

1. Change the existing WDIOC_SETOPTIONS to WDIOC_SETOPTIONS_OLD
2. Add a new, correctly defined WDIOC_SETOPTIONS.
3. Update all drivers to use WDIOC_SETOPTIONS.
4. Provide a helper which deals with WDIOC_SETOPTIONS_OLD and translates
   it to the proper WDIOC_SETOPTIONS call (this could be just:

	if (cmd == WDIOC_SETOPTIONS_OLD) {
		static int first = 1;
		if (first)
			pr_warn("%s:%d used old WDIOC_SETOPTIONS call.  Please rebuild\n",
				current->comm, current->pid);
		first = 0;
		cmd = WDIOC_SETOPTIONS;
	}

   before any argument copies.

This means you preserve existing compatibility with userspace, yet gain
a path to a non-broken ioctl interface.

As stuff gets rebuilt and replaced, you'll eventually be able to remove
the above.  That period used to be two years for such simple changes.
