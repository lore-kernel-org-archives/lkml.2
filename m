Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965029Ab2LFJyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:54:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965011Ab2LFJyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:54:38 -0500
Date: Thu, 6 Dec 2012 10:54:34 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] HID: i2c-hid: fix memory corruption due to missing
 hid declaration
In-Reply-To: <20121205182543.0db92d3e@endymion.delvare>
Message-ID: <alpine.LNX.2.00.1212061054270.28002@pobox.suse.cz>
References: <1354716176-12558-1-git-send-email-benjamin.tissoires@gmail.com> <1354716176-12558-2-git-send-email-benjamin.tissoires@gmail.com> <20121205182543.0db92d3e@endymion.delvare>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Dec 2012, Jean Delvare wrote:

> > HID descriptors contains 4 bytes of reserved field.
> > The previous implementation was overriding the next fields in struct i2c_hid.
> > 
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> > ---
> >  drivers/hid/i2c-hid/i2c-hid.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> > index 7062df2..34cca42 100644
> > --- a/drivers/hid/i2c-hid/i2c-hid.c
> > +++ b/drivers/hid/i2c-hid/i2c-hid.c
> > @@ -69,6 +69,7 @@ struct i2c_hid_desc {
> >  	__le16 wVendorID;
> >  	__le16 wProductID;
> >  	__le16 wVersionID;
> > +	__le32 reserved;
> >  } __packed;
> >  
> >  struct i2c_hid_cmd {
> > @@ -776,7 +777,13 @@ static int __devinit i2c_hid_fetch_hid_descriptor(struct i2c_hid *ihid)
> >  	}
> >  
> >  	dsize = le16_to_cpu(hdesc->wHIDDescLength);
> > -	if (!dsize || dsize > HID_MAX_DESCRIPTOR_SIZE) {
> > +	/*
> > +	 * the size of the HID descriptor should at least contain
> > +	 * its size and the bcdVersion (4 bytes), and should not be greater
> > +	 * than sizeof(struct i2c_hid_desc) as we directly fill this struct
> > +	 * through i2c_hid_command.
> > +	 */
> > +	if (dsize < 4 || dsize > sizeof(struct i2c_hid_desc)) {
> >  		dev_err(&client->dev, "weird size of HID descriptor (%u)\n",
> >  			dsize);
> >  		return -ENODEV;
> 
> Reviewed-by: Jean Delvare <khali@linux-fr.org>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
