Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab0HWGf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 02:35:29 -0400
Received: from web37605.mail.mud.yahoo.com ([209.191.87.88]:41730 "HELO
	web37605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751978Ab0HWGf2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 02:35:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=B5oKNyyBxEse9mfk2hXYp+WLtxS+9hOsDHlU/hKb0ZOaYQHeu5S9Ox83msHaOjp9sNONAavleBjR4D1XCmI+uvPmBntZg/HV6+lkp5UKGvzlROeT6JSmK0Vvj1eQzv8rJjFw9vN4Y3N7wReX+g59pD80TD6875IcheBBoDV1m/M=;
Message-ID: <824153.86716.qm@web37605.mail.mud.yahoo.com>
X-YMail-OSG: 62gc_NcVM1lYht.z95x3NY_LejgfZvhz.xfa1zGt7G.6Lci
 xe8C42AVM71Q2CwO9LmoYhVu9BNsYHPYSX_MdU25Mj0wzeawgOPPn8OBzfeK
 HVj5X6IPTgpstQmpxxcUL3Eu4iHDyKSE8KOPsffC0ryobhD5BlmgNhYH3TYQ
 IbGH0bJgPs3A.pmQsQTquoIvVHBL1PHiwCUvGzE7fmRn84a4lT8FyA1r4CoT
 wPiLNjDuobEf6IGQI_Xi7JjrWKwZB5nOT5XnOAoAoxh_ZDtrn6ZYv8VgX25j
 yRo86pKC4tA6YxUyy9qn4n9roweI-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Sun, 22 Aug 2010 23:35:26 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH] My work on MemoryStick system
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1282402579.4799.20.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > 
> > > I just tested this series with Jmicron, and
> unfortunelly
> > > there are bugs.
> > > 
> > > * driver refuses to handle 26 byte TPC I use to
> read regs
> > > (sizeof(ms_registers). If I bump it to 32, it
> works.
> > 
> > It will work with any multiply of 4 (24 and 28 work as
> well). It's a known
> > "feature".
> Then I bump the size of ms_registers to 32 and leave this
> as is.
> OK?

I'd rather minimize the transfer size, than increase it.


> And I add a warning about this feature of some hardwares
> someplace.
> 
> 
> But what about MS_TPC_GET_INT. This asks for single byte.
> Hardware has to support it.

They've got a custom register for its value. GET_INT is implemented by
different hardware than READ/WRITE_REG

> 
> 
> 
> > 
> > > 
> > > * With this fix first few reads still fail.
> > > That means that card isn't detected always
> because boot
> > > blocks might not
> > > be read.
> > > Later card works fine.
> > > 
> > > * Also I found out that msproblk.c allocates
> memory for
> > > attributes IO
> > > using stock kmalloc, and hangs that to driver.
> > > However if driver doesn't support such address,
> it will
> > > fail.
> > 
> > Why would hardware do anything at all with attribute
> memory space?
> Read it?
> 
> You allocate the memory with kmalloc, create a sg with
> sg_init_one and
> pass that to driver.
> So therefore it can be from arbitrary address.

Yes, indeed.

> 
> I found further problems in jmicron driver:
> 
> 
> 1. Serial mode doesn't work well.
> I first read the boot block, and then enable parallel
> mode.
> I do so because boot block has a flag that tells if
> parallel mode is
> supported.
> It turns out that sector reads often don't finish,
> especially first and
> often second one which contain boot blocks.
> If I enable parallel mode right away problem goes away.

They have really weird dependency between clock setup and operation mode.
Try to use the clock setup values from the errata I've sent you.
The order of register initialization and reset timing seems to affect
the operation as well.

To summarize my opinion about it: if I had to design a card reader, I
won't even look at anything, but TI chips. :-)


> 
> 
> 2. the MS_TPC_WRITE_LONG_DATA fail, therefore I can't write
> anything to
> the stick.
> 
> As soon as my driver starts to write a block,  first
> MS_TPC_WRITE_LONG_DATA succeeds, but second one timeouts.
> (there is no MS_TPC_GET_INT in between, because of parallel
> mode).
> 
> Maybe I do something wrong in my ms_block.c, but I checked
> it many
> times, and it appears to be correct, and it works fine with
> r592.c
> 
> 
> Best regards,
> Maxim Levitsky
> 
> 
> 
> 


      
