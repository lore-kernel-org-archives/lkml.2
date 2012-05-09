Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab2EIHFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 03:05:16 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:38186 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab2EIHFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 03:05:14 -0400
Date: Wed, 9 May 2012 09:05:00 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 03/14 v3] Input: atmel_mxt_ts - refactor 
 mxt_read/write_reg to take a length
Message-ID: <20120509090500.1dc9143e@endymion.delvare>
In-Reply-To: <20120509055411.GG10514@core.coreip.homeip.net>
References: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
	<1334755319-21365-4-git-send-email-djkurtz@chromium.org>
	<20120509055411.GG10514@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmirty,

On Tue, 8 May 2012 22:54:11 -0700, Dmitry Torokhov wrote:
> Hi Daniel,
> 
> On Wed, Apr 18, 2012 at 09:21:48PM +0800, Daniel Kurtz wrote:
> > +	ret = i2c_transfer(client->adapter, xfer, 2);
> > +	if (ret != 2) {
> > +		dev_err(&client->dev, "i2c read reg failed (%d)\n", ret);
> > +		if (ret >= 0)
> > +			ret = -EIO;
> >  	}
> >  
> > -	return 0;
> > +	return (ret == 2) ? 0 : ret;
> >  }
> 
> Would prefer:
> 
> 	ret = i2c_transfer(client->adapter, xfer, ARRAY_SIZE(xfer));
> 	if (ret != ARRAY_SIZE(xfer)) {
> 		if (ret >= 0)
> 			ret = -EIO;
> 		dev_err(&client->dev, "i2c read reg failed (%d)\n", ret);
> 		return ret;
> 	}
> 
> 	return 0;
> 
> 
> Or maybe we need i2c_transfer_exact() wrapper? Jean?

What would this function do? Return 0 on success instead of the number
of transferred messages? And -EIO on partial transfers?

That would make sense. Partial success is a rare case anyway, and
recovery possibilities are even rarer. I think most drivers don't
bother and either retry the whole transaction or fail right away. In
fact the number of messages successfully transferred is more useful to
diagnose problems during driver development or debugging.

Feel free to write and send a patch introducing i2c_transfer_exact().
It would make sense to have it log a debug message on partial success,
as it is a rare case. Bonus points if you also sent one or more patches
converting (some of) the existing callers to make use of the new
function.

-- 
Jean Delvare
