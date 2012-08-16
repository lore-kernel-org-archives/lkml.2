Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab2HPPNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:13:36 -0400
Received: from netrider.rowland.org ([192.131.102.5]:36291 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754602Ab2HPPNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:13:34 -0400
Date: Thu, 16 Aug 2012 11:13:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Hans de Goede <hdegoede@redhat.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Miklos Szeredi <miklos@szeredi.hu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [REGRESION] Suspend hangs with 3.6-rc1 on Lenovo T60 notebook
In-Reply-To: <502CDADA.2070507@redhat.com>
Message-ID: <Pine.LNX.4.44L0.1208161106350.24305-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2012, Hans de Goede wrote:

> Ah right, these are bus_driver operations. That explains some things, so I've
> done some more research asking myself: "Why does generic_ide_suspend(), which
> is a *bus* op, call dev_get_drvdata?", the answer to that seems to be that
> the ide subsystem is abusing (IMHO) drvdata to store per device bus_driver
> data. Which I believe is not how drvdata is intended to be used.
> 
> With that said, the above knowledge has allowed me to write an (ugly) fix for
> the regression Miklos is seeing. Miklos can you give the attached patch a
> try please?
> 
> > It clearly should check if drive is not NULL before using that pointer.
> 
> I assume you mean drive*r*, yes I agree that generic_ide_remove should
> check for that. So who is going to write a patch for that?

The existing code could certainly be improved.  Your patch does:

> +               /*
> +                * device_register() will have cleared drvdata on
> +                * device_attach failure, but we use drvdata to store per
> +                * device bus info, rather then for driver info, so restore it.
> +                */
> +               dev_set_drvdata(dev, drive);

But at this point, dev is defined by:

		struct device *dev = &drive->gendev;

So why bother setting anything?  It seems to me that 
generic_ide_suspend() and generic_ide_resume() could easily replace

	ide_drive_t *drive = dev_get_drvdata(dev);

with

	ide_drive_t *drive = dev_to_ide_drive(dev);

where dev_to_ide_drive is defined as "container_of(dev, ide_drive_t,
gendev)" (if this isn't defined already).

Alan Stern

