Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab1ECVNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 17:13:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63336 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab1ECVNk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 17:13:40 -0400
MIME-Version: 1.0
In-Reply-To: <20110503210950.GA2866@ponder.secretlab.ca>
References: <1302520914-22816-1-git-send-email-jamie@jamieiles.com> <20110503210950.GA2866@ponder.secretlab.ca>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 3 May 2011 15:13:20 -0600
X-Google-Sender-Auth: z68PDoSco3ePFXqO9nQqh1cfHOo
Message-ID: <BANLkTi=5Ad7_9_fVMCcJ7MfM5Ns8q9qqsQ@mail.gmail.com>
Subject: Re: [PATCHv3 0/7] gpio: extend basic_mmio_gpio for different controllers
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        cbouatmailru@gmail.com, arnd@arndb.de, nico@fluxnic.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, forgot to cc tglx...

On Tue, May 3, 2011 at 3:09 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Mon, Apr 11, 2011 at 12:21:47PM +0100, Jamie Iles wrote:
>> Updated from v2 with change to use the set/dat registers for input/output
>> register pair devices and removed some rebasing breakage.
>>
>> Jamie Iles (7):
>>   basic_mmio_gpio: remove runtime width/endianness evaluation
>>   basic_mmio_gpio: convert to platform_{get,set}_drvdata()
>>   basic_mmio_gpio: allow overriding number of gpio
>>   basic_mmio_gpio: request register regions
>>   basic_mmio_gpio: detect output method at probe time
>>   basic_mmio_gpio: support different input/output registers
>>   basic_mmio_gpio: support direction registers
>>
>>  drivers/gpio/basic_mmio_gpio.c  |  390 +++++++++++++++++++++++++++++++--------
>>  include/linux/basic_mmio_gpio.h |    1 +
>>  2 files changed, 311 insertions(+), 80 deletions(-)
>
> Hey Jamie,
>
> Thanks a lot for putting this series together.
>
> While on the topic of a generic mmio gpio driver, I've been thinking a
> lot about things that Alan, Anton, and others have been doing, and I
> took a good look at the irq_chip_generic work[1] that tglx (cc'd) put
> together.
>
> There are two things that stood out.  Alan pointed out (IIRC) that a
> generic gpio driver should not require each bank to be encapsulated in
> a separate struct platform_device, and after mulling over it a while I
> agree.  It was also pointed out by Anton that often GPIO controllers
> are embedded into other devices register addresses intertwined with
> other gpio banks, or even other functions.
>
> In parallel, tglx posted the irq_chip_generic patch[1] which has to
> deal with pretty much the same set of issues.  I took a close look at
> how he handled it for interrupt controllers, and I think it is
> entirely appropriate to use the same pattern for creating a
> gpio_mmio_generic library.
>
> [1] http://comments.gmane.org/gmane.linux.ports.arm.kernel/113697
>
> So, the direction I would like to go is to split the basic_mmio_gpio
> drivers into two parts;
>  - a platform_driver, and
>  - a gpio_mmio_generic library.
>
> The platform driver would be responsible for parsing pdata and/or
> device tree node data, but would call into the gpio_mmio_generic
> library for actually registering the gpio banks.
>
> I envision the gpio_mmio_generic library would look something like
> this:
>
> First, a structure for storing the register offsets froma  base
> address:
>
> struct gpio_mmio_regs {
> };
>
> Next, a structure for each generic mmio gpio instance:
>
> struct gpio_mmio_generic {
>        spinlock_t      lock;
>
>        /* initialized by user */
>        unsigned long   reg_data;
>        unsigned long   reg_set;
>        unsigned long   reg_clr;
>        unsigned long   reg_dir;
>
>        void __iomem    *reg_base;
>
>        /* Runtime register value caches; may be initialized by user */
>        u32             data_cache;
>        u32             dir_cache;
>
>        /* Embedded gpio_chip.  Helpers functions set up accessors, but user
>         * can override before calling gpio_mmio_generic_add() */
>        struct gpio_chip chip;
> };
>
> And then some helpers for initializing/adding/removing the embedded gpio_chip:
>
> void gpio_mmio_generic_setup(struct gpio_mmio_generic *gmg, int register_width);
> int gpio_mmio_generic_add(struct gpio_mmio_generic *gmg);
> void gpio_mmio_generic_remove(struct gpio_mmio_generic *gmg);
>
> gpio_mmio_generic_setup() sets up the common callback ops in the
> embedded gpio_chip, but the decisions it makes could be overridden by
> the user before calling gpio_mmio_generic_add().
>
> I've not had time to prototype this yet, but I wanted to get it
> written down and out onto the list for feedback since I probably won't
> have any chance to get to it until after UDS.  Bonus points to anyone
> who wants to take the initiative to hack it together before I get to
> it.  Extra bonus points to anyone who also converts some of the other
> gpio controllers to use it.  :-D

And triple bonus points to anyone who thinks this is stupid and comes
up with a better approach.  :-)

g.
