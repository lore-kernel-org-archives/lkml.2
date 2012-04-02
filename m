Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab2DBJDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 05:03:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:28771 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab2DBJDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 05:03:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="127715401"
Date: Mon, 2 Apr 2012 12:03:46 +0300
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: Alexander Holler <holler@ahsoftware.de>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: Re: bluetooth: fix deadlock on device reset and power down
Message-ID: <20120402090337.GB29687@aemeltch-MOBL1>
Mail-Followup-To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
	David Herrmann <dh.herrmann@googlemail.com>,
	Alexander Holler <holler@ahsoftware.de>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo F. Padovan" <padovan@profusion.mobi>
References: <4F77055A.2070502@ahsoftware.de>
 <20120402065525.GA29687@aemeltch-MOBL1>
 <4F796377.2050008@ahsoftware.de>
 <CANq1E4RCQvQX6deGOTjdhbEkAahZD9MmAmfgz-Y-+wDfRtx0dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANq1E4RCQvQX6deGOTjdhbEkAahZD9MmAmfgz-Y-+wDfRtx0dw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

On Mon, Apr 02, 2012 at 10:44:43AM +0200, David Herrmann wrote:
> Hi Andrei and Alexander
> 
> On Mon, Apr 2, 2012 at 10:29 AM, Alexander Holler <holler@ahsoftware.de> wrote:
> > Am 02.04.2012 08:55, schrieb Andrei Emeltchenko:
> >> Hi Alexander,
> >>
> >> On Sat, Mar 31, 2012 at 03:23:38PM +0200, Alexander Holler wrote:
> >>> I've experienced a deadlock on shutdown using kernel 3.3 and tracked
> >>> it down. Because I'm not very familiar with the bluetooth stack I'm
> >>> not sure if the below patch is correct, but it fixed the problem
> >>> here.
> >>
> >> Could you please attach deadlock dump?
> >>
> >>>
> >>> Commit 09fd0de5bd8f8ef3317e5365f92f1a13dcd89aa9 introduced a deadlock:
> >>>
> >>> bluetoothd calls ioctl HCIDEVDOWN
> >>>     hci_sock_ioctl()
> >>>         hci_dev_close()
> >>>             hci_dev_do_close()
> >>>                 hci_dev_lock(hdev);
> >>>                 inquiry_cache_flush();
> >>>                 hci_conn_hash_flush();
> >>>                     hci_conn_del()
> >>>                         cancel_delayed_work_sync()
> >>>                             hci_conn_timeout()
> >>>                                 hci_dev_lock(hdev); /* DEADLOCK */
> >>
> >> I am actually not sure that hci_conn_timeout locks hdev. Why do you think
> >> so?
> >
> > By reading the source, printk and suffering through the deadlock. It's
> > especially painfull when using a bt-keyboard and systemd, because
> > systemd tries 4 times (~ some minutes) to kill bluetoothd before it
> > marks the service as failed and finally continues to shut down.
> 
> hci_conn_timeout does lock the device. See the source. But the problem

I think you need to check commit e72acc13c770a82b4ce4a07e9716f29320eae0f8

commit e72acc13c770a82b4ce4a07e9716f29320eae0f8
Author: Andre Guedes <andre.guedes@openbossa.org>
Date:   Fri Jan 27 19:42:03 2012 -0300

    Bluetooth: Remove unneeded locking
    
    We don't need locking hdev in hci_conn_timeout() since it doesn't
    access any hdev's shared resources, it basically queues HCI commands.

Best regards 
Andrei Emeltchenko 

