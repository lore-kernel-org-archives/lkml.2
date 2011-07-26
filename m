Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab1GZQSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 12:18:43 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44325
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753367Ab1GZQSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 12:18:37 -0400
Date: Tue, 26 Jul 2011 12:18:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Steven Liu <lingjiujianke@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [git pull] vfs pile 1.5
Message-ID: <20110726161831.GA6704@infradead.org>
References: <20110725185649.GA22133@ZenIV.linux.org.uk>
 <20110726033535.GA11939@x4.trippels.de>
 <CA+55aFzaKHpVdLKac6rFN+YsAugz1aR3fv-reThJiD4HWDND8w@mail.gmail.com>
 <20110726082146.GB11939@x4.trippels.de>
 <CADxeRwnYxgxZPT3DN=SraZOvL_juWzV+MoY9+0vqZr29y6U6cA@mail.gmail.com>
 <20110726085804.GA1639@x4.trippels.de>
 <CA+55aFz0S3mO9ETFZpsEcbotWV+NMzaFhpZcN09LNAdk+eavjg@mail.gmail.com>
 <20110726155930.GB1629@x4.trippels.de>
 <CA+55aFzxmLvLcEagYqE5iOTRv724ecW3va+Pv_RPsPLKeYHTCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzxmLvLcEagYqE5iOTRv724ecW3va+Pv_RPsPLKeYHTCA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 09:10:02AM -0700, Linus Torvalds wrote:
> However, if we *do* have POSIX ACL's enabled, but we just have the XFS
> ACL's disabled, then just returning NULL from xfs_get_acl() is
> actually a horrible idea, because then the VFS code will always call
> that function and it never gets cached as "I have no ACL's". Which is
> why I didn't like the inline function approach. Well, at least not the
> one that only returns NULL - we also want to fill in the cache.

Even getting to check_acl() requires MS_POSIXACL to be set on the
superblock, which it won't be if CONFIG_XFS_ACL isn't set.

These days we can probably kill CONFIG_FOOFS_ACL given that everyone
now uses the generic code, and due to the deeper VFS interaction is
more or less forced to anyway.  Historically that wasn't the case.

> I'm actually getting more and more convinced that we should just do
> that "set_acl_cache()" in generic code for the "get_acl()" case. Even
> without any locking it's no worse than all the current filesystems,
> since they *also* do it with no locking. And then this kind of issue
> wouldn't come up.

While I agree with you that we should life it into the common code,
the common caching is not related at all to this particular issue.

The code that fails to compile is where XFS implements the default ACL
inheritance when creating new inodes.  Move filesystems do this a bit
simpler and dumber and do the ACL-induced i_mode modifications after
creating the inode. XFS tries to create the inode with the correct mode
from the first moment and thus has a slightly broader interface between
the "normal" inode ops and its ACL code.

Due to various interactions with the fs transaction code the inheritance
code is at the very end of my list of ACL pieces to move to common code.

