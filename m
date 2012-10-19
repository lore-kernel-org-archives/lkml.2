Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161065Ab2JSDNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:13:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:64989 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964858Ab2JSDNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 23:13:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,610,1344236400"; 
   d="scan'208";a="206363211"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        ??? <cw00.choi@samsung.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        anish kumar <anish198519851985@gmail.com>
Subject: RE: RE: [PATCH] extcon : callback function to read cable property
Thread-Topic: RE: [PATCH] extcon : callback function to read cable property
Thread-Index: AQHNrDZYz6QBYjeG4EOZV386h3aappe/8Skg
Date: Fri, 19 Oct 2012 03:13:27 +0000
Message-ID: <20ADAB092842284E95860F279283C5643BD887@BGSMSX101.gar.corp.intel.com>
References: <18312556.138071350457714044.JavaMail.weblogic@epml24>
In-Reply-To: <18312556.138071350457714044.JavaMail.weblogic@epml24>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="ks_c_5601-1987"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9J3Dxsp015485



> > > > > Subject: Re: [PATCH] extcon : callback function to read cable
> > > > > property
> > > > >
> > > > > I think the reason why we have extcon is in first place is to
> > > > > only notify the clients of cable connection and disconnection
> > > > > and it is up to the client to decide what else to do with the
> > > > > cable such as finding which state it is in and other details.
> > > > > So I feel this should not be handled in the extcon.
> > > > >
> > > > > However it is up to the maintainer to decide.
> > > >
> > > > Once the consumer gets the notification, it needs to take some action.
> > > > One of the action is to read the cable properties. This can be
> > > > done by proprietary calls which is known both to the consumer and the
> provider.
> > > > My intention is to avoid this proprietary calls. Since both the
> > > > provider and consumer are communicating with the extcon subsystem
> > > > , I feel having a callback function of this kind would help to
> > > > avoid the use of proprietary calls. Also I agree that extcon
> > > > notifier chains are used to notify the cable state
> > > > (attach/detach). But if a cable has more than two states (like the
> > > > charger cable) how do we support it without
> > > having a callback function like this?
> > > > Let the maintainer take the final decision.
> > > Well this use case will keep on growing if we start factor in this
> > > kind of changes and that is why I am opposed to adding any other state.
> > > Maintainer?
> > > >
> > > >
> > >
> 
> Hello,
> 
> 
> I don't think it's appropriate to declare the charger specific properties in
> extcon.h. The status of a charger should be and can be represented by an
> instance of regulator, power-supply-class, or charger-manager.
> 
Agreed. We can move this to power supply subsystem.

> Thus, we may (I'm still not sure) need to let extcon to relay the instance
> (struct device? or char *devname?) with some callback similar with
> get_cable_device().  However, allowing (and encouraging) to pass void
> pointer of cable_props to extcon users from extcon device appears not
> adequete. If the both parties can use their own "private"
> data structure, why they cannot simply pass their own data witht the
> "private" data channel?
> 
> 
> Recap:
> - The later part of patch: NACK
> - The first part of patch (callback): need to reconsider the data type.
> We may get device pointer or device name that is correspondant to the
> cable, which in turn, guides us to the corresponding data structure (charger-
> manager, regulator, or something) However, I'm still not sure which should
> be appropriate for this.
> 

The requirement for this feature came from the implementation of the
power supply charging framework (http://www.spinics.net/lists/kernel/msg1420500.html 
refer charger_cable_event_worker function). The charging framework is not a driver. It can
be compiled with the power supply class driver to support charging. Also the
private data structure may not provide a generic method for this implementation
since the extcon provider drivers will be different in different platforms. So it's not
necessary that the framework knows the private data structure of the provider.
Basically the requirement is to have a generic method to retrieve the cable properties without
knowing the extcon provider driver internal implementation. Can you suggest a generic approach
for this problem?

Also the cable states we support in extcon (attach/detach) is not sufficient
to support the cable states of a charger cable which can have more than 2 states. The charger cable 
states can be (1)attach/(2)detach, (3)suspend - host suspend (different from detach since it's possible to charge
in this state but with a different charge current than the attached state),(4)resume - resume after the suspend,
(5)update - update the cable properties after USB enumeration (USB cable supports 100(USB2.0)/150(USB3.0)
in an un configured state. But after enumeration it can support up to 500mA(USB 2.0)/900(USB 3.0))

Since extcon is basically intended to support the cable states, how do we support cables with
more than two states?
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
