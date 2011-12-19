Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab1LSQD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 11:03:27 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50651 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab1LSQDY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 11:03:24 -0500
MIME-Version: 1.0
X-Originating-IP: [94.21.194.149]
In-Reply-To: <1324305522.2723.51.camel@menhir>
References: <1321873893-4544-1-git-send-email-miklos@szeredi.hu>
	<1321873893-4544-4-git-send-email-miklos@szeredi.hu>
	<20111217073604.GA31872@ZenIV.linux.org.uk>
	<1324305522.2723.51.camel@menhir>
Date: Mon, 19 Dec 2011 17:03:23 +0100
Message-ID: <CAJfpegsukLF=cgdZcB0+9F6Asrt1S0pQeziGu6Z_ROkQEKr38g@mail.gmail.com>
Subject: Re: [PATCH 3/4] vfs: count unlinked inodes
From: Miklos Szeredi <miklos@szeredi.hu>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        jack@suse.cz, akpm@linux-foundation.org, toshi.okajima@jp.fujitsu.com,
        mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 3:38 PM, Steven Whitehouse <swhiteho@redhat.com> wrote:
> Hi,
>
> On Sat, 2011-12-17 at 07:36 +0000, Al Viro wrote:
>> On Mon, Nov 21, 2011 at 12:11:32PM +0100, Miklos Szeredi wrote:
>> > @@ -241,6 +242,11 @@ void __destroy_inode(struct inode *inode)
>> >     BUG_ON(inode_has_buffers(inode));
>> >     security_inode_free(inode);
>> >     fsnotify_inode_delete(inode);
>> > +   if (!inode->i_nlink) {
>> > +           WARN_ON(atomic_long_read(&inode->i_sb->s_remove_count) == 0);
>> > +           atomic_long_dec(&inode->i_sb->s_remove_count);
>> > +   }
>>
>> Umm...  That relies on ->destroy_inode() doing nothing stupid; granted,
>> all work on actual file removal should've been done in ->evice_inode()
>> leaving only (RCU'd) freeing of in-core, but there are odd ones that
>> do strange things in ->destroy_inode() and I'm not sure that it's not
>> a Yet Another Remount Race(tm).  OTOH, it's clearly not worse than what
>> we used to have; just something to keep in mind for future work.
>>
> GFS2 is one of those cases. The issue is that when we enter
> ->evict_inode() with i_nlink 0, we do not know whether any other node
> still has the inode open. If it does, then we do not deallocate it in
> ->evict_inode() but instead just forget about it, just as if i_nlink was
>> 0 leaving the remaining opener(s) to do the deallocation later,

And does GFS2 care about read-only remount races because of that?
I.e. if an unlinked file is still open on another node, should we
prevent remounting read-only until it the file is released and
actually gone?

If that's not a requirement (and I don't see why it should be) then all is fine.

Thanks,
Miklos
