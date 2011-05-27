Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1E0F7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 01:59:46 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:39172 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab1E0F7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 01:59:45 -0400
X-ASG-Debug-ID: 1306475983-01de280c1e05680001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DDF3DCD.40501@fusionio.com>
Date: Fri, 27 May 2011 07:59:41 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Vivier <Laurent.Vivier@bull.net>
Subject: Re: [PATCH] loop: export module parameters
References: <1306302242-7019-1-git-send-email-namhyung@gmail.com> <1306472258.2544.6.camel@leonhard>
X-ASG-Orig-Subj: Re: [PATCH] loop: export module parameters
In-Reply-To: <1306472258.2544.6.camel@leonhard>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306475983
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64787
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-27 06:57, Namhyung Kim wrote:
> 2011-05-25 (수), 14:44 +0900, Namhyung Kim:
>> Export 'max_loop' and 'max_part' parameters to sysfs so user can know
>> that how many devices are allowed and how many partitions are supported.
>>
>> If 'max_loop' is 0, there is no restriction on the number of loop devices.
>> User can create/use the devices as many as minor numbers available. If
>> 'max_part' is 0, it means simply the device doesn't support partitioning.
>>
>> Also note that 'max_part' can be adjusted to power of 2 minus 1 form if
>> needed. User should check this value after the module loading if he/she
>> want to use that number correctly (i.e. fdisk, mknod, etc.).
>>
>> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
>> Cc: Laurent Vivier <Laurent.Vivier@bull.net>
>> ---
>>  drivers/block/loop.c |   17 ++++++++++++++---
>>  1 files changed, 14 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
>> index c59a672a3de0..76c8da78212b 100644
>> --- a/drivers/block/loop.c
>> +++ b/drivers/block/loop.c
>> @@ -1540,9 +1540,9 @@ static const struct block_device_operations lo_fops = {
>>   * And now the modules code and kernel interface.
>>   */
>>  static int max_loop;
>> -module_param(max_loop, int, 0);
>> +module_param(max_loop, int, S_IRUGO);
>>  MODULE_PARM_DESC(max_loop, "Maximum number of loop devices");
>> -module_param(max_part, int, 0);
>> +module_param(max_part, int, S_IRUGO);
>>  MODULE_PARM_DESC(max_part, "Maximum number of partitions per loop device");
>>  MODULE_LICENSE("GPL");
>>  MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);
>> @@ -1688,9 +1688,20 @@ static int __init loop_init(void)
>>  	 */
>>  
>>  	part_shift = 0;
>> -	if (max_part > 0)
>> +	if (max_part > 0) {
>>  		part_shift = fls(max_part);
>>  
>> +		/*
>> +		 * Adjust max_part according to part_shift as it is exported
>> +		 * to user space so that user can decide correct minor number
>> +		 * if [s]he want to create more devices.
>> +		 *
>> +		 * Note that -1 is required because partition 0 is reserved
>> +		 * for the whole disk.
>> +		 */
>> +		max_part = (1UL << part_shift) - 1;
>> +	}
>> +
>>  	if ((1UL << part_shift) > DISK_MAX_PARTS)
>>  		return -EINVAL;
>>  
> 
> Hi Jens,
> 
> Could you please consider applying this in your tree too? It's exactly
> the same thing what I did for brd series.

Applied now, missed it yesterday. Thanks!

-- 
Jens Axboe

