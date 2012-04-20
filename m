Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab2DTTh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 15:37:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46802 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2DTTh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 15:37:27 -0400
Date: Fri, 20 Apr 2012 20:37:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hugh Dickins <hughd@google.com>
Cc: linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] situation with fput() locking (was Re: [PULL REQUEST] :
 ima-appraisal patches)
Message-ID: <20120420193719.GL6871@ZenIV.linux.org.uk>
References: <1334754302.2137.8.camel@falcor>
 <alpine.LRH.2.02.1204190101380.30151@tundra.namei.org>
 <1334772473.2137.22.camel@falcor>
 <20120418183938.GH6589@ZenIV.linux.org.uk>
 <1334865448.2429.35.camel@falcor>
 <20120420004303.GB6871@ZenIV.linux.org.uk>
 <alpine.LSU.2.00.1204201133340.1450@eggly.anvils>
 <20120420190418.GK6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120420190418.GK6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 08:04:18PM +0100, Al Viro wrote:

> Deferring the final pass after dropping ->mmap_sem is going to be
> interesting; what would protect ->vm_next on those suckers?  Locking
> rules are already bloody complicated in mm/*; this will only add more
> subtle fun.  Note that right now both the dissolution of ->vm_next
> list and freeing of VMAs happen under ->mmap_sem; changing that might
> cost us a lot of headache...

BTW, even leaving that aside, we have at least one definite deadlock
(mainline, not on ->mmap_sem - see the mess in drivers/video/msm/mdp.c)
and a possibility of other fun (e.g. any network filesystem that
ends up triggering rtnl_lock() during umount is going to deadlock if
you combine it with sch_atm.c mess where we do fget()/check/fput()
in netlink message handling, close() from another thread racing with
it and descriptor being the only thing that keeps that network fs
alive past lazy umount or namespace dissolution).  And then there's
SCM_RIGHTS vs. drivers/vhost/net.c, which might or might not be
deadlockable - I'm not familiar enough with that driver to tell
right now.

_If_ it had been ->mmap_sem alone, the things would be much simpler.
There wouldn't be a problem, to start with - IMA stuff is not in the
mainline and that's the only thing that really wants ->i_mutex in
fput(); the few existing places that grab it in ->release() are racy
anyway and need to be fixed with proper locking.
