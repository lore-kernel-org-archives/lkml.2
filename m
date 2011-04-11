Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab1DKWMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 18:12:50 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34181 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab1DKWMs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 18:12:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hjMtKTOpWlvElAt/L/Rkw6+08hb2GJ1Z0fcbYHNW9PMcO+YENxIMVkx4VwhTsOA0gI
         Vz4emjH+m/mfo1FrwTARO3F9kY9QATxlgtDOzP/iqlZPsyYXF1dR01B6FkHFIlrnSJQT
         aUeaN0OTIBepjR7fayPEWyOnlWvTza299fau0=
MIME-Version: 1.0
In-Reply-To: <20110411215619.GA27943@kroah.com>
References: <1302557114-7880-1-git-send-email-zajec5@gmail.com>
	<20110411210631.GA28559@kroah.com>
	<BANLkTim155YxMUVJ=pmVs-rNhkovGPG6OQ@mail.gmail.com>
	<20110411212513.GA17809@kroah.com>
	<BANLkTingqXAWTeOhcL6ER0UJfEdQF5Bo2A@mail.gmail.com>
	<20110411215619.GA27943@kroah.com>
Date: Tue, 12 Apr 2011 00:12:47 +0200
Message-ID: <BANLkTimjThXn347+=m98NsBXY84guJjNqA@mail.gmail.com>
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

2011/4/11 Greg KH <greg@kroah.com>:
> On Mon, Apr 11, 2011 at 11:36:39PM +0200, Rafał Miłecki wrote:
>> 2011/4/11 Greg KH <greg@kroah.com>:
>> > Please read the documentation for how to do this properly.  I find it
>> > really hard to believe that you wrote that comment instead of putting in
>> > the 2 lines of code required for this function.
>> >
>> > Especially as-it-is, your code does not work properly and leaks memory
>> > badly.  Why would you do that on purpose?
>>
>> I tried to read some documentation about this.
>>
>> 1) driver-mode/device.txt says only that:
>> > Callback to free the device after all references have
>> > gone away. This should be set by the allocator of the
>> > device (i.e. the bus driver that discovered the device).
>> I *really* do not know how my driver should "free" core on AXI bus.
>
> The structure that you have created, added to the bus, is now ready to
> have its memory freed.  So free it.
>
> This usually means something like:
>        struct my_obj = to_my_obj(dev);
>        kfree(my_obj);
> in the release function.

I register core->dev to the bus (I set core->dev.bus and
core->dev.parent, is that what you mean?). This core->dev is "struct
dev" embedded in "struct axi_device". By embedded I mean it is *not* a
pointer, I do not alloc it, it's part of the "struct axi_device".


>> 2) LDD3 says:
>> > The method is called when the last reference to the device is removed; it is called
>> > from the embedded kobject’s release method. All device structures registered with
>> > the core must have a release method, or the kernel prints out scary complaints.
>> Well, I do not register any structs for AXI core.
>
> Yes you did, otherwise you would have never seen that callback warning
> you that you needed a release function.

I was thinking about alloc, sorry, ignore this one.


>> 4) SSB in it's ssb_release_dev just calls kfree on struct that was
>> allocated when registering drivers. *I do not* allocate such a struct,
>> so I believe I do exactly the same memory leak as SSB does.
>
> Well someone allocated it, right?  Who did it?  If it wasn't you, where
> did that structure come from and why are you registering it on your bus?
>
>> Can you spend 2 more minues in addition to commenting my ideas and
>> help me with writing that 2 lines I missed? Where do I leak memory in
>> my driver? Which struct should I kfree?
>
> The structure that you wrap around 'struct device' for your bus.

As explained above, this I do not dynamically alloc this 'struct
device'. So is there really any memory leak?

-- 
Rafał
