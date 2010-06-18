Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab0FRCyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 22:54:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:57028 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755517Ab0FRCye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 22:54:34 -0400
Date: Fri, 18 Jun 2010 12:54:20 +1000
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sage Weil <sage@newdream.net>, Alexey Dobriyan <adobriyan@gmail.com>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, hch@lst.de,
       bfields@citi.umich.edu
Subject: Re: weird umem vs nfsd regression
Message-ID: <20100618125420.46fda9d6@notabene.brown>
In-Reply-To: <20100617134706.6c5ad7f1.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.1006171305320.8387@cobra.newdream.net>
	<20100617134706.6c5ad7f1.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010 13:47:06 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 17 Jun 2010 13:21:36 -0700 (PDT)
> Sage Weil <sage@newdream.net> wrote:
> 
> > Hi,
> > 
> > I started seeing a hang during bootup of a machine with a umem 
> > (micromemory nvram) card.  I bisected it and narrowed it down to commit 
> > b95a5680 which merged a couple nfsd changes, although strangely reverting 
> > just b160fdab ('nfsd: nfsd_setattr needs to call commit_metadata') is 
> > sufficient to make the problem go away.

There are two possible explanations for this.
One is that the breakage is caused be an interaction between a commit in one
branch below the merge, and a commit in the other branch.
The other is that the bug has nothing to do with the code, it is randomly
caused by some hardware timing issue, and the "git bisect" process just lead
you on a random walk through git history.

It could be a combination of the two.  Some earlier commit makes the symptom
possible but not probably.  'git bisect' would then lead you to some random
commit after the causal commit.

Did you try each kernel multiple times?  Could you?

> > 
> > I'm not quite sure what to make of it.  I don't see how the nfsd change 
> > would affect the umem driver initialization.  The machine _is_ netbooting 
> > (kernel via PXE, nfs root), though.
> 
> gee, who maintains umem?  Neil wrote it eight years ago ;)

Well, wrote some of it and got it incorporated upstream.
I still vaguely remember how it works.

> 
> > When it hangs, I see
> > 
> > [    1.069553] v2.3 : Micro Memory(tm) PCI memory board block driver
> > [    1.075780] umem 0000:02:01.0: can't find IRQ for PCI INT C; probably buggy MP table
> > [    1.083633] umem 0000:02:01.0: Micro Memory(tm) controller found (PCI Mem Module (Battery Backup))
> > [    1.092762] umem 0000:02:01.0: CSR 0xfc9ffc00 -> 0xffffc90001466c00 (0x100)
> > [    1.099880] umem 0000:02:01.0: Size 1048576 KB, Battery 1 Disabled (FAILURE), Battery 2 Disabled (FAILURE)
> > [    1.109745] umem 0000:02:01.0: Window size 16777216 bytes, IRQ 9
> > [    1.115842] umem 0000:02:01.0: memory NOT initialized. Consider over-writing whole device.
> > [    1.125778]  umema:
> > [  240.886560] INFO: task swapper:1 blocked for more than 120 seconds.
> > [  240.893186] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  240.901115] swapper       D 0000000000000001     0     1      0 0x00000000
> > [  240.908231]  ffff8800f8da1b50 0000000000000046 ffff8800f8da1ac0 ffff8800f8da1fd8
> > [  240.916027]  ffff8800f8d80050 0000000000004000 0000000000004000 00000000001d2180
> > [  240.923819]  00000000001d2180 ffff8800f8da1fd8 ffff8800f8da1fd8 00000000001d2180
> > [  240.931611] Call Trace:
> > [  240.934133]  [<ffffffff8144f96d>] ? _raw_spin_unlock_irqrestore+0x4c/0x68
> > [  240.941011]  [<ffffffff812a99ab>] ? mm_unplug_device+0x47/0x50

It looks like umem is waiting for the DMA controller on the card to
acknowledge that the DMA is complete.
Maybe the interrupt is getting lost somehow?  Shared interrupt line?  I guess
we would see some sort of "nobody cared" messaged if it were something like
that.


> > and with the above commit reverted, I get a 'normal' umem driver init (the 
> > umem errors/warnings are normal.. the batteries aren't connected and the 
> > card isn't being used):

Is this really a reliable effect?  Boot several times without the commit and
it works.  Add the commit and boot several times and it always fails.   Then
remove the commit again and it reliably works?

I don't like to have to ask such basic questions, but it is a really weird
error so I need to be sure to eliminate any mismeasurement.



> There may also be bugs in the umem driver.  Even if the IO errors are
> bogus, the kernel shouldn't hang up waiting for IO completion as it's
> doing here.
> 

No?  Even if it is due to faulty hardware?
Do you think the driver should set a timer and disable the card if it hasn't
heard back for a while?
I guess that might be reasonable, though if it turns out to be faulty
hardware I wouldn't trust it on the buss at all...

NeilBrown
