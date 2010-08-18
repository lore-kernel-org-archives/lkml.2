Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab0HRSNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 14:13:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45800 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab0HRSNj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 14:13:39 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "felipe.balbi@nokia.com" <felipe.balbi@nokia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "byron.bbradley@gmail.com" <byron.bbradley@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Wed, 18 Aug 2010 23:43:02 +0530
Subject: RE: [PATCH 1/3] RTC:s35390a: Add Alarm interrupt support
Thread-Topic: [PATCH 1/3] RTC:s35390a: Add Alarm interrupt support
Thread-Index: Acs97n9gMHpicL8vTiaaZki7f/V1twBEf1uQ
Message-ID: <19F8576C6E063C45BE387C64729E7394044F124C8F@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
 <1282034921-22167-2-git-send-email-hvaibhav@ti.com>
 <20100817092845.GE19211@nokia.com>
In-Reply-To: <20100817092845.GE19211@nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Felipe Balbi [mailto:felipe.balbi@nokia.com]
> Sent: Tuesday, August 17, 2010 2:59 PM
> To: Hiremath, Vaibhav
> Cc: linux-kernel@vger.kernel.org; akpm@linux-foundation.org;
> byron.bbradley@gmail.com; linux-omap@vger.kernel.org
> Subject: Re: [PATCH 1/3] RTC:s35390a: Add Alarm interrupt support
> 
> On Tue, Aug 17, 2010 at 10:48:39AM +0200, ext hvaibhav@ti.com wrote:
> >From: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> you need a description here.
> 
[Hiremath, Vaibhav] Frankly, I deliberately removed the description thinking its duplication of subject line and subject like should be enough to explain about the patch.

I will add description in the next version.

> >Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> [snip]
> 
> >+static void s35390a_work(struct work_struct *work)
> >+{
> >+	struct s35390a *s35390a;
> >+	struct i2c_client *client;
> >+	char buf[1];
> >+
> >+	s35390a = container_of(work, struct s35390a, work);
> >+	if (!s35390a)
> >+		return;
> 
> container_of() will never return NULL. You can remove this check. You
> won't need this, actually after converting to threaded_irq, see below.
> 
[Hiremath, Vaibhav] Ok, will remove in next version.

> >+static irqreturn_t s35390a_irq(int irq, void *client)
> >+{
> >+	struct s35390a *s35390a;
> 
> all the other drivers will do:
> 
> static irqreturn_t s35390a_irq(int irq, void *_s35390a)
> {
> 	struct s35390a	*s35390a = _s35390a
> 
> 	[...]
> 
> >+	if (!client)
> >+		return IRQ_HANDLED;
> 
> if client is NULL, you should let this oops.
> 
[Hiremath, Vaibhav] Ok, will remove in next version.

> >+	schedule_work(&s35390a->work);
> 
> please don't use workqueue. Use threaded IRQ.
> 
[Hiremath, Vaibhav] Ok, will migrate to threaded irq and submit it again.


Thanks,
Vaibhav

> >@@ -261,15 +447,30 @@ static int s35390a_probe(struct i2c_client *client,
> > 	if (s35390a_get_datetime(client, &tm) < 0)
> > 		dev_warn(&client->dev, "clock needs to be set\n");
> >
> >+	INIT_WORK(&s35390a->work, s35390a_work);
> >+
> >+	if (client->irq > 0) {
> 
> irq 0 is a valid number.
> 
> >+		err = request_irq(client->irq, s35390a_irq, IRQF_TRIGGER_LOW,
> >+				client->name, client);
> 
> instead of the i2c client, you can pass s35390. Also use
> request_threaded_irq();
> 
> --
> balbi
> 
> DefectiveByDesign.org
