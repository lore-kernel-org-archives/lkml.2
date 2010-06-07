Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab0FGVdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 17:33:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57364 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab0FGVdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 17:33:15 -0400
Date: Mon, 7 Jun 2010 22:33:10 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Dave Airlie <airlied@linux.ie>,
       dri-devel@lists.freedesktop.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] drm fixes
Message-ID: <20100607213310.GO31073@ZenIV.linux.org.uk>
References: <alpine.DEB.2.00.1006070404510.29029@skynet.skynet.ie>
 <alpine.LFD.2.00.1006071057300.3515@i5.linux-foundation.org>
 <20100607182640.GL31073@ZenIV.linux.org.uk>
 <alpine.LFD.2.00.1006071146451.3515@i5.linux-foundation.org>
 <1275939165.17903.5100.camel@macbook.infradead.org>
 <alpine.LFD.2.00.1006071409320.4506@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006071409320.4506@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 02:17:23PM -0700, Linus Torvalds wrote:
> 	jffs2_clear_inode(inode);
> 
> into
> 
> 	make_bad_inode(inode);
> 	iput(inode);
> 
> and that changelog doesn't really explain it either ("fix leak"? Ok, I can 
> see the iput() fixing the leak - but you also did that jffs2_clear_inode() 
> change, and that has no explanation what-so-ever.

The final iput() calls ->clear_inode() (jffs2_clear_inode in case of jffs2)
and the inode has just been created, with no other in-core references
existing.  Basically, that call was the only part of (required) iput() that
_was_ done there ;-)

FWIW, what's happening around ->clear_inode()/->delete_inode()/->drop_inode()
is a mess.  This leak got found when I'd been looking through that crap;
results of sanitizing are in #evict_inode (vfs-2.6.git).  I'm going to shift
that into for-next tomorrow, assuming it survives local beating.  For now
I've just pulled jffs2-fixes in it...
