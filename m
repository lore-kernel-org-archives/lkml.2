Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab2FSGkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 02:40:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62293 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab2FSGke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 02:40:34 -0400
Message-ID: <4FE01ED8.8000903@bernhard-voelker.de>
Date: Tue, 19 Jun 2012 08:40:24 +0200
From: Bernhard Voelker <mail@bernhard-voelker.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: "gnehzuil.lzheng@gmail.com" <gnehzuil.lzheng@gmail.com>
CC: Jens Axboe <axboe@kernel.dk>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        util-linux@vger.kernel.org
Subject: Re: Why does ionice(1) ban the user to set back to 'none' class?
References: <20120618114841.GA4855@gmail.com> <4FDF2D10.9050008@kernel.dk> <4FDFDFCE.9010307@gmail.com>
In-Reply-To: <4FDFDFCE.9010307@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:H/7UceP0KM1b8T5DmiHub8xSDI/KbD0KPNZLIIzAY3L
 2CIZOTVZVVONl1Q1QBERiSBIq/KQRrxNJTSOswnyV8ZLEfvjgK
 nducqmNoJ2YG1JntrTmit3QRbWP2ZEZ878EtdkBgFJU8124bkG
 zWJX5UcaBJILeyvPrVDTgkp8mpK9EN59tK3NmT7xpg6D8afZ2t
 cm2OaACReSF2Nx4KozoGL0zjIApNNuwlsWD8Y1ymz3z924w7Uo
 KzI7rgadeTd/G/42zYPTKeBy7G6yslAYYJIEKB8JOBqiqV8VEP
 bLHFnS4VVLtb0AzHxpHWYTKu/fW2BbQOxVgGYhrupI6yDPZP94
 N3NhPq/8CAh/TDZGI1alQc3Xis/RsOyRxkzrrgAxc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 04:11 AM, gnehzuil.lzheng@gmail.com wrote:
> [CC'd to util-linux mailing list]
> 
> On 06/18/2012 09:28 PM, Jens Axboe wrote:
> 
>> On 06/18/2012 01:48 PM, Zheng Liu wrote:
>>> Hi Jens,
>>>
>>> I meet a problem when I use ionice(1) to adjust a process's io priority.
>>> I do the following operations:
>>>
>>> $ ionice -p${pid}
>>> none: prio 0
>>> $ ionice -p${pid} -c2 -n4
>>> $ ionice -p${pid}
>>> best-effort: prio 4
>>> $ ionice -p${pid} -c0 -n0
>>> $ ionice -p${pid}
>>> best-effort: prio 0
>>>
>>> So I cannot set scheduling class back to 'none'.  If I call ioprio_set(2)
>>> directly, it will be fine.  But if I use ionice(1), I cannot change it.  I
>>> read the docs about ionice in [1].  I notice this code:
>>>
>>> switch (ioprio_class) {
>>> 	case IOPRIO_CLASS_NONE:
>>> 		ioprio_class = IOPRIO_CLASS_BE;
>>>                                ^^^^^^^^^^^^^^^^
>>>                                *It means that we cannot set back to none.*
>>> 		break;
>>> 	case IOPRIO_CLASS_RT:
>>> 	case IOPRIO_CLASS_BE:
>>> 		break;
>>> 	case IOPRIO_CLASS_IDLE:
>>> 		ioprio = 7;
>>> 		break;
>>> 	default:
>>> 		printf("bad prio class %d\n", ioprio_class);
>>> 		return 1;
>>> }
>>>
>>> My question is why we need to ban the user to set back to 'none'.  Is there
>>> some reasons?  Thank you.
>>
>> The kernel code does allow it, so it's only in the tool that this
>> restriction exists. I don't think we have a particularly good reason to
>> have it there. This is a tools question, though, not a kernel issue. I
>> suggest you take it up with the util-linux crew. I'm fine with removing
>> this restriction from ionice, especially since you could just roll your
>> own that did it.
>>
> 
> 
> Thanks for your reply.  Hopefully we can get some feedbacks from
> util-linux crew.

That has already been fixed by commit v2.15-45-g5dc9371 more than 2 years ago:

  Author: Jakob Unterwurzacher <jakobunt@gmail.com>  2009-01-17 02:38:32
  Committer: Karel Zak <kzak@redhat.com>  2009-05-27 23:43:18

and the change made it into 2.16.

The current piece of code looks like this:

	switch (ioclass) {
		case IOPRIO_CLASS_NONE:
			if ((set & 1) && !tolerant)
				warnx(_("ignoring given class data for none class"));
			data = 0;
			break;
		case IOPRIO_CLASS_RT:
		case IOPRIO_CLASS_BE:
			break;

We'are currently at version 2.21.2.

Have a nice day,
Berny



