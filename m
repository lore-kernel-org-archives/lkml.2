Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab0LNXat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 18:30:49 -0500
Received: from smtp-out.google.com ([216.239.44.51]:36247 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab0LNXas convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 18:30:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=VdvQ+xVPMbE7NYQEdAr5xEyzVWe1PicJ3XYoqIsd0PoNr6DxVs+YdgUKoz/yn3Wp37
         eaXhP72oxnfvKCqpbP2g==
MIME-Version: 1.0
In-Reply-To: <AANLkTi=reqRMrv4k5EZKdj7pmsomApw9=Kwh9nxfKCuJ@mail.gmail.com>
References: <20101214212846.17022.64836.stgit@mike.mtv.corp.google.com>
 <20101214212904.17022.16604.stgit@mike.mtv.corp.google.com> <AANLkTi=reqRMrv4k5EZKdj7pmsomApw9=Kwh9nxfKCuJ@mail.gmail.com>
From: Mike Waychison <mikew@google.com>
Date: Tue, 14 Dec 2010 15:30:24 -0800
Message-ID: <AANLkTinVHrkLOMBkH3cauQndL03C_mnAJDJNYHa14ysZ@mail.gmail.com>
Subject: Re: [PATCH v3 02/22] netconsole: Introduce locking over the netpoll fields
To: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Cc: simon.kagstrom@netinsight.net, davem@davemloft.net, nhorman@tuxdriver.com,
        Matt Mackall <mpm@selenic.com>, adurbin@google.com,
        linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>, netdev@vger.kernel.org,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/14 Michał Mirosław <mirqus@gmail.com>:
> 2010/12/14 Mike Waychison <mikew@google.com>:
>> The netconsole driver currently doesn't do any locking over its
>> configuration fields.  This can cause problems if we were to ever have
>> concurrent writing to fields while somebody is enabling the service.
>>
>> For simplicity, this patch extends targets_list_lock to cover all
>> configuration fields within the targets.  Macros are also added here to
>> wrap accessors so that we check whether the target has been enabled with
>> locking handled.
>>
>> Signed-off-by: Mike Waychison <mikew@google.com>
>> Acked-by: Matt Mackall <mpm@selenic.com>
>> ---
>>  drivers/net/netconsole.c |  114 ++++++++++++++++++++++++++--------------------
>>  1 files changed, 64 insertions(+), 50 deletions(-)
>>
>> diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
>> index c87a49e..6e16888 100644
>> --- a/drivers/net/netconsole.c
>> +++ b/drivers/net/netconsole.c
>> @@ -327,6 +327,7 @@ static ssize_t store_enabled(struct netconsole_target *nt,
>>                             const char *buf,
>>                             size_t count)
>>  {
>> +       unsigned long flags;
>>        int err;
>>        long enabled;
>>
>> @@ -335,6 +336,10 @@ static ssize_t store_enabled(struct netconsole_target *nt,
>>                return enabled;
>>
>>        if (enabled) {  /* 1 */
>> +               spin_lock_irqsave(&target_list_lock, flags);
>> +               if (nt->enabled)
>> +                       goto busy;
>> +               spin_unlock_irqrestore(&target_list_lock, flags);
>>
>
> This looks wrong. Unless there is another lock or mutex covering this
> function, at this point (after spin_unlock_irqrestore()) another
> thread might set nt->enabled = 1.
>

Agreed that this looks wrong :)

It is fixed in the next patch where a state machine is introduced to
replace the binary flag nt->enabled.  The code before this patch had
the a very similar problem in that a target could be enabled twice.
store_enabled() would call netpoll_setup() the second time without
checking to see if it was already enabled.
