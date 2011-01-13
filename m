Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936Ab1AMLJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 06:09:15 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58280 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428Ab1AMLJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 06:09:12 -0500
To: Nick Piggin <npiggin@gmail.com>
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <AANLkTikEStNgB58Q-797rQST3QW=maz9LiGFSC=A8kkc@mail.gmail.com>
	(message from Nick Piggin on Thu, 13 Jan 2011 12:49:53 +1100)
Subject: Re: [PATCH] fuse: make fuse_permission() RCU aware
References: <E1Pcd7R-0007XC-VO@pomaz-ex.szeredi.hu>
	<AANLkTik-=LqSHQ=7zDznx9oCJFViPpp406Yz7J5Z-quj@mail.gmail.com>
	<E1Pd1eC-0001hR-LW@pomaz-ex.szeredi.hu> <AANLkTikEStNgB58Q-797rQST3QW=maz9LiGFSC=A8kkc@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1PdL3D-0003dx-EE@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 13 Jan 2011 12:09:07 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011, Nick Piggin wrote:
> >        inode = entry->d_inode;
> >        if (inode && is_bad_inode(inode))
> >                return 0;
> 
> Now it can be the case that entry->d_inode is not stable -- it can
> go away or even flip between inodes in the case of concurrent
> unlink/creat activity. And you may be using a different inode than
> the namei path walk is using!
> This isn't as scary as it sounds actually, because any such changes
> do get detected and the path walk restarted in that case.
> 
> You might be OK becuse you do test for NULL (although it really
> wants an ACCESS_ONCE() so it doesn't load a NULL or different
> inodes, but that's quite theoretical).
> 
> But this is a little unfriendly for filesystems, and I do want to impress
> the rule to not touch ->d_parent or ->d_inode in rcu walk mode
> (just to avoid any surprises).
> 
> So what I have done in such cases is to update the API to provide
> what the callers want. In this case, we could consider adding an
> inode parameter to .d_revalidate, which callers can be sure matches
> the inode used by vfs, and will not change.

Yes, I think supplying an inode to ->d_revalidate() would be the right
thing.

I see that there's nd->inode, and it's documented in vfs.txt, but IMO
we shouln'd be encouraging new uses of 'nd' inside filesystem
callbacks, rather the opposite.  A 'flags' parameter too might make
sense which, for the moment, would only have LOOKUP_RCU instead of all
the lookup flags.

Thanks,
Miklos
