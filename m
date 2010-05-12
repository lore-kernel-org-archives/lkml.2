Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab0ELTIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 15:08:22 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:64353 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab0ELTIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 15:08:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xjsxaq6pdkpvXLm6MVuuIOovh/KxJL5IWp6LSn93OBJv09QqrMgLyd/vFahIQGAxtQ
         JdfmJ1vSCxf2lpuhvoJw4t6k7oY/koenqL6n16RPnQRP+D0YUNLceOh7FKx+PLiYn1oG
         nSZY0HHs+Ud0OlqVs5W6i9AhHz5SX8tSE+Z00=
Date: Wed, 12 May 2010 23:08:14 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Matt Reimer <mreimer@vpop.net>, Evgeniy Polyakov <zbr@ioremap.net>,
       Tejun Heo <tj@kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Introduce {sysfs,device}_create_file_mode
Message-ID: <20100512190814.GA9674@oksana.dev.rtsoft.ru>
References: <1273595926-26249-1-git-send-email-daniel@caiaq.de>
 <20100511174708.GA26777@oksana.dev.rtsoft.ru>
 <20100511175812.GH30801@buzzloop.caiaq.de>
 <20100511182347.GA31831@oksana.dev.rtsoft.ru>
 <20100511222825.GJ30801@buzzloop.caiaq.de>
 <20100512181546.GA4804@oksana.dev.rtsoft.ru>
 <20100512183806.GA28658@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100512183806.GA28658@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 11:38:06AM -0700, Greg KH wrote:
> On Wed, May 12, 2010 at 10:15:46PM +0400, Anton Vorontsov wrote:
> > We need to create attributes with different modes across devices.
> > We can do this by modifying attr.mode between device_create_file
> > invocations, but that is racy in case of globally defined attrs.
> > 
> > Luckily, there's sysfs_add_file_mode() function that seems to do
> > exactly what we want, and if we use it, we don't need any locks
> > to avoid races. Though, it isn't exposed via device-drivers core
> > API.
> 
> But you race the creation of the device notifying userspace, and then
> the file being created, right?

Yep, you've raised that question once, like 3 years ago. :-)

http://lkml.org/lkml/2007/4/11/452
http://lkml.org/lkml/2007/4/12/144

In short: we can't use attr groups since the attributes creation
is conditional. And we especially don't want to use the attr groups
for attrs with different modes. But it's not a problem, because...

> Or is that properly taken care of elsewhere?

Yep, userland should just listen to uevents, we're sending
'changed' event at the end of the registration. Attributes
may appear and disappear dynamically, battery handling
userland have to cope with that anyway.

> > Greg, does the patch look OK? If so, I'd like it to go
> > via battery-2.6.git tree, along with patches that need
> > that one.
> 
> Looks good with one minor problem:
> 
> > --- a/drivers/base/core.c
> > +++ b/drivers/base/core.c
> > @@ -440,6 +440,27 @@ struct kset *devices_kset;
> >   * device_create_file - create sysfs attribute file for device.
> 
> That should be "device_create_file_mode"

Thanks for catching! Will change.

> Make that change and then feel free to take it through your tree with
> an:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> on it.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
