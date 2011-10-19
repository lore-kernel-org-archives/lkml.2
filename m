Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab1JSEyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 00:54:39 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:4714 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710Ab1JSEyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 00:54:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAPZVnk55LI88/2dsb2JhbABEqHCBBoFuAQEEATocIwULCAMYLhQlAyETiAC1OhKHKGEEpWk
Date: Wed, 19 Oct 2011 15:54:18 +1100
From: Dave Chinner <david@fromorbit.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Joe Perches <joe@perches.com>, Russell King <rmk@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ARM 4Kstacks: introduction
Message-ID: <20111019045418.GF21338@dastard>
References: <4E9E0B71.9020708@am.sony.com>
 <1318983248.7569.5.camel@Joe-Laptop>
 <4E9E1944.80601@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9E1944.80601@am.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 05:26:44PM -0700, Tim Bird wrote:
> On 10/18/2011 05:14 PM, Joe Perches wrote:
> > On Tue, 2011-10-18 at 16:27 -0700, Tim Bird wrote:
> >> I'm about to submit a set of patches (really pretty small)
> >> to add 4K stack support to ARM (defaulted to 'N').
> > 
> > When 4k stacks went away, I thought it safe enough
> > to submit vsnprintf recursion using %pV.
> > 
> > I believe the current vsnprintf max recursion is 3.
> > Each recursion uses at least 300 bytes of stack.
> > 
> > That might be some additional issue for 4k stacks.
> 
> Interesting.  Thanks very much for the heads up.
> I don't know how prevalent %pV is, but I'll take a
> look tomorrow and see if I think this would be an
> issue.  One option would be to turn off recursion
> in the 4K stacks case (but I don't know how badly
> this would mangle the code).

Badly.

For example, every single message emitted by XFS uses %pV to add
consistent message prefixes to the messages. See __xfs_printk().

And a quick grep shows this same technique is used in ext3, ext4,
NILFS, FAT and other filesystems, as well as netdev_printk,
dev_printk, the libata code and more. IOWs, you'd basically break
messages from most subsystems and drivers in the kernel...

> I'm not sure I'm willing to advocate eliminating
> all occurrences of high stack usage in the kernel.
> It seems like this would generate a lot of friction
> for getting this mainlined.  As long as I can document
> the trouble that people might get in when they
> turn this on, I think that would be very good.

"You can't use block based storage because the storage stack doesn't
fit in 4k."

> Even inside Sony, usage of 4K stacks is limited
> to some very special cases, where memory is exceedingly
> tight (we have one system with 4M of RAM).  And we
> don't mind lopping off features or coding around
> problem areas to support our special case.

Sounds to me like it's less overhead simply to maintain the patches
for the systems that need it than it is to put it in mainline,
document all the stuff that doesn't work and then, of course, have
to triage all the problems people report because they haven't read
the documentation.... :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
