Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818Ab1CCUqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:46:37 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:45353 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758758Ab1CCUqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:46:34 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] st_nlink after rmdir() and rename()
References: <20110303032454.GI22723@ZenIV.linux.org.uk>
	<AANLkTin5GpLSvNnLb_=2wMS9w6RjHa=q8p0gOENtNjfq@mail.gmail.com>
	<20110303060352.GK22723@ZenIV.linux.org.uk>
	<AANLkTi=85DJo-Qy0bABKg1J_j0s=8HfTt1m+rq4E5GqS@mail.gmail.com>
Date: Fri, 04 Mar 2011 05:46:27 +0900
In-Reply-To: <AANLkTi=85DJo-Qy0bABKg1J_j0s=8HfTt1m+rq4E5GqS@mail.gmail.com>
	(Linus Torvalds's message of "Thu, 3 Mar 2011 12:05:43 -0800")
Message-ID: <87tyfk7x0c.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, Mar 2, 2011 at 10:03 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> IOW, it's a QoI question - sure, NFS is weird and you lose a lot of usual
>> warranties there when it comes to object removal.  But why get local
>> fs behaving strangely?  It's not like "decrement i_nlink from 2 to 1" was
>> cheaper than "assign 0 to i_nlink", after all.
>>
>> FWIW, a lot of local filesystems have no notion of links; they tend to
>> maintain zero/non-zero distinction just fine.  Including those that have
>> all directories with i_nlink == 1 for as long as directory lives.
>
> The thing is, I don't think it's a QoI question at all - since any
> user that _depends_ on this kind of behavior is simply broken. We
> aren't going to guarantee it, exactly because some filesystems simply
> will not ever guarantee it.
>
> Now, for FAT we do in fact try rather hard to fake the i_nlink count,
> but I'm not at all convinced that's a good idea. It makes reading
> directory inodes on FAT much more expensive (we have to basically do a
> readdir for each open). So I'd hate to make that whole "you need to
> emulate i_nlink even if you really don't care" be something that we
> actually end up thinking is a quality issue.

Yes. It's one of reason linux's FAT is slow for some operations (from
original designs).

> There are other filesystems where i_nlink can be even _less_
> meaningful, ie if the filesystem does any kind of fancy
> content-indexing thing or lazy COW (think "union filesystem within the
> filesystem") or whatever, I could easily see i_nlink not having any
> traditional unix filesystem semantics.

But, some commands see i_nlink (IIRC, it's checking i_nlink == 2, to
know empty dir or not). So we have to simulate some levels. I guess you
are not saying we don't need to care it at all though.

I think if it's _really easy_ to do, I think we should try.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
