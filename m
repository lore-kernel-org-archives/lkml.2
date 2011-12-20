Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab1LTXcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 18:32:03 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60455 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab1LTXcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 18:32:00 -0500
Date: Tue, 20 Dec 2011 23:31:39 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        mc@linux.vnet.ibm.com, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
Message-ID: <20111220233139.GG23916@ZenIV.linux.org.uk>
References: <1324373854.21588.16.camel@mengcong>
 <4EF0654B.4060904@linux.vnet.ibm.com>
 <4EF06C9B.4010703@linux.vnet.ibm.com>
 <4EF084A4.3000106@linux.vnet.ibm.com>
 <20111220140628.GD23916@ZenIV.linux.org.uk>
 <4EF09D34.1060607@linux.vnet.ibm.com>
 <20111220175919.GE23916@ZenIV.linux.org.uk>
 <4EF0DE04.6030604@linux.vnet.ibm.com>
 <20111220195806.GF23916@ZenIV.linux.org.uk>
 <20111220222734.GA23662@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220222734.GA23662@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 09:27:34AM +1100, Dave Chinner wrote:

> Only thing that concerns me about this patch is the bitmap changing
> between lock and unlock operations. i.e.
> 
> CPU 1: lock all cpus in mask
... after having taken the spinlock
> CPU 2: brings up new cpu, notifier adds CPU to bitmask
... which would also take the same spinlock
> CPU 1: unlock all cpus in mask
... which is where that spinlock would've been released

> And in this case the unlock tries to unlock a cpu that wasn't locked
> to start with. It really seems to me that while a global lock is in
> progress, the online bitmask cannot be allowed to change.

Well, yes.  See spin_lock() in br_write_lock() before the loop and
spin_unlock() in br_write_unlock() after the loop...

> Perhaps something can be passed between the lock and unlock
> operations to be able to detect a changed mask between lock/unlock
> operations (e.g. a generation number) and then handle that via a
> slow path that unlocks only locks that are active in the online
> bitmask?  i.e. all the notifier does is bump the generation count,
> and the slow path on the unlock handles everything else?

???
