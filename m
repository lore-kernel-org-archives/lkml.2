Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab0JTMlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 08:41:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48984 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0JTMlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 08:41:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=NRm9RxIfXqDjQdKeuI2+aoT6Stc8jPLZ88iacgsJnV2MJdxjxS7sdRZKPSHGRFVaUg
         GwNqUBP/g6MpexGwoB5DX8nN6GN3gHZT3oN2aCUnh3YYB1mIvT2ClhoUKVp5OT4QoUO8
         dCYMB0pa0p8Ul0HNN4qadJgigYZRA8F1eOHZ4=
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: Re: [PATCH v5] GPIO: add support for 74x164 serial-in/parallel-out 8-bit shift register
Date: Wed, 20 Oct 2010 14:42:36 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-server; KDE/4.5.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Brownell <david-b@pacbell.net>, Willy Tarreau <w@1wt.eu>,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Miguel Gaio <miguel.gaio@efixo.com>, dbrownell@users.sourceforge.net,
        Juhos Gabor <juhosg@openwrt.org>
References: <201010182135.09506.florian@openwrt.org> <AANLkTi==o4dJSfuC5HT64ZWb0f3ZMG-hjTiK8Sh9UYoR@mail.gmail.com> <AANLkTi=EYsufd2Gq-p-8zRMVLz4xG7_z4aJ5G-1ZDOL3@mail.gmail.com>
In-Reply-To: <AANLkTi=EYsufd2Gq-p-8zRMVLz4xG7_z4aJ5G-1ZDOL3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010201442.36402.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 October 2010 10:17:32 Miguel Ojeda wrote:
> On Wed, Oct 20, 2010 at 9:52 AM, Miguel Ojeda
> 
> <miguel.ojeda.sandonis@gmail.com> wrote:
> > On Wed, Oct 20, 2010 at 1:00 AM, Andrew Morton
> > 
> > <akpm@linux-foundation.org> wrote:
> >> On Tue, 19 Oct 2010 09:26:42 +0200
> >> 
> >> Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
> >>> On Mon, Oct 18, 2010 at 9:35 PM, Florian Fainelli <florian@openwrt.org> 
wrote:
> >>> > From: Miguel Gaio <miguel.gaio@efixo.com>
> >>> > 
> >>> > This patch adds support for generic 74x164 serial-in/parallel-out
> >>> > 8-bits shift register. This driver can be used as a GPIO output
> >>> > expander.
> >>> 
> >>> ...
> >>> 
> >>> > +struct gen_74x164_chip {
> >>> > +       struct spi_device       *spi;
> >>> > +       struct gpio_chip        gpio_chip;
> >>> > +       struct mutex            lock;
> >>> > +       u8                      port_config;
> >>> > +};
> >>> 
> >>> ...
> >>> 
> >>> > +static void gen_74x164_set_value(struct gpio_chip *gc,
> >>> > +               unsigned offset, int val)
> >>> > +{
> >>> > +       struct gen_74x164_chip *chip = gpio_to_chip(gc);
> >>> > +       bool refresh;
> >>> > +
> >>> > +       mutex_lock(&chip->lock);
> >>> > +       if (val)
> >>> > +               chip->port_config |= (1 << offset);
> >>> > +       else
> >>> > +               chip->port_config &= ~(1 << offset);
> >>> 
> >>> set_bit(), clear_bit() ?
> >> 
> >> They're only to be used on `unsigned long' types, and `port_config' is
> >> u8.
> > 
> > Right as always! Maybe BIT()? Don't we have a {SET,CLEAR}_BIT()-like
> > macros somewhere?
> > 
> > #define SET_BIT(var,nr) (var) |= BIT((nr))
> > #define CLEAR_BIT(var,nr) (var) &= ~BIT((nr))
> > #define PUT_BIT(var,nr,value) do { \
> >        if ((value)) \
> >                SET_BIT((var), (nr)); \
> >        else \
> >                CLEAR_BIT((var), (nr)); \
> > } while(0)
> > 
> > May I make a patch and try to see who could use it? I suppose a
> > Coccinelle's semantic patch would be great here.
> 
> Well, after trying a few minutes spatch for my first time it has
> already found a lot of places where the macros could be applied. I
> will prepare a patch.

Though this is certainly valid, what's the benefit in using a macro to do that 
instead of open coding the toggle of a bit in a variable?
--
Florian
