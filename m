Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab1DZQPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:15:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37680 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751993Ab1DZQPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:15:18 -0400
Date: Tue, 26 Apr 2011 17:15:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bill Gatliff <bgat@billgatliff.com>
Cc: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Expose regulator:set_consumer_device_supply()?
Message-ID: <20110426161516.GC11848@opensource.wolfsonmicro.com>
References: <BANLkTi=dCHXEtv+=+sRaDp_Pt3zQy5o7ug@mail.gmail.com>
 <20110426083350.GA20595@sirena.org.uk>
 <BANLkTimmpx5ZThXj705Yn_wRQ6bF7VzwPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimmpx5ZThXj705Yn_wRQ6bF7VzwPw@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 10:33:29AM -0500, Bill Gatliff wrote:
> On Tue, Apr 26, 2011 at 3:33 AM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:

> > You can specify the device by either dev_name() or a dev pointer.  You
> > can use dev_name() at any time without the device having been
> > instantiated, it would be unusal to use a struct device.

> When a consumer e.g. i2c chip driver is trying to get a handle for its
> own regulator, the only function I see is:
> 
> struct regulator* regulator_get(struct device *dev, const char *id)

There's also regulator_get_exclusive() but it's almost exactly the same
thing.

> In order for there to be a regulator with a matching device:id
> combination, someone must have previously provided a struct
> regulator_consumer_supply with the identical device pointer to
> regulator_register().  That means that I have to call
> regulator_register() AFTER I register the i2c chip driver, so that I
> have a struct device pointer to place in the regulator_consumer_supply
> list.  Right?

No.  As I said in the text you've quoted above you can also specify the
device mapping using the dev_name() of the device.  As you will have
seen when looking through the regulator_get() implementation the
matching is actually done on the dev_name(), if the mapping is set up
with a struct device we always do matches based on the dev_name()
string, not by comparing pointers.
  
> > This would facilitate abuse of the API, we already have enough problems
> > with people trying to pass regulators as platform data.

> But I think you'll agree that regulators are pretty important platform data, no?

No, the set of power supplies the device has is not platform data, it's
a physical property of the device.

> What specifically is the breakage that comes from allowing consumers
> to add themselves to regulator consumer lists at a time after
> regulator_register() is complete?  Why is passing a regulator pointer
> as platform data such a problem?

It means you get reams of code in drivers conditionally using the
regulator API, all of which adds needless complexity all over the tree
as people invariably make everything conditional on the regulator not
being there when they shouldn't.  This then means you also end up with
no meaningful error handling, all errors just get silently eaten.
