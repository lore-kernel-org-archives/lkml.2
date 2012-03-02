Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030186Ab2CBO0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 09:26:44 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52366 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965451Ab2CBO0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 09:26:40 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6636"; a="168507341"
Message-ID: <6669559e86c1d13b27e941ff2acf89d2.squirrel@www.codeaurora.org>
In-Reply-To: <CAKYAXd_6OqQJ78mPJp11gRvGwwg88S_n_Auu=_HdP_ZXzCKrDg@mail.gmail.com>
References: <4934441a17d25c3249556f7bf281b1be.squirrel@www.codeaurora.org>
    <CAKYAXd_6OqQJ78mPJp11gRvGwwg88S_n_Auu=_HdP_ZXzCKrDg@mail.gmail.com>
Date: Fri, 2 Mar 2012 06:26:39 -0800 (PST)
Subject: Re: [PATCH v5 2/2] mmc: core: Support packed command for eMMC4.5 
     device
From: merez@codeaurora.org
To: "Namjae Jeon" <linkinjeon@gmail.com>
Cc: merez@codeaurora.org, "Seungwon Jeon" <tgih.jun@samsung.com>,
        linux-mmc@vger.kernel.org, "Chris Ball" <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Our tests showed that the write packing improved the performance of the
write sequential operations:

Long write operation:
----------------------
no-packing: 15.8 MB/s
packed commands patch (both READ and WRITE packing are enabled): 23.3 MB/s

Several parallel write operations (sum of all the write throughputs):
---------------------------
no-packing: 17.1 MB/s
packed commands patch(both READ and WRITE packing are enabled): 25 MB/s

Parallel long read and long write operations (write throughput):
-----------------------------------------------------------------
no-packing: 12.2 MB/s
packed commands patch (both READ and WRITE packing are enabled): 16.3 MB/s

Parallel short read and long write operations (write throughput):
-----------------------------------------------------------------
no-packing: 15.4 MB/s
packed commands patch (both READ and WRITE packing are enabled): 16.4 MB/s

Several Parallel short read and short write operations (sum of all the
write throughputs):
--------------------------------------------------------------------------
no-packing: 12.5 MB/s
packed commands patch (both READ and WRITE packing are enabled): 15.5 MB/s


Random read and random write:
------------------------------
I checked the random read and random write IOPs by using the IOZONE
application. There was a slight degradation in the read results due to the
packing and no improvements in the write results.

The results are:

IOZONE file size of 100M:
no-packing: random read: 4675, random write: 729
packed commands patch (both READ and WRITE packing are enabled): random
read: 4557 random write: 723

IOZONE file size of 256M:
no-packing: random read: 4632, random write: 744
packed commands patch (both READ and WRITE packing are enabled): random
read: 4498, random write: 742

Thanks,
Maya Erez
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum

> Hi. merez.
>
> Would you share random read speed with us ?
>
> And Write speed also..
>
> Thanks.
>
> 2012/3/1  <merez@codeaurora.org>:
>>> This patch supports packed command of eMMC4.5 device.
>>> Several reads(or writes) can be grouped in packed command
>>> and all data of the individual commands can be sent in a
>>> single transfer on the bus.
>>>
>>> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
>>> ---
>>>  drivers/mmc/card/block.c   |  496
>>> +++++++++++++++++++++++++++++++++++++++++--
>>>  drivers/mmc/card/queue.c   |   48 ++++-
>>>  drivers/mmc/card/queue.h   |   13 ++
>>>  drivers/mmc/core/mmc_ops.c |    1 +
>>>  include/linux/mmc/core.h   |    4 +
>>>  5 files changed, 535 insertions(+), 27 deletions(-)
>>>
>> Hi,
>>
>> We ran performance tests on the packed commands patch. We found out that
>> enabling the read packing didn't improve the performance in any of the
>> scenarios we ran (see the detailed results below).
>> Therefore, we suggest to move the read packing code to a different patch
>> and approve only the write packing code for now. The read packing adds
>> complexity to the code and we don't see a point in adding it while the
>> intention is to disable it.
>>
>> Test results:
>>
>> Long read operation:
>> ----------------------
>> no-packing: 39.5 MB/s
>> packed commands patch (both READ and WRITE packing are enabled): 39.5
>> MB/s
>> packed commands patch + enabling only READ packing: 39.5 MB/s
>>
>> Several parallel read operations (sum of all the read throughputs):
>> ---------------------------
>> no-packing: 42.6 MB/s
>> packed commands patch(both READ and WRITE packing are enabled): 38 MB/s
>> packed commands patch + enabling only READ packing: 38.2 MB/s
>>
>> Parallel long read and long write operations (read throughput):
>> -----------------------------------------------------------------
>> no-packing: 23.8 MB/s
>> packed commands patch (both READ and WRITE packing are enabled): 12.6
>> MB/s
>> packed commands patch + enabling only READ packing: 12.5 MB/s
>>
>> Parallel short read and long write operations (read throughput):
>> -----------------------------------------------------------------
>> no-packing: 22.9 MB/s
>> packed commands patch (both READ and WRITE packing are enabled): 8.4
>> MB/s
>> packed commands patch + enabling only READ packing: 8.6 MB/s
>>
>> Several Parallel short read and short write operations (sum of all the
>> read throughputs):
>> --------------------------------------------------------------------------
>> no-packing: 41.6 MB/s
>> packed commands patch (both READ and WRITE packing are enabled): 35 MB/s
>> packed commands patch + enabling only READ packing: 36 MB/s
>>
>> Thanks,
>> Maya Erez
>> Consultant for Qualcomm Innovation Center, Inc.
>> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
>>
>>
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


