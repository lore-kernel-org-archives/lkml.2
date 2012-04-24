Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab2DXJWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 05:22:30 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4646 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab2DXJW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 05:22:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 24 Apr 2012 02:22:27 -0700
Message-ID: <4F967089.3050004@nvidia.com>
Date: Tue, 24 Apr 2012 14:51:13 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH V1 2/2] i2c: tegra: support for I2C_M_NOSTART protocol
 mangling
References: <1335251976-31925-1-git-send-email-ldewangan@nvidia.com>	<1335251976-31925-3-git-send-email-ldewangan@nvidia.com> <20120424105557.7ac07232@endymion.delvare>
In-Reply-To: <20120424105557.7ac07232@endymion.delvare>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 April 2012 02:25 PM, Jean Delvare wrote:
> On Tue, 24 Apr 2012 12:49:36 +0530, Laxman Dewangan wrote:
>> Adding support for protocol mangling I2C_M_NOSTART.
>> When multiple message transfer request made through i2c
>> and if any message is flagged with I2C_M_NOSTART then
>> it will not send the start/repeat start/address of that
>> message i.e. send the data directly.
>>
>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
>> ---
>>   drivers/i2c/busses/i2c-tegra.c |   32 +++++++++++++++++++++++++++-----
>>   1 files changed, 27 insertions(+), 5 deletions(-)
> What do you need this for?
>

The primary use-case here is scatter-gather of multiple I2C messages; 
the first message will contain the START and perhaps some transfers, 
then subsequent messages will continue with more data transfers. This 
removes the need to put all the data transfers into a single message, 
and hence avoids some copying of commands/data.

Mark Brown says this is important for regmap. This feature is implement 
gather support for I2C transfers - the resulting I2C transfer is 
entirely normal but this ends up being implemented by the controller 
doing two transfers back to back with no start on the second transfer. 
To the outside world it looks like a perfectly normal transfer. This 
behaviour can be emulated by allocating a buffer and coalescing the data 
into that buffer before sending it to the hardware but this introduces 
an avoidable and sometimes noticeable overhead.

Including Mark B here for more comment/insight.
