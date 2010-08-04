Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab0HDTb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 15:31:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53974 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548Ab0HDTbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 15:31:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ha+3JyVK5I2vmWYm4KS+lMWG3mVMLphKR0k7BdKyIKHCz9HXNdAQ62eI5c+fT+6qi3
         q2avZelD0Mm6YPwzHSA8oL4XAFQzt3j/dxItXH7Uo6sWipkD2rZkkdfS+GKwk5ORx/VI
         91ySpYqbVYAtNKF/b6i2QQt4KsxjUir0aIyRs=
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1280940512.16380.4.camel@maxim-laptop>
References: <441366.48179.qm@web37605.mail.mud.yahoo.com>
	 <1280940512.16380.4.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 22:31:44 +0300
Message-ID: <1280950305.16380.25.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 19:48 +0300, Maxim Levitsky wrote: 
> On Wed, 2010-08-04 at 00:57 -0700, Alex Dubov wrote: 
> > I see two immediate problems with this patch:
> > 
> > 1. On cosmetic level, custom debug macros should not be employed. Device
> > core already have this functionality (dynamic debug levels and such). Please,
> > use dev_dbg and friends for print-outs.
> This allows much easier control for debug.
> Single module parameter is enough to adjust it.
> This helps me help users.
> (Eg, kernel compilation is out of question)
> 
> 
> > 
> > 2. On a structural level, I'd rather prefer host drivers to not start their
> > own threads. If you look at both current host implementations, they operate
> > in callback fashion. Apart from saving some resources, this reduces the
> > amount of problems encountered during suspend/resume and shutdown.
> This isn't possible.
> Hardware doesn't support interrupts on memstick bus changes, it only
> supports DMA done from/to internal FIFO, and DMA it only possible for
> 512 byte TPCs.
> 


Another question.

I see that current code ignores MEMSTICK_CAP_AUTO_GET_INT
Instread mspro_blk.c enables this capability for parallel mode, assuming
that hw supports it. Its true in my case, but might not be true in other
cases.
I think I should fix that, right?

Also I see that you bath TPC_READ_LONG_DATA/TPC_READ_LONG_DATA
Does that mean that every HW sector is larger that 512?
If so, you are doing copy on write, right?
I have small caching in my sm_ftl of last sector. It helps performance a
lot.


Also I want to clarify that the only kind of interrupts supported by hw
(besides usual card detection interrupt), is DMA done interrupt.
Thats why I have to use thread.
Doing polling in r592_submit_req (which runs in atomic context is just
cruel).
Besides, under moderate IO load, the IO thread doesn't sleep, thus there
is no overhead of wake/sleep.


Best regards,
Maxim Levitsky

