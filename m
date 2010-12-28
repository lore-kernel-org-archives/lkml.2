Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab0L1Gke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 01:40:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab0L1Gkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 01:40:32 -0500
Date: Mon, 27 Dec 2010 23:40:47 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Tsozik <tsozik@yahoo.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, zaitcev@redhat.com
Subject: Re: [PATCH 1/1] mct_u232: added _ioctl, _msr_to_icount and
 _get_icount functions
Message-ID: <20101227234047.3f70a515@lembas.zaitcev.lan>
In-Reply-To: <711019.98747.qm@web65713.mail.ac4.yahoo.com>
References: <20101227151237.744bbb6e@lembas.zaitcev.lan>
	<711019.98747.qm@web65713.mail.ac4.yahoo.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Dec 2010 20:04:51 -0800 (PST)
Tsozik <tsozik@yahoo.com> wrote:

> So I ran geiger counter against /dev/ttyS0 device for 20 minutes and
> acquired 20 measurements. Then I compared last average with last 20
> minute measurement average acquired via mct_u232 on the laptop placed
> nearby. The error was ~4% (rounded up).

Great, I'm ready to ack.

There's just one thing that is bugging me... I think it would be best
if Alan Cox or Greg Kroah commented on it. The edgeport does the
following, which we copied:


		schedule();
		........
		if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr &&
		    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts)
			return -EIO; /* no change => error */
		if (((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
		    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
		    ((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
		    ((arg & TIOCM_CTS) && (cnow.cts != cprev.cts))) {
			return 0;
		}

So, if there was a status report, but no change to bits, the ioctl
TIOCMIWAIT would return with -EIO. In serial_core.c, that serves
conventional non-USB UARTs, nothing like this occurs. I am not quite
sure what the point of doing this -EIO check is.

Oh and BTW, I'm wondering what is going to happen if the device is
disconnected while an application is blocked waiting for the status
change. The patch is not particularly bad here, it just copies
an existing code from elsewhere.

-- Pete
