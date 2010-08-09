Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab0HIG4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 02:56:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57012 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417Ab0HIG4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 02:56:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WJP/z8TyKEXHFP/7Rl29ASe3pZd/UXyDAHAwaMBclKavAqPnmBzMstcpbph9+WA4ni
         IGFiWwWVLlduapgIav3FSFWayXq//BXl88dRKu/GVN8iIiaNcTRJIAK0nvjF4dVa3dXJ
         HJqQOxrscG9utn6ClVr/7b7Wk9iHbe1hZl6hs=
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <397573.48417.qm@web37608.mail.mud.yahoo.com>
References: <397573.48417.qm@web37608.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 09:56:04 +0300
Message-ID: <1281336964.16637.13.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-08-08 at 23:31 -0700, Alex Dubov wrote: 
> > 
> > I currently assume that if I set req->need_card_int, the
> > driver will
> > wait till device raises MEMSTICK_INT_CED regardless of
> > serial/parallel
> > mode. This bit is always available on serial line.
> > Is that OK to assume?
> 
> I'm not quite sure about this question.
> Normally, when you wait for the media interrupt, you want to see the whole
> value of the INT register (CED by itself doesn't indicate successful
> command completion; in fact it's value is undefined in presence of other
> INT flags, like BREQ or CMDNK). In parallel mode, host is required to
> fetch all meaningful INT bits from the media bus, while in serial mode
> this is only possible, if host supports automatic INT retrieval (the host
> will issue GET_INT tpc behind the scenes before alerting the software).
Ok, maybe I didn't explain myself correctly.

Device is in serial mode.
I set need_card_int
I send a command.
<here I assume that driver waits for CED bit, which is exposed on data
line, if CED won't be set, driver/hardware will timeout>
I send GET_INT _once_, look at flags. If I see CED, no NACK, then ok,
otherwise I send error result.



> 
> > 
> > Another thing that I want to ask is about writes to
> > overwrite/managment
> > flag.
> > Common sense tells me that I can write the flash many
> > times, but write
> > can only clear bits. Therefore if I write 0xFF, this just
> > means do
> > nothing.
> > Probably same applies to data content, but that isn't much
> > of the use.
> 
> Yes, all memsticks are NAND flash, so writing 1s has no effect whatsoever.
> 
> > Thats why I see that default (good) value of bits in
> > overwrite flag is
> > 1.
> > This is correct I assume?
> 
> Yes, a direct consequence of the above.

I suspect that managment flag also has default value of 0xFF, and these
'special' features (drm, boot block, temporary table) clear bits out of
it.

> 
> > 
> > 
> > Another interesting thing I observed was that
> > MEMSTICK_INT_ERR can mean
> > a correctable error,  therefore it shouldn't
> > alone  reject read/write of
> > a sector. (I think that it means that one of
> > MEMSTICK_STATUS1_UCFG..MEMSTICK_STATUS1_DTER is set)
> > Same question about this.
> > 
> 
> There are three groups of error flags. While overwrite_flag register is
> accessible as part of extra data, being the indicator of block goodness
> it earned its own error flag:
> 
> DTER (UCDT) - error (uncorrectable) in data area
> EXER (UCEX) - error (uncorrectable) in extra data area
> FGER (UCFG) - error (uncorrectable) in overwrite_flag register
> 
> Uncorrectable error means that you've got some bit errors in the data
> you've obtained from the media. If uncorrectable flag is not set, it
> means that media's ECC circuit managed to correct the bit flip. The
> desired way of action is, of course, to reallocate the block before it
> develops an uncorrectable failure.
That I understand clearly.
I ask what the meaning of MEMSTICK_INT_ERR is.
I expect it to be set if any of (un) correctable errors are found.
Therefore if MEMSTICK_INT_ERR, I can't report error instantly, but I
need to look at status1 to see if error is correctable or not.
This is correct?


Best regards,
Maxim Levitsky

