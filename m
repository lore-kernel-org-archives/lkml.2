Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab1LHTdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 14:33:36 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38161 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab1LHTde convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 14:33:34 -0500
References: <1311207599-2553-1-git-send-email-tomoya-linux@dsn.okisemi.com> <1311207599-2553-6-git-send-email-tomoya-linux@dsn.okisemi.com>
In-Reply-To: <1311207599-2553-6-git-send-email-tomoya-linux@dsn.okisemi.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <3D60A4A2-3538-4B24-B65B-219D6ED7B219@gmail.com>
Content-Transfer-Encoding: 8BIT
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        alexander.stein@systec-electronic.com, qi.wang@intel.com,
        yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com
From: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Subject: gpio-pch: does not honour IRQF_ONESHOT?
Date: Thu, 8 Dec 2011 14:37:31 -0500
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I am using the interrupt function of gpio-pch.c. I have an adp5588 who's interrupt line goes into one of the
GPIO lines of a EG20T.

I have a patch (not yet submitted to lkml) which lets the platform control the IRQ flags for the chip. I had to
do this to allow the IRQ line to be shared. I used IRQF_SHARED | IRQF_ONESHOT | IRQF_TRIGGER_LOW.

Unfortunately, since all of the handling of the adp5588 is done in a thread function, the interrupt stays low
between the moment the hard handler is run and the 5588 function is run. Since pch_gpio_handler clears
the interrupt status right away, I get an interrupt storm for the pch_gpio_handler function.

the line that does "iowrite32(BIT(i), &chip->reg->iclr);" right before calling generic_handle_irq should be
executed only after the corresponding nested ISR has run it's thread function.

I am open to patching this and submitting, but I would like some pointers before I dive in.

Thanks for the help!
(and thanks Tomoya for the interrupt support ;)

On Jul 20, 2011, at 20:19, Tomoya MORINAGA wrote:

> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
> drivers/gpio/Kconfig    |    1 +
> drivers/gpio/gpio-pch.c |  187 +++++++++++++++++++++++++++++++++++++++++++++++
> 2 files changed, 188 insertions(+), 0 deletions(-)
> ...
