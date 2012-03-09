Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab2CIPPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 10:15:33 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43388 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754380Ab2CIPPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 10:15:31 -0500
Date: Fri, 9 Mar 2012 16:15:27 +0100
From: Johan Hovold <jhovold@gmail.com>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] bluetooth: hci_ldisc: fix NULL-pointer dereference
 on tty_close
Message-ID: <20120309151527.GH4497@localhost>
References: <1331136120-27075-1-git-send-email-jhovold@gmail.com>
 <1331136120-27075-2-git-send-email-jhovold@gmail.com>
 <CANq1E4Sd45FtZN6NXs7TZ1k6VrFkbcAZug-1UQwW-XPB0e5Aag@mail.gmail.com>
 <20120309142939.GD4497@localhost>
 <CANq1E4TzcQCuKomPv1bNTdkJ7LDTYjKiMqUwV8ZaoYG6FJO9Qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANq1E4TzcQCuKomPv1bNTdkJ7LDTYjKiMqUwV8ZaoYG6FJO9Qw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 03:35:46PM +0100, David Herrmann wrote:
> On Fri, Mar 9, 2012 at 3:29 PM, Johan Hovold <jhovold@gmail.com> wrote:
> > On Fri, Mar 09, 2012 at 02:44:30PM +0100, David Herrmann wrote:
> >> On Wed, Mar 7, 2012 at 5:01 PM, Johan Hovold <jhovold@gmail.com> wrote:
> >> > Do not close protocol driver until device has been unregistered.
> >> >
> >> > This fixes a race between tty_close and hci_dev_open which can result in
> >> > a NULL-pointer dereference.
> >> >
> >> > The line discipline closes the protocol driver while we may still have
> >> > hci_dev_open sleeping on the req_lock mutex resulting in a NULL-pointer
> >> > dereference when lock is acquired and hci_init_req called.
> >
> > [...]
> >
> >> > diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
> >> > index 0711448..6946081 100644
> >> > --- a/drivers/bluetooth/hci_ldisc.c
> >> > +++ b/drivers/bluetooth/hci_ldisc.c
> >> > @@ -310,11 +310,11 @@ static void hci_uart_tty_close(struct tty_struct *tty)
> >> >                        hci_uart_close(hdev);
> >> >
> >> >                if (test_and_clear_bit(HCI_UART_PROTO_SET, &hu->flags)) {
> >> > -                       hu->proto->close(hu);
> >> >                        if (hdev) {
> >> >                                hci_unregister_dev(hdev);
> >> >                                hci_free_dev(hdev);
> >> >                        }
> >> > +                       hu->proto->close(hu);
> >> >                }
> >> >        }
> >> >  }
> >>
> >> I can confirm this. hci_uart_set_proto() opens the proto before it
> >> registers the hci device. Hence, we should also unregister the hci
> >> device before closing the proto. I also looked whether this introduces
> >> other race conditions but no proto-callback can be called here as they
> >> are all protected by the tty-layer which synchronizes all
> >> tty-callbacks. Therefore, I think this is the correct fix.
> >>
> >> We can apply this to stable even without the "destruct"-fixes from me
> >> as hu->proto->$cb$() doesn't care whether hdev is valid or not. I
> >> don't think the destruct-fixes are important enough to send them to
> >> stable.
> >
> > Unfortunately hu is is not valid once hci_unregister returns as it will
> > call the destruct callback. So my patch depends on changing this
> > behaviour first. (I could also store a pointer to the protocol before
> > calling unregister in my patch.)
> 
> Right, I missed that, sorry.
> 
> > Secondly, I must disagree with you regarding whether the memory leak you
> > found is critical enough to be added to the stable trees. We're leaking
> > kernel memory in a deterministic and easily triggered way which could be
> > exploited by a malicious user.
> 
> Are you planning on sending a patch to stable-ML or should I do so? How about
> my proposal in the other mail? Could you include this fix when resending this?

This needs to go in through the bluetooth/networking trees (or their
maintainers at least) so that it gets in to 3.3, otherwise stable will
not pick it up for earlier trees.

I'll post a revised series which includes the minimal fix to the memory
leak so that all three patches can go to Linus and hopefully make it in
before 3.3 is out. 

Sounds good?

Thanks,
Johan
