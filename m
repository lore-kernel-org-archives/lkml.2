Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab1CCUGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:06:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932320Ab1CCUGg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:06:36 -0500
MIME-Version: 1.0
In-Reply-To: <20110303060352.GK22723@ZenIV.linux.org.uk>
References: <20110303032454.GI22723@ZenIV.linux.org.uk> <AANLkTin5GpLSvNnLb_=2wMS9w6RjHa=q8p0gOENtNjfq@mail.gmail.com>
 <20110303060352.GK22723@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 Mar 2011 12:05:43 -0800
Message-ID: <AANLkTi=85DJo-Qy0bABKg1J_j0s=8HfTt1m+rq4E5GqS@mail.gmail.com>
Subject: Re: [RFC] st_nlink after rmdir() and rename()
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 2, 2011 at 10:03 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> IOW, it's a QoI question - sure, NFS is weird and you lose a lot of usual
> warranties there when it comes to object removal.  But why get local
> fs behaving strangely?  It's not like "decrement i_nlink from 2 to 1" was
> cheaper than "assign 0 to i_nlink", after all.
>
> FWIW, a lot of local filesystems have no notion of links; they tend to
> maintain zero/non-zero distinction just fine.  Including those that have
> all directories with i_nlink == 1 for as long as directory lives.

The thing is, I don't think it's a QoI question at all - since any
user that _depends_ on this kind of behavior is simply broken. We
aren't going to guarantee it, exactly because some filesystems simply
will not ever guarantee it.

Now, for FAT we do in fact try rather hard to fake the i_nlink count,
but I'm not at all convinced that's a good idea. It makes reading
directory inodes on FAT much more expensive (we have to basically do a
readdir for each open). So I'd hate to make that whole "you need to
emulate i_nlink even if you really don't care" be something that we
actually end up thinking is a quality issue.

There are other filesystems where i_nlink can be even _less_
meaningful, ie if the filesystem does any kind of fancy
content-indexing thing or lazy COW (think "union filesystem within the
filesystem") or whatever, I could easily see i_nlink not having any
traditional unix filesystem semantics.

Seriously - how did you even notice this?

I'm not opposed to fix actual bugs, but I _do_ think it is
questionable to make this kind of nonsense semantic issue be an issue.

                     Linus
