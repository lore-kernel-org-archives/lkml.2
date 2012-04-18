Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab2DRGUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 02:20:14 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1758 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab2DRGUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 02:20:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 17 Apr 2012 23:20:01 -0700
Message-ID: <4F8E5CFD.4040501@nvidia.com>
Date: Wed, 18 Apr 2012 11:49:41 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Bryan Freed <bfreed@chromium.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "max@stro.at" <max@stro.at>,
        "jbrenner@taosinc.com" <jbrenner@taosinc.com>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "grundler@chromium.org" <grundler@chromium.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: iio: light: isl29018: use regmap for register
 access
References: <1334652631-21032-1-git-send-email-ldewangan@nvidia.com>	<4F8D5506.6070105@cam.ac.uk>	<4F8D5B09.8080309@nvidia.com> <CAEYUcX3TbXFmKYCvfz00tpJ3K0bSExnQxV1R==dP=+vsK54KPQ@mail.gmail.com>
In-Reply-To: <CAEYUcX3TbXFmKYCvfz00tpJ3K0bSExnQxV1R==dP=+vsK54KPQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Including Mark here for more insight/comment.

On Tuesday 17 April 2012 11:26 PM, Bryan Freed wrote:
> Hey Laxman, Jonathan.
>
> The regmap is pretty new to me.  In looking at it, I see
> _regmap_write() will regcache_write() before attempting to write to
> the device.
> This effectively updates the cached value even when the device write
> fails, which is the opposite of the current isl29018 cache policy.
>
> It looks like we tried to change the policy back in August and got
> this response:
>    >  I did change one basic behavior that I think was also broken: cache
>    >  the value regardless of if the transaction completed successfully or
>    >  not.
>    Don't do that.  That means userspace will get an invalid value if it reads
>    in the meantime. If you have an error on a hardware bus - tell userspace about
>    it and don't 'guess' what is in the register.
> See http://driverdev.linuxdriverproject.org/pipermail/devel/2011-August/020256.html
> for details.
>
> The result is likely to be that after a failed write to one field of a
> register, the next successful write to another field of that register
> will update them both.

yes, the caching is done before actual transfer and it can make cache 
dirty in case of transfer failure.
I am not sure what should be correct handling here: make cache dirty or 
revert the value to original one?
But using the regmap will provide the common behavior across the driver 
and all driver will have same behavior rather than handling on 
differently across driver.
So if there is any other policy for this, it will be same for all driver.


