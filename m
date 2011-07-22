Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab1GVNHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 09:07:21 -0400
Received: from smtp.nokia.com ([147.243.128.26]:29077 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204Ab1GVNHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 09:07:19 -0400
Subject: Re: [RFC PATCHv5 1/7] HSI: hsi: Introducing HSI framework
From: Carlos Chinea <carlos.chinea@nokia.com>
To: balbi@ti.com
Cc: ext Sjur BRENDELAND <sjur.brandeland@stericsson.com>,
        "sjurbren@gmail.com" <sjurbren@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110722120553.GZ32058@legolas.emea.dhcp.ti.com>
References: <1307713124-3946-1-git-send-email-carlos.chinea@nokia.com>
	 <1308769914-15440-1-git-send-email-sjur.brandeland@stericsson.com>
	 <1308834524.27256.3247.camel@groo>
	 <81C3A93C17462B4BBD7E272753C105791A64C2735E@EXDCVYMBSTM005.EQ1STM.local>
	 <1311331416.32639.34.camel@groo>
	 <20110722110102.GR32058@legolas.emea.dhcp.ti.com>
	 <1311335472.32639.75.camel@groo>
	 <20110722120553.GZ32058@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jul 2011 16:02:09 +0300
Message-ID: <1311339729.32639.99.camel@groo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-22 at 15:05 +0300, ext Felipe Balbi wrote:
> Hi,
> 
> On Fri, Jul 22, 2011 at 02:51:12PM +0300, Carlos Chinea wrote:
> > Hi Felipe, 
> 
> hello there :-)
> 
> > > are you already using pm_runtime ? You could put that logic grouped in
> > > runtime_suspend()/runtime_resume() calls and from the driver, just call
> > > pm_runtime_put()/pm_runtime_get_sync() whenever you want to
> > > suspend/resume.
> > 
> > In the case of the omap_ssi driver not yet, but hopefully the
> > implementation will come soon ;) Anyway, the DATA/FLAG workaround is not
> > something I'm going to add to the omap_ssi, at least not now. This seems
> > to be needed by ST-Ericcson in their HSI controller.
> 
> aha, I see. Thanks for the clarification.
> 
> > > true, but I'm not sure a usecount is a good way to go. Why don't you
> > > just remove the sync API altogether and use only async, then the OMAP
> > > HSI controller driver is supposed to know when it can go to sleep. If
> > > you receive some data before a client queues a request, you just defer
> > > processing of that data until a new request is queued, or something...
> > 
> > Hmmm, Do you mean I remove the hsi_start_tx() and hsi_stop_tx()
> > completely ? Or Do I just create an async version of them ?
> 
> I would say remove completely and add async-only version.
> 
> > The truth is that they should not even exist in the first place, and the
> > wakelines should have been handled silently by the hsi controllers.  
> > But they are need because the hsi_clients/protocols, like CAIF or the
> > ssi_protocol in N900, need access to the wakelines to implement some
> > workarounds due to some races in the HSI/SSI HW spec.
> 
> that's quite nasty situation :-)
> 
> I still think, though, that if the clients don't really start a transfer
> straight away (meaning it's all ASYNC), you might be able to handle the
> workarounds in the HSI framework itself by having some extra flags on
> your hsi request structure (?).
> 
> See for example the use of short_not_ok flags on the gadget framework.
> The gadget drivers which can't handle short transfers (as of today only
> the Mass Storage gadget) will set that flag to tell the controller that
> we're not expecting a short packet and if we do, treat it as error. In
> case of such error, gadget driver is required to dequeue any queued
> transfer, flush the FIFO and restart ;-)
> 
> Maybe you could have something similar ? Depending on the workaround
> you're talking about, this might be feasible with few lines of code on
> the async API.
> 

The problem is that there is no standard way to handle this situation :(

For example ssi_protocol tries to deal with the wakelines race problem
by raising the wakeline and then waiting for the other end to send a
"READY to receive" data frame, before start sending. But as you can see
in the case of CAIF, they went for a solution where they raise their
wakeline and wait for the other end to raise its wakeline to signal that
they are "READY to received". Both solutions have their pros and cons.

Br,
-- 
Carlos Chinea <carlos.chinea@nokia.com>

