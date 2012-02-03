Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab2BCWv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 17:51:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60216 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab2BCWv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 17:51:26 -0500
Date: Fri, 3 Feb 2012 16:51:23 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 2/3] apple_bl: Rework in advance of gmux backlight support
Message-ID: <20120203225123.GD22758@ubuntu-macmini>
Mail-Followup-To: Lars-Peter Clausen <lars@metafoo.de>,
	linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
	Matthew Garrett <mjg@redhat.com>
References: <1328300884-21551-1-git-send-email-seth.forshee@canonical.com>
 <1328300884-21551-3-git-send-email-seth.forshee@canonical.com>
 <4F2C5EC8.8090203@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2C5EC8.8090203@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 11:25:12PM +0100, Lars-Peter Clausen wrote:
> On 02/03/2012 09:28 PM, Seth Forshee wrote:
> > Make it easier to support backlights without a fixed I/O range, and
> > remove use of global variables to allow having multiple backlights
> > concurrently.
> > 
> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> > ---
> >  drivers/video/backlight/apple_bl.c |  163 +++++++++++++++++++-----------------
> >  1 files changed, 85 insertions(+), 78 deletions(-)
> > 
> > diff --git a/drivers/video/backlight/apple_bl.c b/drivers/video/backlight/apple_bl.c
> > index 66d5bec..e65b459 100644
> > --- a/drivers/video/backlight/apple_bl.c
> > +++ b/drivers/video/backlight/apple_bl.c
> > @@ -27,39 +27,30 @@
> >  #include <linux/pci.h>
> >  #include <linux/acpi.h>
> > [...]
> > + */
> > +static int apple_bl_get_brightness(struct backlight_device *bd)
> > +{
> > +	struct apple_bl_data *bl_data = bl_get_data(bd);
> > +	return bl_data->get_brightness(bl_data);
> > +}
> > +
> > +static int apple_bl_update_status(struct backlight_device *bd)
> > +{
> > +	struct apple_bl_data *bl_data = bl_get_data(bd);
> > +
> > +	bl_data->set_brightness(bl_data, bd->props.brightness);
> > +	return 0;
> > +}
> > +
> > +static const struct backlight_ops apple_bl_ops = {
> > +	.get_brightness = apple_bl_get_brightness,
> > +	.update_status = apple_bl_update_status,
> >  };
> 
> Adding this extra indirection here isn't so nice and isn't necessary either.
> Just define one set of backlight ops for the intel case and one for the nvidia
> case and use it accordingly when registering the backlight device.

There's a reason for the extra level of indirection to be there. The
driver uses {get,set}_brightness before the backlight device has been
allocated to test whether or not the backlight interface actually works.
This worked okay previously because the functions didn't need any extra
data; they just access fixed port addresses (really it only half-worked,
the update_status actually already has this indirection to support the
test, duplicated for each interface). But for the gmux backlight we're
getting the I/O address range from ACPI, so it needs to get at the data.

Of course there are a couple of ways we could get around this. Not
calling the backlight ops in the gmux case would be an option; then you
don't get the check, but so far as I know right now the check doesn't
work for the gmux backlight anyway. Or allocating the backlight device
first before doing the check, but I don't see that as a good option.

I feel like what I've done is the cleanest way to accommodate the test,
and the extra level of indirection really isn't all that bad imho.

Seth
