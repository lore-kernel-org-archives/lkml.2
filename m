Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab1BWBdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:33:07 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:51938 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab1BWBdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:33:05 -0500
Message-ID: <00ffee499c3a14f9f96aaf8575193dd9.squirrel@webmail.greenhost.nl>
In-Reply-To: <20110222130440.21a27714@jbarnes-desktop>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
    <20110216192658.GA7225@blimp.localdomain>
    <20110217221329.GA3332@x61.home>
    <3f792aaf90cf0b3d49be21baa2682d5d.squirrel@webmail.greenhost.nl>
    <AANLkTik20vCMhXqjxkoebZ1cWFb0zQLP5OZvVx4GWMPb@mail.gmail.com>
    <AANLkTik3ECs5z5td6GYuDExrc74_18mC-bk-hsq4e1+i@mail.gmail.com>
    <AANLkTik9XHcDUbPTPh6t--TwQompeQBY9TNuuBRk++-6@mail.gmail.com>
    <20110222130440.21a27714@jbarnes-desktop>
Date: Wed, 23 Feb 2011 02:32:58 +0100 (CET)
Subject: Re: [PATCH] fix backlight brightness on intel LVDS panel after 
     reopening lid
From: "Indan Zupancic" <indan@nul.nu>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Alex Riesen" <raa.lkml@gmail.com>,
        "DRI mailing list" <dri-devel@lists.freedesktop.org>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        stable@kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: 2c269fdec788119c0964d98755c55204
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, February 22, 2011 22:04, Jesse Barnes wrote:
> On Sat, 19 Feb 2011 15:07:49 -0800
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> On Sat, Feb 19, 2011 at 4:26 AM, Alex Riesen <raa.lkml@gmail.com> wrote:
>> > On Sat, Feb 19, 2011 at 13:11, Alex Riesen <raa.lkml@gmail.com> wrote:
>> >>> Lastly, could you verify that my patch at https://lkml.org/lkml/2011/2/16/447
>> fixes
>> >>> it for you too? (Make sure you're at max brightness before rebooting.)
>> >>
>> >> I'll try it now.
>> >>
>> >
>> > I can confirm that it does fix backlight in my case (Dell XPS 1330,
>> > LVDS panel, GM965/GL960).
>> >
>> > Tested-by: Alex Riesen <raa.lkml@gmail.com>
>>
>> Guys, should I apply this, or will I get it through somebody's pull?
>
> I'm worried that removing combo mode will break some working setups,
> but if it's seen a lot of testing and is ok, then I'm fine with it, as
> it definitely simplifies things.

This all seems new code added in 2.6.37, it wasn't there before. The working
setups stopped working when that code was added. The only reason it may work
for some gen 2 and gen 3 hardware is because of a random value of the max
brightness (bit 16).  The buggy code seems to be written in a haste without
any testing done. It's so off from the official documentation that I suspect
that the windows driver was used as reference, but its code was misinterpreted.

I grepped the userspace driver source, and LBPC is defined there for 810,
but not used anywhere either.

This patch should be added to stable kernel 2.6.37.2, because it messes
up the LPBC register, which some laptops store between boots.

Quoting https://bugzilla.kernel.org/show_bug.cgi?id=23472#c57

- Checking bit 16 in BLC_PWM_CTL is wrong, it has no special meaning.

- If LBPC == 0xff, it should be ignored and it's not in combination mode.
  (This is for gen 3).

- Gen 2 documentation doesn't mention LBPC or combination mode at all.
  Gen 3 does, but doesn't tell what the register value is or how to use it,
  it just mentions it.

- The calculations are rubbish, resulting in bogus LBPC values, and
  depending on how lucky you are, it writes different values for the
  registers after a restore.

All this code is new and causes problems, while everything worked before
just fine, when the driver didn't do anything special.

So it seems a bit like voodoo programming, because nothing the driver did
followed the official Intel documentation.

Now, there may be real reasons for some of the code, but I propose we add
them one at a time when people show up with problems without the weird code
added. That way the reason for any weirdness is also documented.

Greetings,

Indan


