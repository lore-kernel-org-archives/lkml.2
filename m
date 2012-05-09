Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088Ab2EIHZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 03:25:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40684 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab2EIHZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 03:25:23 -0400
Date: Wed, 9 May 2012 00:25:18 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 03/14 v3] Input: atmel_mxt_ts - refactor
 mxt_read/write_reg to take a length
Message-ID: <20120509072517.GH10514@core.coreip.homeip.net>
References: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
 <1334755319-21365-4-git-send-email-djkurtz@chromium.org>
 <20120509055411.GG10514@core.coreip.homeip.net>
 <20120509090500.1dc9143e@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509090500.1dc9143e@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 09:05:00AM +0200, Jean Delvare wrote:
> Hi Dmirty,
> 
> On Tue, 8 May 2012 22:54:11 -0700, Dmitry Torokhov wrote:
> > Hi Daniel,
> > 
> > On Wed, Apr 18, 2012 at 09:21:48PM +0800, Daniel Kurtz wrote:
> > > +	ret = i2c_transfer(client->adapter, xfer, 2);
> > > +	if (ret != 2) {
> > > +		dev_err(&client->dev, "i2c read reg failed (%d)\n", ret);
> > > +		if (ret >= 0)
> > > +			ret = -EIO;
> > >  	}
> > >  
> > > -	return 0;
> > > +	return (ret == 2) ? 0 : ret;
> > >  }
> > 
> > Would prefer:
> > 
> > 	ret = i2c_transfer(client->adapter, xfer, ARRAY_SIZE(xfer));
> > 	if (ret != ARRAY_SIZE(xfer)) {
> > 		if (ret >= 0)
> > 			ret = -EIO;
> > 		dev_err(&client->dev, "i2c read reg failed (%d)\n", ret);
> > 		return ret;
> > 	}
> > 
> > 	return 0;
> > 
> > 
> > Or maybe we need i2c_transfer_exact() wrapper? Jean?
> 
> What would this function do? Return 0 on success instead of the number
> of transferred messages? And -EIO on partial transfers?

Yes, exactly.

> 
> That would make sense. Partial success is a rare case anyway, and
> recovery possibilities are even rarer. I think most drivers don't
> bother and either retry the whole transaction or fail right away. In
> fact the number of messages successfully transferred is more useful to
> diagnose problems during driver development or debugging.
> 
> Feel free to write and send a patch introducing i2c_transfer_exact().
> It would make sense to have it log a debug message on partial success,
> as it is a rare case. Bonus points if you also sent one or more patches
> converting (some of) the existing callers to make use of the new
> function.

OK, thanks.

-- 
Dmitry
