Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab2DYUJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 16:09:34 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:36761 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758428Ab2DYUJc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 16:09:32 -0400
References: <1311207599-2553-1-git-send-email-tomoya-linux@dsn.okisemi.com> <1311207599-2553-6-git-send-email-tomoya-linux@dsn.okisemi.com> <3D60A4A2-3538-4B24-B65B-219D6ED7B219@gmail.com>
In-Reply-To: <3D60A4A2-3538-4B24-B65B-219D6ED7B219@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <CA46BB56-61AD-45E9-8D03-906B71C21C71@gmail.com>
Content-Transfer-Encoding: 8BIT
Cc: open list <linux-kernel@vger.kernel.org>,
        alexander.stein@systec-electronic.com, qi.wang@intel.com,
        yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com
From: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Subject: Re: gpio-pch: BUG - driver does not honour IRQF_ONESHOT
Date: Wed, 25 Apr 2012 16:09:28 -0400
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isn't anyone concerned with this? I am replying to myself to provoke a response.

Configuring a gpio pin with the gpio-pch driver with
"IRQF_TRIGGER_LOW | IRQF_ONESHOT" generates an interrupt
storm for threaded ISR until the ISR thread actually gets to physically clear
the interrupt on the triggering chip!! The immediate observable symptom
is the high CPU usage for my ISR thread task and the interrupt count in
/proc/interrupts incrementing radically.

See below for more details.

On Dec 8, 2011, at 14:37, Jean-Francois Dagenais wrote:

> Hello all,
> 
> I am using the interrupt function of gpio-pch.c. I have an adp5588 who's interrupt line goes into one of the
> GPIO lines of a EG20T.
> 
> I have a patch (not yet submitted to lkml) which lets the platform control the IRQ flags for the chip. I had to
> do this to allow the IRQ line to be shared. I used IRQF_SHARED | IRQF_ONESHOT | IRQF_TRIGGER_LOW.
> 
> Unfortunately, since all of the handling of the adp5588 is done in a thread function, the interrupt stays low
> between the moment the hard handler is run and the 5588 function is run. Since pch_gpio_handler clears
> the interrupt status right away, I get an interrupt storm for the pch_gpio_handler function.
> 
> the line that does "iowrite32(BIT(i), &chip->reg->iclr);" right before calling generic_handle_irq should be
> executed only after the corresponding nested ISR has run it's thread function.
> 
> I am open to patching this and submitting, but I would like some pointers before I dive in.
> 
> Thanks for the help!
> (and thanks Tomoya for the interrupt support ;)
> 
> On Jul 20, 2011, at 20:19, Tomoya MORINAGA wrote:
> 
>> 
>> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
>> ---
>> drivers/gpio/Kconfig    |    1 +
>> drivers/gpio/gpio-pch.c |  187 +++++++++++++++++++++++++++++++++++++++++++++++
>> 2 files changed, 188 insertions(+), 0 deletions(-)
>> ...

