Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab0HJIM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 04:12:57 -0400
Received: from web37603.mail.mud.yahoo.com ([209.191.87.86]:28179 "HELO
	web37603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751048Ab0HJIMt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 04:12:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=xnVLMr+ZPu8qXfQKf7gIO8R2hv6RLQ0PNCEzR/rNcS/Hc4k5q8eVShbAin6lHemyoBUY/sozvM7oj7VoRa0S4EsfxZozUTLa6iGlJMQgqZAYZ2yA15Q3VVsWbHpeqfryzfnWYAX3w19yhRVK9jiYzXVWWwPkLHkw54LmIGoLfU0=;
Message-ID: <749211.91566.qm@web37603.mail.mud.yahoo.com>
X-YMail-OSG: kg5Wkk8VM1kgZnHZCwOQUDTYegX3Z_4B5v8mVSmx_UXDiNo
 petm7qi5Qr0UvMIqmp2uu8nvEtHOe4NBYBZd3AaKNPftMe9_1kKnBLSSJWDy
 _ZT3vjlZ6527S4XXFKleOsRwiHhX4NAlw1VTmhhkdg6LS.T8DIXK2iXGmEig
 EdLgdhh0t6zsDycEgKaRDk6OrxrfRfOSvB5W2pXS_ANcuB_LbJjBtRPiGJux
 XsSfq2yng8DYX44x3KQ5_ggzPqP_xe4pAbS7gyUIOFSUNODx2rSYCEjAkcPK
 LnuNEHLXyGDAPZNMr7xtCfSIxNdxFvkX_YgmD0j7KkEngsNZRCbP5Wg--
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Tue, 10 Aug 2010 01:12:47 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281367801.22777.19.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Received: Monday, 9 August, 2010, 8:30 AM
> I have another question.
> 
> Looking at ms_block.c, I see that it sometimes changes
> register window.
> This doesn't look good.
> I see it does put the register window back, but still its a
> bit obscure.

It looks very good, in fact, it is the Sony specified way to operate
the media. MS Pro works quite the same, it just needs fewer operations
to actually access data.

> 
> I added tracking of current register window, so every time
> I send
> MS_TPC_SET_RW_REG_ADRS I note the ranges.
> And read/write functions now always attempt to send
> MS_TPC_SET_RW_REG_ADRS. If the window is same as was 
> set last time, TPC
> is skipped.

Sure it is. The media will remember the window set.
Media has all its registers in a sort of flat file. SET_RW_REG_ADDR
selects the subset of the registers that will receive the data delivered
within TPC. This subset is remembered until power off or until changed.


> 
> However, I am thinking, that maybe I should always write
> both param and
> extra register? I just write 0xFF to extra register and
> thats all.

You should write into a param register when you want to alter the command
parameters. You cannot do so during auto incrementing block access, for
example.

But, if you're using the auto incrementing write, you will have to write
extra register for every page transferred.

That's where changing RW_REG_ADDR comes handy.

> Windows driver does that partially. It writes 0xFF to
> managmemt and
> 0xF8 to overwrite flag (why???)

It's a factory default.
Try to read it from some empty block. :-)
(My theory is that missing bits contain invisible ECC data).


> I don't
> think that matters.
> It also always sends the MS_TPC_SET_RW_REG_ADRS, which I
> don't like.
> 

This only reduces the performance slightly. SET_RW_REG_ADDR does not
influence the media's state machine as far as I can tell, unless you try
to push it during the data transfer cycle (whereupon you will end up
having a literal value of the tpc in the media data buffer).



      
