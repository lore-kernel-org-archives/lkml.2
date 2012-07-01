Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab2GAMWR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 08:22:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:29500 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932295Ab2GAMWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 08:22:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="162772915"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Anton Vorontsov (cbouatmailru@gmail.com)" <cbouatmailru@gmail.com>,
        "Anton Vorontsov (anton.vorontsov@linaro.org)" 
	<anton.vorontsov@linaro.org>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>,
        =?ks_c_5601-1987?B?w9bC+b/s?= <cw00.choi@samsung.com>,
        =?ks_c_5601-1987?B?udqw5rnO?= <kyungmin.park@samsung.com>
Subject: RE: Charger Manager Proposal.
Thread-Topic: Charger Manager Proposal.
Thread-Index: AQHNUzandOUTr9ZTmkKYrtWvKOeXGJcRJjyg
Date: Sun, 1 Jul 2012 12:22:09 +0000
Message-ID: <20ADAB092842284E95860F279283C564299FD7@BGSMSX101.gar.corp.intel.com>
References: <27205114.39211340672223116.JavaMail.weblogic@epv6ml01>
In-Reply-To: <27205114.39211340672223116.JavaMail.weblogic@epv6ml01>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q61CMNg0003573

Hi,

Thanks a lot for your reply. 

To give more insight to the requirements please find the battery profile format we use.

Charge Termination current 
	* Should be programmed to charger or used by charger driver to stop charging along with the voltage level for charger full. The charge full voltage level will change based on temperature zone or maintenance charging
Maximum voltage
	* Maximum voltage battery can support in any temperature zone
Battery type
	* Type of battery (Li-ION)
Lower temperature limit
	* Lowest temperature zone at which charging is allowed.
Number of temperature monitoring Ranges 
	* As per PSE standard it's 6

Each zone as the following attributes
Upper temperature Limit
	* Upper temperature zone for this range
Full charge voltage
	* CV for this range
Full charge current
	* CC for this range
Maintenance restart voltage
	* In maintenance mode, charging will be resumed on this voltage level.
Maintenance charging stop voltage
	* This voltage is used as CV in maintenance voltage. Used with charge termination current to stop charging in maintenance charging mode.
Maintenance charge current
	* CC for maintenance charging mode. This gives a flexibility to use a lower CC in maintenance mode so that we can keep the battery relaxed.


The charging algorithm will make use of the above battery profile and control the charging parameters in different phase of charging.  So the primary requirement is to have a common charging framework which will listen to different charger or battery events and modify the charging parameters appropriately.

Along with controlling the charging parameters we are trying to implement the following requirements
	* Hybrid charge termination
		* Charger driver/charging framework will listen to the h/w charge termination notification. On receiving this notification, software logic will read the charge current and voltage to ensure that battery is actually full. 		If it's not full, a software charge termination logic is used to ensure a battery full. Software charge termination logic internally need to turn of the h/w charge termination logic
	* Controlling INLIMIT for charger
		* Chargers will have different capabilities. For example a USB SDP charger can support 900mA(USB3.0)/500mA/100mA. A CDP/DCP can support 1500mA. Charger chip supports an INLMT which controls the 			maximum current that can be drawn from a charger.  The INLMT is different from CC which just tells the battery charging current, but it doesn't put limitation on the current drawn from the charger to meet system 		requirements. Looking at the latest charger manager patch (interfacing with the extcon class), it seems like controlling the CC and not the INLMT (Correct me if I am wrong).
	* Control the charger power path
		* Disable Charging (Disable charging. Charger will continue to supply power to platform)
		* Enable charging ( Enable charging)
		* Disable charger (Disable charging and turn off power to platform)
		* Enable charger (Enable charger and turn on power to platform)
			* The last two power path controls are used to throttle the charger.

