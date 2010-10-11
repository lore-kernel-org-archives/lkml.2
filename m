Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab0JKH4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 03:56:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57557 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab0JKH4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 03:56:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=mK/KsnqGYqkidMhZCdgMtjYlSube1JUqwcYyjZyAcz1qXAgimwQtuKREWW8XAX+epj
         6rLwkSlE7rDQpIIl9LGPEtDd5291jzwmchZeFw3q0GFErKU6yvx+BkTN1mFnspRnOUiR
         anKCFgp6G1Dqa86KU7Ht+7g2p1Y1pGOSpMgd0=
Message-ID: <4CB2C33C.8080109@gmail.com>
Date: Mon, 11 Oct 2010 09:56:44 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.9) Gecko/20100914 SUSE/3.1.4 Thunderbird/3.1.4
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: ML netdev <netdev@vger.kernel.org>,
        linux-atm-general@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>, chas@cmf.nrl.navy.mil
Subject: [HELP] ATM: mpc, use-after-free
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Stanse found this use-after-free:

static void mpc_push(struct atm_vcc *vcc, struct sk_buff *skb)
{
...
        new_skb = skb_realloc_headroom(skb, eg->ctrl_info.DH_length);

        dev_kfree_skb_any(skb);

FREE    ^^^^^^^^^^^^^^^^^^^^^^^

        if (new_skb == NULL) {
                mpc->eg_ops->put(eg);
                return;
        }
        skb_push(new_skb, eg->ctrl_info.DH_length);
        skb_copy_to_linear_data(new_skb, eg->ctrl_info.DLL_header,
                                eg->ctrl_info.DH_length);
 ...
        memset(ATM_SKB(skb), 0, sizeof(struct atm_skb_data));

USE            ^^^^^^^^^^^^

        netif_rx(new_skb);

I guess it should be ATM_SKB(new_skb), right?

The two problems are:
1) obvious use-after-free
2) ?data leak, since we don't erase the right memory?

thanks,
-- 
js
