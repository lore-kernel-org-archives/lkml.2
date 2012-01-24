Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab2AXMtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 07:49:53 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35823 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab2AXMtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 07:49:52 -0500
Message-ID: <1327416561.32498.10.camel@lappy>
Subject: Re: [PATCH] net: caif: Don't act on notification for non-caif
 devices
From: Sasha Levin <levinsasha928@gmail.com>
To: Sjur =?ISO-8859-1?Q?Br=E6ndeland?= <sjurbren@gmail.com>
Cc: davem@davemloft.net, davej@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 24 Jan 2012 09:49:21 -0500
In-Reply-To: <CAJK669acbPLTxTDrk_uqdB2FmewcSA+HF0qEFADgT8YdfNMcpQ@mail.gmail.com>
References: <1327390229-30170-1-git-send-email-levinsasha928@gmail.com>
	 <CAJK669acbPLTxTDrk_uqdB2FmewcSA+HF0qEFADgT8YdfNMcpQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-24 at 11:52 +0100, Sjur Brændeland wrote:
> 
> Nack, we have to handle other device types than just ARPHDR_CAIF after
> introducing
> CAIF over USB/NCM. I'd rather fix this in netns by removing the BUG_ON
> and return
> NULL. How about this instead: 
[snip]

I think that doing it this way is wrong for two reasons:

1. The code in net/ assumes net_generic is a trivial dereference and doesn't check that it's not NULL. This means that if anything goes wrong there you'll have a more dangerous NULL deref instead of a BUG().

2. You'll need to add other device to that if() statement anyway, as it currently looks like this:

	cfg = get_cfcnfg(dev_net(dev));
	caifdevs = caif_device_list(dev_net(dev));
	if (!cfg || !caifdevs)
		return 0;

	caifd = caif_get(dev);
	if (caifd == NULL && dev->type != ARPHRD_CAIF)
		return 0;

What my patch did was simply move the type check to above the net_generic call, it didn't add any new checks - which according to what you said, you'll need to do anyway.

-- 

Sasha.

