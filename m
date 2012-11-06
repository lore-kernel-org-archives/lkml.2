Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab2KFW5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 17:57:44 -0500
Received: from mga14.intel.com ([143.182.124.37]:32828 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab2KFW5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 17:57:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,724,1344236400"; 
   d="scan'208";a="165261427"
From: "Woodhouse, David" <david.woodhouse@intel.com>
To: Krzysztof Mazur <krzysiek@podlesie.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chas Williams - CONTRACTOR <chas@cmf.nrl.navy.mil>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v3 5/7] pppoatm: take ATM socket lock in pppoatm_send()
Thread-Topic: [PATCH v3 5/7] pppoatm: take ATM socket lock in pppoatm_send()
Thread-Index: AQHNvGz3+/ZM1gSqR0mkUiHOeUa5KJfda2IA
Date: Tue, 6 Nov 2012 22:57:39 +0000
Message-ID: <1352242658.7340.19.camel@shinybook.infradead.org>
References: <1352240222-363-1-git-send-email-krzysiek@podlesie.net>
	 <1352240222-363-6-git-send-email-krzysiek@podlesie.net>
In-Reply-To: <1352240222-363-6-git-send-email-krzysiek@podlesie.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.122.128]
Content-Type: text/plain; charset="utf-8"
Content-ID: <1DDACE81D6B5FA409A8BD38C858EA4BA@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qA6MvkM8017521

On Tue, 2012-11-06 at 23:17 +0100, Krzysztof Mazur wrote:
> +       if (sock_owned_by_user(sk_atm(vcc)))
> +               goto nospace;

I still think this one can lead to an infinite stall of the PPP channel,
because we return 0 from pppoatm_send() but never make a later call to
ppp_output_wakeup() to unblock it.

In the existing cases where we could return 0 (because
pppoatm_may_send() said no), we were careful to set the BLOCKED flag and
we *knew* that a packet was in flight so we'd get to wake it up again on
a subsequent pppoatm_pop().

None of that works for this new code path that returns zero.

-- 
                   Sent with MeeGo's ActiveSync support.

David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
