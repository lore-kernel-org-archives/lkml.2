Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3ADMvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 07:51:23 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:50726 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab3ADMvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 07:51:21 -0500
Message-ID: <50E6D01D.6040304@ahsoftware.de>
Date: Fri, 04 Jan 2013 13:50:37 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Shawn Guo <shawn.guo@linaro.org>, Sasha Levin <levinsasha928@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <florianSchandinat@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fbdev@vger.kernel.org, Bernie Thompson <bernie@plugable.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH] fb: Rework locking to fix lock ordering on takeover
References: <20121116192606.11799.35711.stgit@localhost.localdomain> <CA+5PVA6nKNZY70UoeDUhQo9Rj4Ck+k+XTHL++gwErgzqAdy6Aw@mail.gmail.com> <20121121125310.00625f55@pyramind.ukuu.org.uk> <CA+5PVA5iQwYOcoSYtLOoRBHaTNJANdv+X-C78474n3SzZg_m9w@mail.gmail.com> <CA+1xoqe0G4rha5bDcoQQUcACYbQ8BCO7AE_JE8z5VjJLeNUdyA@mail.gmail.com> <CAM_iQpWLgnxQR+oYD+Dnh9NprR1-QLjXa6T+dtHUs3A-_N2wmQ@mail.gmail.com> <CA+1xoqf0d5ckDZ3o1-Y+qd61nvVA7EECeH20U+WjDpNVb4E=pw@mail.gmail.com> <20121227045301.GB17472@x1.alien8.de> <20121228115022.GA28009@S2101-09.ap.freescale.net> <20121228124026.GB12918@x1.alien8.de>
In-Reply-To: <20121228124026.GB12918@x1.alien8.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 28.12.2012 13:40, schrieb Borislav Petkov:
> On Fri, Dec 28, 2012 at 07:50:27PM +0800, Shawn Guo wrote:
>> +1
>>
>> http://thread.gmane.org/gmane.linux.kernel/1413953/focus=1415070
>
> Cool, works fine here too. Is Linus on CC? (/me checks.. ) Yes he is,
> good.
>
> Linus, Alan's patch works at least in 2 cases, you might consider
> picking it up directly since the fb maintainer is absent, reportedly.


Btw. I think all the usb-fb's (udlfb, smscufx and udl) are broken, at 
least on ARM(v5). When I have linked in udlfb the following happens on 
boot (with an attached USB-LCD and with or without the "Rework locking 
patch):

dlfb_init_framebuffer_work() (work)
         register_framebuffer() (lock mutex registration_lock)
                 (vt_console_print) (spinlock printing_lock)
                 (fbcon_scroll)
                 (fbcon_redraw)
                 (fbcon_putcs)
                 (bit_putcs)
                 dlfb_ops_imageblit()
                         dlfb_handle_damage()
                                 dlfb_get_urb()
                                         down_timeout(semaphore)
					BUG: scheduling while atomic
                 (vt_console_print) (release spinlock printing_lock)
         register_framebuffer() (unlock mutex registration_lock)

The above is without the "Rework locking" patch. But I get the same BUG 
with the patch (so the patch doesn't do any harm), I just haven't looked 
in detail what changed with the patch.

I don't get the BUG when I try the same on a x86_64 machine, not sure 
why. I've just started to read me through the code, documentation and 
the "Rework locking" patch. And I'm slow in doing so (spare time).
But maybe someone else with more knowledge about the inner workings of 
this stuff is faster than I.

Regards,

Alexander
