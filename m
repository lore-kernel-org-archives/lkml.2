Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab0KVTEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 14:04:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38191
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750793Ab0KVTEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 14:04:54 -0500
Date: Mon, 22 Nov 2010 11:05:19 -0800 (PST)
Message-Id: <20101122.110519.39205345.davem@davemloft.net>
To: alban.crequy@collabora.co.uk
Cc: eric.dumazet@gmail.com, shemminger@vyatta.com, gorcunov@openvz.org,
        adobriyan@gmail.com, lennart@poettering.net, kay.sievers@vrfy.org,
        ian.molton@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] AF_UNIX: find the recipients for multicast messages
From: David Miller <davem@davemloft.net>
In-Reply-To: <1290450982-17480-4-git-send-email-alban.crequy@collabora.co.uk>
References: <20101122183447.124afce5@chocolatine.cbg.collabora.co.uk>
	<1290450982-17480-4-git-send-email-alban.crequy@collabora.co.uk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alban Crequy <alban.crequy@collabora.co.uk>
Date: Mon, 22 Nov 2010 18:36:17 +0000

> unix_find_multicast_recipients() builds an array of recipients. It can either
> find the peers of a specific multicast address, or find all the peers of all
> multicast group the sender is part of.
> 
> Signed-off-by: Alban Crequy <alban.crequy@collabora.co.uk>

You really should use RCU to lock this stuff, this way sends run
lockless and have less worries wrt. the memory allocation.  You'll
also only take a spinlock in the write paths which change the
multicast groups, which ought to be rare.

Although to be honest you should optimize the case of small numbers of
recipients, in the same way we optimize small numbers of iovecs on
sends.  Have an on-stack array that holds a small number of entries
and use that if the set fits, otherwise dynamic allocation.
