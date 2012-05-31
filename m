Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab2EaI1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 04:27:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:58831 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757987Ab2EaI1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 04:27:15 -0400
Message-ID: <4FC72AB9.5070606@kernel.dk>
Date: Thu, 31 May 2012 10:24:25 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Asai Thambi S P <asamymuthupa@micron.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 10/11] mtip32xx: Changes to sysfs entries
References: <4FC57B96.30500@micron.com> <20120531060840.GA14755@kroah.com>
In-Reply-To: <20120531060840.GA14755@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2012 08:08 AM, Greg KH wrote:
> On Tue, May 29, 2012 at 06:44:54PM -0700, Asai Thambi S P wrote:
>>
>> * Formatted the output of 'registers' entry
>> * Added "Commands in Q' to output of 'registers' entry
>> * Added a new entry 'flags'
>>
>> Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
>> ---
>>  Documentation/ABI/testing/sysfs-block-rssd |   12 ++++-
>>  drivers/block/mtip32xx/mtip32xx.c          |   76 +++++++++++++++++++++-------
>>  2 files changed, 67 insertions(+), 21 deletions(-)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-block-rssd b/Documentation/ABI/testing/sysfs-block-rssd
>> index d535757..679ce35 100644
>> --- a/Documentation/ABI/testing/sysfs-block-rssd
>> +++ b/Documentation/ABI/testing/sysfs-block-rssd
>> @@ -6,13 +6,21 @@ Description:    This is a read-only file. Dumps below driver information and
>>                  hardware registers.
>>                      - S ACTive
>>                      - Command Issue
>> -                    - Allocated
>>                      - Completed
>>                      - PORT IRQ STAT
>>                      - HOST IRQ STAT
>> +                    - Allocated
>> +                    - Commands in Q
>>  
>>  What:           /sys/block/rssd*/status
>>  Date:           April 2012
>>  KernelVersion:  3.4
>>  Contact:        Asai Thambi S P <asamymuthupa@micron.com>
>> -Description:   This is a read-only file. Indicates the status of the device.
>> +Description:    This is a read-only file. Indicates the status of the device.
>> +
>> +What:           /sys/block/rssd*/flags
>> +Date:           May 2012
>> +KernelVersion:  3.5
>> +Contact:        Asai Thambi S P <asamymuthupa@micron.com>
>> +Description:    This is a read-only file. Dumps the flags in port and driver
>> +                data structure
>> diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
>> index d0fa357..18daa04 100644
>> --- a/drivers/block/mtip32xx/mtip32xx.c
>> +++ b/drivers/block/mtip32xx/mtip32xx.c
>> @@ -2562,40 +2562,58 @@ static ssize_t mtip_hw_show_registers(struct device *dev,
>>  	int size = 0;
>>  	int n;
>>  
>> -	size += sprintf(&buf[size], "S ACTive:\n");
>> +	size += sprintf(&buf[size], "Hardware\n--------\n");
>> +	size += sprintf(&buf[size], "S ACTive      : [ 0x");
>>  
>> -	for (n = 0; n < dd->slot_groups; n++)
>> -		size += sprintf(&buf[size], "0x%08x\n",
>> +	for (n = dd->slot_groups-1; n >= 0; n--)
>> +		size += sprintf(&buf[size], "%08X ",
>>  					 readl(dd->port->s_active[n]));
> 
> <snip>
> 
> WHAT???
> 
> No, this needs to be a debugfs file, sysfs is "one value per file",
> stuff like this is not allowed at all.
> 
> Please remove these sysfs files entirely, they are not allowed.  If you
> feel you really need them, put them in debugfs.
> 
> As-is, this patch is not acceptable, and a follow-on patch needs to be
> created to remove these sysfs files now.

True, it really should be moved to debugfs. Not only because of the
multiple value thing (not going to render my personal opinion on that),
but because it is indeed debug functionality. It does not constitute a
real API of any sort.

The file is already there, the patch is only changing the contents. It
wasn't a single value thing before either. So Asai, I'd suggest you
guys send a followup patch moving it to debugfs.

-- 
Jens Axboe

