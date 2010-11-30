Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab0K3HSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 02:18:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56122 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab0K3HSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 02:18:41 -0500
Date: Tue, 30 Nov 2010 08:18:16 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Jonathan Corbet <corbet@lwn.net>
cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] core: add a function to safely try to get device
 driver owner
In-Reply-To: <20101129152838.4ff57277@bike.lwn.net>
Message-ID: <Pine.LNX.4.64.1011300016260.27962@axis700.grange>
References: <Pine.LNX.4.64.1011292043000.27962@axis700.grange>
 <20101129131737.3dd6eb03@bike.lwn.net> <Pine.LNX.4.64.1011292147540.27962@axis700.grange>
 <20101129214128.GA9691@kroah.com> <Pine.LNX.4.64.1011292300300.27962@axis700.grange>
 <20101129152838.4ff57277@bike.lwn.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:kO3ou/AwOrFN2RdUR1gRJSub0Bl8dsszFDLKEco0+aE
 yricsk8Q3cBxVvCgPo86qwtVErfSNjdpaERKjX/578tCQAUo8u
 2VPrENYu2zmk4MVaCsIT5tUW8k3JLimqVXa0d440Rh9RXtAyaB
 bFHYIraXqCzkYWocHmQBCKhGrDDwHhXYQr1dMyTpa0zlZ/0/ik
 1WHEIyg6EaaKLSc73D6wy5n7uEeUXhqCdN7mf0y8Ls=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010, Jonathan Corbet wrote:

> On Mon, 29 Nov 2010 23:10:50 +0100 (CET)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > In my case I have two platform devices: CEU and CSI2. In some cases (with 
> > parallel sensors) CEU operates on its own. With serial (CSI-2) camera 
> > sensors we need the CSI2 driver. So, I want to 
> > try_module_get(csi2_dev->driver->owner) the CSI2 driver from my CEU 
> > driver. This call can Oops if not done safely. Am I missing something? Is 
> > there an easier way to achieve the same?
> 
> This looks exactly like what the V4L2 subdev mechanism was meant to do.
> Is there a reason you can't use that interface?

Subdev doesn't solve this completely. Media controller, probably, will, 
not sure to what extent, but it is not yet in the mainline.

These my devices do use the subdev API, the CEU driver registers a 
v4l2_device, and the CSI2 driver and the attached sensor register 
v4l2_subdev instances. The problem is - when you register v4l2_subdev, you 
have to specify the respective v4l2_device. In case of sensor (and other 
I2C) drivers this is solved with I2C probing. Generally speaking, the 
v4l2_device registers a device for the subdev driver, and expects a driver 
to attach to it. Then, when the subdev driver probes with the newly 
registered device, it passes its v4l2_subdev instance back with its 
i2c_client object, and then the caller can match them. While doing so they 
also allow a race like

	if (!try_module_get(client->driver->driver.owner))

which is exactly what my patch is attempting to fix.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
