Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab1BHMAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:00:46 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52461 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab1BHMAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:00:45 -0500
To: Gurudas Pai <gurudas.pai@oracle.com>
CC: Trond.Myklebust@netapp.com, miklos@szeredi.hu, hughd@google.com,
        hch@infradead.org, akpm@linux-foundation.org,
        lkml20101129@newton.leun.net, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
In-reply-to: <4D512E63.1040202@oracle.com> (message from Gurudas Pai on Tue,
	08 Feb 2011 17:22:03 +0530)
Subject: Re: [PATCH] mm: prevent concurrent unmap_mapping_range() on the same
 inode
References: <E1PftfG-0007w1-Ek@pomaz-ex.szeredi.hu>	<20110120124043.GA4347@infradead.org>	<E1PfvGx-00086O-IA@pomaz-ex.szeredi.hu>	<alpine.LSU.2.00.1101212014330.4301@sister.anvils>	<E1PhSO8-0005yN-Dp@pomaz-ex.szeredi.hu> <AANLkTimBR=CuMpWE2juJG2jsLsTqK=tc00sRrEjhkHg=@mail.gmail.com> <E1Pmkpt-0006Cd-Q6@pomaz-ex.szeredi.hu> <4D512E63.1040202@oracle.com>
Message-Id: <E1PmmEZ-0006JD-7v@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 08 Feb 2011 12:59:51 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Feb 2011, Gurudas Pai wrote:
> > On Wed, 26 Jan 2011, Hugh Dickins wrote:
> >> I had wanted to propose that for now you modify just fuse to use
> >> i_alloc_sem for serialization there, and I provide a patch to
> >> unmap_mapping_range() to give safety to whatever other cases there are
> >> (I'm now sure there are other cases, but also sure that I cannot
> >> safely identify them all and fix them correctly at source myself -
> >> even if I found time to do the patches, they'd need at least a release
> >> cycle to bed in with BUG_ONs).
> > 
> > Since fuse is the only one where the BUG has actually been triggered,
> > and since there are problems with all the proposed generic approaches,
> > I concur.  I didn't want to use i_alloc_sem here as it's more
> > confusing than a new mutex.
> > 
> > Gurudas, could you please give this patch a go in your testcase?
> I found this BUG with nfs, so trying with current patch may not help.
> https://lkml.org/lkml/2010/12/29/9
> 
> Let me know if I have to run this

Ahh, I was not aware of that.  No, in that case there's not much point
in trying this patch for you as it only fixes the issue in fuse. I
haven't looked at the NFS side of it yet.

Added Trond to the Cc.

Thanks,
Miklos


> > 
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > Subject: fuse: prevent concurrent unmap on the same inode
> > 
> > Running a fuse filesystem with multiple open()'s in parallel can
> > trigger a "kernel BUG at mm/truncate.c:475"
> > 
> > The reason is, unmap_mapping_range() is not prepared for more than
> > one concurrent invocation per inode.
> > 
> > Truncate and hole punching already serialize with i_mutex.  Other
> > callers of unmap_mapping_range() do not, and it's difficult to get
> > i_mutex protection for all callers.  In particular ->d_revalidate(),
> > which calls invalidate_inode_pages2_range() in fuse, may be called
> > with or without i_mutex.
> > 
> > This patch adds a new mutex to fuse_inode to prevent running multiple
> > concurrent unmap_mapping_range() on the same mapping.
> 
> Thanks,
> -Guru
> 
> 
> 
> 