The challenge I see in implementing the above requirements in charger manager is, some of  the above requirements are not supported by the regulator framework (disable/enable charger, Controlling the INLMT, disable h/w charge termination etc). So it would be difficult to control  the charger completely using a regulator framework. Also I would like to make the charging algorithm more generic and less dependent on the platform layer code. This includes implementing  a battery identification framework which will give the battery profile in a generic manner. 

Considering all the requirements and challenges, I doubt supporting them in charger manager would be good or not. I am looking for your suggestions on this. 

Thanks in advance,
-jtc

> -----Original Message-----
> From: MyungJoo Ham [mailto:myungjoo.ham@samsung.com]
> Sent: Tuesday, June 26, 2012 6:27 AM
> To: Tc, Jenny
> Cc: linux-kernel@vger.kernel.org; Anton Vorontsov
> (cbouatmailru@gmail.com); Anton Vorontsov (anton.vorontsov@linaro.org);
> Pallala, Ramakrishna; ÃÖÂù¿ì; ¹Ú°æ¹Î
> Subject: Re: Charger Manager Proposal.
> 
> > MyungJoo,
> >
> > I would like to align with the charger-manager activities and would like to
> propose few changes for charger-manager. The changes I would like to have
> in the charger manager is
> >
> > 	* Manage charging based on a battery profile - Each battery  can have
> a different  profile and the charging should be done based on this profile. So
> there should be a mechanism inside the charger-manager to read the battery
> profile. To start with we can make it available as platform data for the
> charger-manager.
> 
> Yes, each instance of charger-manager devices represents a battery (or a set
> of batteries controlled as a single battery.) Thus, the profile can be described
> in struct charger_desc. What do you need additionally there?
> 
> > 	* The charge parameters (CC and CV) needs to be changed as per the
> batter profile. The battery profile will have a different CC and CV for different
> temperature zone. So charger-manager needs to listen  battery Temperature
> change events (using power_supply_changed events from FG?)  and modify
> the CC and CV.
> 
> Then, my suggestion is that
> Plan A.
>   1. Add a pair of CC and CV regulators at struct charger_desc, independently
> defined in struct charger_desc from charger_desc.charger_regulators as
> charger_regulators are to enable/disable chargers attached to the battery
> described by struct charger_desc.
>   2. Add an array of { temperature (min), CC-value, CV-value, hysterisis-temp
> } with temperature = - MAX for "default" value.
> Plan B.
>   1. Add an array of { temperature (min), callback, hysterisis-temp}
> 
> If CC/CV values are the only ones to be controlled by temperature, Plan A is
> fine. However, if we are going to need more, Plan B may be more
> appropriate.
> 
> > 	* It's good to have a hybrid (Software and Hardware mode) full
> detection logic. This give more flexibility to define the charge full detection
> thresholds. So charger-manager can listen to charge-full detection from
> charger-hardware and can start a thread to verify the thresholds from
> software.
> 
> You can do this with cm_notify_event() and fullbatt_vchk() though we may
> need more parameters to control the behavior of fullbatt_vchk().
> 
> > 	* Need to have a maintenance upper voltage threshold. The upper
> threshold needs to be less than the Battery FULL voltage threshold and this
> can part of battery profile. This approach helps to increase the battery life.
> 
> Could you please elaborate this one more? What do you do with "upper
> threshold"?
> 
> >
> > I would like to start implementing these features for charger manager. But I
> would like to align with your planned charger-manager activities so that we
> don't end up in duplicating the effort. Please let me know your suggestions
> on this.
> >
> > -jtc
> 
> Another update or modification on-going is:
> 	- Integrating with extcon subsystem
> 	- Add current-limit for each charger
> You can see the according patches at
> http://git.infradead.org/users/kmpark/linux-
> samsung/shortlog/refs/heads/charger-manager-for-next
> 
> 
> Thanks. And sorry for late reply; we had the office moved which cut the
> internetaccess for a while.
> 
> 
> Cheers!
> MyungJoo.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
