Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab0HWE7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 00:59:30 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33413 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682Ab0HWE73 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 00:59:29 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "felipe.balbi@nokia.com" <felipe.balbi@nokia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "byron.bbradley@gmail.com" <byron.bbradley@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Mon, 23 Aug 2010 10:28:42 +0530
Subject: RE: [PATCH-V2 1/3] RTC:s35390a: Add Alarm interrupt support
Thread-Topic: [PATCH-V2 1/3] RTC:s35390a: Add Alarm interrupt support
Thread-Index: ActBOgPpuEku45dESo6B8nCMpj/mvABRDLeQ
Message-ID: <19F8576C6E063C45BE387C64729E7394044F1252C6@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
 <1282393829-7326-2-git-send-email-hvaibhav@ti.com>
 <20100821140541.GA31697@nokia.com>
In-Reply-To: <20100821140541.GA31697@nokia.com>
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
> Sent: Saturday, August 21, 2010 7:36 PM
> To: Hiremath, Vaibhav
> Cc: linux-kernel@vger.kernel.org; akpm@linux-foundation.org;
> byron.bbradley@gmail.com; linux-omap@vger.kernel.org; Balbi Felipe (Nokia-
> MS/Helsinki)
> Subject: Re: [PATCH-V2 1/3] RTC:s35390a: Add Alarm interrupt support
> 
> Hi,
> 
> On Sat, Aug 21, 2010 at 02:30:27PM +0200, ext hvaibhav@ti.com wrote:
> >+static irqreturn_t s35390a_irq_thread(int irq, void *handle)
> >+{
> >+	char buf[1];
> >+	struct s35390a *s35390a = handle;
> >+	struct i2c_client *client = s35390a->client[0];
> 
> don't you need some locking on the irq handler ? a mutex maybe ? Just
> wondering...
> 
[Hiremath, Vaibhav] Yes definitely we do need locking here, I thought of adding locking mechanism in subsequent patch, does it makes sense?


> >@@ -261,15 +424,30 @@ static int s35390a_probe(struct i2c_client *client,
> > 	if (s35390a_get_datetime(client, &tm) < 0)
> > 		dev_warn(&client->dev, "clock needs to be set\n");
> >
> >+	if (client->irq >= 0) {
> >+		err = request_threaded_irq(client->irq, NULL,
> >+				s35390a_irq_thread,
> >+				IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> >+				client->name, s35390a);
> >+		if (err) {
> >+			dev_err(&client->dev, "unable to request IRQ\n");
> >+			goto exit_dummy;
> >+		}
> >+	}
> >+
> > 	s35390a->rtc = rtc_device_register(s35390a_driver.driver.name,
> > 				&client->dev, &s35390a_rtc_ops, THIS_MODULE);
> >
> > 	if (IS_ERR(s35390a->rtc)) {
> > 		err = PTR_ERR(s35390a->rtc);
> >-		goto exit_dummy;
> >+		goto exit_intr;
> > 	}
> >+
> > 	return 0;
> >
> >+exit_intr:
> >+	free_irq(client->irq, client);
> 
> free_irq() won't behave correctly, I believe since you're passing
> different dev_id parameters. If you look at the implementation of
> free_irq() you'll see it uses dev_id to find the correct struct
> irqaction pointer.
> 
[Hiremath, Vaibhav] Overlooked, my bad. Thanks for pointing this to me ,will fix.


Thanks,
Vaibhav
> --
> balbi
> 
> DefectiveByDesign.org
