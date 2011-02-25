Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab1BYPeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 10:34:06 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50420 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab1BYPeE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 10:34:04 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=2a=9=k+ZG46yqKOaHd9tCkJVm4QRxGmgbRzsv@mail.gmail.com>
References: <20110219150644.681D59D401D@zog.reactivated.net>
 <AANLkTi=29myerzgH6WRCSOPKpaDnGgEtQacVHvxRoQT_@mail.gmail.com> <AANLkTi=2a=9=k+ZG46yqKOaHd9tCkJVm4QRxGmgbRzsv@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 25 Feb 2011 08:33:44 -0700
X-Google-Sender-Auth: HNGBCqq-H_wTIWeYFVemwok7VWg
Message-ID: <AANLkTimpWxEvQ1wgQzZ2RRA=0s_hEmKFAyz1bVr8nKai@mail.gmail.com>
Subject: Re: [PATCH] olpc_battery: bind to device tree
To: Daniel Drake <dsd@laptop.org>
Cc: devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        linux-kernel@vger.kernel.org, dilinger@queued.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 7:19 AM, Daniel Drake <dsd@laptop.org> wrote:
> On 23 February 2011 20:34, Grant Likely <grant.likely@secretlab.ca> wrote:
>> As mentioned in the other thread, matching by name is strongly
>> discouraged.  It isn't very accurate and compatible is the preferred
>> method for binding devices.  'battery' in particular is highly
>> non-specific.
>>
>> I do understand that you don't have a compatible property in the
>> current firmware, and to a certain extent we have to live with what
>> we're given by the kernel.  However, I think it would be better in the
>> OLPC case to find the battery node and add a compatible property
>> before registering a platform_device for it.  (or use a bus notifier
>> to tell you when it is registered, and add 'compatible' at that
>> point.)  That way we the uncertainty is taken care of in the board
>> support code without polluting the driver matching namespace.
>
> Thanks for the review. This and the rest of your feedback makes sense.
>
> Would you mind commenting on exactly how this should look?

Before calling of_platform_bus_probe(), search the device tree for the
battery node and use prom_add_property() to add a compatible prop.

>
> Here are the changes i'm planning to make, both to the firmware and
> with kernel code as you suggest to fixup device trees for systems with
> old firmware:
>
> /battery@0/compatible property added with value "olpc-battery" (XO-1 and XO-1.5)
> /pci/isa@f/rtc@i70/compatible property prepended with "olpc-xo1-rtc,"
> (XO-1 only)
> /pci/display@1,1/dcon device added, name=dcon compatible=olpc-dcon
> (XO-1 and XO-1.5)

Compatible properties should generally be in the form:
"<vendor>,<part>".  So these should probably be:

battery:  compatible = "olpc,xo1-battery";
rtc: compatible = "olpc,xo1-rtc";
dcon: compatible = "olpc,xo1-dcon";

I would explicitly specify the "xo1-" part in all three to protect
against the eventuality of a new xo revision that has does something
incompatible.  ie. "olpc-battery" doesn't help if, say, XO-1.75 has a
different battery.  Newer configurations can claim compatibility with
the old if they are truly compatible.

>
> In addition to the battery patch you reviewed, we plan to make the
> olpc-rtc and DCON drivers bind to device tree nodes, which is the
> reason behind the other changes.

okay.

g.
