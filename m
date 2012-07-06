Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030272Ab2GFLUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:20:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:25609 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933532Ab2GFLU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:20:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="174115877"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "Anton Vorontsov (cbouatmailru@gmail.com)" <cbouatmailru@gmail.com>,
        "Anton Vorontsov (anton.vorontsov@linaro.org)" 
	<anton.vorontsov@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>,
        ??? <cw00.choi@samsung.com>, ??? <kyungmin.park@samsung.com>
Subject: RE: RE: Charger Manager Proposal.
Thread-Topic: RE: Charger Manager Proposal.
Thread-Index: AQHNWOMfoGqutTxan0+ljIbDUkO2I5cbspOg
Date: Fri, 6 Jul 2012 11:20:22 +0000
Message-ID: <20ADAB092842284E95860F279283C5642A1F26@BGSMSX101.gar.corp.intel.com>
References: <14051592.104301341296077424.JavaMail.weblogic@epml05>
In-Reply-To: <14051592.104301341296077424.JavaMail.weblogic@epml05>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q66BKjfj002707

Hi,

Since modifying the charger manager for the below requirements would be more complex and would not fit inside the charger manager we are thinking of implementing new framework under power_supply subsystem with following features.

* Battery identification framework which will provide interfaces to 
	* Register a battery profile (From a MIBI BIF protocol driver/ BSI sensing driver/ Digital battery identification driver/from the platform layer)
	* Read battery profile (From FG driver/charger driver or from the new charger framework)
* Provide flexibility to plug in a charging algorithm (PSE compliant/pulse charging/burp charging/ custom charging algorithm etc)
* Provide the following interfaces to the algorithm so that it can control and monitor charging.
	* Get Battery Temperature/Current/Voltage (If power_supply device of type BATTERY is available read from that else from external sources)
	* Modify CC/CV/INLMT/Termination current (Power supply set_property interface)
	* Get charger thermal throttling state from platform thermal management framework.
* Charger Throttling
	* Register with thermal subsystem as a cooling device and make the current throttling state available to charging algorithm.
* Provide options for maintenance charging and  Hybrid Full detection logic.

The outcome of all the above changes would be that, a set of charging algorithms would be available in the mainline and chargers can make use of the algorithms without making much modifications to the charger driver code. Also this would give a standard framework for monitoring and controlling battery charging.

Anton,
	Could you please review the above proposal?

Myungjoo,
	Thank you very much for your timely response. Please let me know your suggestions on this proposal.  Please find my reply inline.


-jtc



> >
> > Charge Termination current
> > 	* Should be programmed to charger or used by charger driver to stop
> > charging along with the voltage level for charger full. The charge
> > full voltage level will change based on temperature zone or
> > maintenance charging
> 
> Each charger should be responsible for this. Personally, I've been
> implementing this feature as a current-limit regulator (topoff) at a charger or
> a PMIC regulator drivers. If we add this at charger-manager, we will be
> adding a variable that is not used or only used by ABI-read only. I'm not
> aware of charger-manager related code that need to access this information
> other than chargers themselves, yet.

Based on your comment I think this requirement doesn't fit with charger manager. The requirement is to configure charger(s) based on  battery profile. So there needs to be an interface which can provide battery specific information to each charger. I think using a regulator framework we cannot achieve this.
> 
> 
> > Maximum voltage
> > 	* Maximum voltage battery can support in any temperature zone
> 
> Is this "CV"?
> Or the V-Batt value that is supposed to be "full"? (included as "fullbatt_uV")
> 

It's not CV. This is the maximum battery voltage  at any temperature level. Battery will have different set of CC and CV pair for each temperature zone. Since the regulator framework provides only 2 interfaces to change the voltage and current I think regulator framework doesn't suite for our requirement. We have to modify INLMT, CC ,CV and Termination current based on the battery profile.

> > Battery type
> > 	* Type of battery (Li-ION)
> 
> I'm not sure what would it mean in charger-manager. Who's going to use this
> value?

This value can be used by charger to decide the charging algorithm. The same way it can be used by Fuel Gauge to report battery type property

