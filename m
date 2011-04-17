Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab1DQCCj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 22:02:39 -0400
Received: from mail.solarflare.com ([216.237.3.220]:34530 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab1DQCCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 22:02:33 -0400
Subject: Re: [PATCH 4/5] ethtool: Use the full 32 bit speed range in
 ethtool's set_settings
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Decotigny <decot@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        ilon Greenstein <eilong@broadcom.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <1303001651-4074-4-git-send-email-decot@google.com>
References: <1303001651-4074-1-git-send-email-decot@google.com>
	 <1303001651-4074-4-git-send-email-decot@google.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare
Date: Sun, 17 Apr 2011 03:02:29 +0100
Message-ID: <1303005749.5282.909.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Apr 2011 02:02:33.0131 (UTC) FILETIME=[83CCFFB0:01CBFCA3]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18076.005
X-TM-AS-Result: No--18.609500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-04-16 at 17:54 -0700, David Decotigny wrote:
> This makes sure the ethtool's set_settings() callback of network
> drivers don't ignore the 16 most significant bits when ethtool calls
> their set_settings().
> 
> All the driver compiled with make allyesconfig on x86_64 have been
> updated.

You missed one generic function, mdio45_ethtool_gset_npage() in
drivers/net/mdio.c.

[...]
> diff --git a/drivers/net/dl2k.c b/drivers/net/dl2k.c
> index c05db60..ba6c151 100644
> --- a/drivers/net/dl2k.c
> +++ b/drivers/net/dl2k.c
> @@ -1219,11 +1219,11 @@ static int rio_set_settings(struct net_device *dev, struct ethtool_cmd *cmd)
>  	} else {
>  		np->an_enable = 0;
>  		if (np->speed == 1000) {
> -			cmd->speed = SPEED_100;
> +			ethtool_cmd_speed_set(cmd, SPEED_100);
>  			cmd->duplex = DUPLEX_FULL;
>  			printk("Warning!! Can't disable Auto negotiation in 1000Mbps, change to Manual 100Mbps, Full duplex.\n");
>  		}
> -		switch(cmd->speed + cmd->duplex) {
> +		switch (ethtool_cmd_speed(cmd) + cmd->duplex) {
[...]

If you're going to stop these drivers ignoring speed_hi, maybe you
should also stop them ignoring the difference between speed and duplex!
Currently the user can ask for 99 Mbit/s full-duplex and get 100 Mbit/s
half-duplex.

There are several others that use this trick.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

