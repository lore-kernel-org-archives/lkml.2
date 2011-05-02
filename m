Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab1EBVaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:30:24 -0400
Received: from smtp-out.google.com ([216.239.44.51]:50095 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab1EBVaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:30:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RjuffsBnq67oUTksEFvMywB+Qx5hCz6VQWFah1GPzV7utGajDFXkPvwB/1dJMNsSeX
         UU4S6ntl9tjw447t6EOg==
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF0497F1B201@HQMAIL01.nvidia.com>
References: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF0497F1B201@HQMAIL01.nvidia.com>
Date: Mon, 2 May 2011 14:30:10 -0700
Message-ID: <BANLkTimKU-=GXzrn8=MQn-GAmKHOvKmuNQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] drivers: create a pinmux subsystem
From: Colin Cross <ccross@google.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Erik Gilling <konkers@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 2, 2011 at 1:52 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Monday, May 02, 2011 1:16 PM:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> This creates a subsystem for handling of pinmux devices. These are
>> devices that enable and disable groups of pins on primarily PGA and
>> BGA type of chip packages and common in embedded systems.
>
> I would avoid any references to particular package types; I've seen
> pinmuxing applied to PLCC and DIP/DIL too, and in general, it's possible
> irrespective of package type.
>
>> This is being done to depopulate the arch/arm/* directory of such
>> custom drivers and try to abstract the infrastructure they all
>> need. See the Documentation/pinmux.txt file that is part of this
>> patch for more details.
>
>> diff --git a/Documentation/pinmux.txt b/Documentation/pinmux.txt
>>...
>> +The mux settings are:
>> +
>> +- Oriented around enumerated physical pins or pads denoted by unsigned
>> +  integers in the range 0..MAX_INT. Every pin on your system (or atleast
>> +  every pin that can be muxed) should have a unique number. The numberspace
>
> Does this imply a model where each pin's "special function" can be
> controlled independently? I think reading through the document that
> isn't the case, but I just wanted to be sure.
>
> In particular, NVIDIA Tegra has a setup where:
>
> * Pinmux configuration for "special functions" is at a "pad-group"
>  level, where there may be 1..N pins in a pad-group, and there is a
>  single register field that defines the current special function routed
>  to/from all pins in that pad-group at once.
>
> * Each pad group can be assigned 1 of N special functions (none might be
>  an option in some/all cases too)
>
> * Some special functions may be assignable to multiple pad groups,
>  although obviously only 1 pad group per function at a time.
>
> * GPIO selection is at per-pin granularity; individual pins may be used
>  as a GPIO irrespective of what SFR is selected for the pad group
>  containing the pin.
>
> * There are also other configurations associated with pinmuxing, such
>  as drive strength, pull up/down enables, etc.
>
> Also, some of our drivers use "dynamic pinmuxing". For example, our
> downstream I2C driver exposes N I2C busses and reprograms the pinmux
> at runtime to attach the actual I2C controller to different sets of
> pins, essentially multi-plexing the control across N physical busses.

Tegra has more fun pinmux quirks than just those :)

* Drive strength is also controlled through groups of pins, but
different groups than pinmux.  Most of the drive strength groups are
collections of pad mux groups, but there are a few pins that are in
the same pad mux group but a different drive strength group.
* Setting a pin as a GPIO overrides its group's mux setting, except
for the group's tristate.  You must untristate the entire group to use
a single pin as a GPIO.
* Each group has a "safe mode", but which mux id to select to enter
the safe mode is completely random.

In the end, we determined that there was no way to sanely handle
setting up Tegra's pinmux programatically, and instead required each
board to pass in a table of pinmux settings.
