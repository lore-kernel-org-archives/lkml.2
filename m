Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780Ab2KBMRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 08:17:04 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:37032 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750858Ab2KBMRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 08:17:01 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux1394-devel@lists.sourceforge.net, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 0/1] staging: Add firewire-serial driver
Date: Fri,  2 Nov 2012 08:16:32 -0400
Message-Id: <cover.1351817601.git.peter@hurleysoftware.com>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1350565015.23730.4.camel@thor>
References: <1350565015.23730.4.camel@thor>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2 of this driver submission builds and runs cleanly against Greg KH's
tty-next and (hopefully) addresses the concerns raised regarding the
dependence on tty_buffer internals; specifically with the workarounds to fix
1) data loss on hangup and 2) throttling before the flip buffers are full.

1) Data loss on hangup
Although I experimented with alternative solutions as Alan suggested, none
were practical. For example, this sequence (which is almost identical to
what the n_tty ldisc does in input_available_p()):

     tty_flush_to_ldisc(tty);
     n = ldisc->ops->chars_in_buffer(tty);

suffers from a race that the ldisc could have _just_ emptied the read
buffer between these calls, so that n == 0 but data is still in the
flip buffers.

For now, the driver v2 delays the hangup on carrier loss by a fixed timeout.

2) Flip buffers full before throttle received from ldisc
Because driver throttling is performed by the ldisc, and not by the
tty_buffer, the flip buffers can be filled before receiving a throttle
request.

For now, the driver v2 pre-buffers in front of the tty_buffer; ie, rx data
which is not accepted by tty_insert_flip_string...() is buffered in the
driver, the sender is throttled and when ldisc unthrottles, normal operation
resumes by feeding the tty_buffer from the pre-buffered data.

This driver v2 also fixes the occasionally flaky auto-connect, 2 (valid)
lockdep warnings, racy line status changes, and delays fifo allocation
until .activate() to minimize memory footprint.

As before, the TODO file notes the remaining issues.

Regards,
Peter

Peter Hurley (1):
  staging: fwserial: Add TTY-over-Firewire serial driver

 drivers/staging/Kconfig             |    2 +
 drivers/staging/Makefile            |    1 +
 drivers/staging/fwserial/Kconfig    |    9 +
 drivers/staging/fwserial/Makefile   |    2 +
 drivers/staging/fwserial/TODO       |   37 +
 drivers/staging/fwserial/dma_fifo.c |  310 ++++
 drivers/staging/fwserial/dma_fifo.h |  130 ++
 drivers/staging/fwserial/fwserial.c | 2946 +++++++++++++++++++++++++++++++++++
 drivers/staging/fwserial/fwserial.h |  387 +++++
 9 files changed, 3824 insertions(+)
 create mode 100644 drivers/staging/fwserial/Kconfig
 create mode 100644 drivers/staging/fwserial/Makefile
 create mode 100644 drivers/staging/fwserial/TODO
 create mode 100644 drivers/staging/fwserial/dma_fifo.c
 create mode 100644 drivers/staging/fwserial/dma_fifo.h
 create mode 100644 drivers/staging/fwserial/fwserial.c
 create mode 100644 drivers/staging/fwserial/fwserial.h

-- 
1.7.12.3

