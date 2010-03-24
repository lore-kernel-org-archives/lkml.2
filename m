Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab0CXQXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:23:00 -0400
Received: from web94909.mail.in2.yahoo.com ([203.104.17.168]:21943 "HELO
	web94909.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752014Ab0CXQW7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:22:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=saMCi3Pch8HeKg5kwafErez5Bl0s9L4QzhRptf7PwYcjC0Cv9Xr/6fIlfd28htQmb2f+lzErR67ATaCcz+3SAvNcWvsQjTDmX0Uxpl3FkV3bVu9jpYFiGTeT9cRx7EX/r+Ti4arF1psgU45HirVbn3zDI4gkaOibpGvyyz+BV/w=;
Message-ID: <12213.61465.qm@web94909.mail.in2.yahoo.com>
X-YMail-OSG: Luo3Dz8VM1mkJIW3TQvPe7Uz01zs0Wp0GG42XJOO1DLy4ss
 ERq78QN3eX4WDRBIlaWV2T2dqJ6H71_AoDQtjVFYuWAVlmc8.8NVpkW1CO6V
 rC9zXcZ8IreQ9JmHigmUsbal85a1LWV.1L6a6eJyXDZQbDoq1hsnKxL1EdsJ
 iMGppAUTXQ3SCkK0ob8KQEp9DQ1bbIYUszUSXO4TwPUYFdEzx3fEJp.Ukiff
 dxTyRBHtSvr2OSNin61zlfPgNge6S3Wlcudx4ImMlqgp8ayhR..BgZtchq2V
 azTl6WehV0sR6OHK8Ri1H0iQ-
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Wed, 24 Mar 2010 21:52:56 +0530 (IST)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Greg KH <gregkh@suse.de>, PavanSavoy <pavan_savoy@ti.com>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1269447105.11714.117.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 24/3/10, Marcel Holtmann <marcel@holtmann.org> wrote:

> From: Marcel Holtmann <marcel@holtmann.org>
> Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
> To: "Pavan Savoy" <pavan_savoy@yahoo.co.in>
> Cc: "Greg KH" <gregkh@suse.de>, "PavanSavoy" <pavan_savoy@ti.com>, "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> Date: Wednesday, 24 March, 2010, 9:41 PM
> Hi Pavan,
> 
> 
> > I wanted to somehow put this in staging because then
> it would probably have a thorough architectural review
> process.
> > Some details about this driver - 
> > 
> > 1. This driver will be used by Bluetooth-BlueZ/FM-V4L2
> and GPS (probably character device driver) using the
> EXPORTED symbols (-register/_unregister).
> > 
> > 2. Much like the hciattach daemon which maintains
> N_HCI bluetooth line discipline, this driver will also have
> a User-Space  N_TI_WL Init manager (UIM) maintaining
> the Line discipline.
> 
> can you explain why you think this is needed and we can not
> interface
> this directly. If it is a serial port, what protocol does
> it talk?

Illustration: The BT driver on top of this ST driver, would create a hci0 interface, when someone does an DEVUP on that interface, the BT driver would then do a st-register - which in-turn would ask the hciattach-like daemon to install the line discipline for it via the sysfs entry.
The same concept goes for FM-V4L2 and GPS character driver.

The core of the problem is we cannot ask/install/ldisc_put for a line discipline from kernel space.

> 
> > 3. Because of the UIM should know when to
> install/uninstall line discipline, the /sys entry is created
> a root called UIM (a new kobject) and UIM daemon would write
> it's PID to it.
> 
> I don't understand this. This sounds like a broken concept
> to me.

Yes, I don't feel good about it either. But how do I request for a line discipline from kernel space ?
Currently a daemon has to run in user-space to maintain the ldisc, at all times, and I don't want to open TTY @ boot, and install Ldisc (tiocsetd) on it, without BT/FM or GPS core on chip being used - The Power Management team here would beat me up if I do that, 
and hence the very dumb idea of passing the PID of the daemon via sysfs entry, and the driver sending SIGUSR2 to that PID, daemon doing a tiocsetd upon that signal.

> 
> > 4. As Alan suggested, If I make it self-contained by
> pushing number of line disciplines to a slightly larger
> number, then would it be OK ?
> 
> Just from a quick look, I think within a few review cycles
> this might be
> able to get proper upstream inclusion. No idea why bother
> with staging
> in the first place. Lets do this correctly.
> 

The only reason I wanted this to be in staging was to have sort of continuous review process, and in hope the driver wouldn't be forgotten.

> Regards
> 
> Marcel
> 
> 
> 


      The INTERNET now has a personality. YOURS! See your Yahoo! Homepage. http://in.yahoo.com/
