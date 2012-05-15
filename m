Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965651Ab2EOQHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:07:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57637 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099Ab2EOQHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:07:41 -0400
Message-ID: <4FB27EC5.70507@ammonit.com>
Date: Tue, 15 May 2012 18:05:25 +0200
From: =?GB2312?B?U3RlZmZlbiBLqLlobg==?= <sk@ammonit.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20110307 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: "ludovic.desroches" <ludovic.desroches@atmel.com>
CC: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] mmc: atmel-mci: fix deadlock
References: <1336555416-14640-1-git-send-email-sk@ammonit.com> <4FAA4ADA.1080008@atmel.com>
In-Reply-To: <4FAA4ADA.1080008@atmel.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 15 May 2012 16:05:21.0694 (UTC) FILETIME=[87C4DBE0:01CD32B4]
X-Provags-ID: V02:K0:rn0BbgLZ7vuaiBDxdpMgIeaRwRbQnfhCt4mZDQg2J3s
 vN+7o4fxENBWX4EdBT/TEUrer6PCwvYOUQKGxWOMeeUGGxy19J
 ll+QVEtEUMoCYH3eIFoF4YuxutJXAzVIbbPCbaF9UnN1R9EaLu
 0lfg1qzdtuUfh4RfSYDjoRC836aeLNuLY/X5dzbT4RkZmSG+4F
 x+NNVv3d3NOj5xMwhAz7/V3IlJGI1n2fbNZGkkbaW+1JyUc6hX
 L4wWtbKj3Hrpx7hanvb96s+C+2r4WhE6pbbD6sr+0dz3hIQHQI
 e8lR+fzFsr9F2Im6VqfqcG6TBIhYi5iTUb+ueJ9Z5+ZVScHM/W
 rMsxROWeATICHQgWPYQY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Ludovic,

in the meantime I have some new informations about the atmel-mci
deadlock problem: When you write permanently with

dd if=/dev/zero of=/dev/<device> bs=512

and removing the card you will get almost always a hang up. With
"printk" I have find out that the function "atmci_tasklet_func" doesn't
run anymore in this case.

I would ask you to add card inserting and removing during write and read
in your test cases.

Regards
Steffen


Am 09.05.2012 12:45, schrieb ludovic.desroches:
> Hi Steffen,
> 
> Le 05/09/2012 11:23 AM, Steffen K¨¹hn a ¨¦crit :
>> solves a deadlock problem which appears when a mmc card is
>> removing and a process is reading from the card at the same time.
>> ---
>>   drivers/mmc/host/atmel-mci.c |    4 +++-
>>   1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
>> index e94476b..effdc36 100644
>> --- a/drivers/mmc/host/atmel-mci.c
>> +++ b/drivers/mmc/host/atmel-mci.c
>> @@ -1499,8 +1499,10 @@ static void atmci_tasklet_func(unsigned long priv)
>> 			}
>>
>> 			if (!atmci_test_and_clear_pending(host,
>> -						EVENT_XFER_COMPLETE))
>> +						EVENT_XFER_COMPLETE)) {
>> +				host->stop_transfer(host);
>> 				break;
>> +            }
>>
>> 			atmci_set_completed(host, EVENT_XFER_COMPLETE);
>> 			prev_state = state = STATE_DATA_BUSY;
>> --
>> 1.7.2.5
> 
> Even if it solves your issue, I am not sure about the consequences of
> this fix even if it is working well in your case and with your hardware.
> 
> This condition allows to wait for the end of a transfer. The
> EVENT_XFER_COMPLETE flag is set when the dma transfer is complete (or pdc).
> If the transfer is not complete you will ask to stop it. I understand it
> could solve your issue but I am afraid it can also stop a transfer
> before its normal completion.
> 
> I am currently working on atmel-mci and the state machine would be
> changed.  So I prefer to wait the new atmel-mci version to take this
> patch. I will add your issue to my test cases.
> 
> 
> By the way, can you give me more details about your issue because I
> can't reproduce it on my side. If I remove the card while a process is
> reading from it, I also have I/O errors but I have no issue to detect a
> new card insertion.
> 
> 
> Regards
> 
> Ludovic

