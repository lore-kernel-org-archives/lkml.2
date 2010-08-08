Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab0HHO0q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 10:26:46 -0400
Received: from web37604.mail.mud.yahoo.com ([209.191.87.87]:23441 "HELO
	web37604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754161Ab0HHO0p convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 10:26:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=okzPCI4NaUdcQWyK+6a6QXxe/ZFEYEx8rxrqd1T1gvxMnlXgJm/qv15x4X/cAXIFkucZv8JV+zf3DHhEcoD1F99ivwbFh5CA7Pl3+/LcVSaQZ5X6yR7B66oU/50r8vywA3ukODFTYCt7+dCcXlsNPRUVJgrNNSW62eajiu/CFGE=;
Message-ID: <518887.35250.qm@web37604.mail.mud.yahoo.com>
X-YMail-OSG: geFCnaQVM1k.PhenF.wAqGHfKWm_ar1rCpzC7CuvaiKN8xi
 zuFuBaYEsDnTTd2jGw5uuIMXCXJxAnnF8jw3GjuTgWJb0zuIZwIVzWvEwevc
 rZxyyS1bci4CrixVx2liOyJxFI5BLUvah8uleWZYWBsTekKdMSplaO8Mb0mF
 mI4x3wU5QNE01cyrCt.vofAYI8iqgmkYiON4SQog32o8GIQjpsTzp0SGL28W
 b.rcUBF6.Nf1t6DDguiWE3YHsCSFrnOka7vYp3sxGaNjQMgJIRhTFEn22KcB
 Gg3W6Jk335wbSH9XQ4toCTYECueLo_1HlmPgFTqYV
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Sun, 8 Aug 2010 07:26:42 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281212565.3300.20.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> I have few more questions about memsticks.
> 
> First of all, I need an explanation of overwrite flag.
> You already explained it to me once, but I still not sure
> about few
> things.

Overwrite register can be accessed either as part of extra data access
or separately (CP_OVERWRITE access mode).

> 
> #define MEMSTICK_OVERWRITE_UDST  0x10
> This one I understand, thinking about xD again, I think it
> is very
> handy.
> 
> My idea (from xD of course) is that copyonwrite is done
> this way:
> 
> 1. read old sector
> 2. allocate new sector
> 2. write what was just read to new sector.
> 3. erase old sector.

This is correct.

> 
> Could you explain when I need to set and reset the
> MEMSTICK_OVERWRITE_UDST?

UDST flag should be set when you're marking the block for
reallocation during the read/modify/write cycle. You read the existing
physical block, mark it with UDST flag (setting it to zero), then write
different physical block on behalf of the same logical one, then erase the
original block. The UDST flag is supposed to guard against a situation,
whereupon power fails during the write cycle and you're left with two
physical blocks mapped to the same logical one (so the one marked with
zero UDST value is supposedly "known good").


> 
> 
> #define MEMSTICK_OVERWRITE_PGST1 0x20
> #define MEMSTICK_OVERWRITE_PGST0 0x40
> I suppose these indicate that page(sector) contains
> incorrect data, just
> like in xD there is page status?
> Again, better explanation is welcome.
> Also, should I touch that flag when I update sector?
> 
> 
> 
> #define MEMSTICK_OVERWRITE_BKST  0x80
> This marks bad blocks?

BKST set to zero indicates that the whole block is bad and shouldn't be
used.

PGST1:0 has several values:
11:  default, r/w page
10: reserved value, shouldn't be used
01: page is read-only (soft write-protect)
00: page is accessible, but the value is not guaranteed (faulty page that
sort-of works)

That's what the spec says.

> 
> 
> 
> Another question is about write of oob data.
> When I write it, overwrite flag is updated, or I need to
> use
> MEMSTICK_CP_OVERWRITE to update it?
> I think former is true.

As I mentioned above, it can be accessed either as part of extra data
or separately.

> 
> When I write a sector, I just write 0 to management flag,
> right?

You shouldn't touch management_flag at all, as far as I can tell.
It's only used to indicate special purpose blocks, such as factory
written boot blocks, volatile look-up table blocks (for systems with
tight RAM requirements) and DRM marked blocks which I has no info about.

> 
> 
> And last question,
> If I use MEMSTICK_CP_BLOCK, can I start reading a block
> from non-zero
> page offset?

Yes, it starts from the user specified page address and auto increments it
until the current block end is hit.

> 
> 
> And surely last question, what is 'MS_CMD_BLOCK_END'

This command is used to terminate the currently ongoing block operation.
If you are using one of the auto-increment modes (with CP_BLOCK set) but
do not want to access all the pages until the block end, you must issue
this command after the desired number of pages is transferred to return
the media's state machine to the initial state. This command never hurts,
as you can guess.

> 
> 
> Thanks again for all help so far,
> 

You're welcome.



      
