Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab1C2IxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 04:53:00 -0400
Received: from mx2.parallels.com ([64.131.90.16]:58962 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab1C2Iw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 04:52:59 -0400
Message-ID: <4D919DE5.1010509@parallels.com>
Date: Tue, 29 Mar 2011 03:52:53 -0500
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: Commit 7eaceaccab5f40 causing boot hang.
References: <4D9179EE.9040707@parallels.com> <4D917DB1.9030300@fusionio.com>
In-Reply-To: <4D917DB1.9030300@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2011 01:35 AM, Jens Axboe wrote:
> On 2011-03-29 08:19, Rob Landley wrote:
>> Using the attached config (run through oldconfig and holding down
>> enter), 2.6.38 boots but current -git hangs.  I've bisected it to this
>> commit:
>>
>> 7eaceaccab5f40bbfda044629a6298616aeaed50 is the first bad commit
>> commit 7eaceaccab5f40bbfda044629a6298616aeaed50
>> Author: Jens Axboe <jaxboe@fusionio.com>
>> Date:   Thu Mar 10 08:52:07 2011 +0100
>>
>>     block: remove per-queue plugging
>>
>>     Code has been converted over to the new explicit on-stack plugging,
>>     and delay users have been converted to use the new API for that.
>>     So lets kill off the old plugging along with aops->sync_page().
>>
>>     Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
>>
>> I suspect it broke CONFIG_IDE_GD_ATA.  (The symptoms change a bit in
>> later versions, when that was first introduced it hung right after
>> discovering hda, now it makes it to freeing kernel memory and then hangs
>> trying to launch init.  But "the disk hangs a lot" still seems to
>> describe the problem.)
> 
> That is the case even with 9ced0b95b3993660e7990cf6bf68c1a80f31544e,
> which was otherwise supposed to fix this queue stall?
> 

The first time I tried it, that version did manage to launch init, and
then hung two lines later with ".udev/ already exists on the static
/dev! ..." and the cursor still on the end of that line.  Could be an
unrelated bug, hard to tell.

I tried it three more times and it hung right after "freeing unused
kernel memory", with no output from init.  (I also tried adding
"init=/bin/bash" to the kernel command line and it still hung after the
"freeing unused kernel memory" line, with no output from bash.  Pressed
a lot of keys, nothing echoed back.)

This is an improvement over hanging earlier in the boot, but userspace
isn't really happy at the moment.

I'm booting all this under kvm or qemu, by the way:

qemu-system-x86_64 -m 1024 -kernel arch/x86/boot/bzImage \
  -hda ~/sid.ext3 -append "root=/dev/hda rw"

Sometimes with init=/bin/bash in that last quoted bit.  The root
filesystem's debian sid but that's probably not relevant because it
worked fine with .38.

Rob
