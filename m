Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab2AXPGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 10:06:35 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48082 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2AXPGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 10:06:33 -0500
MIME-Version: 1.0
In-Reply-To: <1327416561.32498.10.camel@lappy>
References: <1327390229-30170-1-git-send-email-levinsasha928@gmail.com>
	<CAJK669acbPLTxTDrk_uqdB2FmewcSA+HF0qEFADgT8YdfNMcpQ@mail.gmail.com>
	<1327416561.32498.10.camel@lappy>
Date: Tue, 24 Jan 2012 16:06:32 +0100
Message-ID: <CAJK669ZWJsxnSiyKWFFFUWOA3TaGMY-AmgWuVsYfR=tKQaODgg@mail.gmail.com>
Subject: Re: [PATCH] net: caif: Don't act on notification for non-caif devices
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: davem@davemloft.net, davej@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sasha,

>> Nack, we have to handle other device types than just ARPHDR_CAIF after
>> introducing CAIF over USB/NCM.
> What my patch did was simply move the type check to above the net_generic call,
> it didn't add any new checks - which according to what you said, you'll need to do anyway.

As I said I, don't think your patch would work. Try to see what happens if
dev->type != ARPHDR_CAIF and caifd != NULL. Then the statement:

	if (caifd == NULL && dev->type != ARPHRD_CAIF)
		return 0;
is very different from:

       if (dev->type != ARPHRD_CAIF)
               return 0;
...
       if (caifd == NULL)
               return 0;

Anyway, another option could be to explicitly check if name space is
initialized,
similar to what net_generic() does,e.g. something like:

diff --git a/net/caif/caif_dev.c b/net/caif/caif_dev.c
index 673728a..3197bc2 100644
--- a/net/caif/caif_dev.c
+++ b/net/caif/caif_dev.c
@@ -371,6 +371,13 @@ static int caif_device_notify(struct notifier_block *me, un
        struct cflayer *layer, *link_support;
        int head_room = 0;
        struct caif_device_entry_list *caifdevs;
+       int len;
+
+       rcu_read_lock();
+       len = rcu_dereference(dev_net(dev)->gen)->len;
+       rcu_read_unlock();
+       if (caif_net_id > len)
+               return 0;

        cfg = get_cfcnfg(dev_net(dev));
        caifdevs = caif_device_list(dev_net(dev));
--

Regards,
Sjur
