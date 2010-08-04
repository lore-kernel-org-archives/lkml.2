Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659Ab0HDLeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 07:34:24 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:53791 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757745Ab0HDLeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 07:34:22 -0400
X-ASG-Debug-ID: 1280921661-03cf00010000-xx1T2L
X-Barracuda-URL: http://10.101.1.181:8000/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4C595037.4050408@fusionio.com>
Date: Wed, 4 Aug 2010 13:34:15 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
X-ASG-Orig-Subj: Re: [PATCHv6 00/15] kill unnecessary bdi wakeups + cleanups
Subject: Re: [PATCHv6 00/15] kill unnecessary bdi wakeups + cleanups
References: <1280057365-10297-1-git-send-email-dedekind1@gmail.com>	 <4C580B1C.3020409@kernel.dk> <1280839036.15689.8.camel@localhost> <4C580FFF.2000605@kernel.dk>
In-Reply-To: <4C580FFF.2000605@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1280921661
X-Barracuda-Virus-Scanned: by Barracuda Spam & Virus Firewall at fusionio.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-03 14:47, Jens Axboe wrote:
> On 2010-08-03 14:37, Artem Bityutskiy wrote:
>> On Tue, 2010-08-03 at 14:27 +0200, Jens Axboe wrote:
>>> On 2010-07-25 13:29, Artem Bityutskiy wrote:
>>>> Hi,
>>>>
>>>> here is v6 of the patch series which clean-ups bdi threads and substantially
>>>> lessens amount of unnecessary kernel wake-ups, which is very important on
>>>> battery-powered devices.
>>>>
>>>> This patch-set is also available at:
>>>> git://git.infradead.org/users/dedekind/misc-2.6.git flushers_v6
>>>
>>> Thanks Artem, for sticking around long enough to get this into
>>> shape. I have finally merged it.
>>
>> Thanks, but
>>
>>>> 1. Use 'spin_lock_bh' for the 'bdi->wb_lock' (changed patch N12)
>>>
>>> I'd rather not, question is how to avoid it. Either just wakeup the
>>> default thread, or punt the lock-and-check bdi->wb.task to a thread.
>>
>> you merged this change, do you want me to send a separate patch which
>> undo the 'spin_lock_bh' change? I'll think about how to avoid this and
>> come back.
> 
> Yes, it's not a huge thing, but it would be nice to get rid of. So I
> figured it was better to merge it and not have you respin the series yet
> again.

There is a spinlock bug in the current code, you nest _bh locks on lock
but not always on unlock. I fixed it up as per the below:

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 0b8ee66..08d3575 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -415,7 +415,8 @@ static int bdi_forker_thread(void *ptr)
 				break;
 			}
 
-			spin_lock_bh(&bdi->wb_lock);
+			spin_lock(&bdi->wb_lock);
+
 			/*
 			 * If there is no work to do and the bdi thread was
 			 * inactive long enough - kill it. The wb_lock is taken
@@ -432,7 +433,7 @@ static int bdi_forker_thread(void *ptr)
 				action = KILL_THREAD;
 				break;
 			}
-			spin_unlock_bh(&bdi->wb_lock);
+			spin_unlock(&bdi->wb_lock);
 		}
 		spin_unlock_bh(&bdi_lock);
 

-- 
Jens Axboe


Confidentiality Notice: This e-mail message, its contents and any attachments to it are confidential to the intended recipient, and may contain information that is privileged and/or exempt from disclosure under applicable law. If you are not the intended recipient, please immediately notify the sender and destroy the original e-mail message and any attachments (and any copies that may have been made) from your system or otherwise. Any unauthorized use, copying, disclosure or distribution of this information is strictly prohibited.
