Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab0HJJsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 05:48:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59387 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab0HJJsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 05:48:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hiZN/ys6+x6RJoKVt4+sB4J1UlxKCze0Qer+dFiQNaoTdPpZ1B1kDxVFf1y/cdmYFo
         3aTbA27T2UA96YQSA1KX+3bmJHpiRWAkuWsBCaHeRFQBZKvPbt7av2Dh0yANJWluCmk0
         xf/e2NP/vqjxjj8mNCs+hNVpQtujY4PY8QpNA=
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <749211.91566.qm@web37603.mail.mud.yahoo.com>
References: <749211.91566.qm@web37603.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Aug 2010 12:47:58 +0300
Message-ID: <1281433678.2016.34.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-10 at 01:12 -0700, Alex Dubov wrote: 
> > Received: Monday, 9 August, 2010, 8:30 AM
> > I have another question.
> > 
> > Looking at ms_block.c, I see that it sometimes changes
> > register window.
> > This doesn't look good.
> > I see it does put the register window back, but still its a
> > bit obscure.
> 
> It looks very good, in fact, it is the Sony specified way to operate
> the media. MS Pro works quite the same, it just needs fewer operations
> to actually access data.
> 
> > 
> > I added tracking of current register window, so every time
> > I send
> > MS_TPC_SET_RW_REG_ADRS I note the ranges.
> > And read/write functions now always attempt to send
> > MS_TPC_SET_RW_REG_ADRS. If the window is same as was 
> > set last time, TPC
> > is skipped.
> 
> Sure it is. The media will remember the window set.
> Media has all its registers in a sort of flat file. SET_RW_REG_ADDR
> selects the subset of the registers that will receive the data delivered
> within TPC. This subset is remembered until power off or until changed.

I know everything you have just said.
I just want to point out that code in many places assumes that register
window is the same as set on device initialization.

However some code changes the register window, and therefore has to
change it back at the end of execution.
If error happens, window can be left changed, while rest of code thinks
it isn't changed.
Thats is why a tracking of it would eliminate the problem safely.

> 
> 
> > 
> > However, I am thinking, that maybe I should always write
> > both param and
> > extra register? I just write 0xFF to extra register and
> > thats all.
> 
> You should write into a param register when you want to alter the command
> parameters. You cannot do so during auto incrementing block access, for
> example.
> 
> But, if you're using the auto incrementing write, you will have to write
> extra register for every page transferred.
But what if I fill extra register with 0xFF?
And besides on reads, the fact that I *write* the extra register before
I execute read command shouldn't matter at all regardless of what I
write there.
On writes however I *do* need to write extra register anyway with proper
values.

Therefore I see no reason why I can't set write window to cover both
param and extra register, and leave it always like that.

> 
> That's where changing RW_REG_ADDR comes handy.
> 
> > Windows driver does that partially. It writes 0xFF to
> > managmemt and
> > 0xF8 to overwrite flag (why???)
> 
> It's a factory default.
> Try to read it from some empty block. :-)
> (My theory is that missing bits contain invisible ECC data).
> 
> 
> > I don't
> > think that matters.
> > It also always sends the MS_TPC_SET_RW_REG_ADRS, which I
> > don't like.
> > 
> 
> This only reduces the performance slightly. SET_RW_REG_ADDR does not
> influence the media's state machine as far as I can tell, unless you try
> to push it during the data transfer cycle (whereupon you will end up
> having a literal value of the tpc in the media data buffer).
Indeed. Maybe I too should just send the MS_TPC_SET_RW_REG_ADRS at start
of command, and know that nothing will go south....

Even if that reduces performance by 0.2%, it isn't big deal. Data
corruptions is very big deal.


Best regards,
Maxim Levitsky

