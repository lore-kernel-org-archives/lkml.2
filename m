Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab0ICQfD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 12:35:03 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33339 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab0ICQfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 12:35:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vYg/4BzYfWNdNgrmieVMPfk1EQHpjFET28LEk1BPsgTit7ndOoKxbzT6y+ygOYlk5T
         ax30vxj9kpEt1GKwOexvOlaML1M+lhYe1IOtSDDSQQiYUXEO9W81XqbdZxhCtLwUnVyh
         xnxejIHMZBBowm4MvwCa4od1vpyzkYJrmbylE=
Date: Fri, 3 Sep 2010 09:34:39 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Hemanth V <hemanthv@ti.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [RFC] [PATCH V2 1/2] input: CMA3000 Accelerometer driver
Message-ID: <20100903163438.GB2200@core.coreip.homeip.net>
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com>
 <20100829184904.GC26209@core.coreip.homeip.net>
 <017e01cb4b53$45925da0$LocalHost@wipblrx0099946>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <017e01cb4b53$45925da0$LocalHost@wipblrx0099946>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hemanth,

On Fri, Sep 03, 2010 at 04:02:11PM +0530, Hemanth V wrote:
> >
> >
> >Do not like repeated release of resources in main and error path... Can
> >we do it like:
> >
> >...
> >disable_irq();
> >error = cma3000_set(data, CMA3000_CTRL, ctrl, "ctrl");
> >if (!error) {
> >/* Settling time delay required after mode change */
> >msleep(CMA3000_SETDELAY);
> >}
> >enable_irq();
> >out:
> >mutex_unlock();
> >return error ? error : count;
> 
> I am thinking I can just add the below statement, and should be able to
> remove repeated release.
> 
> return error ? error : count;
> 

That would make us sleep for CMA3000_SETDELAY even in case of failure...
... But that should be OK.

> >>+
> >>+ if (data->client->irq) {
> >>+ ret = request_threaded_irq(data->client->irq, NULL,
> >>+ cma3000_thread_irq,
> >>+ irqflags | IRQF_ONESHOT,
> >>+ data->client->name, data);
> >>+
> >>+ if (ret < 0) {
> >>+ dev_err(&data->client->dev,
> >>+ "request_threaded_irq failed\n");
> >>+ goto err_op1_failed;
> >>+ }
> >>+ }
> >
> >What is the utility of the driver when there is no IRQ line?
> 
> Not sure I fully understand your comments.
> Currently probe would return a failure.
> 

You have a check for data->client->irq != 0 and finish probe() with
success in case it is 0. The question is what is the use of the
device/driver combo in case when data->client->irq == 0?

-- 
Dmitry
