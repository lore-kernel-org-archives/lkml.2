Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab1GZQKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 12:10:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753520Ab1GZQKZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 12:10:25 -0400
MIME-Version: 1.0
In-Reply-To: <20110726155930.GB1629@x4.trippels.de>
References: <20110725185649.GA22133@ZenIV.linux.org.uk> <20110726033535.GA11939@x4.trippels.de>
 <CA+55aFzaKHpVdLKac6rFN+YsAugz1aR3fv-reThJiD4HWDND8w@mail.gmail.com>
 <20110726082146.GB11939@x4.trippels.de> <CADxeRwnYxgxZPT3DN=SraZOvL_juWzV+MoY9+0vqZr29y6U6cA@mail.gmail.com>
 <20110726085804.GA1639@x4.trippels.de> <CA+55aFz0S3mO9ETFZpsEcbotWV+NMzaFhpZcN09LNAdk+eavjg@mail.gmail.com>
 <20110726155930.GB1629@x4.trippels.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 26 Jul 2011 09:10:02 -0700
Message-ID: <CA+55aFzxmLvLcEagYqE5iOTRv724ecW3va+Pv_RPsPLKeYHTCA@mail.gmail.com>
Subject: Re: [git pull] vfs pile 1.5
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Steven Liu <lingjiujianke@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 8:59 AM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
>
> Yes, that was my first idea, too. But unfortunately it doesn't work:
>
>  CC      fs/xfs/linux-2.6/xfs_iops.o
> fs/xfs/linux-2.6/xfs_iops.c: In function ‘xfs_vn_mknod’:
> fs/xfs/linux-2.6/xfs_iops.c:184:28: error: called object ‘0u’ is not a function
> make[2]: *** [fs/xfs/linux-2.6/xfs_iops.o] Error 1

Ahh, we use that elsewhere too.

However, if we *do* have POSIX ACL's enabled, but we just have the XFS
ACL's disabled, then just returning NULL from xfs_get_acl() is
actually a horrible idea, because then the VFS code will always call
that function and it never gets cached as "I have no ACL's". Which is
why I didn't like the inline function approach. Well, at least not the
one that only returns NULL - we also want to fill in the cache.

I'm actually getting more and more convinced that we should just do
that "set_acl_cache()" in generic code for the "get_acl()" case. Even
without any locking it's no worse than all the current filesystems,
since they *also* do it with no locking. And then this kind of issue
wouldn't come up.

Christoph, Al, comments?

                           Linus
