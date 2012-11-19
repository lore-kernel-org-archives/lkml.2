Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab2KSVxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 16:53:18 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:33329 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab2KSVxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 16:53:17 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: The bug of iput() removal from flusher thread?
References: <8762541uyx.fsf@devron.myhome.or.jp>
	<873906vumh.fsf@devron.myhome.or.jp>
	<20121119145140.GA20532@quack.suse.cz>
	<20121119194102.GB20532@quack.suse.cz>
	<87a9udtiyk.fsf@devron.myhome.or.jp>
	<20121119212448.GA29498@quack.suse.cz>
Date: Tue, 20 Nov 2012 06:53:12 +0900
In-Reply-To: <20121119212448.GA29498@quack.suse.cz> (Jan Kara's message of
	"Mon, 19 Nov 2012 22:24:48 +0100")
Message-ID: <876251tg3b.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>> >  static void inode_sync_complete(struct inode *inode)
>> >  {
>> > +	/* If inode is clean an unused, put it into LRU now.  */
>> > +	if (!(inode->i_state & I_DIRTY) && !atomic_read(&inode->i_count))
>> > +		inode_lru_list_add(inode);
>> 
>> IMHO, open coding this would be bad idea.
>   Do you mean creating a separate function for the above two lines?

Yes. And the intent is to consolidate "when adds inode to LRU" with
iput_final()'s one.

>> And another one is I_REFERENCED. We really want to remove I_REFERENCED?
>   We don't want I_REFERENCED set - noone used the inode. But looking into
> the code with fresh eyes, the fix isn't as simple as I thought. First I
> need to check MS_ACTIVE and second I need to check I_FREEING... So the
> condition will be complex enough to warrant a separate function.

I can't see the issue (sync_filesystem() will wait I_DIRTY before
MS_ACTIVE, and I_DIRTY prevents I_FREEING) though, it may be possible.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
