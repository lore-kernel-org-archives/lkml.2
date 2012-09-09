Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab2IIU2Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 16:28:25 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52674 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab2IIU2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 16:28:23 -0400
Message-ID: <504CFBE3.401@pobox.com>
Date: Sun, 09 Sep 2012 16:28:19 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Arvydas Sidorenko <asido4@gmail.com>
CC: Hugh Dickins <hughd@google.com>, Zheng Liu <wenqing.lz@taobao.com>,
        linux-kernel@vger.kernel.org,
        IDE/ATA development list <linux-ide@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Storage related regression in linux-next 20120824
References: <CA+6av4=uxu_q5U_46HtpUt=FSgbh3pZuAEY54J5_xK=MKWq-YQ@mail.gmail.com> <CAFtxgO536xEMjMw_D1u3utT1f1iy-6EsjcawdYvbocRxc=Wu=A@mail.gmail.com> <503BA2DB.9080704@gmail.com> <503BB4BB.4080307@gmail.com> <alpine.LSU.2.00.1209090012390.2416@eggly.anvils> <CA+6av4=6WeLcde5me2FCpBtQJAOTtHZvf4pkMExgMW9agVNLWg@mail.gmail.com>
In-Reply-To: <CA+6av4=6WeLcde5me2FCpBtQJAOTtHZvf4pkMExgMW9agVNLWg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2012 04:11 PM, Arvydas Sidorenko wrote:
>> I think you know your way around SCSI/libata much better than I do.
>>
>> I just bisected linux-next, and it comes down to the commit below, which
>> introduces the regression for me, and I'm guessing for you also.  Maybe
>> it can be fixed up to satisfy us, but otherwise will have to be reverted:
>> we don't invert a default if it's going to break older working systems.
>>
>> A good workaround for me meanwhile is to add boot option "libata.fua=0":
>> please try that (or reverting the commit) and let us know the result.
>>
>> Thanks,
>> Hugh
>>
>> commit 91895b786e631ab47b618c901231f22b5a44115b
>> Author: Zheng Liu <wenqing.lz@taobao.com>
>> Date:   Tue May 8 11:24:03 2012 +0800
>>
>>      libata: enable SATA disk fua detection on default
>>
>>      Currently, SATA disk fua detection is disabled on default because most of
>>      devices don't support this feature at that time.  With the development of
>>      technology, more and more SATA disks support this feature.  So now we can enable
>>      this detection on default.
>>
>>      Although fua detection is defined as a kernel module parameter, it is too hard
>>      to set its value because it must be loaded and set before system starts up.
>>      That needs to modify initrd file.  So it is inconvenient for administrator who
>>      needs to manage a huge number of servers.
>>
>>      Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
>>      Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
>>
>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>> index 5eee1c1..c3fbdca 100644
>> --- a/drivers/ata/libata-core.c
>> +++ b/drivers/ata/libata-core.c
>> @@ -135,9 +135,9 @@ int atapi_passthru16 = 1;
>>   module_param(atapi_passthru16, int, 0444);
>>   MODULE_PARM_DESC(atapi_passthru16, "Enable ATA_16 passthru for ATAPI devices (0=off, 1=on [default])");
>>
>> -int libata_fua = 0;
>> +int libata_fua = 1;
>>   module_param_named(fua, libata_fua, int, 0444);
>> -MODULE_PARM_DESC(fua, "FUA support (0=off [default], 1=on)");
>> +MODULE_PARM_DESC(fua, "FUA support (0=off, 1=on [default])");
>>
>>   static int ata_ignore_hpa;
>>   module_param_named(ignore_hpa, ata_ignore_hpa, int, 0644);
>
> Indeed, disabling FUA explicitly solved the issue on my disk as well.
> Hugh, what hard drive you have this issue on?
>
> I believe there are two solutions:
> - Revert FUA default back to '0'
> - Start filling SATA drive blacklist in function:

I think the right thing to do for release is disable it (again), then we 
can try again later with better logic.

I'll send Linus a patch to disable.

It is entirely possible that this is a software problem, where we 
missing some detail turning on FUA (thereby engaging some less traveled 
core block layer machinery), or even a remote possibility of triggering 
a filesystem bug.

	Jeff





