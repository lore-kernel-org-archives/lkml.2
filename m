Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab2LRCnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 21:43:07 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:38217 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab2LRCnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 21:43:06 -0500
X-Greylist: delayed 5543 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2012 21:43:06 EST
MIME-Version: 1.0
In-Reply-To: <20121218015705.GH4939@ZenIV.linux.org.uk>
References: <CALCETrXs15M-cJRGD_R7fXBxOXR=Pyqsh2dVC78DgShxwn60nA@mail.gmail.com>
 <20121218015705.GH4939@ZenIV.linux.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 17 Dec 2012 18:42:44 -0800
Message-ID: <CALCETrUHF40CJYi1=aWpqhW9qkxUDQNt9LAAGoWA57YXowdr_w@mail.gmail.com>
Subject: Re: Are there u32 atomic bitops? (or dealing w/ i_flags)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 5:57 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Dec 17, 2012 at 05:10:21PM -0800, Andy Lutomirski wrote:
>> I want to change inode->i_flags access to be atomic -- there are some
>> locking oddities right now, I think, and I want to use a new inode
>> flag to signal mtime updates from page_mkwrite.  The problem is that
>> i_flags is an unsigned int, and making it an unsigned long seems like
>> a waste, but there aren't any u32 atomic bitops.
>
> ... and atomic accesses cost more.  A lot more on some architectures.
> FWIW, atomic_t *is* 32bit on 32bit architectures, which still doesn't
> make it a good idea.

Are atomic_set_mask and atomic_clear_mask as fast as set_bit and
friends on all archs?

In any case, i_flags looks like it's rarely written, so I find it a
bit hard to believe that making it atomic would hurt.  Isn't
atomic_read equivalent to non-atomic reads everywhere?

I want page_mkwrite to set a flag (without taking i_mutex) but *not*
call file_update_time and then to have the writeback paths update the
inode time.  (This, along with stable pages, is the major cause of
long sleeps in my application.)  OTOH, maybe I should just use i_state
and i_lock for this.


--Andy
