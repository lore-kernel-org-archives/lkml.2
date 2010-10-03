Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab0JCUZj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 16:25:39 -0400
Received: from n2-vm1.bullet.mail.gq1.yahoo.com ([67.195.23.155]:36685 "HELO
	n2-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754609Ab0JCUZh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 16:25:37 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 653468.56056.bm@omp131.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=K68RBK7kQhDWF4qVHgg9OFgKKAA1aET8FE0qgJ572nFK6BXCPFFjmJ+iRL5RAvQmsRTBHEqjLIhfvAz3HzmZL4mEcaBFWEC0LFTvDwbngrgUh0Bx3djkT8CMu3YQxiWXG3hyjJqCwAQUfFgmfoGv6R934zp5acMkR+azSdjp3Kw=;
Message-ID: <568203.56459.qm@web180308.mail.gq1.yahoo.com>
X-YMail-OSG: luLHLSMVM1kVRFKzkemV8dsLCG5hhozyMPA2WKSIIIc9c8Y
 9nDJONP4tUcygmI_ot17f1Z5cV4.B2qsScdYY5_cER4PN_wFew6rl_7sjsFb
 c3LkMra1LLU7yW3JLSa86A3FvgfwAHTP40SSWN3OZP5PwO3mnbBEjVFvQ29A
 NvlcGVHQtFf6dGvEa29oQMKZQTxOM1l.aUoG4d5SkRfm0nZmwxr8aAuFFOnM
 5BpNu2G5AgvoBsp9v9Jej5.Dcm_V2n5n5e6mz.xxuLkLL8YAvPW.cXBl3kVe
 iBic09x4fecnz0iUJyHn8JhzOHKH_u4ufn5CcG1O3_OIlxopBU57as0MNF7G
 NjpQCcMRKAiFyKUUFX.h06M5tVXjqJwdft4scknbIemaIDlhJ6389DA--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.105.279950
Date: Sun, 3 Oct 2010 13:25:36 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [RFC/PATCH 2/2] usb:gadget: Add SuperSpeed support to the Gadget Framework
To: linux-usb@vger.kernel.org, tlinder <tlinder@codeaurora.org>
Cc: Tatyana Linder <tlinder@codeaurora.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Robert Lukassen <robert.lukassen@tomtom.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Fabien Chouteau <fabien.chouteau@barco.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1286092937-29191-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Sun, 10/3/10, tlinder <tlinder@codeaurora.org> wrote:

> In order not to force all the FDs to supply 

What do File Descriptors have to do with this?

If you don't mean FD == File Descriptor, then
please spell out what you do mean, instead of
trying to repurpose a widely used abbreviation.


SuperSpeed
> descriptors when
> operating in SuperSpeed mode the following approach was
> taken:
> If we're operating in SuperSpeed mode and the FD didn't
> supply SuperSpeed
> descriptors, the composite layer will automatically create
> SuperSpeed
> descriptors with default values.

That bothers me in two ways.  First, I want to
see a solution that maintains today's policy where
the composite framework is optional for all gadget
drivers.

Second, that kind of automagic bothers me.

What could be wrong with expecting gadget
drivers to provide all the descriptors they need,
instead of introducing automagic?


> Support for new SuperSpeed BOS descriptor was 

Wireless USB BOS descriptors exist too, yes?  Does
this approach cover them, or just SuperSpeed?  (We
may someday want to support Wireless USB on the
peripheral/gadget side too...



> +++++++++++++++++++++++++++++++++++++---
>  include/linux/usb/ch9.h

I like to see patches related to USB-IF formats
and protocols be separate from functional changes
in the USB stack or its drivers. which may rely
on those formats/protocols; less entanglement.
       
> +

> +config USB_GADGET_SUPERSPEED
> +    boolean "Gadget opperating in Super
> Speed"
> +    depends on USB_GADGET
> +    depends on USB_GADGET_DUALSPEED
> +    default n
> +    help
> +      Enabling this feature enables
> Super Speed support in the Gadget
> +      driver. It means that gadget
> drivers should include extra (SuperSpeed)
> +      descriptors.

That is:  the automagic isn't needed.  The
concepts in this patch seem to be a bit on
the self-contradictory side...

ep_comp_desc = {
> +        .bDescriptorType =
> USB_DT_SS_ENDPOINT_COMP,
> +        .bLength = 0x06,
> +        .bMaxBurst = 0,
> /*the default is we don't support bursting*/

I've not followed the SuperSpeed stuff as closely
as I might, but ... doesn't bursting require some
hardware support?  So that not all UDC + driver
stacks can support it?   (That'd be a case, if so,
for more sanity checks ... and the gadget driver to
explicitly say if it handles bursting.



