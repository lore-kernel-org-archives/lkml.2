Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab1BIHDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 02:03:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53630
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898Ab1BIHD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 02:03:29 -0500
Date: Tue, 08 Feb 2011 23:04:04 -0800 (PST)
Message-Id: <20110208.230404.189683472.davem@davemloft.net>
To: toshiharu-linux@dsn.okisemi.com
Cc: netdev@vger.kernel.org, tomoya-linux@dsn.okisemi.com, qi.wang@intel.com,
        yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pch_gbe: Fix the issue which a driver locks when rx
 offload is set by ethtool
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110208.225702.104076116.davem@davemloft.net>
References: <20110208.164030.242137610.davem@davemloft.net>
	<3F7E1C17407A45E3834BF70553CB294C@hacdom.okisemi.com>
	<20110208.225702.104076116.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 08 Feb 2011 22:57:02 -0800 (PST)

> From: "Toshiharu Okada" <toshiharu-linux@dsn.okisemi.com>
> Date: Wed, 9 Feb 2011 11:04:11 +0900
> 
>> From: David Miller <davem@davemloft.net>
>> Date: Tue, 08 Feb 2011 16:40:30 -0800 (PST)
>> 
>>>> @@ -531,12 +533,8 @@ void pch_gbe_reinit_locked(struct pch_gbe_adapter 
>>>> *adapter)
>>>>  {
>>>>  struct net_device *netdev = adapter->netdev;
>>>>
>>>> - rtnl_lock();
>>>> - if (netif_running(netdev)) {
>>>> - pch_gbe_down(adapter);
>>>> - pch_gbe_up(adapter);
>>>> - }
>>>> - rtnl_unlock();
>>>> + pch_gbe_down(adapter);
>>>> + pch_gbe_up(adapter);
>>>
>>>Are you sure you can just blindly delete the netif_running() check here?
>> 
>> Yes, sure.
>> pch_gbe_reinit_locked() is called after confirming of netif_running() except 
>> for pch_gbe_reset_task() function.
>> This netif_running() was redundant.
> 
> Thanks for explaining, applied, thank you.

Actually, I had to revert, this patch introduces an obvious compiler warning:

drivers/net/pch_gbe/pch_gbe_main.c: In function 'pch_gbe_reinit_locked':
drivers/net/pch_gbe/pch_gbe_main.c:533:21: warning: unused variable 'netdev'

Sloppy build issues like this reflects very poorly upon the patch
submitter.
