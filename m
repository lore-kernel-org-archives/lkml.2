Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab1FQBd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 21:33:27 -0400
Received: from mga14.intel.com ([143.182.124.37]:62618 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab1FQBdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 21:33:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,378,1304319600"; 
   d="scan'208";a="14229557"
Date: Fri, 17 Jun 2011 09:34:26 +0800
From: "Du, Alek" <alek.du@intel.com>
To: "Tang, Feng" <feng.tang@intel.com>
CC: "dirk.brandewie@gmail.com" <dirk.brandewie@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "alan@linux.intel.com" <alan@linux.intel.com>
Subject: Re: [PATCH 3/5] dw_spi: rework message processing
Message-ID: <20110617093426.40f0be34@dxy2>
In-Reply-To: <20110616220003.7ac89d56@feng-i7>
References: <1308158588-17249-1-git-send-email-dirk.brandewie@gmail.com>
	<1308158588-17249-4-git-send-email-dirk.brandewie@gmail.com>
	<20110616220003.7ac89d56@feng-i7>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.239.72.91]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011 22:00:03 +0800
"Tang, Feng" <feng.tang@intel.com> wrote:

> Hi Dirk,
> 
> On Thu, 16 Jun 2011 01:23:06 +0800
> "dirk.brandewie@gmail.com" <dirk.brandewie@gmail.com> wrote:
> 
> > From: Dirk Brandewie <dirk.brandewie@gmail.com>
> >
> > NOTE: patch created git format-patch --break-rewrites=/50%
> >
> > This patch reworks the message pump worker thread function to run
> > until all messages queued to the driver have been handled. The
> > function to handle individual spi_transfers is now a synchronus
> > function the tasklet to handle spi_transfers has been removed. Work
> > for the worker thread is only queued in host controller transfer
> > function.
> >
> > Psuedo code for new thread function:
> >   message = get_message()
> >   while (message){
> >     for_each_transfer_in_msg(message){
> >       transfer_setup(transfer)
> >       do_transfer()
> >     }
> >     complete_message()
> >     message = get_message()
> >   }
> >
> > Changes that fell out of the message thread changes:
> > Non-DMA transfers that are larger than the size of the controller FIFO
> > are handled as interrupt driven transfers.
> >
> > Common FIFO handling functions shared PIO and interrupt transfers.
> >
> > Simplified queue stop/start funcitons.
> >
> > Cleanup fixes:
> > Changed exported all exported function names to have dw_spi_ prefix
> >
> > Removed support for registering chip select control function. Setting
> > the slave chip select is handled by setting the SER (Slave enable
> > register)
> >

Removing this, you already break the TI spi BT module which requires that it
controls the chip select instead of controller.

When TX FIFO empty (means TX draining fast) the CS pin will de-assert.
In order to support those spi slaves that cannot stand this, the chip
select control function callback was added to this driver. Please don't
break previous contribution please.

And again, it is meaningless to enable both TX and RX fifo threshold interrupts,
since they are connected in hardware.

Thanks,
Alek
