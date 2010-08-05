Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218Ab0HEMqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 08:46:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58030 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab0HEMql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 08:46:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Frd2qLGpZ/uON1aXQa1vlbFnJ7pva2pCSiq+c6x8bnGTVpCeLDApW8ipwywSf2oRZ3
         TEy/n6x8o2pbzmaUoGvCO8Rn4KvWuthAYQLYqnmTwiXxSDIoMPplySMXxsu1MKg4EfuN
         Ovss5A3QvgBVoSPr3C1HLlb2xpTeFxgoc+NfE=
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <952321.94696.qm@web37608.mail.mud.yahoo.com>
References: <952321.94696.qm@web37608.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 15:46:36 +0300
Message-ID: <1281012396.9324.29.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 01:30 -0700, Alex Dubov wrote: 
> > Maxim Levitsky wrote: 
> > > On Wed, 2010-08-04 at 00:57 -0700, Alex Dubov wrote: 
> > > > I see two immediate problems with this patch:
> > > > 
> > > > 1. On cosmetic level, custom debug macros should
> > not be employed. Device
> > > > core already have this functionality (dynamic
> > debug levels and such). Please,
> > > > use dev_dbg and friends for print-outs.
> > > This allows much easier control for debug.
> > > Single module parameter is enough to adjust it.
> > > This helps me help users.
> > > (Eg, kernel compilation is out of question)
> 
> I doubt it will be that useful, but it's not my call to make anyway.
> 
> 
> > > 
> > > 
> > > > 
> > > > 2. On a structural level, I'd rather prefer host
> > drivers to not start their
> > > > own threads. If you look at both current host
> > implementations, they operate
> > > > in callback fashion. Apart from saving some
> > resources, this reduces the
> > > > amount of problems encountered during
> > suspend/resume and shutdown.
> > > This isn't possible.
> > > Hardware doesn't support interrupts on memstick bus
> > changes, it only
> > > supports DMA done from/to internal FIFO, and DMA it
> > only possible for
> > > 512 byte TPCs.
> > > 
> > 
> 
> How depressing.
> 
> > 
> > Another question.
> > 
> > I see that current code ignores MEMSTICK_CAP_AUTO_GET_INT
> > Instread mspro_blk.c enables this capability for parallel
> > mode, assuming
> > that hw supports it. Its true in my case, but might not be
> > true in other
> > cases.
> > I think I should fix that, right?
> 
> This is mandated by the spec. INT should be available automatically in
> parallel mode, and some hardware does it in serial as well.
Thinking again about that I agree with you.
Then I can remove 2 more lines from my driver.

Btw, I want to add a callback from driver to card driver to be able to
reset card in case of error (windows driver does that in case of any
error)

I would use most of the mspro_block_resume for the implementation for
mspro.

Any objections, suggestions?

> 
> > 
> > Also I see that you bath
> > TPC_READ_LONG_DATA/TPC_READ_LONG_DATA
> > Does that mean that every HW sector is larger that 512?
> > If so, you are doing copy on write, right?
> > I have small caching in my sm_ftl of last sector. It helps
> > performance a
> > lot.
> 
> 
> That's how its called in the spec.
> Sectors can be larger than 512b on Pro-HG sticks, and there's additional
> TPC_READ/WRITE_QUAD_DATA which operates on larger quantities.
> 
> > 
> > 
> > Also I want to clarify that the only kind of interrupts
> > supported by hw
> > (besides usual card detection interrupt), is DMA done
> > interrupt.
> > Thats why I have to use thread.
> > Doing polling in r592_submit_req (which runs in atomic
> > context is just
> > cruel).
> 
> Yes, I see you have a timed wait there.
> 
> 
> > Besides, under moderate IO load, the IO thread doesn't
> > sleep, thus there
> > is no overhead of wake/sleep.
> > 
> > 
> > Best regards,
> > Maxim Levitsky
> > 

Best regards,
Maxim Levitsky

