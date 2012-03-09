Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab2CIOkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 09:40:20 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60358 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754444Ab2CIOkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 09:40:17 -0500
Date: Fri, 9 Mar 2012 15:40:13 +0100
From: Johan Hovold <jhovold@gmail.com>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] bluetooth: hci_ldisc: fix NULL-pointer dereference
 on tty_close
Message-ID: <20120309144013.GE4497@localhost>
References: <1331136120-27075-1-git-send-email-jhovold@gmail.com>
 <1331136120-27075-2-git-send-email-jhovold@gmail.com>
 <1331148797.3392.191.camel@aeonflux>
 <20120308115721.GB4497@localhost>
 <1331228722.14217.7.camel@aeonflux>
 <20120309130413.GC4497@localhost>
 <CANq1E4RjnCdUfZuKawHs2te9wX30H-boC5tUPFarBCVbtn2n5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANq1E4RjnCdUfZuKawHs2te9wX30H-boC5tUPFarBCVbtn2n5Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 02:52:00PM +0100, David Herrmann wrote:
> On Fri, Mar 9, 2012 at 2:04 PM, Johan Hovold <jhovold@gmail.com> wrote:
> > On Thu, Mar 08, 2012 at 09:45:22AM -0800, Marcel Holtmann wrote:
> >> > > > Do not close protocol driver until device has been unregistered.
> >> > > >
> >> > > > This fixes a race between tty_close and hci_dev_open which can result in
> >> > > > a NULL-pointer dereference.
> >> > > >
> >> > > > The line discipline closes the protocol driver while we may still have
> >> > > > hci_dev_open sleeping on the req_lock mutex resulting in a NULL-pointer
> >> > > > dereference when lock is acquired and hci_init_req called.
> >> >
> >> > [...]
> >> >
> >> > > what kernel version is this against? Our changes in bluetooth-next fixed
> >> > > some of the destruct handling.
> >> >
> >> > This is against the latest rc as it needs to be fixed in 3.3, but I
> >> > missed a dependency to bluetooth-next as you point out below.
> >> >
> >> > > Also hci_unregister_dev should be calling the destruct handler and thus
> >> > > your change is now accessing hu but it got freed already.
> >> >
> >> > You're right, my patch depends on 010666a126fc ("Bluetooth: Make
> >> > hci-destruct callback optional") and 797fe796c4 ("Bluetooth: uart-ldisc:
> >> > Fix memory leak and remove destruct cb") from bluetooth-next.
> >> >
> >> > But since the latter one fixes a memory leak it should have been marked
> >> > for stable as well as pushed to Linus for 3.3, right?
> >>
> >> we need to look into this and propose patches for -stable. Is your
> >> problem still present with bluetooth-next or not?
> >
> > Yes, both races are present in bluetooth-next of today (b8622cbd58f34)
> > and only takes an additional manual step to trigger (as the core no
> > longer tries to open the device twice automatically).
> >
> > My two patches on top of either the two patches by David Herrmann
> > mentioned above or the following minimal fix of the same memory leak
> > would be sufficient to fix both races in 3.3:
> >
> > diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
> > index 0711448..97c5faa 100644
> > --- a/drivers/bluetooth/hci_ldisc.c
> > +++ b/drivers/bluetooth/hci_ldisc.c
> > @@ -237,7 +237,6 @@ static void hci_uart_destruct(struct hci_dev *hdev)
> >                return;
> >
> >        BT_DBG("%s", hdev->name);
> > -       kfree(hdev->driver_data);
> >  }
> >
> >  /* ------ LDISC part ------ */
> > @@ -316,6 +315,7 @@ static void hci_uart_tty_close(struct tty_struct *tty)
> >                                hci_free_dev(hdev);
> >                        }
> >                }
> > +               kfree(hu);
> >        }
> >  }
> 
> The "destruct"-callback was broken in many ways but working around it
> without removing it seems wrong.

The reason for not doing so would be to keep the fixes minimal and thus
more appropriate for the stable trees.

Furthermore, according to you patch own description "Several drivers
already provide an empty callback" so I didn't consider it to be
a problem.

> This memory-leak occurs only if a
> tty-device uses the uart-ldisc without a protocol bound to it.
> Therefore, I didn't consider it important enough for stable.

See my answer to you previous mail regarding this.

> However,
> if you want to fix this, leave the kfree() inside the destruct
> callback but add another kfree() into the hci_uart_close() in an
> "else"-clause like this:
> 
> if (test_and_clear_bit(...)) {
> } else {
> +   kfree(...);
> }

You really don't want to free the hci_uart in it's own close method...

The hci_uart is allocated in tty_open and should be freed in tty_close.

> This will still keep the bogus ref-counts inside hci_dev with the
> destruct() callback but will also free the ldisc if no protocol is
> set.

Thanks,
Johan