> 
> However, if we are going to provide arbitraty power-supply-class properties
> via charger-manager, we may need to add something to charger_desc. For
> example, char *psy_abi_provider may be added in charger_desc to provide
> get_property() for additional enum power_supply_property that is not
> supported in default charger-manager including "Type of battery" you
> mentioned. I don't think we need to support such values natively in charger-
> manager as it is not shared between entities connected via charger-manager.
> 

We would like to make it more generic  and should be able to plug a new charger easily without platform data change. Basically this can be achieved by modifying the power_supply subsystem to connect different chargers through notification mechansims and using get/set property calls.  This way chargers can be supported in a plug and play manner without any platform layer code change. Modifying the changer manager to achieve the same will be too complex since the charger manager is designed around the platform data (charger_desc). This is the main reason for thinking in a different direction. 

> > Lower temperature limit
> > 	* Lowest temperature zone at which charging is allowed.
> > Number of temperature monitoring Ranges
> > 	* As per PSE standard it's 6
> >
> > Each zone as the following attributes
> > Upper temperature Limit
> > 	* Upper temperature zone for this range Full charge voltage
> > 	* CV for this range
> > Full charge current
> > 	* CC for this range
> > Maintenance restart voltage
> > 	* In maintenance mode, charging will be resumed on this voltage
> level.
> > Maintenance charging stop voltage
> > 	* This voltage is used as CV in maintenance voltage. Used with charge
> termination current to stop charging in maintenance charging mode.
> > Maintenance charge current
> > 	* CC for maintenance charging mode. This gives a flexibility to use a
> lower CC in maintenance mode so that we can keep the battery relaxed.
> 
> All these can be handled if we add "generalized temperature event handling"
> feature in charger-manager.

Since the regulator framework doesnâ€™t expose a mechanism to modify CC/CV, it is not possible to modify CC/CV without tweaking the regulator framework.

> 
> Then, we will need to
> 1. Remove "temperature_out_of_range" callback, add "get_temperature"
> callback or integrate with IIO subsystem for temperature sensors.
> 2. Add a data structure supporting
> 2.1. Range of temperatures with hysterisis support 2.2. (force) Disable
> chargers 2.3. CV and CC values (we will need to add CC and CV regulators)
> 2.4. Behaviors in maintenance mode? (still don't get it what's maintenance
> mode) 3. Use the above data structure at sampling/polling mechanism (along
> with get_temperature or integrated IIO)
> 

It make sense to get  the battery temperature from BATTERY driver (FG).  Also since the power_supply subsystem can give notifications to other power_supply class drivers, the framework need not to poll for temperature. So I think we don't need a callback functions for getting the temperature.
When the battery is full,  charging gets into maintenance charging mode. When the battery voltage falls below a certain voltage (similar to fullbatt_vchkdrop_uV) charging will be restarted with a low CC and CV (Defined in battery profile). This is to keep the battery in relaxed state  even though we are trying to keep it fully charged. Keeping a low CV in maintenance mode  will ensure that battery is not completely FULL for a long time. This is to increase the battery life span.

> >
> > The charging algorithm will make use of the above battery profile and
> control the charging parameters in different phase of charging.  So the
> primary requirement is to have a common charging framework which will
> listen to different charger or battery events and modify the charging
> parameters appropriately.
> 
> Except for the temperature events generated by charger manager and
> timed-events related with voltage drop after full event, every event is
> generated externally via cm_notify_event().
> 
> Please note that having notifier chains for such seems unnecessary; charger
> manager is the only listener here.
> 

If we are going to use the power_supply  supplied_to (need to make it dynamic) parameter, we donâ€™t need any other notifier mechanism.

