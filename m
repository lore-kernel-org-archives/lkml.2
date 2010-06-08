Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab0FHAaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 20:30:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36409 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab0FHAaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 20:30:22 -0400
Date: Tue, 8 Jun 2010 01:30:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] drm fixes
Message-ID: <20100608003015.GP31073@ZenIV.linux.org.uk>
References: <alpine.DEB.2.00.1006070404510.29029@skynet.skynet.ie>
 <alpine.LFD.2.00.1006071057300.3515@i5.linux-foundation.org>
 <20100607182640.GL31073@ZenIV.linux.org.uk>
 <alpine.LFD.2.00.1006071146451.3515@i5.linux-foundation.org>
 <1275939165.17903.5100.camel@macbook.infradead.org>
 <alpine.LFD.2.00.1006071409320.4506@i5.linux-foundation.org>
 <1275946768.17903.5126.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275946768.17903.5126.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 10:39:28PM +0100, David Woodhouse wrote:
> On Mon, 2010-06-07 at 14:17 -0700, Linus Torvalds wrote:
> > and that changelog doesn't really explain it either ("fix leak"? Ok, I can 
> > see the iput() fixing the leak - but you also did that jffs2_clear_inode() 
> > change, and that has no explanation what-so-ever.
> 
> jffs2_clear_inode() is the file system's ->clear_inode method, so it
> gets called from the VFS when the inode is destroyed, after iput().
> 
> I suppose that ought to have been a clue, right from the very beginning,
> that we should never have been calling it directly on our error paths.

Yep.  The other place that directly called its ->clear_inode() also had
been bogus, BTW - logfs had been playing rather sick games with special
inodes and ended up open-coding just about everything on new_inode/iput
paths for those.  They needed that stuff evicted after all normal inodes,
but before the second call of invalidate_inodes() would scream about
surviving busy inodes.  I.e. that should've been happening in ->put_super();
no need to deal with handcrafted inodes that would sit outside of inode
list...
