Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab2IXFjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 01:39:24 -0400
Received: from mailhost.elitecore.com ([203.88.135.194]:55210 "EHLO
	elitecore.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750792Ab2IXFjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 01:39:22 -0400
Message-ID: <505FF35E.6020506@elitecore.com>
Date: Mon, 24 Sep 2012 11:15:02 +0530
From: Jagdish Motwani <jagdish.motwani@elitecore.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andres Freund <andres@anarazel.de>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: performance degradation on kernel upgrade (due to commit ab0a9735e06914ce4d2a94ffa41497dbc142fe7f)
References: <505C700C.3010403@elitecore.com> <201209211625.42895.andres@anarazel.de>
In-Reply-To: <201209211625.42895.andres@anarazel.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Cyberoam-smtpxy-version: 1.0.6.3
X-Cyberoam-AV-Policy: Default Rule
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 07:55 PM, Andres Freund wrote:
> Hi,
>
> On Friday, September 21, 2012 03:47:56 PM Jagdish Motwani wrote:
>> Recently i upgraded my kernel from 2.6.29.6 to 2.6.35.14.
>>
>> After upgrading i got very poor performance on my postgre database.
>>
>>
>> My test.sql contains 10000 postgre insert query
>>
>>
>> Linux  2.6.29.6
>>
>> time psql -U user -d database -f test.sql  > /dev/null
>> real    0m 7.23s
>> user    0m 0.38s
>> sys     0m 0.12s
>>
>>
>>
>> Linux  2.6.35.14
>>
>> # time psql -U user -d database -f test.sql  > /dev/null
>> real    1m 4.05s
>> user    0m 0.44s
>> sys    0m 0.12
> How do the results to this look if you use psql -1/--single-transaction?
Using single transaction solves the problem - but that's not what i 
really want.
>
>> I even tried Linux 3.5.4 and got similar results.
>>
>> Using git bisect, i got commit ab0a9735e06914ce4d2a94ffa41497dbc142fe7f
>>
>> Is it a behavior change or am i missing something? Are there any
>> workarounds for this?
> I guess youre using some form of virtualization? I think what youre observing
> is just that access via raw devices previously lied about consistency. As the
> commit observes several virtualization solutions can use raw device access.
>
> If all those 10000 inserts above happen in individual transactions - which
> would happen if youre not using transactions explicitly -  each and every one
> of them will cause a single disk write if they are executed sequentially.
> A typical rotating disks can do between 80-160 such writes. If you devide 10k
> transactions by 150 synchronous writes a second you get ~66s which pretty
> nicely fits your time above.
>
> If you don't care about loosing a very small amount of transactions (up to a
> second with the default settings) you can disable the synchronous_commit
> setting in postgres. No earlier commits/changes will be lost/corrupted.
> You can change that setting per transaction, per session/connection, per user,
> per database or globally.
>
> Greetings,
>
> Andres
Thanks Andres,

I disabled synchronous_commit, and got results similar to 2.6.32.

Regards,
Jagdish Motwani
