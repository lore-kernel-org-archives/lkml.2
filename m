Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab1IHFQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 01:16:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:8642 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab1IHFQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 01:16:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,349,1312182000"; 
   d="scan'208";a="49154142"
From: "Luck, Tony" <tony.luck@intel.com>
To: Minskey Guo <chaohong_guo@linux.intel.com>,
        Chen Gong <gong.chen@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Date: Wed, 7 Sep 2011 22:16:04 -0700
Subject: RE: [PATCH 5/5] mce: recover from "action required" errors reported
 in data path in usermode
Thread-Topic: [PATCH 5/5] mce: recover from "action required" errors
 reported in data path in usermode
Thread-Index: Acxt1HpgAYxti2IxQ1KZ9BIUFi/J9gAEO/Pg
Message-ID: <987664A83D2D224EAE907B061CE93D5301EA9704CD@orsmsx505.amr.corp.intel.com>
References: <4e5eb50721061dbb1b@agluck-desktop.sc.intel.com>
 <4E6709B2.7020401@linux.intel.com> <4E683108.8020000@linux.intel.com>
In-Reply-To: <4E683108.8020000@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p885Gv6Y023868

>    __memory_failure() handling calls  some routines, such
> as  is_free_buddy_page(),  which needs to acquire the spin
> lock,  zone->lock. How can we guarantee that other CPUs
> haven't acquired the lock when receiving #mc broadcast
> and entering #mc handlers ?

By the time I call __memory_failure() - the other cpus have
been released from mce handler - so they are back executing
normal code.

But Chen Gong's earlier comments made me look again at entry_64.S
code - ane I realized that I missed seeing code in the return
path from do_machine_check() that switched from MCE stack to
regular kernel stack before processing TIF_MCE_NOTIFY.

I may go back and re-visit a path that I looked at to change
do_machine_check from "void" return to "unsigned long" and have
it return the address for the "AR" case and "0" otherwise.
Then we could switch out of machine check stack to non-mce
context to call __memory_failure().  When I looked at this
before the entry_64.S path looked plausible. The 32-bit
path looked to be painful (too many macros in entry_32.S)


-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
