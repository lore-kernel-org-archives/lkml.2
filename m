Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab1ITIy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 04:54:56 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:47566 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab1ITIyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 04:54:53 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E7854D8.7000603@cam.ac.uk>
Date: Tue, 20 Sep 2011 09:54:48 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110901 Thunderbird/6.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Jean Delvare <khali@linux-fr.org>, Stephen Warren <swarren@nvidia.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Andrew Chew <achew@nvidia.com>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-i2c@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH V3 1/5] i2c: Add irq_gpio field to struct i2c_client,
 i2c_board_info.
References: <1314914676-28397-1-git-send-email-swarren@nvidia.com> <20110902085620.4ad918c4@endymion.delvare> <20110920041629.GC30517@ponder.secretlab.ca>
In-Reply-To: <20110920041629.GC30517@ponder.secretlab.ca>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/11 05:16, Grant Likely wrote:
> On Fri, Sep 02, 2011 at 08:56:20AM +0200, Jean Delvare wrote:
>> Stephen,
>>
>> Can you please fix your e-mail client / system / whatever so that your
>> patch series are no longer sent duplicated?
>>
>> On Thu,  1 Sep 2011 16:04:27 -0600, Stephen Warren wrote:
>>> Some devices use a single pin as both an IRQ and a GPIO. In that case,
>>> irq_gpio is the GPIO ID for that pin. Not all drivers use this feature.
>>> Where they do, and the use of this feature is optional, and the system
>>> wishes to disable this feature, this field must be explicitly set to a
>>> defined invalid GPIO ID, such as -1.
>>>
>>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>>> ---
>>> v3: Also add the field to i2c_board_info, and copy the field from
>>>     i2c_board_info to i2c_client upon instantiation
>>
>> I don't get the idea. The i2c core doesn't make any use of the field,
>> and that field will only be used by a few drivers amongst the 420+
>> i2c drivers in the tree. This looks like a waste of memory. What's wrong
>> with including the new field in the private platform or arch data
>> structure for drivers which need it?
> 
> I have to second the concern; but for a different reason.  This
> shouldn't even remotely be necessary.  If the pin is used as an
> interrupt, then interrupt controller driver (which I would assume is
> also the gpio controller driver) should be responsible for setting up
> the pin so that it can be used correctly as a irq line.  Why does the
> gpio number need to be explicitly passed?
The particular driver covered here is somewhat of a false positive.
It really ought to be rewritten to do everything 'properly' with
interrupts.  Right now no one with the inclination has the hardware
to fix it up.

The nasty case we are trying to cover is peripherals that use level
interrupts talking to gpio chips that only do edge triggered ones.
We use the pin as an irq but have to query it as a gpio to discover
if the sneaky chip raised it again without it actually going low.

There are sometimes work arounds involving polling registers on
the device to check if the interrupt is active, but give the bus is
slow, pinging the gpio to find out it's state is often much faster.

So it's a dirty hack for dirty hardware.  Having said that I agree
that it's a niche case and certainly shouldn't be part of any core
code, unless it is done right at the core in the generic interrupt
code and previous discussions suggest that is tricky to say the least!


