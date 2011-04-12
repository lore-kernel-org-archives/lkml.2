Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab1DLFlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 01:41:21 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:56676 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab1DLFlT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 01:41:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Tol+PVs6xkl3AFkAaCanaEsW958UwxOIOpJ3Qih0+FxbTY4pn3n/pWCmZda+lnXcFg
         ESIuBrQ3FP/Gqt+MuDyuGnou/yc6U/dLojmf6HuPrSX8MenDcvHyiVgDqv1GSVriI8Ks
         BH6W9TltukMYeTHVaENmPygXdLW9EWV4igqMU=
MIME-Version: 1.0
In-Reply-To: <20110411233506.GA13240@kroah.com>
References: <1302557114-7880-1-git-send-email-zajec5@gmail.com>
	<20110411210631.GA28559@kroah.com>
	<BANLkTim155YxMUVJ=pmVs-rNhkovGPG6OQ@mail.gmail.com>
	<20110411212513.GA17809@kroah.com>
	<BANLkTingqXAWTeOhcL6ER0UJfEdQF5Bo2A@mail.gmail.com>
	<20110411215619.GA27943@kroah.com>
	<BANLkTimjThXn347+=m98NsBXY84guJjNqA@mail.gmail.com>
	<20110411223632.GB31833@kroah.com>
	<BANLkTinpKKRCrBik6-9C5WqcSDGuEt5yCw@mail.gmail.com>
	<20110411233506.GA13240@kroah.com>
Date: Tue, 12 Apr 2011 07:41:18 +0200
Message-ID: <BANLkTi=cG3U8yXaQ6PusmNaWcr+AWv3e_w@mail.gmail.com>
Subject: Re: [RFC][PATCH V3] axi: add AXI bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        George Kashperko <george@znau.edu.ua>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        b43-dev@lists.infradead.org,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        Andy Botting <andy@andybotting.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/12 Greg KH <greg@kroah.com>:
> On Tue, Apr 12, 2011 at 12:45:33AM +0200, Rafał Miłecki wrote:
>> 2011/4/12 Greg KH <greg@kroah.com>:
>> > On Tue, Apr 12, 2011 at 12:12:47AM +0200, Rafał Miłecki wrote:
>> >> 2011/4/11 Greg KH <greg@kroah.com>:
>> >> > On Mon, Apr 11, 2011 at 11:36:39PM +0200, Rafał Miłecki wrote:
>> >> >> 2011/4/11 Greg KH <greg@kroah.com>:
>> >> >> > Please read the documentation for how to do this properly.  I find it
>> >> >> > really hard to believe that you wrote that comment instead of putting in
>> >> >> > the 2 lines of code required for this function.
>> >> >> >
>> >> >> > Especially as-it-is, your code does not work properly and leaks memory
>> >> >> > badly.  Why would you do that on purpose?
>> >> >>
>> >> >> I tried to read some documentation about this.
>> >> >>
>> >> >> 1) driver-mode/device.txt says only that:
>> >> >> > Callback to free the device after all references have
>> >> >> > gone away. This should be set by the allocator of the
>> >> >> > device (i.e. the bus driver that discovered the device).
>> >> >> I *really* do not know how my driver should "free" core on AXI bus.
>> >> >
>> >> > The structure that you have created, added to the bus, is now ready to
>> >> > have its memory freed.  So free it.
>> >> >
>> >> > This usually means something like:
>> >> >        struct my_obj = to_my_obj(dev);
>> >> >        kfree(my_obj);
>> >> > in the release function.
>> >>
>> >> I register core->dev to the bus (I set core->dev.bus and
>> >> core->dev.parent, is that what you mean?). This core->dev is "struct
>> >> dev" embedded in "struct axi_device". By embedded I mean it is *not* a
>> >> pointer, I do not alloc it, it's part of the "struct axi_device".
>> >
>> > That is exactly as it should be.
>> >
>> > Then in your release function, free the struct axi_device.  It's that
>> > simple.  To try to free it before then would be wrong and cause
>> > problems.
>>
>> This is because it is defined as:
>> struct axi_device cores[AXI_MAX_NR_CORES];
>
> No way, seriously?
>
> You can't do that, no static struct devices please.  Make these dynamic
> and everything will be fine.  The -mm tree used to have a huge warning
> if you ever tried to register a statically allocated struct, but that
> didn't really work out, but would have saved you a lot of time here,
> sorry.
>
> So dynamically allocate the structures and you will be fine.

Well, I saw that along kernel, I had no idea there is anything wrong
about this. It seems more ppl do not know about this:
struct radeon_ib	ibs[RADEON_IB_POOL_SIZE];
struct radeon_pm_clock_info clock_info[8];
struct radeon_pm_profile profiles[PM_PROFILE_MAX];
struct radeon_surface_reg surface_regs[RADEON_GEM_MAX_SURFACES];
struct radeon_i2c_chan *i2c_bus[RADEON_MAX_I2C_BUS];

struct b43_key key[B43_NR_GROUP_KEYS * 2 + B43_NR_PAIRWISE_KEYS];

struct ssb_device devices[SSB_MAX_NR_CORES];
I guess I could fine more examples by simple grepping .h files.

Is there some guide around with things like this we should avoid?
checkpatch does no catch this, so maybe just some manual? Could you
point me to it?

-- 
Rafał
