Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356Ab0EYAyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 20:54:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35928 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757983Ab0EYAyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 20:54:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Mack <daniel@caiaq.de>
Subject: Re: [Regression] Commit "power_supply: Use attribute groups" breaks KDE battery monitor on openSUSE 11.3 M6
Date: Tue, 25 May 2010 02:55:11 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-tst; KDE/4.3.5; x86_64; ; )
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Greg KH <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <201005250028.24687.rjw@sisk.pl> <201005250220.45889.rjw@sisk.pl> <20100525004744.GS30801@buzzloop.caiaq.de>
In-Reply-To: <20100525004744.GS30801@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005250255.11924.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 May 2010, Daniel Mack wrote:
> On Tue, May 25, 2010 at 02:20:45AM +0200, Rafael J. Wysocki wrote:
> > On Tuesday 25 May 2010, Rafael J. Wysocki wrote:
> > > On Tuesday 25 May 2010, Daniel Mack wrote:
> > > > On Tue, May 25, 2010 at 12:28:24AM +0200, Rafael J. Wysocki wrote:
> > > > > Your commit 5f487cd34f4337f9bc27ca19da72a39d1b0a0ab4 (power_supply: Use
> > > > > attribute groups) unfortunately breaks KDE 4.4's battery monitor from openSUSE
> > > > > 11.3 Milestone 6 on my Acer Ferrari One.  Apparently, the battery monitor can't
> > > > > access the sysfs battery attributes with this commit applied.
> > > > 
> > > > Can you still see the attributes in sysfs?
> > > 
> > > Yes, I can.
> > 
> > Ah, sorry.  The 'type' property is not present (I didn't notice that before).
> 
> Ah. That I didn't see. Does the (untested) patch below help?
> 
> Daniel
> 
> From ea5c518fb287d5e80e9a46ba1f9a17c45141187c Mon Sep 17 00:00:00 2001
> From: Daniel Mack <daniel@caiaq.de>
> Date: Tue, 25 May 2010 02:39:45 +0200
> Subject: [PATCH] power_supply: fix regression for 'type' property
> 
> Commit 5f487cd34f4337f9bc27ca19da72a39d1b0a0ab4 (power_supply: Use
> attribute groups) causes a regression the power supply core does not
> export the 'type' attribute anymore.
> 
> POWER_SUPPLY_PROP_TYPE is handled by the power supply core without the
> low-level driver, so power_supply_attr_is_visible() must always return
> the entry as readable.
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Reported-by: Rafael J. Wysocki <rjw@sisk.pl>

Yes, that's it, thanks.

Rafael


> ---
>  drivers/power/power_supply_sysfs.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
> index 6a86cdf..9d30eeb 100644
> --- a/drivers/power/power_supply_sysfs.c
> +++ b/drivers/power/power_supply_sysfs.c
> @@ -179,14 +179,16 @@ static mode_t power_supply_attr_is_visible(struct kobject *kobj,
>  {
>  	struct device *dev = container_of(kobj, struct device, kobj);
>  	struct power_supply *psy = dev_get_drvdata(dev);
> +	mode_t mode = S_IRUSR | S_IRGRP | S_IROTH;
>  	int i;
>  
> +	if (attrno == POWER_SUPPLY_PROP_TYPE)
> +		return mode;
> +
>  	for (i = 0; i < psy->num_properties; i++) {
>  		int property = psy->properties[i];
>  
>  		if (property == attrno) {
> -			mode_t mode = S_IRUSR | S_IRGRP | S_IROTH;
> -
>  			if (psy->property_is_writeable &&
>  			    psy->property_is_writeable(psy, property) > 0)
>  				mode |= S_IWUSR;
> 

