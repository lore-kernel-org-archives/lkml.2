Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab2ICTxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 15:53:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49974 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab2ICTxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 15:53:34 -0400
Date: Mon, 03 Sep 2012 15:53:32 -0400 (EDT)
Message-Id: <20120903.155332.1814926007061594344.davem@davemloft.net>
To: chikazawa.akifu@jp.fujitsu.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: when the MTU interface is modified, the promiscuous mode is
 reset in gianfar driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <201208270838.AA02326@VF09040P.jp.fujitsu.com>
References: <201208270838.AA02326@VF09040P.jp.fujitsu.com>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chikazawa.akifu@jp.fujitsu.com (近沢 哲史)
Date: Mon, 27 Aug 2012 17:38:34 +0900

>  I am using the gianfar ethernet driver. I am having a problem with the
>  interface settings.
>  Under promiscuous mode, when the MTU interface is modified, the promiscuous
>  mode setting is turned off in gianfar driver when it should not be.
> The details are as follows:
>  After changing MTU with ifconfig, I could see that the interface flag of
>  eth0 is still PROMISC.
>  However, when I checked value of RCTL register with ethtool, PROM bit of
>  RTCL register is cleared.
>  It seems to be cause that is the gfar_init_mac() function, it doesn't set
>  the PROM bit after the interface MTU is changed.
>  This problem was detected on linux-2.6.32.2, but it seems to same on
>  linux-3.6.0-rc3.
> Is this behavior on purpose?
> 
> I also attach the amended file,I think it would be so.
> 
> Signed-off-by: Akifumi Chikazawa <chikazawa.akifu@jp.fujitsu.com>

It seems like we also lose all of the multicast configurations as
well.

Therefore, the thing to do is to simply call gfar_set_multi() at the
appropriate location.  That will take care of both the promiscuous
bit, as well as the multicast addresses.

You can then remove some of the code in gfar_init_mac() that does
things like gfar_clear_exact_match(), because gfar_set_multi() will
take care of that if necessary.
