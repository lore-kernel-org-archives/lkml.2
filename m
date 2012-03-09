Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab2CIOsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 09:48:11 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36883 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754192Ab2CIOsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 09:48:08 -0500
Date: Fri, 9 Mar 2012 15:48:04 +0100
From: Johan Hovold <jhovold@gmail.com>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2 v2] bluetooth: hci_core: fix NULL-pointer dereference
 at unregister
Message-ID: <20120309144804.GF4497@localhost>
References: <1331228606.14217.5.camel@aeonflux>
 <1331297594-13332-1-git-send-email-jhovold@gmail.com>
 <CANq1E4Rt0ctZ5cpXipJE--YmkR4OjKBXLBQkeTKWP3+Q-q37Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANq1E4Rt0ctZ5cpXipJE--YmkR4OjKBXLBQkeTKWP3+Q-q37Yw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Fri, Mar 09, 2012 at 03:04:11PM +0100, David Herrmann wrote:
> On Fri, Mar 9, 2012 at 1:53 PM, Johan Hovold <jhovold@gmail.com> wrote:
> > Make sure hci_dev_open returns immediately if hci_dev_unregister has
> > been called.
> >
> > This fixes a race between hci_dev_open and hci_dev_unregister which can
> > lead to a NULL-pointer dereference.
> >
> > Bug is 100% reproducible using hciattach and a disconnected serial port:
> >
> > 0. # hciattach -n /dev/ttyO1 any noflow
> >
> > 1. hci_dev_open called from hci_power_on grabs req lock
> > 2. hci_init_req executes but device fails to initialise (times out
> >   eventually)
> > 3. hci_dev_open is called from hci_sock_ioctl and sleeps on req lock
> > 4. hci_uart_tty_close calls hci_dev_unregister and sleeps on req lock in
> >   hci_dev_do_close
> > 5. hci_dev_open (1) releases req lock
> > 6. hci_dev_do_close grabs req lock and returns as device is not up
> > 7. hci_dev_unregister sleeps in destroy_workqueue
> > 8. hci_dev_open (3) grabs req lock, calls hci_init_req and eventually sleeps
> > 9. hci_dev_unregister finishes, while hci_dev_open is still running...

[...]

> > diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> > index 00596e8..e8879b9 100644
> > --- a/include/net/bluetooth/hci.h
> > +++ b/include/net/bluetooth/hci.h
> > @@ -93,6 +93,8 @@ enum {
> >  * states from the controller.
> >  */
> >  enum {
> > +       HCI_UNREGISTER,
> > +
> >        HCI_LE_SCAN,
> >  };
> >
> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > index d6448f0..22b6781 100644
> > --- a/net/bluetooth/hci_core.c
> > +++ b/net/bluetooth/hci_core.c
> > @@ -525,6 +525,11 @@ int hci_dev_open(__u16 dev)
> >
> >        hci_req_lock(hdev);
> >
> > +       if (test_bit(HCI_UNREGISTER, &hdev->dev_flags)) {
> > +               ret = -ENODEV;
> > +               goto done;
> > +       }
> > +
> 
> Isn't it enough to check for HCI_RUNNING here? We obviously have a
> race here as we take the device with hci_dev_get(), then sleep and
> then we do not check whether the device is still alive. However,
> drivers are required to reset HCI_RUNNING before calling
> hci_unregister_dev() (which is bogus anyway, but its the way we
> handled it in the past) therefore it should be enough for us to check
> for HCI_RUNNING.

I'm afraid this won't work as hci_dev_open is responsible for setting
HCI_RUNNING in the first place (set in hdev->open(hdev) called from
hci_dev_open).

Thanks,
Johan
