Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab2BTMHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 07:07:35 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56732 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab2BTMHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 07:07:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 01/01] MFD: add ADC support to DA9052/53 MFD  core v2
Date: Mon, 20 Feb 2012 12:07:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Dajun <dajun.chen@diasemi.com>
References: <1326465051.3542.334.camel@dhruva> <20120220114420.GT5387@sortiz-mobl>
In-Reply-To: <20120220114420.GT5387@sortiz-mobl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202201207.27510.arnd@arndb.de>
X-Provags-ID: V02:K0:hofvaAH2jvkgpiiuEF7rBqtC/YYTZ1A5RR6iIN9Yv8l
 pvCFbWEfGYnF2nNX7REzTmqgwVnHq0M6Z1x/cbGIqyqMrN7EdE
 T7S88EqjwoTGj7XtTp0QJ2llEYhO5FVF+99uTiitLi+NILV8ya
 52U4wLYNUy5bwEDrvRCmiOEHYoj8fumLkvuFTVNjhbCel66i2I
 8tvkfLrq6Kpjqxe55vnPBsPansN2twP2I1YAKI890KEZh1hR4M
 labKveb6MYQnHiGv4oVPhUkCgGZDybrZFgTcv8UHMMQRFfDgLz
 3FE4fFom6aGakzviX4v5QxARlcmq+izjz9JyhwX62XJ8QSyJyg
 Of0u6bRUG63mc7MHAF7o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 February 2012, Samuel Ortiz wrote:
> On Fri, Jan 13, 2012 at 08:00:51PM +0530, Ashish Jangam wrote:
> > +struct completion done;
> This shouldn't be a global variable, but a struct da9052 one instead.

Right. Since this thread has showed up in my inbox again, I've
also taken a look at the patch now and noticed another thing:

>> +       ret = request_threaded_irq(da9052->irq_base + DA9052_IRQ_ADC_EOM,
>> +                                  NULL, da9052_auxadc_irq,
>> +                                  IRQF_TRIGGER_LOW | IRQF_ONESHOT,
>> +                                  "adc irq", NULL);

First of all, to clarify: The last argument to this function needs to be
the pointer to da9052 so that it is available in the irq handler function.

Also, I would recommend using request_irq instead of request_threaded_irq
here because the function only has a single "complete()" call in it,
just like a threaded IRQ handler has. There is no point going through
another thread just to wake up the one that is blocked.

	Arnd
