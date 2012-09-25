Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab2IYIat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 04:30:49 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39686 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2IYIap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 04:30:45 -0400
Date: Tue, 25 Sep 2012 09:30:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Poddar, Sourav" <sourav.poddar@ti.com>
Cc: gregkh@linuxfoundation.org, khilman@ti.com, paul@pwsan.com,
        tony@atomide.com, linux-kernel@vger.kernel.org, balbi@ti.com,
        santosh.shilimkar@ti.com, linux-serial@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alan@linux.intel.com
Subject: Re: [RFT/PATCH] serial: omap: prevent resume if device is not
	suspended.
Message-ID: <20120925083029.GG31374@n2100.arm.linux.org.uk>
References: <1347972050-3509-1-git-send-email-sourav.poddar@ti.com> <CAKdam572krJZcayRdJ_AciCUZH3LuzD9yoHenhxrB6j9xDZ6JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKdam572krJZcayRdJ_AciCUZH3LuzD9yoHenhxrB6j9xDZ6JQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 01:52:03PM +0530, Poddar, Sourav wrote:
> Hi Greg,
> 
> Ping on this?
> 
> On Tue, Sep 18, 2012 at 6:10 PM, Sourav Poddar <sourav.poddar@ti.com> wrote:
> > Greg's tty-next is not booting on 2420 based N800. The failure is
> > observed at serial init itself. The reason might be that n800 tries to
> > resume even though it is not suspended before.

How is this happening?  I think that needs proper investigation - or if
it's had more investigation, then the results needs to be included in
the commit description so that everyone can understand the issue here.

We should not be resuming a device which hasn't been suspended.  Maybe
the runtime PM enable sequence is wrong, and that's what should be fixed
instead?  

This sequence in the probe() function:

        pm_runtime_irq_safe(&pdev->dev);
        pm_runtime_enable(&pdev->dev);
        pm_runtime_get_sync(&pdev->dev);

would enable runtime PM while the s/w state indicates that it's disabled,
and then that pm_runtime_get_sync() will want to resume the device.  See
the section "5. Runtime PM Initialization, Device Probing and Removal"
in Documentation/power/runtime_pm.txt, specifically the second paragraph
of that section.
