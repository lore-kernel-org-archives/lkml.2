Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab0FGUZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 16:25:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406Ab0FGUZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 16:25:06 -0400
Date: Mon, 7 Jun 2010 13:24:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg Thelen <gthelen@google.com>
Cc: Richard Kennedy <richard@rsk.demon.co.uk>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>, lkml <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Jeff Mahoney <jeffm@suse.com>,
       reiserfs-devel@vger.kernel.org
Subject: Re: [PATCH RFC]  buffer_head: remove redundant test from
 wait_on_buffer
Message-Id: <20100607132400.492613f1.akpm@linux-foundation.org>
In-Reply-To: <xr93ljbbw3u8.fsf@ninji.mtv.corp.google.com>
References: <1271415499.2075.19.camel@localhost>
	<20100416145123.283f216c.akpm@linux-foundation.org>
	<xr93ljbbw3u8.fsf@ninji.mtv.corp.google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 May 2010 23:05:03 -0700
Greg Thelen <gthelen@google.com> wrote:

> > --- a/fs/buffer.c~buffer_head-remove-redundant-test-from-wait_on_buffer-fix
> > +++ a/fs/buffer.c
> > @@ -90,6 +90,12 @@ EXPORT_SYMBOL(unlock_buffer);
> >   */
> >  void __wait_on_buffer(struct buffer_head * bh)
> >  {
> > +	/*
> > +	 * Calling wait_on_buffer() against a zero-ref buffer is a nasty bug
> > +	 * because it will almost always "work".  However this buffer can be
> > +	 * reclaimed at any time.  So check for it.
> > +	 */
> > +	VM_BUG_ON(atomic_read(&bh->b_count) == 0);
> 
> My system is failing this VM_BUG_ON() occasionally.  I think this is due to
> wait_on_buffer() calls with b_count=0 from locations within fs/buffer.c.

Thanks.

Yup, the buffers are protected by lock_page().

> These
> occasional b_count=0 callers are caused by buf reads that complete quickly -
> after the I/O is issued but before it is waited upon.  Such fs/buffer.c callers
> need to either bypass this assertion or increment b_count.  I don't think they
> need to grab an b_count reference.  I suggest a bypass routine in the patch
> below.  Does this look good?

I think I'll just drop
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch and
wait_on_buffer-remove-the-buffer_locked-test.patch.

