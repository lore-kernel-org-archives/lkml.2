Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab1GRPwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 11:52:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43084 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab1GRPwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 11:52:01 -0400
Date: Mon, 18 Jul 2011 16:51:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Matthew Wilcox <matthew@wil.cx>, Anton Blanchard <anton@samba.org>,
        npiggin@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: vfsmount lock issues on very large ppc64 box
Message-ID: <20110718155141.GA11013@ZenIV.linux.org.uk>
References: <20110717105027.53cc3ca4@kryten>
 <20110717010427.GC5359@parisc-linux.org>
 <20110717084630.GC8006@one.firstfloor.org>
 <1310977028.5756.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20110718154008.GA29593@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110718154008.GA29593@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 11:40:08AM -0400, Christoph Hellwig wrote:
> On Mon, Jul 18, 2011 at 10:17:08AM +0200, Eric Dumazet wrote:
> > > Tim posted a patch, but it wasn't applied for unknown reasons.
> > > 
> > > https://lkml.org/lkml/2011/4/13/561
> > > 
> > 
> > Could Tim respin his patch then ?
> 
> Btw, it seems like most kern_mount users want this and he's still
> missing some like devtmpfs, sysfs or ipc.  What about splitting
> kern_mount into a variant that gets a long-term reference for these
> callers, and one that doesn't for afs/cifs/nfs automounts?

	Careful - we need to balance that on shutdown side with
mnt_make_shortterm() before the final mntput()...  Making it too
easy just on the kern_mount side will lead to easy-to-miss bugs.
For one thing, it's visible only on SMP boxen; for another there's
a lot of such internal vfsmounts (pipefs, sockets, etc.) that
are never shut down, so there'll be no easily copied examples of
what should not be forgotten on __exit side of things in obvious
places...

	FWIW, I had missed the original posting back in April - had been
without net.access then and it hadn't been resent when I came back, asked
people to resend the important ones and shitcanned the huge pile of pending
mail from the previous month...
