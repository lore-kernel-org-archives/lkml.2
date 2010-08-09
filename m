Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab0HIGbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 02:31:36 -0400
Received: from web37608.mail.mud.yahoo.com ([209.191.87.91]:32833 "HELO
	web37608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752753Ab0HIGbf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 02:31:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=0BNQICxa7yfe7yWbBNQpSskMZMQ76+xw123TuaDk51faeMvkmM1/Ljau+zM6rfvXab6Yfo9xIJWAhxhFlT5Nsn3OLHlYM4qyhbGlw/MCSRsm+y3xwRPN4lo8Ti5MP+mT4YkkhJR9yojuTzYA4sQOFQp7KOEODjg8k8+tfTfqvwQ=;
Message-ID: <397573.48417.qm@web37608.mail.mud.yahoo.com>
X-YMail-OSG: g64WcRkVM1kceN.NlCgWfl66sQUnUZK8lsd8AarDA8r8Za2
 bjGmMHK0EOq0goeDBISkuV8.COAFpDdd1RthoB8n7DY0F6OLoeYTSrFnK482
 nek2cJEFai6kjMK69dZnraTZgKS_tsjrDw4.wXSgLUfpHfncPIpFwGMSodni
 fDoC5gi6ip0ZAU4v1yXydROxf91pNIOF0JjHXD24ECtMjGQ9WoScNucB8U4m
 34nmg44Z6mHTpMv68_W3PUOUqvEVHjDnxGlAxfFigkuQ4DgoSso6L9n.8c1W
 BVr1UMWi60nL9E6Xsipg9pKggvv1w5nT3dQN3ssc-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Sun, 8 Aug 2010 23:31:31 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281298140.10030.96.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I currently assume that if I set req->need_card_int, the
> driver will
> wait till device raises MEMSTICK_INT_CED regardless of
> serial/parallel
> mode. This bit is always available on serial line.
> Is that OK to assume?

I'm not quite sure about this question.
Normally, when you wait for the media interrupt, you want to see the whole
value of the INT register (CED by itself doesn't indicate successful
command completion; in fact it's value is undefined in presence of other
INT flags, like BREQ or CMDNK). In parallel mode, host is required to
fetch all meaningful INT bits from the media bus, while in serial mode
this is only possible, if host supports automatic INT retrieval (the host
will issue GET_INT tpc behind the scenes before alerting the software).

> 
> Another thing that I want to ask is about writes to
> overwrite/managment
> flag.
> Common sense tells me that I can write the flash many
> times, but write
> can only clear bits. Therefore if I write 0xFF, this just
> means do
> nothing.
> Probably same applies to data content, but that isn't much
> of the use.

Yes, all memsticks are NAND flash, so writing 1s has no effect whatsoever.

> Thats why I see that default (good) value of bits in
> overwrite flag is
> 1.
> This is correct I assume?

Yes, a direct consequence of the above.

> 
> 
> Another interesting thing I observed was that
> MEMSTICK_INT_ERR can mean
> a correctable error,  therefore it shouldn't
> alone  reject read/write of
> a sector. (I think that it means that one of
> MEMSTICK_STATUS1_UCFG..MEMSTICK_STATUS1_DTER is set)
> Same question about this.
> 

There are three groups of error flags. While overwrite_flag register is
accessible as part of extra data, being the indicator of block goodness
it earned its own error flag:

DTER (UCDT) - error (uncorrectable) in data area
EXER (UCEX) - error (uncorrectable) in extra data area
FGER (UCFG) - error (uncorrectable) in overwrite_flag register

Uncorrectable error means that you've got some bit errors in the data
you've obtained from the media. If uncorrectable flag is not set, it
means that media's ECC circuit managed to correct the bit flip. The
desired way of action is, of course, to reallocate the block before it
develops an uncorrectable failure.



      
