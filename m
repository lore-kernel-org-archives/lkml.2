Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab2CINEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:04:20 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:45990 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753067Ab2CINES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:04:18 -0500
Date: Fri, 9 Mar 2012 14:04:13 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] bluetooth: hci_ldisc: fix NULL-pointer dereference
 on tty_close
Message-ID: <20120309130413.GC4497@localhost>
References: <1331136120-27075-1-git-send-email-jhovold@gmail.com>
 <1331136120-27075-2-git-send-email-jhovold@gmail.com>
 <1331148797.3392.191.camel@aeonflux>
 <20120308115721.GB4497@localhost>
 <1331228722.14217.7.camel@aeonflux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331228722.14217.7.camel@aeonflux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 09:45:22AM -0800, Marcel Holtmann wrote:
> Hi Johan,
> 
> > > > Do not close protocol driver until device has been unregistered.
> > > > 
> > > > This fixes a race between tty_close and hci_dev_open which can result in
> > > > a NULL-pointer dereference.
> > > > 
> > > > The line discipline closes the protocol driver while we may still have
> > > > hci_dev_open sleeping on the req_lock mutex resulting in a NULL-pointer
> > > > dereference when lock is acquired and hci_init_req called.
> > 
> > [...]
> > 
> > > what kernel version is this against? Our changes in bluetooth-next fixed
> > > some of the destruct handling.
> > 
> > This is against the latest rc as it needs to be fixed in 3.3, but I
> > missed a dependency to bluetooth-next as you point out below.
> > 
> > > Also hci_unregister_dev should be calling the destruct handler and thus
> > > your change is now accessing hu but it got freed already.
> > 
> > You're right, my patch depends on 010666a126fc ("Bluetooth: Make
> > hci-destruct callback optional") and 797fe796c4 ("Bluetooth: uart-ldisc:
> > Fix memory leak and remove destruct cb") from bluetooth-next. 
> > 
> > But since the latter one fixes a memory leak it should have been marked
> > for stable as well as pushed to Linus for 3.3, right?
> 
> we need to look into this and propose patches for -stable. Is your
> problem still present with bluetooth-next or not?

Yes, both races are present in bluetooth-next of today (b8622cbd58f34)
and only takes an additional manual step to trigger (as the core no
longer tries to open the device twice automatically).

My two patches on top of either the two patches by David Herrmann
mentioned above or the following minimal fix of the same memory leak
would be sufficient to fix both races in 3.3:

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 0711448..97c5faa 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -237,7 +237,6 @@ static void hci_uart_destruct(struct hci_dev *hdev)
                return;
 
        BT_DBG("%s", hdev->name);
-       kfree(hdev->driver_data);
 }
 
 /* ------ LDISC part ------ */
@@ -316,6 +315,7 @@ static void hci_uart_tty_close(struct tty_struct *tty)
                                hci_free_dev(hdev);
                        }
                }
+               kfree(hu);
        }
 }


Thanks,
Johan
