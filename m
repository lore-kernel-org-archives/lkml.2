Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab1EDKhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 06:37:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57511 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab1EDKhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 06:37:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ABHH3A094gvtIGs4Dw5gVdtY+nfINqtEmYDKYobrcquUShaAox9ZpJiDNcqdo+ezTw
         90QgQI8DV706g+jkhPlHXHl3r5Wy1TpxAvtP2BYCuDZl8slKG/iyRLo8PZZZEUB42sYd
         UtOiiBKwbU+zoyF1Lg3eLPRmjgSbA8KCUVIow=
Date: Wed, 4 May 2011 14:36:57 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, tglx@linutronix.de, arnd@arndb.de,
        nico@fluxnic.net, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCHv3 0/7] gpio: extend basic_mmio_gpio for different
 controllers
Message-ID: <20110504103657.GA23772@oksana.dev.rtsoft.ru>
References: <1302520914-22816-1-git-send-email-jamie@jamieiles.com>
 <20110503210950.GA2866@ponder.secretlab.ca>
 <BANLkTi=5Ad7_9_fVMCcJ7MfM5Ns8q9qqsQ@mail.gmail.com>
 <20110503215211.GA8491@oksana.dev.rtsoft.ru>
 <20110503220408.GA6978@pulham.picochip.com>
 <20110503223415.GA14024@oksana.dev.rtsoft.ru>
 <20110504000055.GA4008@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110504000055.GA4008@ponder.secretlab.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 06:00:55PM -0600, Grant Likely wrote:
[...]
> From the device tree use-case, I personally still prefer a binding
> that provides a single 'reg' entry for the register block and explicit
> offsets in the binding to specify where/how the gpio registers are
> layed out.  It just fits better with existing binding practices.

Hm. AFAIK, it's quite the reverse. Existing device-tree bindings
practices prefer per-bank device bindings. Ie. MPC8xxx, CPM, QE,
Simple GPIOs, etc.

> Also, if you're talking about a gpio device with, say, 128 gpios on an
> soc, then the natural binding probably will be to have a single device
> tree node covering all 4 banks because that is the way the
> documentation lays out the device.  Perhaps something like this
> (completely off the top of my head):
> 
> gpio@fedc0000 {
> 	compatible = "acme,super-soc-gpio", "mmio-gpio";
> 	reg = <0xfedc0000 0x100>;
> 	gpio-controller;
> 	#gpio-cells = <1>;
> 
> 	mmgpio-regoffset-data = <0x00 0x04 0x08 0x0c>;
> 	mmgpio-regoffset-dir  = <0x20 0x24 0x28 0x2c>;
> 	mmgpio-regoffset-set  = <0x10 0x14 0x18 0x1c>;
> 	mmgpio-regoffset-clr  = <0x30 0x34 0x38 0x3c>;
> };
> 
> ... where an array of regoffset values allows for multiple banks.
> Although this might be completely insane and it would be better to
> make the kernel key directly off the 'acme,super-soc-gpio' value.

Oh, I really don't understand why you advocate this approach. It
gives us nothing, except maybe saving a few lines in the device
tree, but in return you abuse hierarchy (you flatten it). From the
hardware point of view, it's even worse -- the bindings would not
let us describe bank's power properties, sleep/wake behaviour etc.
Or this will lead to something like the ugly
mmgpio-sleep = <0 1 1 1>; maps.

I understand that with bgpio library both approaches may easily
coexist, so I'm mostly talking about device tree bindings here.

IMO, the thing we should approach with device tree is these bindings
(example from arch/powerpc/boot/dts/mpc832x_rdb.dts):

                par_io@1400 {
                        #address-cells = <1>;
                        #size-cells = <1>;
                        reg = <0x1400 0x100>;
                        ranges = <3 0x1448 0x18>;
                        compatible = "fsl,mpc8323-qe-pario";

                        qe_pio_d: gpio-controller@1448 {
                                #gpio-cells = <2>;
                                compatible = "fsl,mpc8323-qe-pario-bank";
                                reg = <3 0x18>;
                                gpio-controller;
                        };

			... more banks here ...
                }

Note that in this case bank's reg specifies the whole registers range,
which should be split into several reg entries (inside the reg = <>,
not reg-stuff1, reg-stuff2 thing).

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
