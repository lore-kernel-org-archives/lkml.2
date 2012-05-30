Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab2E3CBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 22:01:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52094 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab2E3CBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 22:01:35 -0400
Date: Wed, 30 May 2012 03:01:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Luk?? Czerner <lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        mbroz@redhat.com
Subject: Re: [PATCH 1/2] vfs: Do not allow mnt_longterm to go negative
Message-ID: <20120530020134.GA20448@ZenIV.linux.org.uk>
References: <1337959776-16564-1-git-send-email-lczerner@redhat.com>
 <alpine.LFD.2.00.1205290807350.2144@dhcp-1-248.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1205290807350.2144@dhcp-1-248.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 12:56:44PM +0200, Luk?? Czerner wrote:
> 
> Anyone can take a look at this ? It's pretty pressing I would say
> since this bug will not only disallow to unattach the loop devices
> but also make it unable to actually unmount the file system!

I agree that it's a bug, but I don't believe that this is a proper
fix.  We can do it much simpler.  Look: making these guys longterm
happens exactly at the same points where we set their ->mnt_ns non-NULL.
Remember that "longterm" == "internal kernel mount, mount in some
namespace, someone's root or pwd".  So the problem is that umount_tree()
is that umount_tree() blindly assumes that it's killing a longterm
ref, even though it may be called when dissolving a tree that never
made it into anyone's namespace.  Fine, so let's just have that
sucker do
                if (p->mnt_ns)
                        __mnt_make_shortterm(p);
                p->mnt_ns = NULL;
instead and that's all it takes.  Alternatively, we can just turn the
code in mntput_no_expire() into
	if (likely(mnt->mnt_ns || atomic_read(...))
and get rid of longterm/shortterm logics around ->mnt_ns completely.
Short-term, pardon the bad pun, I'm going with the first variant; it's
less intrusive.  Longer term I think we want to get rid of playing with
mnt_longterm in there and just check ->mnt_ns as well when deciding to
go for the fast path in mntput_no_expire().

Fixed in my tree, will push in a couple of hours.  And that'll need to
go into -stable as well.  Thanks for catching that sucker...
