Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab2KIOFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:05:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:33043 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669Ab2KIOFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 09:05:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,745,1344236400"; 
   d="scan'208";a="217280840"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        anish kumar <anish198519851985@gmail.com>,
        "myunjoo.ham@gmail.com" <myunjoo.ham@gmail.com>
Subject: RE: [PATCH] extcon : callback function to read cable property
Thread-Topic: [PATCH] extcon : callback function to read cable property
Thread-Index: AQHNpqL6iLZgSIxMH0GKmzwm7ve2K5eyQk0AgAEKtWCAAHd6AIAJUHGggCHhgICAAoy5YA==
Date: Fri, 9 Nov 2012 14:05:03 +0000
Message-ID: <20ADAB092842284E95860F279283C5644017F6@BGSMSX101.gar.corp.intel.com>
References: <1349864628-21479-1-git-send-email-jenny.tc@intel.com>
 <1349880328.22926.2.camel@anish-Inspiron-N5050>
 <20ADAB092842284E95860F279283C56439BC4A@BGSMSX101.gar.corp.intel.com>
 <1349963260.8329.1.camel@anish-Inspiron-N5050>
 <20ADAB092842284E95860F279283C5643BA10D@BGSMSX101.gar.corp.intel.com>
 <509B0A0F.5000406@samsung.com>
In-Reply-To: <509B0A0F.5000406@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qA9E5Im5031154

> I think that the role of extcon subsystem notify changed
> state(attached/detached) of cable to notifiee, but if you want to add
> property feature of cable, you should solve ambiguous issues.
> 
> First,
> This patch only support the properties of charger cable but, never support
> property of other cable. The following structure depend on only charger
> cable. We can check it the following structure:
> 	struct extcon_chrg_cbl_props {
> 		enum extcon_chrgr_cbl_stat cable_state;
> 		unsigned long mA;
> 	};
> 
> I think that the patch have to support all of cables for property feature.

My suggestion is to have a structure like this 

struct  extcon_cablel_props {
	unsigned int cable_state;
    	unsigned int data; 
}

Not all cables will have more than two states. If any cable has more than two states,
the above structure makes it flexible to represent additional state and the data associated

> 
> Second,
> Certainly, you should define common properties of all cables and specific
> properties of each cable. The properties of charger cable should never be
> defined only.

Hope above structure would be enough to represent the common cable state and
it's data. If a cable has more than two states, then extcon_update_state can be used to
notify the consumer
1)Provider can just toggle the "state" argument to notify the consumer that cable state is 
changed
OR
2) Add one more argument  like  extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state1, u32 sate2)
If the state2 is set, then consumers can use get_cable_properties() to query the cable properties. State2 need to be
used only if the cable need to represent more than two state

> 
> Third,
> If we finish to decide the properties for all cables, I'd like to see a example
> code.

Agreed. If we  agree on the above structure, I can modify the charging subsystem patch
to use the same structure. (https://lkml.org/lkml/2012/10/18/219). This would give a reference
for the new feature.

> 
> You explained following changed state of USB according to Host state on
> other patch.
> ---------------------------
> For USB2.0
> 1) CONNECT (100mA)->UPDATE(500mA)->DISCONNECT(0mA)
> 2) CONNECT (100mA)->UPDATE(500mA)->HOST SUSPEND(2.5mA/500mA)-
> >DISCONNECT(0mA)
> 3) CONNECT (100mA)->UPDATE(500mA)->HOST SUSPEND(2.5mA/500mA)-
> >HOST RESUME(500mA)->DISCONNECT(0mA)
> 
> For USB 3.0
> 4) CONNECT (150mA)->UPDATE(900mA)->DISCONNECT(0mA)
> 5) CONNECT (150mA)->UPDATE(900mA)-> HOST SUSPEND(2.5mA/900mA)-
> >DISCONNECT(0mA)
> 6) CONNECT (100mA)->UPDATE(900mA)->HOST SUSPEND(2.5mA/900mA)-
> >HOST RESUME(900mA)->DISCONNECT(0mA)
> ---------------------------
> 
> I have a question. Can the provider device driver(e.g., extcon-max77693.c/
> extcon-max8997.c) detect the changed state of host? I'd like to see the
> example device driver that the provider device driver detect changed state
> of host.
> Could you provide example device driver?

Good question. The OTG drivers are capable of identifying the SUSPEND event.
System cannot setup SDP (USB host) charging with maximum charging current - 500mA
(USB2.0/ 900mA(USB 3)) without enumerating the USB. The USB enumeration can be
done only with a USB/OTG driver. IMHO the above extcon drivers
(extcon-max77693.c/ extcon-max8997.c) are not capable of doing the USB enumeration
and identifying the charge current. They can just identify the charger type - 
SDP/DCP/CDP/ACA/AC. The intelligence for USB enumeration 
should be inside USB/OTG driver.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
