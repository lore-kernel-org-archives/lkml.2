Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab0LaTUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 14:20:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47243
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754118Ab0LaTUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 14:20:30 -0500
Date: Fri, 31 Dec 2010 11:21:01 -0800 (PST)
Message-Id: <20101231.112101.70194518.davem@davemloft.net>
To: tilman@imap.cc
Cc: jj@chaosbits.net, gigaset307x-common@lists.sourceforge.net, hjlipp@web.de,
        isdn@linux-pingi.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ISDN, Gigaset: Fix memory leak in do_disconnect_req()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D1A2185.2010700@imap.cc>
References: <alpine.LNX.2.00.1012262053130.20797@swampdragon.chaosbits.net>
	<4D1A2185.2010700@imap.cc>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Tue, 28 Dec 2010 18:42:29 +0100

> Quite correct. Thanks for finding and fixing this.
> 
> Am 26.12.2010 20:59 schrieb Jesper Juhl:
>> Hi,
>> 
>> In drivers/isdn/gigaset/capi.c::do_disconnect_req() we will leak the 
>> memory allocated (with kmalloc) to 'b3cmsg' if the call to alloc_skb() 
>> fails.
>> 
>> ...
>> 		b3cmsg = kmalloc(sizeof(*b3cmsg), GFP_KERNEL);
>> 	allocation here ------^
>> 		if (!b3cmsg) {
>> 			dev_err(cs->dev, "%s: out of memory\n", __func__);
>> 			send_conf(iif, ap, skb, CAPI_MSGOSRESOURCEERR);
>> 			return;
>> 		}
>> 		capi_cmsg_header(b3cmsg, ap->id, CAPI_DISCONNECT_B3, CAPI_IND,
>> 				 ap->nextMessageNumber++,
>> 				 cmsg->adr.adrPLCI | (1 << 16));
>> 		b3cmsg->Reason_B3 = CapiProtocolErrorLayer1;
>> 		b3skb = alloc_skb(CAPI_DISCONNECT_B3_IND_BASELEN, GFP_KERNEL);
>> 		if (b3skb == NULL) {
>> 			dev_err(cs->dev, "%s: out of memory\n", __func__);
>> 			send_conf(iif, ap, skb, CAPI_MSGOSRESOURCEERR);
>> 			return;
>> 	leak here ------^
>> ...
>> 
>> This leak is easily fixed by just kfree()'ing the memory allocated to 
>> 'b3cmsg' right before we return. The following patch does that.
>> 
>> 
>> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> Acked-by: Tilman Schmidt <tilman@imap.cc>

Applied.
