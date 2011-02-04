Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab1BDGuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 01:50:00 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48627 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab1BDGt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 01:49:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fbuPVIvUouF7IfRmmBmyb7Dh2lRbkKlkJBQHixGYeawx2wXovkAqYkBWZYFEWfoKoL
         cTk9TphGwdTqegh70gDzUl3mYt6mZwwXbnW7/PNk/EM7dWo0xsCcgvfQZnQ014oRd91Q
         6YQViXNlbFrjeeinbiyPzf4hfg1QEy9vSwTCA=
Date: Thu, 3 Feb 2011 22:49:52 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Felix Fietkau <nbd@openwrt.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Wireless regression (was 2.6.38-rc3: FUSE (sshfs) hangs under load)
Message-ID: <20110204064952.GA12914@core.coreip.homeip.net>
References: <20110201175452.GB518@core.coreip.homeip.net>
 <E1PkbGG-0005Rf-QL@pomaz-ex.szeredi.hu>
 <20110202165236.GA3178@core.coreip.homeip.net>
 <20110203065541.GB5592@core.coreip.homeip.net>
 <E1Pkx7s-00073l-5B@pomaz-ex.szeredi.hu>
 <20110203194115.GA14159@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203194115.GA14159@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 11:41:15AM -0800, Dmitry Torokhov wrote:
> On Thu, Feb 03, 2011 at 12:13:24PM +0100, Miklos Szeredi wrote:
> > On Wed, 2 Feb 2011, Dmitry Torokhov wrote:
> > > On Wed, Feb 02, 2011 at 08:52:36AM -0800, Dmitry Torokhov wrote:
> > > > On Wed, Feb 02, 2011 at 12:52:36PM +0100, Miklos Szeredi wrote:
> > > > > On Tue, 1 Feb 2011, Dmitry Torokhov wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > After installing 2.6.38-rc3 (plus a few input patches) sshfs started to
> > > > > > misbehave on me under load. It starts off fine but when I try to compile
> > > > > > a few modules against kernel sources residing on the other box the
> > > > > > processes go into 'D' state and just sit there doing nothing.
> > > > > 
> > > > > Can you please post a stack trace from SysRq-T?
> > > > > 
> > > > 
...
> > > 
> > > OK, so here are the stack traces you requested. First one is snapshot of
> > > when compile got stuck, the 2nd one is when I interrupted make which
> > > caused gcc to go to 'D' state.
> > 
> > There doesn't appear anything abnormal there.
> > 
> > It's going into D state after it has received an interrupt and sent it
> > along to the userspace filesystem.  Then it will go into
> > uninterruptible sleep until the answer is received.
> > 
> > So the hang is because the answer to an open request is not being
> > received.  I can't tell where it got stuck, apparently not anywhere on
> > the local machine.
> > 
> > Can you please get a log from sshfs with "-odebug,sshfs_debug" and
> > redirect stderr to a file?  That might tell a bit more about the
> > situation.  Or it might not...
> 
> Hmm, it might be just the network itself, last night mutt in ssh session
> froze on me as well. I guess I'll just have to finish my bisect
> exercise.
> 

I finished bisecting and it turned out that the problematic commit
happened to be in wireless (I have iwl3945):

commit 4cd06a344db752f513437138953af191cbe9a691
Author: Felix Fietkau <nbd@openwrt.org>
Date:   Sat Dec 18 19:30:49 2010 +0100

    mac80211: skip unnecessary pskb_expand_head calls

    If the skb is not cloned and we don't need any extra headroom, there
    is no point in reallocating the skb head.

    Signed-off-by: Felix Fietkau <nbd@openwrt.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

With this commit reverted from 2.6.38-rc3 I can not reproduce sshfs
getting stuck here.

Thanks.

-- 
Dmitry
