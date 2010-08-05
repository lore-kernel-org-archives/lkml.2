Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975Ab0HEIaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 04:30:16 -0400
Received: from web37608.mail.mud.yahoo.com ([209.191.87.91]:31479 "HELO
	web37608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758810Ab0HEIaM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 04:30:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=pepxm+NfY6VySfcNz77su5NA4JTGnvoKO4b8p0bdvQ8OW9DmA3HwLh4RpixLNVZYbgwFJsVzoGDU5Qvuy8G8hMZ/DU3vh3HtHoHJDddHuA2eBf/o/94lGZFQFy0ynQ3kqEEy1RGf3w7p6KbuWfQXxsXc7SGVQz+oheP7ftEWFDk=;
Message-ID: <952321.94696.qm@web37608.mail.mud.yahoo.com>
X-YMail-OSG: 6YicJREVM1kCv.d9..LIBkAvclmc6ah_pCv4ioao8DUZ36b
 VRL5JvXChQU_ClIrQJ0So5NLp1VxFHA_CeijVp46KXg1wBak06g2sK.iILoJ
 jPFCrLPTULt_M9noB2UNPdiIm_u6K8wC9k96BiwsErQu72o2FzjywavsCYSu
 0tQR7H5k88LDUHTUdqQIv6ZQ63mhrJxfhH1_XI3MiqLbFtL6MskSy12FwMFc
 XPitR2X28cHi1IaxbmyDZusXR6YruRBq2G7jThkIbtSzfM.OJJ.yAdQu6yqA
 0id57UEjzrmY7QT3XGQT_aryHJ9lHcUNYg_PHgBo-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Thu, 5 Aug 2010 01:30:08 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maxim Levitsky wrote: 
> > On Wed, 2010-08-04 at 00:57 -0700, Alex Dubov wrote: 
> > > I see two immediate problems with this patch:
> > > 
> > > 1. On cosmetic level, custom debug macros should
> not be employed. Device
> > > core already have this functionality (dynamic
> debug levels and such). Please,
> > > use dev_dbg and friends for print-outs.
> > This allows much easier control for debug.
> > Single module parameter is enough to adjust it.
> > This helps me help users.
> > (Eg, kernel compilation is out of question)

I doubt it will be that useful, but it's not my call to make anyway.


> > 
> > 
> > > 
> > > 2. On a structural level, I'd rather prefer host
> drivers to not start their
> > > own threads. If you look at both current host
> implementations, they operate
> > > in callback fashion. Apart from saving some
> resources, this reduces the
> > > amount of problems encountered during
> suspend/resume and shutdown.
> > This isn't possible.
> > Hardware doesn't support interrupts on memstick bus
> changes, it only
> > supports DMA done from/to internal FIFO, and DMA it
> only possible for
> > 512 byte TPCs.
> > 
> 

How depressing.

> 
> Another question.
> 
> I see that current code ignores MEMSTICK_CAP_AUTO_GET_INT
> Instread mspro_blk.c enables this capability for parallel
> mode, assuming
> that hw supports it. Its true in my case, but might not be
> true in other
> cases.
> I think I should fix that, right?

This is mandated by the spec. INT should be available automatically in
parallel mode, and some hardware does it in serial as well.

> 
> Also I see that you bath
> TPC_READ_LONG_DATA/TPC_READ_LONG_DATA
> Does that mean that every HW sector is larger that 512?
> If so, you are doing copy on write, right?
> I have small caching in my sm_ftl of last sector. It helps
> performance a
> lot.


That's how its called in the spec.
Sectors can be larger than 512b on Pro-HG sticks, and there's additional
TPC_READ/WRITE_QUAD_DATA which operates on larger quantities.

> 
> 
> Also I want to clarify that the only kind of interrupts
> supported by hw
> (besides usual card detection interrupt), is DMA done
> interrupt.
> Thats why I have to use thread.
> Doing polling in r592_submit_req (which runs in atomic
> context is just
> cruel).

Yes, I see you have a timed wait there.


> Besides, under moderate IO load, the IO thread doesn't
> sleep, thus there
> is no overhead of wake/sleep.
> 
> 
> Best regards,
> Maxim Levitsky
> 
>



      
