Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab1DAR5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 13:57:03 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38215 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab1DAR44 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 13:56:56 -0400
MIME-Version: 1.0
In-Reply-To: <20110401104756.2f5c6f7a@debxo>
References: <20110202195417.228e2656@queued.net> <20110202200812.3d8d6cba@queued.net>
 <20110331230522.GI437@ponder.secretlab.ca> <20110401112030.GA3447@sortiz-mobl>
 <20110401104756.2f5c6f7a@debxo>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 1 Apr 2011 11:56:35 -0600
X-Google-Sender-Auth: iGeDPEXlJcvbxCXkNllVsmTUzTs
Message-ID: <BANLkTi=bCd_+f=EG-O=U5VH_ZNjFhxkziQ@mail.gmail.com>
Subject: Re: [PATCH 07/19] timberdale: mfd_cell is now implicitly available to drivers
To: Andres Salomon <dilinger@queued.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, khali@linux-fr.org,
        ben-linux@fluff.org, Peter Korsgaard <jacmet@sunsite.dk>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-i2c@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Mocean Laboratories <info@mocean-labs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 1, 2011 at 11:47 AM, Andres Salomon <dilinger@queued.net> wrote:
> On Fri, 1 Apr 2011 13:20:31 +0200
> Samuel Ortiz <sameo@linux.intel.com> wrote:
>
>> Hi Grant,
>>
>> On Thu, Mar 31, 2011 at 05:05:22PM -0600, Grant Likely wrote:
> [...]
>> > Gah.  Not all devices instantiated via mfd will be an mfd device,
>> > which means that the driver may very well expect an *entirely
>> > different* platform_device pointer; which further means a very high
>> > potential of incorrectly dereferenced structures (as evidenced by a
>> > patch series that is not bisectable).  For instance, the xilinx ip
>> > cores are used by more than just mfd.
>> I agree. Since the vast majority of the MFD subdevices are MFD
>> specific IPs, I overlooked that part. The impacted drivers are the
>> timberdale and the DaVinci voice codec ones.

Another option is you could do this for MFD devices:

struct mfd_device {
        struct platform_devce pdev;
        struct mfd_cell *cell;
};

However, that requires that drivers using the mfd_cell will *never*
get instantiated outside of the mfd infrastructure, and there is no
way to protect against this so it is probably a bad idea.

Or, mfd_cell could be added to platform_device directly which would
*by far* be the safest option at the cost of every platform_device
having a mostly unused mfd_cell pointer.  Not a significant cost in my
opinion.

One last option is I'm prototyping a way to add type-safe structure
pointers to a device, but that requires nasty CPP tricks and it's not
complete yet.  The cure might be worse than the disease here.

g.

>
> Can you please provide pointers to what you're referring to?  The only
> code that I could find that created platform devices prefixed with
> 'timb-' or named 'xilinx_spi' was drivers/mfd/timberdale.c.
>
>
>
>> To fix that problem I propose 2 alternatives:
>>
>> 1) When declaring the sub devices cells, the MFD driver should
>> specify an mfd_data_size value for sub devices that are not MFD
>> specific. It's the MFD driver responsibility to set the cell
>> properly, and the non MFD specific drivers are kept MFD agnostic.
>> See my patch below for the timberdale case.

This approach worries me because it changes the behaviour on a
per-device basis.  That could be difficult to maintain a mental model
for.  I'd rather see consistent behaviour.

>>
>> 2) Revert the mfd_get_data() call for getting sub devices platform
>> data pointers. That was introduced to ease the MFD cell sharing work,
>> so if we take this route we'll need the cs5535 MFD driver to pass its
>> cells as platform_data pointer. Andres, can you confirm that this
>> would be fine for the mfd_clone_cell() routine to keep working ?
>
> It would break mfd_clone_cell, as it uses mfd_get_cell to grab the one
> to clone.  We could change it to accept the cell as an argument.  It
> would also break mfd_cell_enable/disable, of course.
>
>
>
>>
>> Patch for solution 1:
>>
>>
>>  drivers/mfd/mfd-core.c          |   13 ++++++++++---
>>  drivers/mfd/timberdale.c        |   11 +++++++++++
>>  include/linux/mfd/core.h        |    1 +
>>  drivers/i2c/busses/i2c-ocores.c |    3 +--
>>  drivers/i2c/busses/i2c-xiic.c   |    3 +--
>>  drivers/net/ks8842.c            |    3 +--
>>  drivers/spi/xilinx_spi.c        |    3 +--
>>  7 files changed, 26 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
>> index d01574d..8abe510 100644
>> --- a/drivers/mfd/mfd-core.c
>> +++ b/drivers/mfd/mfd-core.c
>> @@ -75,9 +75,16 @@ static int mfd_add_device(struct device *parent,
>> int id,
>>       pdev->dev.parent = parent;
>>
>> -     ret = platform_device_add_data(pdev, cell, sizeof(*cell));
>> -     if (ret)
>> -             goto fail_res;
>> +     if (cell->mfd_data_size > 0) {
>> +             ret = platform_device_add_data(pdev,
>> +                                     cell->mfd_data,
>> cell->mfd_data_size);
>> +             if (ret)
>> +                     goto fail_res;
>> +     } else {
>> +             ret = platform_device_add_data(pdev, cell,
>> sizeof(*cell));
>> +             if (ret)
>> +                     goto fail_res;
>> +     }
>>
>>       for (r = 0; r < cell->num_resources; r++) {
>>               res[r].name = cell->resources[r].name;
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
