Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab2I1Glq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 02:41:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:15025 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab2I1Glp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 02:41:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,499,1344236400"; 
   d="scan'208";a="227607825"
Message-ID: <506546A7.7030500@linux.intel.com>
Date: Fri, 28 Sep 2012 14:41:43 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120306 Thunderbird/3.1.20
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, tshimizu818@gmail.com,
        linux-kernel@vger.kernel.org, haicheng.lee@gmail.com
Subject: Re: [PATCH 1/2] Fix build error caused by broken PCH_PTP module dependency.
References: <506009A4.8000202@linux.intel.com>	<5060F97F.3040809@linux.intel.com> <20120927.180942.969924012897168294.davem@davemloft.net>
In-Reply-To: <20120927.180942.969924012897168294.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 06:09 AM, David Miller wrote:
> Look at how other people submit patches, do any other patch submissions
> look like your's having all of this metadata in the message body:
I'm sorry for it.

> As for this specific patch:
>
>> -	depends on PTP_1588_CLOCK_PCH
>> +	depends on PTP_1588_CLOCK_PCH = PCH_GBE
>
> This is not the correct way to ensure that the module'ness of one
> config option meets the module'ness requirements of another.
> The correct way is to say something like "&&  (PCH_GBE || PCH_GBE=n)"

This case is a little bit tricky than usual, with PCH_PTP selected, the valid 
config would be either "PTP_1588_CLOCK_PCH=PCH_GBE=m" or 
"PTP_1588_CLOCK_PCH=PCH_GBE=y", and PTP_1588_CLOCK_PCH depends on PCH_GBE.

So are you ok with this:
+	depends on PTP_1588_CLOCK_PCH && (PCH_GBE=m || PTP_1588_CLOCK_PCH=y)

or simply like:
---
From: Haicheng Li <haicheng.lee@gmail.com>

Fix build error caused by broken PCH_PTP module dependency.
The .config is:
         CONFIG_PCH_GBE=y
         CONFIG_PCH_PTP=y
         CONFIG_PTP_1588_CLOCK=m

The build error:

drivers/built-in.o: In function `pch_tx_timestamp':
.../pch_gbe_main.c:215: undefined reference to `pch_ch_event_read'
.../pch_gbe_main.c:225: undefined reference to `pch_tx_snap_read'
.../pch_gbe_main.c:231: undefined reference to `pch_ch_event_write'

.../pch_gbe_main.c:170: undefined reference to `pch_ch_event_read'
.../pch_gbe_main.c:175: undefined reference to `pch_src_uuid_lo_read'
.../pch_gbe_main.c:176: undefined reference to `pch_src_uuid_hi_read'
.../pch_gbe_main.c:190: undefined reference to `pch_ch_event_write'
.../pch_gbe_main.c:184: undefined reference to `pch_rx_snap_read'

.../pch_gbe_main.c:267: undefined reference to `pch_ch_control_write'
.../pch_gbe_main.c:271: undefined reference to `pch_ch_control_write'
.../pch_gbe_main.c:275: undefined reference to `pch_ch_control_write'
.../pch_gbe_main.c:281: undefined reference to `pch_ch_control_write'
.../pch_gbe_main.c:283: undefined reference to `pch_set_station_address'
.../pch_gbe_main.c:290: undefined reference to `pch_ch_event_write'

Signed-off-by: Haicheng Li <haicheng.lee@gmail.com>
---
  drivers/net/ethernet/oki-semi/pch_gbe/Kconfig |    4 ++--
  1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig 
b/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig
index bce0164..df1e649 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig
@@ -21,12 +21,12 @@ config PCH_GBE
  	  ML7223/ML7831 is companion chip for Intel Atom E6xx series.
  	  ML7223/ML7831 is completely compatible for Intel EG20T PCH.

-if PCH_GBE
+if PTP_1588_CLOCK_PCH

  config PCH_PTP
  	bool "PCH PTP clock support"
  	default n
-	depends on PTP_1588_CLOCK_PCH
+	depends on PTP_1588_CLOCK_PCH=y || PCH_GBE=m
  	---help---
  	  Say Y here if you want to use Precision Time Protocol (PTP) in the
  	  driver. PTP is a method to precisely synchronize distributed clocks
-- 
1.7.1



-haicheng
