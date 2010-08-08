Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab0HHPHb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 11:07:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65304 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab0HHPHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 11:07:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tP7ewycFNSK/HeYtX9lVXdJCQzlvcchvLqT4fEfx8bUV3bAUplR+USY12FujVux8WI
         +F3/8iXXA10p+esWAR+0PMtTtW4hU9gS5HG0fLf5h1CgCNWDgBUskKFhk5DuJps2afwV
         jPj7v2yonJqp0z+FNgsCi+Tkb0V6mhRy+0wDc=
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <518887.35250.qm@web37604.mail.mud.yahoo.com>
References: <518887.35250.qm@web37604.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 Aug 2010 18:07:24 +0300
Message-ID: <1281280044.10030.27.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-08-08 at 07:26 -0700, Alex Dubov wrote: 
> > Hi,
> > 
> > I have few more questions about memsticks.
> > 
> > First of all, I need an explanation of overwrite flag.
> > You already explained it to me once, but I still not sure
> > about few
> > things.
> 
> Overwrite register can be accessed either as part of extra data access
> or separately (CP_OVERWRITE access mode).
> 
> > 
> > #define MEMSTICK_OVERWRITE_UDST  0x10
> > This one I understand, thinking about xD again, I think it
> > is very
> > handy.
> > 
> > My idea (from xD of course) is that copyonwrite is done
> > this way:
> > 
> > 1. read old sector
> > 2. allocate new sector
> > 2. write what was just read to new sector.
> > 3. erase old sector.
> 
> This is correct.
> 
> > 
> > Could you explain when I need to set and reset the
> > MEMSTICK_OVERWRITE_UDST?
> 
> UDST flag should be set when you're marking the block for
> reallocation during the read/modify/write cycle. You read the existing
> physical block, mark it with UDST flag (setting it to zero), then write
> different physical block on behalf of the same logical one, then erase the
> original block. The UDST flag is supposed to guard against a situation,
> whereupon power fails during the write cycle and you're left with two
> physical blocks mapped to the same logical one (so the one marked with
> zero UDST value is supposedly "known good").

> 
> 
> > 
> > 
> > #define MEMSTICK_OVERWRITE_PGST1 0x20
> > #define MEMSTICK_OVERWRITE_PGST0 0x40
> > I suppose these indicate that page(sector) contains
> > incorrect data, just
> > like in xD there is page status?
> > Again, better explanation is welcome.
> > Also, should I touch that flag when I update sector?
> > 
> > 
> > 
> > #define MEMSTICK_OVERWRITE_BKST  0x80
> > This marks bad blocks?
> 
> BKST set to zero indicates that the whole block is bad and shouldn't be
> used.
> 
> PGST1:0 has several values:
> 11:  default, r/w page
> 10: reserved value, shouldn't be used
> 01: page is read-only (soft write-protect)
> 00: page is accessible, but the value is not guaranteed (faulty page that
> sort-of works)
> 
> That's what the spec says.

Thank you very much. 
> 
> > 
> > 
> > 
> > Another question is about write of oob data.
> > When I write it, overwrite flag is updated, or I need to
> > use
> > MEMSTICK_CP_OVERWRITE to update it?
> > I think former is true.
> 
> As I mentioned above, it can be accessed either as part of extra data
> or separately.
> 
> > 
> > When I write a sector, I just write 0 to management flag,
> > right?
> 
> You shouldn't touch management_flag at all, as far as I can tell.
> It's only used to indicate special purpose blocks, such as factory
> written boot blocks, volatile look-up table blocks (for systems with
> tight RAM requirements) and DRM marked blocks which I has no info about.
> 
> > 
> > 
> > And last question,
> > If I use MEMSTICK_CP_BLOCK, can I start reading a block
> > from non-zero
> > page offset?
> 
> Yes, it starts from the user specified page address and auto increments it
> until the current block end is hit.
> 
> > 
> > 
> > And surely last question, what is 'MS_CMD_BLOCK_END'
> 
> This command is used to terminate the currently ongoing block operation.
> If you are using one of the auto-increment modes (with CP_BLOCK set) but
> do not want to access all the pages until the block end, you must issue
> this command after the desired number of pages is transferred to return
> the media's state machine to the initial state. This command never hurts,
> as you can guess.
That what I expected, thanks! 
> 
> > 
> > 
> > Thanks again for all help so far,
> > 
> 
> You're welcome.

Thank you very much!

Best regards,
Maxim Levitsky

