Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453Ab0LCJQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 04:16:39 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35907 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab0LCJQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 04:16:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=oFjjZztbo5gOyG7uUEtDnAJg3RSGB3HmaBK+f74xmj0xfHAlXPK1FGX80g2BJBRgFC
         sCPn7goLetoxNfjcwdfxix7OaH+AKLcz/LvyF4XGoLt10gTn2s43ZQZfrxr/eUqfPybg
         o+6o0dUHfSPfB/Alz1c9R8ZdnmkbkXYYBDGm8=
MIME-Version: 1.0
In-Reply-To: <20101029172443.61f7b067@pyx>
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com>
	<20101022135130.617f0ce8@lxorguk.ukuu.org.uk>
	<AANLkTinj93zAXJAipB3HjE62Xa1Z=9k9gPBxaT=+MLtg@mail.gmail.com>
	<20101029172443.61f7b067@pyx>
Date: Fri, 3 Dec 2010 10:16:25 +0100
Message-ID: <AANLkTimiyxiKzT=9pKXLFACkc6C=nTD2dtBR7PcgjhOL@mail.gmail.com>
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
From: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linus.walleij@stericsson.com, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/29 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>> The reason is that the work is generated so often that a work is not
>> finished before next work of same type comes. This is especially true
>> for transmit and receive. Then I get 0 back when queuing the work and
>> there is no real way to solve it from what I can see than to allocate
>> new work structures every time.
>
> So if that is the case what bounds your memory usage - can a busy box end
> up with thousands of work queue slos used ? It sounds like your model is
> perhaps wrong - if there is a continual stream of work maybe you should
> simply have a kernel thread to handle it if it cannot be deferred
> - remember ldisc code is able to sleep in most paths.
>
>

Hi Alan,

I went through my old mails here and realized I hadn't answered you
for this question.
Basically most of the time we are able to handle the works in time for
the next work to be created. But there are occasions where next work
is created really quickly and we end up with an error situation when
starting the work. But if we allocate the work it will then be handled
when the first one is ready. It's not like we will never handle it.
The data transfers can be received in a bit bursty way and then there
are no interrupts for a while. So in the end all works are handled
rather quickly and queue will never build up. We have tested with
several large file transfers and data pumps without issues.

By the way, I will soon release a new patch set for CG2900 (hopefully
next week), which contains major rework. It's hard to explain
everything here and now but changes include:
 - Reuse of existing HCI line discipline under /drivers/bluetooth/.
Line discipline has been modified so it is selectable from protocol if
line discipline should register to Bluetooth stack or not.
 - Architecture modification: core, chip, and transport is new created
from platform specific files (/arch/). Each chip file then spawns MFD
devices for the channels it support.
 - Core file now only handles detection of connected chip. All chip
dependent code is moved to transport and chip files.

/P-G
