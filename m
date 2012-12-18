Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab2LRWUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 17:20:32 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:36824 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab2LRWU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 17:20:27 -0500
MIME-Version: 1.0
In-Reply-To: <20121218213043.GF15182@dastard>
References: <CALCETrXs15M-cJRGD_R7fXBxOXR=Pyqsh2dVC78DgShxwn60nA@mail.gmail.com>
 <20121218015705.GH4939@ZenIV.linux.org.uk> <CALCETrUHF40CJYi1=aWpqhW9qkxUDQNt9LAAGoWA57YXowdr_w@mail.gmail.com>
 <20121218213043.GF15182@dastard>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 18 Dec 2012 14:20:06 -0800
Message-ID: <CALCETrV9fEfTVbiSzai2dvk6MWwDhsD_nAKs7Z1JP0ZkF-eruw@mail.gmail.com>
Subject: Re: Are there u32 atomic bitops? (or dealing w/ i_flags)
To: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 1:30 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Dec 17, 2012 at 06:42:44PM -0800, Andy Lutomirski wrote:
>> On Mon, Dec 17, 2012 at 5:57 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> > On Mon, Dec 17, 2012 at 05:10:21PM -0800, Andy Lutomirski wrote:
>> >> I want to change inode->i_flags access to be atomic -- there are some
>> >> locking oddities right now, I think, and I want to use a new inode
>> >> flag to signal mtime updates from page_mkwrite.  The problem is that
>> >> i_flags is an unsigned int, and making it an unsigned long seems like
>> >> a waste, but there aren't any u32 atomic bitops.
>> >
>> > ... and atomic accesses cost more.  A lot more on some architectures.
>> > FWIW, atomic_t *is* 32bit on 32bit architectures, which still doesn't
>> > make it a good idea.
>>
>> Are atomic_set_mask and atomic_clear_mask as fast as set_bit and
>> friends on all archs?
>>
>> In any case, i_flags looks like it's rarely written, so I find it a
>> bit hard to believe that making it atomic would hurt.  Isn't
>> atomic_read equivalent to non-atomic reads everywhere?
>>
>> I want page_mkwrite to set a flag (without taking i_mutex) but *not*
>> call file_update_time and then to have the writeback paths update the
>> inode time.
>
> Deadlocks ahoy!
>
> We don't currently take the i_mutex anywhere in the writeback path
> as the writeback path is nested inside the i_mutex. Hence this seems
> like an extremely dangerous thing to do...

Hmm.

This can all be made fs-specific: page_mkclean_file sets a bit in the
inode flags or inode state or address_space_flags.  (The latter might
be nice -- it's already atomic and I think there are plenty of bits
free.)  Then a filesystem could stop calling file_update_time in
->page_mkwrite and instead test-clear that bit in ->writepage.

At that point, maybe the fs knows it's safe to mark the inode dirty
and update times.  (The actual time fields don't seem to be uniformly
protected by any lock.)  Can ext4_mark_inode_dirty be called from
->writepage?

Filesystems that haven't been converted can will continue to update
times in ->page_mkwrite.

>
>> (This, along with stable pages, is the major cause of
>> long sleeps in my application.)  OTOH, maybe I should just use i_state
>> and i_lock for this.
>
> Or, perhaps, export O_CMTIME to fcntl and/or open?

That would work, but it would be kind of nice for the time stamps on
my files to get updated correctly.  I'd argue that it's more correct
for the timestamp to be after the update (at page cleaning time,
probably) than at page_mkwrite time.

--Andy
