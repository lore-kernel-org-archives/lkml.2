Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab0IWE7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 00:59:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33794 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab0IWE7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 00:59:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=oMlOJ/E8sC4jRqI9jNN1KCfTB/eRqIzccPNtDI7OkLYBQHCTgwbEBjGsaHqdHwQS0m
         iiVpyn98CiHXN55RMglDl4w7S1WjRd2wgtlqpEYpLA9n6wI6PDpVNILKp6LtRrWgxBdv
         ykW8lCpUaw7MYmYeQ2vECUc0VsF8RBPILW8Lw=
MIME-Version: 1.0
In-Reply-To: <1283256734-3408-12-git-send-email-linus.walleij@stericsson.com>
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
Date: Wed, 22 Sep 2010 21:59:13 -0700
X-Google-Sender-Auth: gT7N0ExiSj9ORMxGZ7ICn9TMNfc
Message-ID: <AANLkTimGu1R0vqpLK9X30CxkibO6N964D1Y-fQvAdA9D@mail.gmail.com>
Subject: Re: [PATCH 11/12] DMAENGINE: let PL08X memcpy TXDs wait
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, yuanyabin1978@sina.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 5:12 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> This change makes the memcpy transfers wait for a physical channel
> to become available if no free channel is available when the job
> is submitted. When the first physical channel fires its tasklet,
> it will spin over the memcpy channels to see if one of these is
> waiting.
>
> This is necessary to get the memcpy semantics right: the generic
> memcpy API assume transfers never fail, and with our oversubscribed
> physical channels this becomes a problem: sometimes submit would
> fail. This fixes it by letting the memcpy channels pull a free
> channel ASAP.
>
> The slave channels shall however *fail* if no channel is available
> since the device will then either fall back to some PIO mode or
> retry.
>

This patch does not sit right with me.  It seems a bit arbitrary that
memcpy operations will be queued while slave operations are failed.
Is there anyway to know at prep time whether a subsequent submit will
fail?  Are there any cases where a slave might want its operation
queued?

The prep routine is meant to guarantee that all the resources for a
transaction have been acquired.  The only reason ->tx_submit() has a
return value is to support the net_dma usage model that uses opaque
cookies for tracking transactions.

If we make tx_submit() fallable we should go back and ensure that all
usages are prepared to handle failure.

--
Dan

sidenote: this driver needs to be converted to a dma descriptor pool
(allocated at device_alloc_chan_resources time), or at a minimum use
GFP_NOWAIT in device_prep_dma_memcpy because that routine may be
called from atomic contexts.
