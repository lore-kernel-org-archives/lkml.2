Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab2JYDS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 23:18:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:29769 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140Ab2JYDS1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 23:18:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,643,1344236400"; 
   d="scan'208";a="208992844"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        anish kumar <anish198519851985@gmail.com>
Subject: RE: [PATCH] extcon : callback function to read cable property
Thread-Topic: [PATCH] extcon : callback function to read cable property
Thread-Index: AQHNrmPuW/u4e5/PKkelYut1V5yfTpfIf2aw
Date: Thu, 25 Oct 2012 03:18:04 +0000
Message-ID: <20ADAB092842284E95860F279283C5643E590E@BGSMSX101.gar.corp.intel.com>
References: <18312556.138071350457714044.JavaMail.weblogic@epml24>
 <20ADAB092842284E95860F279283C5643BD887@BGSMSX101.gar.corp.intel.com>
 <5082010B.4040102@samsung.com>
In-Reply-To: <5082010B.4040102@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Subject: Re: [PATCH] extcon : callback function to read cable property
> 
> On 10/19/2012 12:13 PM, Tc, Jenny wrote:
> >
> >
> >>>>>> Subject: Re: [PATCH] extcon : callback function to read cable
> >>>>>> property
> >>>>>>
> >>>>>> I think the reason why we have extcon is in first place is to
> >>>>>> only notify the clients of cable connection and disconnection and
> >>>>>> it is up to the client to decide what else to do with the cable
> >>>>>> such as finding which state it is in and other details.
> >>>>>> So I feel this should not be handled in the extcon.
> >>>>>>
> >>>>>> However it is up to the maintainer to decide.
> >>>>>
> >>>>> Once the consumer gets the notification, it needs to take some
> action.
> >>>>> One of the action is to read the cable properties. This can be
> >>>>> done by proprietary calls which is known both to the consumer and
> >>>>> the
> >> provider.
> >>>>> My intention is to avoid this proprietary calls. Since both the
> >>>>> provider and consumer are communicating with the extcon
> subsystem
> >>>>> , I feel having a callback function of this kind would help to
> >>>>> avoid the use of proprietary calls. Also I agree that extcon
> >>>>> notifier chains are used to notify the cable state
> >>>>> (attach/detach). But if a cable has more than two states (like the
> >>>>> charger cable) how do we support it without
> >>>> having a callback function like this?
> >>>>> Let the maintainer take the final decision.
> >>>> Well this use case will keep on growing if we start factor in this
> >>>> kind of changes and that is why I am opposed to adding any other
> state.
> >>>> Maintainer?
> >>>>>
> >>>>>
> >>>>
> >>
> >> Hello,
> >>
> >>
> >> I don't think it's appropriate to declare the charger specific
> >> properties in extcon.h. The status of a charger should be and can be
> >> represented by an instance of regulator, power-supply-class, or charger-
> manager.
> >>
> > Agreed. We can move this to power supply subsystem.
> >
> >> Thus, we may (I'm still not sure) need to let extcon to relay the
> >> instance (struct device? or char *devname?) with some callback
> >> similar with get_cable_device().  However, allowing (and encouraging)
> >> to pass void pointer of cable_props to extcon users from extcon
> >> device appears not adequete. If the both parties can use their own
> "private"
> >> data structure, why they cannot simply pass their own data witht the
> >> "private" data channel?
> >>
> >>
> >> Recap:
> >> - The later part of patch: NACK
> >> - The first part of patch (callback): need to reconsider the data type.
> >> We may get device pointer or device name that is correspondant to the
> >> cable, which in turn, guides us to the corresponding data structure
> >> (charger- manager, regulator, or something) However, I'm still not
> >> sure which should be appropriate for this.
> >>
> >
> > The requirement for this feature came from the implementation of the
> > power supply charging framework
> > (http://www.spinics.net/lists/kernel/msg1420500.html
> > refer charger_cable_event_worker function). The charging framework is
> > not a driver. It can be compiled with the power supply class driver to
> > support charging. Also the private data structure may not provide a
> > generic method for this implementation since the extcon provider
> > drivers will be different in different platforms. So it's not necessary that the
> framework knows the private data structure of the provider.
> > Basically the requirement is to have a generic method to retrieve the
> > cable properties without knowing the extcon provider driver internal
> > implementation. Can you suggest a generic approach for this problem?
> >
> The rold of extcon inform only attached/detached state of extcon consumer
> driver from extcon provider driver. After extcon consumer driver detect the
> state of cable through extcon, extcon consumer driver or framework should
> get the additional information of cable from other device driver except of
> extcon.
> 
> Also, extcon manage various cables (e.g., USB, TA, MHL, JIG-USB-ON, JIG-
> USB-OFF, Dock) What are common properties among many cables expect
> attached or detached state?
> 

For charger cable the current each cable can provide will be common.
But may not be relevant for other cables. 

I understand your point on extcon role. But my concern is, when the consumer
driver gets a notification on cable state change, how does the consumer query the
cable properties in a generic way. Do you have any suggestions for this?

A use case can be as below

When a USB host cable (SDP) connected to the platform, without USB enumeration
it can support only up to 100mA(USB2.)/150mA(USB 3.0) (As per USB charging spec).
Once the enumeration is done this can be 500mA/950mA. If the consumer charger driver
need to configure the charger chip, it need to know the charger cable capabilities.
For example a platform PLAT1 may have charger driver CHRGR1 and OTG driver OTG1.
But platform PLAT2 may have CHGR1 but different OTG driver OTG2. How 
CHGR1 driver can detect  the cable properties without having any platform layer
hooks? The platform layer hooks (using platform data)will work only if the consumer is
a platform driver. What if it's a framework which will have the same flow in all platforms?

> > Also the cable states we support in extcon (attach/detach) is not
> > sufficient to support the cable states of a charger cable which can
> > have more than 2 states. The charger cable states can be
> > (1)attach/(2)detach, (3)suspend - host suspend (different from detach
> > since it's possible to charge in this state but with a different
> > charge current than the attached state),(4)resume - resume after the
> > suspend, (5)update - update the cable properties after USB enumeration
> > (USB cable supports 100(USB2.0)/150(USB3.0) in an un configured state.
> > But after enumeration it can support up to 500mA(USB 2.0)/900(USB
> > 3.0))
> >
> > Since extcon is basically intended to support the cable states, how do
> > we support cables with more than two states?
> 
> You explained about charger cable for charging framework. I think that
> extcon consumer driver can detect the chagne of system state from idle to
> suspend, then extcon consumer driver change charge current according to
> system state(idle or suspend).  Also, I think that the main of charging is
> regulator and the regulator for charging defines max or min limitation of
> charge current with H/W dependency. The extcon provider driver haven't
> decided the charge current according to cable type.
> 

I was referring to the host suspend case when we use SDP cable. For example if the
cable is connected to a host machine to charger a target, the charger current supplied by
the host will vary based on the HOST power state. For example if it's in suspend, some platforms
support 500mA but other platforms may prefer to comply USB spec ie 2.5mA.

> Now that extcon-max77693 MUIC device driver can detect difference
> between "MHL" and "MHL-TA"
> when MHL/MHL-TA cable is attached/detached and define two type cable of
> MHL cable.
> 
> Thanks,
> Chanwoo Choi