> 
> >
> > Along with controlling the charging parameters we are trying to implement
> the following requirements
> > 	* Hybrid charge termination
> > 		* Charger driver/charging framework will listen to the h/w
> charge termination notification. On receiving this notification, software logic
> will read the charge current and voltage to ensure that battery is actually full.
> 		If it's not full, a software charge termination logic is used to
> ensure a battery full. Software charge termination logic internally need to
> turn of the h/w charge termination logic
> 
> This can be implemented inside fullbatt_handler() and fullbat_vchk(). The
> current charger manager also verifies whether the battery is really full with
> software logic after hardware tells that the battery is full via
> cm_notify_event().
> 
> > 	* Controlling INLIMIT for charger
> > 		* Chargers will have different capabilities. For example a USB
> SDP charger can support 900mA(USB3.0)/500mA/100mA. A CDP/DCP can
> support 1500mA. Charger chip supports an INLMT which controls the
> 		maximum current that can be drawn from a charger.  The
> INLMT is different from CC which just tells the battery charging current, but it
> doesn't put limitation on the current drawn from the charger to meet system
> 		requirements. Looking at the latest charger manager patch
> (interfacing with the extcon class), it seems like controlling the CC and not
> the INLMT (Correct me if I am wrong).
> > 	* Control the charger power path
> > 		* Disable Charging (Disable charging. Charger will continue to
> supply power to platform)
> > 		* Enable charging ( Enable charging)
> > 		* Disable charger (Disable charging and turn off power to
> platform)
> > 		* Enable charger (Enable charger and turn on power to
> platform)
> > 			* The last two power path controls are used to
> throttle the charger.
> 
> The patch you've seen (Chanwoo's) does this if you define
> charger_cable.charger == charger regulator. We don't have CC controlling
> mechanisms; CC is determined by (at least in software logic) the sum of
> active charger regulators' current limit. For example, if USB cable and TA
> cable may be attached seperatedly (no mutual exclusiveness) making them
> seperated chargers connected to the same battery and each has 500mA and
> 1500mA as its current limit, then, if both cables are attached, USB's current
> limit will be 500mA, TA's current limit will be 1500mA, and (effective) CC will
> be 2000mA.
> 

Since we are using the set_current interface for modifying the INLMT we cannot modify the CC using regulator framework. Since the charging algorithm needs to modify CC and CV along with INLMT, regulator framework doesnâ€™t seems to be fit for the requirements we discussed.

