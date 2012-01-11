Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655Ab2AKQjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 11:39:44 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57874 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757102Ab2AKQjm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 11:39:42 -0500
MIME-Version: 1.0
In-Reply-To: <1326258182.23910.105.camel@pasglop>
References: <1326156853-24840-1-git-send-email-dianders@chromium.org>
	<4F0CF61F.50705@gmail.com>
	<1326258182.23910.105.camel@pasglop>
Date: Wed, 11 Jan 2012 08:39:40 -0800
X-Google-Sender-Auth: XS1vVkXRVvalmJcOrhPSTyFZV7k
Message-ID: <CAD=FV=Uc7bhr4Knvr2Th5HVNnoF8TtBHZ7LTE6ZFYGUyNkgM4Q@mail.gmail.com>
Subject: Re: [PATCH] of: Support CONFIG_CMDLINE_EXTEND config option
From: Doug Anderson <dianders@chromium.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rob Herring <robherring2@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben,

Thank you for the review!  See below for a question...

On Tue, Jan 10, 2012 at 9:03 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>> > The new logic is now documented in of_fdt.h and is copied here for
>> > reference:
>> >
>> > - CONFIG_CMDLINE_FORCE=true
>> >     CONFIG_CMDLINE
>> > - CONFIG_CMDLINE_EXTEND=true
>> >     CONFIG_CMDLINE + dt bootargs (even if dt bootargs are empty)
>> > - CMDLINE_FROM_BOOTLOADER=true, dt bootargs=non-empty:
>> >     dt bootargs
>> > - CMDLINE_FROM_BOOTLOADER=true, dt bootargs=empty, @data is non-empty string
>> >     @data is left unchanged
>> > - CMDLINE_FROM_BOOTLOADER=true, dt bootargs=empty, @data is empty string
>> >     CONFIG_CMDLINE (or "" if that's not defined)
>> >
> So if CONFIG_CMDLINE_EXTEND=true, dt_bootargs is empty, and @data is non
> empty, I want CONFIG_CMDLINE + @data..

Before I go and recode, can you confirm this?  It doesn't seem to
match the help for CMDLINE_EXTEND, which says that the final command
line should be the kernel's base plus the bootloader's (not combining
the two separate ways that the kernel determined the cmdline).  Here's
the help string:

           The command-line arguments provided by the boot loader will be
           appended to the default kernel command string.

Instead, would you consider the following?  It would seem to match the
concept of @data being a higher-priority alternative to
CONFIG_CMDLINE:

- CONFIG_CMDLINE_EXTEND=true, @data is non-empty string
    @data + dt bootargs (even if dt bootargs are empty)
- CONFIG_CMDLINE_EXTEND=true, @data is empty string
    CONFIG_CMDLINE + dt bootargs (even if dt bootargs are empty)


In that, there would never be a case of combining @data and
CONFIG_CMDLINE, which I think is OK.


> So if you have CONFIG_CMDLINE_EXTEND, and have a command line in the
> device-tree, you just read it, concat with what's in data but ...
>
> the next node in the device-tree will hit the initial code above again
> which will overwrite what you just did with the content of
> CONFIG_CMDLINE (unless /chosen is the last node in the device-tree,
> probably why it might have worked for you once).
>
> It can still work ... as long as once you've hit the command line above,
> you clear overwrite_incoming_cmdline. You may also clear read_dt_cmdline
> for good measure.

Good catch here.  I didn't have a real test case where @data was set
to something before this function was called, so I unit tested that
particular scenario and didn't catch it there.

I may just move things back to only working properly if the DT has a
"chosen" attribute, like the old code did.  I don't need that fix, so
there's no reason to complicate this patch.


-Doug
