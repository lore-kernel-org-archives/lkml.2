Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab0IWHkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 03:40:00 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36460 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab0IWHj7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 03:39:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xOm61tWCMajbi4ceu3hilQhVhl6rpQFtR4WsudSxHN5nbqe2Mgyjw6OXgNVdIcxxAC
         Axt3+MzTYs3oiRXUO2ofWtwl1DdXHSbbaaDCSCZQrMBAsVlhGqo6ynHzVnbbdPnMv12I
         r08JnG1POBtIdryZjFgoFG7VqPDNbTvtnIxBM=
MIME-Version: 1.0
In-Reply-To: <AANLkTimGu1R0vqpLK9X30CxkibO6N964D1Y-fQvAdA9D@mail.gmail.com>
References: <1283256734-3408-1-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-2-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-3-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-4-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-5-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-6-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-7-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-8-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-9-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-10-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-11-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-12-git-send-email-linus.walleij@stericsson.com>
	<AANLkTimGu1R0vqpLK9X30CxkibO6N964D1Y-fQvAdA9D@mail.gmail.com>
Date: Thu, 23 Sep 2010 09:39:58 +0200
Message-ID: <AANLkTik+6oAHBjT1LDZthYhVUTwVzs3kTgM2LPn10vbY@mail.gmail.com>
Subject: Re: [PATCH 11/12] DMAENGINE: let PL08X memcpy TXDs wait
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, yuanyabin1978@sina.com,
        linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Per_Frid=E9n?= <per.friden@stericsson.com>,
        Rabin VINCENT <rabin.vincent@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/23 Dan Williams <dan.j.williams@intel.com>:
> On Tue, Aug 31, 2010 at 5:12 AM, Linus Walleij
> <linus.walleij@stericsson.com> wrote:
>> This change makes the memcpy transfers wait for a physical channel
>> to become available if no free channel is available when the job
>> is submitted. When the first physical channel fires its tasklet,
>> it will spin over the memcpy channels to see if one of these is
>> waiting.
>>
>> This is necessary to get the memcpy semantics right: the generic
>> memcpy API assume transfers never fail, and with our oversubscribed
>> physical channels this becomes a problem: sometimes submit would
>> fail. This fixes it by letting the memcpy channels pull a free
>> channel ASAP.
>>
>> The slave channels shall however *fail* if no channel is available
>> since the device will then either fall back to some PIO mode or
>> retry.
>>
>
> This patch does not sit right with me.  It seems a bit arbitrary that
> memcpy operations will be queued while slave operations are failed.

I was sort of suspecting a discussion around this...

Background: the PL081 that I'm testing on only has *two* physical
channels, they can be used for memcpy, slave transfers (RX/TX).

My first option was to set one channel aside for memcpy and
one for dev xfers and be done with it.

But that would be devastating if
I was only using them for memcpy or only devxfer, since it would
slash performance in half. So I decided to let memcpy and
dev xfers battle for the channels with oversubscription and exposing
two virtual memcpy channels.

Whereas the slave drivers I've written are prepared to handle the
case where a transfer fails gracefully (and not treat it as an error)
and fall back to IRQ/PIO mode, the memcpy tests in
drivers/dma/dmatest.c does treat a failure to prep() or submit()
as an error.

So for this reason I'm queueing memcpy requests until
there is a channel ready.

Are you suggesting I should rewrite the memcpy tests instead
so they gracefully handle a failed prep() call, not treat it as an
error and either:

- retry or
- copy with a regular klibc memcpy() call?

> Is there anyway to know at prep time whether a subsequent submit will
> fail?  Are there any cases where a slave might want its operation
> queued?
>
> The prep routine is meant to guarantee that all the resources for a
> transaction have been acquired.  The only reason ->tx_submit() has a
> return value is to support the net_dma usage model that uses opaque
> cookies for tracking transactions.

It is possible to do this at prep() time. However that assumes that every
device transfer has code that executes this sequence:

.device_prep_slave_sg()
.tx_submit()
.device_issue_pending()

In direct succession. If there is an arbitrary delay between prep()
and submit() (where I currently fail xfers) the physical channels
may starve if prep() allocates them.

If I can safely assume that prep() and .tx_submit() are in quick
succession, I can reserve the physical channel at prep() time.

This seems to be the case in current code where only quick
things like setting a callback etc is done between prep() and
.tx_submit().

So I'll spin the PL08x around to reserve channels on
prep() instead.

(By the way: we should rename .tx_submit() to just .submit()
since in device context this can just as well be RX!)

> If we make tx_submit() fallable we should go back and ensure that all
> usages are prepared to handle failure.

OK I've implemented failure path for tx_submit() in all my
drivers but I also have it for prep() of course. I hope I can keep
that code... I'll take out the comments about allocation failure
and move them to the prep() calls though.

Yours,
Linus Walleij
