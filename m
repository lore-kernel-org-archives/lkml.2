Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987Ab0IYVSb convert rfc822-to-quoted-printable (ORCPT
	<rfc822;w@1wt.eu>); Sat, 25 Sep 2010 17:18:31 -0400
Received: from tuxonice.net ([74.207.252.127]:42397 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326Ab0IYVSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 17:18:30 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C9E6724.5000300@tuxonice.net>
Date: Sun, 26 Sep 2010 07:18:28 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.10pre) Gecko/20100903 Shredder/3.1.4pre
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [linux-pm] [PATCH] Hibernate: Implement readahead when resuming
References: <1285416056-9735-1-git-send-email-nigel@tuxonice.net> <1285416056-9735-2-git-send-email-nigel@tuxonice.net> (sfid-20100925_155139_503661_B410FD8E) <201009252102.52401.Martin@lichtvoll.de>
In-Reply-To: <201009252102.52401.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from QUOTED-PRINTABLE to 8bit by mail.home.local id o8PLJrhX010803

Hi.

On 26/09/10 05:02, Martin Steigerwald wrote:
> Hi Nigel and Rafael,
>
> Am Samstag 25 September 2010 schrieb Nigel Cunningham:
>> Add support for submitting reads before they're needed. This greatly
>> improves the speed of resuming:
>>
>> From
>>
>> PM: Image read at 66 MB/s.
>>
>> to
>>
>> PM: Image read at 229 MB/s.
>>
>> ...and removes the need for the sync_read flag.
>
> So
>
> martin@shambhala:~/Computer/Shambhala/Kernel/2.6.36/tuxonice-head>  git
> branch -av | grep for-rafael
> * for-rafael                      d4e7490 Hibernate: Implement readahead
> when resuming
>    remotes/origin/for-rafael       d4e7490 Hibernate: Implement readahead
> when resuming
>
> martin@shambhala:~>  cat /proc/version
> Linux version 2.6.36-rc5-tp42-hibernate-accel-vmembase-0-00135-gd4e7490-
> dirty (martin@shambhala) (gcc version 4.4.5 20100728 (prerelease) (Debian
> 4.4.4-8) ) #1 PREEMPT Sat Sep 25 18:02:02 CEST 2010
>
> basically seems to work.
>
> But
>
>> Signed-off-by: Nigel Cunningham<nigel@tuxonice.net>
>> ---
>>   kernel/power/block_io.c |   97
>> ++++++++++++++++++++++++++++++++++++++++++++--- kernel/power/power.h
>>   |    4 --
>>   kernel/power/snapshot.c |    5 --
>>   kernel/power/swap.c     |    2 -
>>   4 files changed, 91 insertions(+), 17 deletions(-)
>>
>> diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
>> index fc2e05d..5a13f80 100644
>> --- a/kernel/power/block_io.c
>> +++ b/kernel/power/block_io.c
> [...]
>> +	if (!offset) {
>> +		printk("Offset zero - no more readahead.\n");
>> +		more_readahead = 0;
>> +		return 0;
>> +	}
>> +
>> +	printk("(1) Submitting readahead of sector %llu to page %p.\n",
>> +			offset, ra_page);
>
> and
>
>> +	if (!readahead_list_head) {
>> +		printk("No readahead left. Returning -EFAULT.\n");
>>   		return -EFAULT;
>> -	return hib_bio_read_page(offset, buf, sync);
>> +	}
>> +
>> +	printk("Waiting on readahead of page %p.\n", readahead_list_head);
>
> should be made optional - activatable via a debug switch - before this
> gets merged, cause it displays a lots of these on resuming which takes
> some time in itself.

Oh, I'm sorry. I completely forgot about that debugging code. Removed 
now. (Note that I'm rebasing and modifying this branch like a patch 
series, so you will get conflicts when you pull updates).

> I tried 5 times:
>
> - one with just kdm started worked nicely and really rather fast!
>
> - four with a full blown KDE 4.5.1 session with OpenGL compositing
>    - one seemed to hang prior to reinitializing the Radeon KMS DRM setup
>    - three other worked just fine
>
> I do not think that the hang is related to your changes, Nigel. The kernel
> remained stuck at the lower initial resolution and didn't seem to
> initialize the radeon KMS framebuffers at 1400x1050 properly. I didn't see
> this with 2.6.35 and userspace software suspend.
>
> Writing and reading seems to be way faster than with userspace software
> suspend, I didn't compare with unpatched in kernel suspend. But I do not
> seem to get any numbers printed:
>
> shambhala:~>  grep "Image read" /var/log/syslog
> shambhala:~#1>  dmesg | grep "Image read"
> shambhala:~#1>  dmesg | grep "Image writ"
> shambhala:~#1>  grep "Image writ" /var/log/syslog
> shambhala:~#1>

It uses pr_debug. Do you have CONFIG_PM_DEBUG=y?

> The machine seems to return more quickly to an usable state. Does in
> kernel suspend save larger images? I am especially surprised as I use
> compression with userspace software suspend which I thought should speed
> up writing the image. It feels that in kernel suspend with patches from
> you, Nigel, seems to outdo userspace software suspend by quite some
> margin.

All I have changed at the moment is how the image is saved. With these 
patches, swap is being allocated prior to saving the image (which 
shouldn't itself make a huge difference in speed), and the image is 
stored in a slightly different format which lets us not have to do i/o 
in batches. In addition (with this last patch), we submit the reads 
before we need them.

> I have a quite high setting for userspace software suspend image size:
>
>    1 # /etc/uswsusp.conf(8) -- Configuration file for s2disk/s2both·
>    2 resume device = /dev/sda2
>    3 compress = y
>    4 early writeout = y
>    5 image size = 1500
>    6 shutdown method = halt
>
> Still the machine crawls on resume for about 30 seconds or a minute before
> coming into a usable state. With patched in kernel suspend this wait for
> responsivity seems to have cut down to about 10-15 seconds.
>
> Please note: I didn't actually measure anything of this, this is just
> subjective impressions so far. Before measuring, I think I should disable
> those debug outputs I mentioned above ;).
>
> The ThinkPad T42 I am testing on has 2 GiB RAM. Swap is about 4 GB.
>
> No long term observations so far. I will report how it goes.
>
> Thanks,

Thank you!

Nigel
