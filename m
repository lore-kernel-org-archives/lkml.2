Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759Ab2EIMNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 08:13:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58248 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758687Ab2EIMMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 08:12:50 -0400
Message-ID: <4FAA5F3F.8060906@ammonit.com>
Date: Wed, 09 May 2012 14:12:47 +0200
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
X-OriginalArrivalTime: 09 May 2012 12:12:47.0859 (UTC) FILETIME=[0C281C30:01CD2DDD]
X-Provags-ID: V02:K0:G/ma/pObF5JdZwQoJRC+QUPmvz6p3vT/usE5/xEZ7XC
 lERR+4e677dDKnHzdGDnlKfLu0M6KN+d6KvV7Ourp1YQ9ceEIT
 6jy+6XFYnxC/7m3Qx+36C2hzUqjAo//i963+lj+r9y3LaQq19n
 fZjHotU5gtvqs1VaHTX3N8yTJIPT19GnSO98C4EQjM38coROwk
 KOQ33T7RPbh6TBRMz390Qbb0/NT7h7Sa51pjgAz74EyPrzXQ8A
 xP20QqdEnPWXNVA5mVrR1EvKnuy5A5Nvy/UuFKIBsMaDMIhhJO
 7fcan0H6Iqmsr7lZxYvafBJDbOEvRrWlPyUKzX4MHIXvx56ZA9
 Hmx8wwhvHadK9w6kKPB8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ludovic,

my hardware is a multiprocessor system by which the access to the card
is shared between two processors. Because of this changes happen really
frequently.

I have observed that the deadlock only occurs when the card is
desappearing and there are errors like 'end_request: I/O error, dev
mmcblk0, sector XXX'. A process has to read permanently from the card.

The problem seems to be that the driver waits for finishing the
transfer, but this comes never because the card is unavailable. Maybe a
new state machine solves this in a better way as my workaround.

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
