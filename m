Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422989Ab2LFKBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 05:01:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422974Ab2LFKBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 05:01:52 -0500
Date: Thu, 6 Dec 2012 11:01:48 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] HID: i2c-hid: fix i2c_hid_get_raw_report count
 mismatches
In-Reply-To: <20121205205926.143070ef@endymion.delvare>
Message-ID: <alpine.LNX.2.00.1212061101100.28002@pobox.suse.cz>
References: <1354716176-12558-1-git-send-email-benjamin.tissoires@gmail.com> <1354716176-12558-5-git-send-email-benjamin.tissoires@gmail.com> <20121205205926.143070ef@endymion.delvare>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Dec 2012, Jean Delvare wrote:

> > The previous memcpy implementation relied on the size advertized by the
> > device. There were no guarantees that buf was big enough.
> > 
> > Some gymnastic is also required with the +2/-2 to take into account
> > the first 2 bytes of the returned buffer where the total returned
> > length is supplied by the device.
> > 
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> > ---
> >  drivers/hid/i2c-hid/i2c-hid.c | 16 ++++++++++++----
> >  1 file changed, 12 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> > index c6630d4..ce01d59 100644
> > --- a/drivers/hid/i2c-hid/i2c-hid.c
> > +++ b/drivers/hid/i2c-hid/i2c-hid.c
> > @@ -502,23 +502,31 @@ static int i2c_hid_get_raw_report(struct hid_device *hid,
> >  {
> >  	struct i2c_client *client = hid->driver_data;
> >  	struct i2c_hid *ihid = i2c_get_clientdata(client);
> > +	size_t ret_count, ask_count;
> >  	int ret;
> >  
> >  	if (report_type == HID_OUTPUT_REPORT)
> >  		return -EINVAL;
> >  
> > -	if (count > ihid->bufsize)
> > -		count = ihid->bufsize;
> > +	/* +2 bytes to include the size of the reply in the query buffer */
> > +	ask_count = min(count + 2, (size_t)ihid->bufsize);
> >  
> >  	ret = i2c_hid_get_report(client,
> >  			report_type == HID_FEATURE_REPORT ? 0x03 : 0x01,
> > -			report_number, ihid->inbuf, count);
> > +			report_number, ihid->inbuf, ask_count);
> >  
> >  	if (ret < 0)
> >  		return ret;
> >  
> > -	count = ihid->inbuf[0] | (ihid->inbuf[1] << 8);
> > +	ret_count = ihid->inbuf[0] | (ihid->inbuf[1] << 8);
> >  
> > +	if (!ret_count)
> 
> I'd make this (ret_count <= 2), as this would let you call memcpy with a
> null or even negative length.

Good catch, it doesn't account for the 2 bytes needed for storing the 
reply size.

I have fixed that and applied the patch, thanks everybody!

-- 
Jiri Kosina
SUSE Labs
