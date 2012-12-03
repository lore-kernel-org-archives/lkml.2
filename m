Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab2LCF3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 00:29:32 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43112 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab2LCF3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 00:29:31 -0500
Subject: RE: [PATCH] EXTCON: Get and set cable properties
From: anish kumar <anish198519851985@gmail.com>
To: "Tc, Jenny" <jenny.tc@intel.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
In-Reply-To: <20ADAB092842284E95860F279283C564E29388@BGSMSX101.gar.corp.intel.com>
References: <1354052956-3394-1-git-send-email-jenny.tc@intel.com>
	 <50BBFCB8.4080903@samsung.com>
	 <20ADAB092842284E95860F279283C564E29388@BGSMSX101.gar.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 Dec 2012 21:29:24 -0800
Message-ID: <1354512564.1600.117.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-03 at 01:53 +0000, Tc, Jenny wrote:
> > We discussed about this patch and then suggest some method to resolve this
> > issue by Myungjoo Ham. Why don't you write additional feature or your
> > opinion based on following patch by Myungjoo Ham?
> > -
> > http://git.kernel.org/?p=linux/kernel/git/mzx/extcon.git;a=commitdiff;h=73
> > 12b79d69a2b9f06af4f1254bc4644751e3e3ea
> > 
> 
> I replied on the thread and pointed out issues that I see with this solution. IMHO
> It's not fair to register a cable with power_supply/regulator/charger manager just to
> expose the cable properties. 
Don't we do that with already in allmost all drivers?Like if I have a
keyboard driver and then I register with input framework and if the
keyboard driver needs clk services then I register with clk framework as
well and same with other services needed by keyboard driver.I think it
makes sense for a cable to register with different framework if it
supports that functionality as those services also would know that we
have a cable with so and so property.
> 
> > 
> > On 11/28/2012 06:49 AM, Jenny TC wrote:
> > > Existing EXTCON implementation doesn't give a mechanim to read the
> > > cable properties and extra states a cable needs to support. There are
> > > scenarios where a cable can have more than two
> > > states(CONNECT/DISCONNECT/SUSPEND/RESUME etc) and can have some
> > > properties associated with cables(mA)
> > >
> > > This patch introduces interface to get and set cable properties from
> > > EXTCON framework. The cable property can be set either by the extcon
> > > cable provider or by other subsystems who know the cable properties
> > > using eth API extcon_cable_set_data()
> > >
> > > When the consumer gets a notification from the extcon, it can use the
> > > extcon_cable_get_data() to get the cable properties irrespective of
> > > who provides the cable data.
> > >
> > > This gives a single interface for setting and getting the cable properties.
> > >
> > > Signed-off-by: Jenny TC <jenny.tc@intel.com>
> > > ---
> > >  drivers/extcon/extcon-class.c |   30
> > ++++++++++++++++++++++++++++++
> > >  include/linux/extcon.h        |   39
> > +++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 69 insertions(+)
> > >
> > > diff --git a/drivers/extcon/extcon-class.c
> > > b/drivers/extcon/extcon-class.c index d398821..304f343 100644
> > > --- a/drivers/extcon/extcon-class.c
> > > +++ b/drivers/extcon/extcon-class.c
> > > @@ -545,6 +545,36 @@ int extcon_unregister_notifier(struct extcon_dev
> > > *edev,  }  EXPORT_SYMBOL_GPL(extcon_unregister_notifier);
> > >
> > > +/**
> > > + * extcon_cable_set_data() - Set the data structure for a cable
> > > + * @edev:	the extcon device
> > > + * @cable_index:	the cable index of the correspondant
> > > + * @type:	type of the data structure
> > > + * @data:
> > > + */
> > > +void extcon_cable_set_data(struct extcon_dev *edev, int cable_index,
> > > +			   enum extcon_cable_name type,
> > > +			   union extcon_cable_data data)
> > > +{
> > > +	edev->cables[cable_index].type = type;
> > > +	edev->cables[cable_index].data = data; }
> > > +
> > > +/**
> > > + * extcon_cable_get_data() - Get the data structure for a cable
> > > + * @edev:	the extcon device
> > > + * @cable_index:	the cable index of the correspondant
> > > + * @type:	type of the data structure
> > > + * @data:	the corresponding data structure (e.g., regulator)
> > > + */
> > > +void extcon_cable_get_data(struct extcon_dev *edev, int cable_index,
> > > +			   enum extcon_cable_name *type,
> > > +			   union extcon_cable_data *data)
> > > +{
> > > +	*type = edev->cables[cable_index].type;
> > > +	*data = edev->cables[cable_index].data; }
> > > +
> > >  static struct device_attribute extcon_attrs[] = {
> > >  	__ATTR(state, S_IRUGO | S_IWUSR, state_show, state_store),
> > >  	__ATTR_RO(name),
> > > diff --git a/include/linux/extcon.h b/include/linux/extcon.h index
> > > 2c26c14..4556cc5 100644
> > > --- a/include/linux/extcon.h
> > > +++ b/include/linux/extcon.h
> > > @@ -135,6 +135,19 @@ struct extcon_dev {
> > >  	struct device_attribute *d_attrs_muex;  };
> > >
> > > +/* FIXME: Is this the right place for this structure definition?
> > > + * Do we need to move it to power_supply.h?
> > > + */
> > > +struct extcon_chrgr_cable_props {
> > > +	unsigned long state;
> > > +	int mA;
> > > +};
> > 
> > As I said, extcon provider driver didn't provide directly charging current(int
> > mA) and some state(unsigned long state) because the extcon provider
> > driver(Micro USB interface controller device or other device related to
> > external connector) haven't mechanism which detect dynamically charging
> > current immediately. If you wish to provide charging current data to extcon
> > consumer driver or framework, you should use regulator/power_supply
> > framework or other method in extcon provider driver.
> > 
> > The patch suggested by Myungjoo Ham define following struct:
> > 	union extcon_cable_data {
> > 		struct regualtor *reg;  /* EXTCON_CT_REGULATOR */
> > 		struct power_supply *psy; /* EXTCON_CT_PSY */
> > 		struct charger_cable *charger; /*
> > EXTCON_CT_CHARGER_MANAGER */
> > 		/* Please add accordingly with enum extcon_cable_type */
> > 	};
> > 
> > Also if you want to define 'struct extcon_chrgr_cable_props', you should
> > certainly show how detect dynamically charging current or state.
> > 
> > > +
> > > +union extcon_cable_data {
> > > +	struct extcon_chrgr_cable_props chrgr_cbl_props;
> > > +	/* Please add accordingly*/
> > > +};
> > > +
> > >  /**
> > >   * struct extcon_cable	- An internal data for each cable of extcon
> > device.
> > >   * @edev	The extcon device
> > > @@ -143,6 +156,8 @@ struct extcon_dev {
> > >   * @attr_name	"name" sysfs entry
> > >   * @attr_state	"state" sysfs entry
> > >   * @attrs	Array pointing to attr_name and attr_state for attr_g
> > > + * @type:	The type of @data.
> > > + * @data:	The data structure representing the status and states of this
> > cable.
> > >   */
> > >  struct extcon_cable {
> > >  	struct extcon_dev *edev;
> > > @@ -153,6 +168,11 @@ struct extcon_cable {
> > >  	struct device_attribute attr_state;
> > >
> > >  	struct attribute *attrs[3]; /* to be fed to attr_g.attrs */
> > > +
> > > +	union extcon_cable_data data;
> > > +
> > > +	/* extcon cable type */
> > > +	enum extcon_cable_name type;
> > It isn't correct. The 'enum extocn_cable_name' isn't type. For example, the
> > list of charger cable are TA/USB/Fast Charger/Slow Charger and so on.
> > The charger cables are charger type so, they has
> > EXTCON_CT_CHARGER_MANAGER as cable type.
> > 
> > The patch suggested by Myungjoo Ham define following struct:
> > 	enum extcon_cable_type {
> > 	       EXTCON_CT_NONE = 0,
> > 	       EXTCON_CT_REGULATOR,
> > 	       EXTCON_CT_PSY,
> > 	       EXTCON_CT_CHARGER_MANAGER,
> > 	       /* Please add other related standards when needed */
> > 	};
> > 


