Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab1KOIsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 03:48:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58045 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab1KOIqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 03:46:15 -0500
Date: Tue, 15 Nov 2011 00:46:09 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: oskar.andero@sonyericsson.com,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "aghayal@codeaurora.org" <aghayal@codeaurora.org>,
        "Cavin, Courtney" <Courtney.Cavin@sonyericsson.com>
Subject: Re: [PATCH v2] input: add driver support for Sharp gp2ap002a00f
 proximity sensor
Message-ID: <20111115084609.GB13157@core.coreip.homeip.net>
References: <1321285158-7123-1-git-send-email-oskar.andero@sonyericsson.com>
 <20111114170352.GA12659@core.coreip.homeip.net>
 <20111115075629.GE9307@caracas.corpusers.net>
 <20111115082926.GA13157@core.coreip.homeip.net>
 <20111115083454.GE6492@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115083454.GE6492@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Tue, Nov 15, 2011 at 10:34:55AM +0200, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Nov 15, 2011 at 12:29:26AM -0800, Dmitry Torokhov wrote:
> > > > > +	error = input_register_device(dt->device);
> > > > > +	if (error) {
> > > > > +		dev_err(&dt->device->dev, "device registration failed\n");
> > > > > +		input_free_device(dt->device);
> > > > 
> > > > If you swap request_threaded_irq() and input_register_device() so that
> > > > registration is the last action error handling will be much simpler.
> > > >
> > > 
> > > I am getting a bit confused here, since you asked me to swap the order
> > > of request_threaded_irq() and input_register_device() in my previous
> > > version as well. Swapping again will take us back to square one or maybe
> > > I am misinterpreting your comment?
> > 
> > Gah, sorry, a bit of boilerplate slipped in. You already have the calls
> > in right order, you just need proper labels.
> > 
> > 
> > 	input_dev = input_allocate_device();
> > 	if (!input_dev) {
> > 		dev_err(...);
> > 		error = -ENOMEM;
> > 		goto err_free_mem;
> > 	}
> > 
> > 	... set up input device fully ...
> > 
> > 	error = request_threaded_irq(...);
> > 	if (error) {
> > 		dev_err(...);
> > 		goto err_free_input_dev;
> > 	}
> > 
> > 	error = input_register_device(input_dev);
> > 	if (error) {
> > 		dev_err(...);
> > 		goto err_free_irq;
> > 	}
> 
> are you sure this is right order ? Won't this create a very small
> timeframe where we could try to call input_report_switch() and
> input_sync() on an unregistered input device ??
> 

Yes, this is fine. As long as input device was allocated with
input_allocate_device() it can be used by input_report_*() and
input_sync() even tough device may not be registered yet - the events
will simply be dropped.

Thanks.

-- 
Dmitry
