Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab2A0Xzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 18:55:48 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:60462 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751521Ab2A0Xzq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 18:55:46 -0500
MIME-Version: 1.0
In-Reply-To: <20120127140240.6b52c906@pyramind.ukuu.org.uk>
References: <CAFLxGvw85fWdsAodBn1Z0vFYZx0U+vYg6hgsBYbmfuyaFTgznA@mail.gmail.com>
	<58311.79.160.186.248.1327615864.squirrel@www.nlc.no>
	<CAFLxGvzsg71gtyPEtOAVnS-DtozYzqgoGNK-ZJRvBfq1mf3Oug@mail.gmail.com>
	<CAFLxGvzffs=uSjxogdWtk_gqoJHPnmgQSLw9WaZRr_be=J5cgw@mail.gmail.com>
	<20120127010838.GA27899@suse.de>
	<CAPXgP12Bj1K3j5HL1=GTj=xEC+oWgB7VFeQL_Pg23fCevTQAcw@mail.gmail.com>
	<CAFLxGvzth1m=iUmXbU2WyGrw0i8441d2nKLjH=mY_f1O-hkKPQ@mail.gmail.com>
	<20120127115143.1943336b@pyramind.ukuu.org.uk>
	<CAFLxGvwA3jjsbZ_-VN2oNUzmRzf01=2MN=SHCqv=u+57=T3Y7w@mail.gmail.com>
	<20120127140240.6b52c906@pyramind.ukuu.org.uk>
Date: Sat, 28 Jan 2012 00:55:45 +0100
Message-ID: <CAFLxGvzD3E3wDAWYObUbsKaDKZo3qmP=z7XxwyjPm2+5xnS=0g@mail.gmail.com>
Subject: Re: [uml-devel] /sys/class/tty/tty0/active?
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
        stian@nixia.no, LKML <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 3:02 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Fri, 27 Jan 2012 13:04:37 +0100
> richard -rw- weinberger <richard.weinberger@gmail.com> wrote:
>
>> On Fri, Jan 27, 2012 at 12:51 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> >> UML's console driver (arch/um/drivers/line.c) implements tty_operations.
>> >> The crash happens because the tty subsystem calls the driver's close()
>> >> function and later
>> >> write_room() or chars_in_buffer().
>> >>
>> >> write_room() and chars_in_buffer() fail badly because close() already
>> >> cleaned up the driver's private data...
>> >
>> > You don't want to do that.
>>
>> That's what i thought.
>>
>> >> Greg, is UML's assumption wrong that after closing the tty no call to
>> >> write_room() or chars_in_buffer() can happen?
>> >> I have no idea why systemd is able to trigger this, UML's console
>> >> driver is old and has always worked quite well.
>> >
>> > It's always been untrue but it's even more untrue nowdays. The tty layer
>> > objects are refcounted, and the code has had significant rewrites. line.c
>> > hidden away in uml hasn't been updated.
>> >
>> > I added a comment about 3 years ago pointing out another older change
>> > that was needed and that wasn't acted on either..
>> >
>> > Take a look at how all the other tty drivers use tty_port, how the ioctls
>> > have been supposed to work for the past few years and the callback
>> > changes, then use them.
>>
>> Can you recommend a well-written driver?
>
> drivers/mmc/card/sdio_uart.c
>
> uses just about all the features including handling hotplug and stuff you
> don't need.
>
> drivers/usb/serial/usb-serial.c
>
> may also be handy as it provides the interface but then calls into other
> driver code to do the work.
>
> Basically though you want a struct tty_port in your private data, either
> created at open, or usually more cleanly for the physical port lifetime
>
>        tty_port_init()
>
> Sets it up, then set the port ops
>
>        tty_port_open()
>        tty_port_close()
>        tty_port_hangup()
>
> do almost all of the rest of the work for you. They call back to your
> activate and shutdown port methods, they serialize them, they call them
> on first open/last close in matching pairs.
>
> For the tty itself
>
>        tty_port_tty_get()
>
> gets you a reference to the tty from the port (or NULL) - so handles a
> close/hangup racing with data arrival
>
>        tty_kref_put()
>
> releases a reference
>
> and
>        tty->ops->cleanup()
>
> is called on the final destruction of the tty object (ie its where you
> can free tty lifetime data in tty->private_data)
>
> So for a simple non pluggable tty it tends to look like
>
>        int my_tty_open(struct tty_struct *tty, struct file *filp)
>        {
>                tty->driver_data = &my_port;
>                return tty_port_open(&my_port, tty, filp);
>        }
>
>        void my_tty_close(struct tty_struct *tty, struct file *filp)
>        {
>                struct my_tty *m = tty->driver_data;
>                if (m == NULL)
>                        return;
>                tty_port_close(&m->port, tty, filp);
>        }
>
>        void my_tty_hangup(struct tty_struct *tty)
>        {
>                struct my_tty *m = tty->driver_data;
>                tty_port_hangup(&m->port);
>        }
>
> provide the needed callbacks and it'll do the locking and the like for
> you.
>
> On the ioctl side as far as I can see you should simply get rid of the
> method entirely.
>
> For buffer_data you might want to allocate the buffer sanely at open time
> (tty_port has a function for this too) so it can't fail weirdly
>
> And your termios method is a bit odd but makes sense if you are just
> pretending anything works and is supported.

Thanks for your help!
tty_port makes sense and I think I understood it.

But after modifying the driver to use tty_port the kernel crashes in
tty_io.c:__tty_fasync() because filp->f_path.dentry is NULL.

Any idea which kind of error can cause this?

-- 
Thanks,
//richard
