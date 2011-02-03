Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab1BCLN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 06:13:28 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53298 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200Ab1BCLN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 06:13:26 -0500
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org
In-reply-to: <20110203065541.GB5592@core.coreip.homeip.net> (message from
	Dmitry Torokhov on Wed, 2 Feb 2011 22:55:41 -0800)
Subject: Re: 2.6.38-rc3: FUSE (sshfs) hangs under load
References: <20110201175452.GB518@core.coreip.homeip.net>
 <E1PkbGG-0005Rf-QL@pomaz-ex.szeredi.hu>
 <20110202165236.GA3178@core.coreip.homeip.net> <20110203065541.GB5592@core.coreip.homeip.net>
Message-Id: <E1Pkx7s-00073l-5B@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 03 Feb 2011 12:13:24 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Feb 2011, Dmitry Torokhov wrote:
> --/9DWx/yDrRhgMJTb
> Content-Type: text/plain; charset=us-ascii
> Content-Disposition: inline
> 
> On Wed, Feb 02, 2011 at 08:52:36AM -0800, Dmitry Torokhov wrote:
> > On Wed, Feb 02, 2011 at 12:52:36PM +0100, Miklos Szeredi wrote:
> > > On Tue, 1 Feb 2011, Dmitry Torokhov wrote:
> > > > Hi,
> > > > 
> > > > After installing 2.6.38-rc3 (plus a few input patches) sshfs started to
> > > > misbehave on me under load. It starts off fine but when I try to compile
> > > > a few modules against kernel sources residing on the other box the
> > > > processes go into 'D' state and just sit there doing nothing.
> > > 
> > > Can you please post a stack trace from SysRq-T?
> > > 
> > 
> > Will do tonight. In the meantime I tried bisecting, but failure is not
> > always triggered on the first attempt so results are iffy. The log so
> > far:
> > 
> > # bad: [7d44b0440147d83a65270205b22e7d365de28948] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse
> > # good: [3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5] Linux 2.6.37
> > git bisect start '7d44b0440147d83a65270205b22e7d365de28948' 'v2.6.37'
> > # bad: [84b7290cca16c61a167c7e1912cd84a479852165] Merge git://git.kernel.org/pub/scm/linux/kernel/git/lethal/fbdev-2.6
> > git bisect bad 84b7290cca16c61a167c7e1912cd84a479852165
> > # good: [fea9294c5f2902c45613681ad995ca27899d2016] pch_can: Optimize "if" condition in rx/tx processing
> > git bisect good fea9294c5f2902c45613681ad995ca27899d2016
> > # bad: [c96e96354a6c9456cdf1f150eca504e2ea35301e] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6 into for-davem
> > git bisect bad c96e96354a6c9456cdf1f150eca504e2ea35301e
> > # good: [003ea98195eebdfcf476317b517e8c29a25b9d10] iwlwifi: remove reference to Gen2
> > git bisect good 003ea98195eebdfcf476317b517e8c29a25b9d10
> > 
> > The last good must have been also bad as sshfs got stuck while I was
> > installing next bisect step over it.
> > 
> 
> OK, so here are the stack traces you requested. First one is snapshot of
> when compile got stuck, the 2nd one is when I interrupted make which
> caused gcc to go to 'D' state.

There doesn't appear anything abnormal there.

It's going into D state after it has received an interrupt and sent it
along to the userspace filesystem.  Then it will go into
uninterruptible sleep until the answer is received.

So the hang is because the answer to an open request is not being
received.  I can't tell where it got stuck, apparently not anywhere on
the local machine.

Can you please get a log from sshfs with "-odebug,sshfs_debug" and
redirect stderr to a file?  That might tell a bit more about the
situation.  Or it might not...

Thanks,
Miklos