> >
> > The challenge I see in implementing the above requirements in charger
> manager is, some of  the above requirements are not supported by the
> regulator framework (disable/enable charger, Controlling the INLMT, disable
> h/w charge termination etc). So it would be difficult to control  the charger
> completely using a regulator framework. Also I would like to make the
> charging algorithm more generic and less dependent on the platform layer
> code. This includes implementing  a battery identification framework which
> will give the battery profile in a generic manner.
> 
> You can implement a charger as a regulator (or a pair of regulators).
> The one registered in charger_desc->charger_regulator->consumer enabled
> and disable The one registered in charger_desc->charger_regulator-
> >consumer controls current limit (along with extcon), INMNT
> 
> If you need to control CV (not supported, yet), another regulator, probably
> defined as charger_desc->battery_CV, maybe added.
> As "CV" value is defined per battery (charger_desc), not per charger
> (charger_desc.charger_regulators), we need to have one per battery.
> Maybe "CC" value may be added per battery (charger_desc) as well if it can
> be controlled independently, however, currently, it is a mere sum of INMNT
> values.
> 
> 
> >
> > Considering all the requirements and challenges, I doubt supporting them
> in charger manager would be good or not. I am looking for your suggestions
> on this.
> >
> > Thanks in advance,
> > -jtc
> 
> I think the features mentioned above are good to be included in charger
> manager as they look quite compatible with current structure with some
> modifications.
> 
> 
> 
> Thank you.
> 
> 
> Cheers!
> MyungJoo
> 
> >
> > > -----Original Message-----
> > > From: MyungJoo Ham [mailto:myungjoo.ham@samsung.com]
> > > Sent: Tuesday, June 26, 2012 6:27 AM
> > > To: Tc, Jenny
> > > Cc: linux-kernel@vger.kernel.org; Anton Vorontsov
> > > (cbouatmailru@gmail.com); Anton Vorontsov
> > > (anton.vorontsov@linaro.org); Pallala, Ramakrishna; ìµœì°¬ìš°; ë°•ê²½ë¯¼
> > > Subject: Re: Charger Manager Proposal.
> > >
> > > > MyungJoo,
> > > >
> > > > I would like to align with the charger-manager activities and
> > > > would like to
> > > propose few changes for charger-manager. The changes I would like to
> > > have in the charger manager is
> > > >
> > > > 	* Manage charging based on a battery profile - Each battery  can
> > > > have
> > > a different  profile and the charging should be done based on this
> > > profile. So there should be a mechanism inside the charger-manager
> > > to read the battery profile. To start with we can make it available
> > > as platform data for the charger-manager.
> > >
> > > Yes, each instance of charger-manager devices represents a battery
> > > (or a set of batteries controlled as a single battery.) Thus, the
> > > profile can be described in struct charger_desc. What do you need
> additionally there?
> > >
> > > > 	* The charge parameters (CC and CV) needs to be changed as per
> > > > the
> > > batter profile. The battery profile will have a different CC and CV
> > > for different temperature zone. So charger-manager needs to listen
> > > battery Temperature change events (using power_supply_changed
> events
> > > from FG?)  and modify the CC and CV.
> > >
> > > Then, my suggestion is that
> > > Plan A.
> > >   1. Add a pair of CC and CV regulators at struct charger_desc,
> > > independently defined in struct charger_desc from
> > > charger_desc.charger_regulators as charger_regulators are to
> > > enable/disable chargers attached to the battery described by struct
> charger_desc.
> > >   2. Add an array of { temperature (min), CC-value, CV-value,
> > > hysterisis-temp } with temperature = - MAX for "default" value.
> > > Plan B.
> > >   1. Add an array of { temperature (min), callback, hysterisis-temp}
> > >
> > > If CC/CV values are the only ones to be controlled by temperature,
> > > Plan A is fine. However, if we are going to need more, Plan B may be
> > > more appropriate.
> > >
> > > > 	* It's good to have a hybrid (Software and Hardware mode) full
> > > detection logic. This give more flexibility to define the charge
> > > full detection thresholds. So charger-manager can listen to
> > > charge-full detection from charger-hardware and can start a thread
> > > to verify the thresholds from software.
> > >
> > > You can do this with cm_notify_event() and fullbatt_vchk() though we
> > > may need more parameters to control the behavior of fullbatt_vchk().
> > >
> > > > 	* Need to have a maintenance upper voltage threshold. The upper
> > > threshold needs to be less than the Battery FULL voltage threshold
> > > and this can part of battery profile. This approach helps to increase the
> battery life.
> > >
> > > Could you please elaborate this one more? What do you do with "upper
> > > threshold"?
> > >
> > > >
> > > > I would like to start implementing these features for charger
> > > > manager. But I
> > > would like to align with your planned charger-manager activities so
> > > that we don't end up in duplicating the effort. Please let me know
> > > your suggestions on this.
> > > >
> > > > -jtc
> > >
> > > Another update or modification on-going is:
> > > 	- Integrating with extcon subsystem
> > > 	- Add current-limit for each charger You can see the according
> > > patches at
> > > http://git.infradead.org/users/kmpark/linux-
> > > samsung/shortlog/refs/heads/charger-manager-for-next
> > >
> > >
> > > Thanks. And sorry for late reply; we had the office moved which cut
> > > the internetaccess for a while.
> > >
> > >
> > > Cheers!
> > > MyungJoo.
> >
> >
> >
> >
> >
> >
> >
> >
> ç¿{.n?Â‰?ï£¨Â‰ï£§Â†+%ÂŠ?zwmÂ…?Âï§ê¿©??zXã‰ï£¨w?{ay????j ï£§?ï¼‚
> ?ÂšÂ‹??ï£¨wâ…±?â—?:+vÂ‰?w???ï£«??å–©zZ+Âƒ?ÂÂŠå­µj"Â??OÂ•è½z?v??m?æ“
> n?ç­¬Y&Â—
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
