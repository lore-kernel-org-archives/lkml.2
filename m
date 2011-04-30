Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab1D3DJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 23:09:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753339Ab1D3DJi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 23:09:38 -0400
MIME-Version: 1.0
In-Reply-To: <20110430030243.GJ9487@ZenIV.linux.org.uk>
References: <web-515866242@zbackend1.aha.ru> <BANLkTimfOCwZQP=Hv+NEhFcxMpC51-RhTw@mail.gmail.com>
 <BANLkTinv38NtVQHrayus6v89BocsK6+iQQ@mail.gmail.com> <20110430025545.GI9487@ZenIV.linux.org.uk>
 <20110430030243.GJ9487@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 29 Apr 2011 20:09:16 -0700
Message-ID: <BANLkTi=9Zq8AdGMyfwyp1nwyjD+PCGQydA@mail.gmail.com>
Subject: Re: 2.6.39-rc5-git2 boot crashs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Joern Engel <joern@logfs.org>, Dave Chinner <dchinner@redhat.com>,
        werner <w.landgraf@ru.ru>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 8:02 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Wait a bit; _can_ we get there with non-NULL ->s_master_inode et.al.?
> iput(NULL) is a noop...  I don't think so, since logfs_init_journal()
> is not called until after we initialize that list.
>
> Not that I'd object against taking that initialization earlier, of course,
> but there seems to be something else going on...  Which iput() it is?

Not something I can guess from the oops, sadly. Gcc has inlined
everything into logfs_mount, and the "0x44f/0x5cc" offset isn't very
helpful (with the same compiler version and config options it would be
possible to figure it out).

But looking at it, logfs_init_mapping() is currently called before
"s_freeing_list" is initialized, and it sets up at least
s_mapping_inode. So if anything fails between that point and the point
where we initialize s_freeing_list, I think we're toast.

I didn't check the other inodes, but at least that one does seem to be
potentially non-NULL. No?

                 Linus
