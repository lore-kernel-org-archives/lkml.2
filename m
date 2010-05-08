Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab0EHCBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 22:01:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:24313 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572Ab0EHCBG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 22:01:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,351,1270450800"; 
   d="scan'208";a="619901802"
From: "Du, Alek" <alek.du@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Ondrej Zary <linux@rainbow-software.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Date: Sat, 8 May 2010 10:00:59 +0800
Subject: RE: [linux-pm] [PATCH v2] [RFC] ehci: Disable wake on overcurrent
 (WKOC_E) and disconnect (WKDISC_E)
Thread-Topic: [linux-pm] [PATCH v2] [RFC] ehci: Disable wake on overcurrent
 (WKOC_E) and disconnect (WKDISC_E)
Thread-Index: Acrt+OPbPENtsyftSB24D3M3BnEK8AAT4YBg
Message-ID: <1865303E0DED764181A9D882DEF65FB61A82A6DF26@shsmsx502.ccr.corp.intel.com>
References: <20100507093200.28ecd63c@dxy2>
 <Pine.LNX.4.44L0.1005071106570.1804-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1005071106570.1804-100000@iolanthe.rowland.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Fri, 7 May 2010, Du, Alek wrote:
>
>> Alan,
>>
>> As I tested, with the second patch, after entering phy low power mode, the
>port cannot detect any USB devices that plugged in.
>
>Ooh, that's not good.  It almost violates the EHCI spec (see the last
>line on p.60 in table 4.4).

Ok, that's the new behavior that PHCD brings to us, It shouldn't a big deal if we
take care of the wakeup bits before PHCD, right? The spec may be modified if
PHCD become a normal feature to EHCI, just like why we have EHCI1.1 addendum
spec. (We have some ehci1.1 addendum patches that will submit soon, but the
PHCD is not in EHCI1.1 addendum currently)

>
>> I also confirm that after set PHCD flag, any write to PORTSC is illegal. (I have
>another patch will send out soon named "Clear PHCD before resuming",
>> but the patch is not related with this one)
>
>I'm afraid we are going to have to modify the wakeup bits in PORTSC
>after PHCD is set.  Can we clear PHCD, modify PORTSC, and then set PHCD
>again?

This is doable. It is confirmed by the HW designer, before accessing PORTSC, just
Clear PHCD. But we still need additional 5ms for the second time PHCD setting to
ensure it enter phy low power mode.

>
>> So it seems wakeup bits must set before set PHCD. So we may revise the
>flowchart a little bit, for example, if the HCD has hostpc,
>> then set the wakeup bits like before, if the HCD is the normal one, then go
>your new way?
>
>For normal HCDs, the wakeup bits don't matter when the controller is in
>D0.  Therefore we can continue to set them as before during bus or port
>suspend.
>
>But during controller suspend, if the controller isn't supposed to be
>remote-wakeup-enabled then we will need to clear the wakeup bits
>(and set them again during controller resume).  Will that work?

That should be ok. For Moorestown, the controller should always enable remote
wakeup, so that won't impact us.

>
>Alan Stern

