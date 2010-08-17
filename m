Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab0HQJ2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 05:28:41 -0400
Received: from smtp.nokia.com ([192.100.105.134]:42742 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757059Ab0HQJ2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 05:28:40 -0400
Date: Tue, 17 Aug 2010 12:28:45 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: "ext hvaibhav@ti.com" <hvaibhav@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "byron.bbradley@gmail.com" <byron.bbradley@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/3] RTC:s35390a: Add Alarm interrupt support
Message-ID: <20100817092845.GE19211@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <hvaibhav@ti.com>
 <1282034921-22167-2-git-send-email-hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1282034921-22167-2-git-send-email-hvaibhav@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 17 Aug 2010 09:27:26.0677 (UTC) FILETIME=[6803A050:01CB3DEE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 10:48:39AM +0200, ext hvaibhav@ti.com wrote:
>From: Vaibhav Hiremath <hvaibhav@ti.com>

you need a description here.

>Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>

[snip]

>+static void s35390a_work(struct work_struct *work)
>+{
>+	struct s35390a *s35390a;
>+	struct i2c_client *client;
>+	char buf[1];
>+
>+	s35390a = container_of(work, struct s35390a, work);
>+	if (!s35390a)
>+		return;

container_of() will never return NULL. You can remove this check. You 
won't need this, actually after converting to threaded_irq, see below.

>+static irqreturn_t s35390a_irq(int irq, void *client)
>+{
>+	struct s35390a *s35390a;

all the other drivers will do:

static irqreturn_t s35390a_irq(int irq, void *_s35390a)
{
	struct s35390a	*s35390a = _s35390a

	[...]

>+	if (!client)
>+		return IRQ_HANDLED;

if client is NULL, you should let this oops.

>+	schedule_work(&s35390a->work);

please don't use workqueue. Use threaded IRQ.

>@@ -261,15 +447,30 @@ static int s35390a_probe(struct i2c_client *client,
> 	if (s35390a_get_datetime(client, &tm) < 0)
> 		dev_warn(&client->dev, "clock needs to be set\n");
>
>+	INIT_WORK(&s35390a->work, s35390a_work);
>+
>+	if (client->irq > 0) {

irq 0 is a valid number.

>+		err = request_irq(client->irq, s35390a_irq, IRQF_TRIGGER_LOW,
>+				client->name, client);

instead of the i2c client, you can pass s35390. Also use 
request_threaded_irq();

-- 
balbi

DefectiveByDesign.org
