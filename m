Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab0LNXd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 18:33:29 -0500
Received: from smtp-out.google.com ([74.125.121.35]:60672 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab0LNXd1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 18:33:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=wlio9jlcrP/vC9hW+4mWVpjwP4iDPIwia1FmftzEk3jwu9OTY9hwM1hzETzOXnCwO+
         grDxkJCDZ/p+gwAmlAGw==
MIME-Version: 1.0
In-Reply-To: <AANLkTik8wzDPPtMM+YPoOSojiW_Nev-KDkAg8dtDV=g1@mail.gmail.com>
References: <20101214212846.17022.64836.stgit@mike.mtv.corp.google.com>
 <20101214212909.17022.96801.stgit@mike.mtv.corp.google.com> <AANLkTik8wzDPPtMM+YPoOSojiW_Nev-KDkAg8dtDV=g1@mail.gmail.com>
From: Mike Waychison <mikew@google.com>
Date: Tue, 14 Dec 2010 15:33:03 -0800
Message-ID: <AANLkTin3JoNQ4_A3eXBAW148kEqWSxr06rY5h8yH+BGb@mail.gmail.com>
Subject: Re: [PATCH v3 03/22] netconsole: Introduce 'enabled' state-machine
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
>> Representing the internal state within netconsole isn't really a boolean
>> value, but rather a state machine with transitions.
> [...]
>> diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
>> index 6e16888..288a025 100644
>> --- a/drivers/net/netconsole.c
>> +++ b/drivers/net/netconsole.c
> [...]
>> @@ -350,9 +362,9 @@ static ssize_t store_enabled(struct netconsole_target *nt,
>>                err = netpoll_setup(&nt->np);
>>                spin_lock_irqsave(&target_list_lock, flags);
>>                if (err)
>> -                       nt->enabled = 0;
>> +                       nt->np_state = NETPOLL_DISABLED;
>>                else
>> -                       nt->enabled = 1;
>> +                       nt->np_state = NETPOLL_ENABLED;
>>                spin_unlock_irqrestore(&target_list_lock, flags);
>>                if (err)
>>                        return err;
> [...]
>
> Since the spinlock protects only nt->np_state setting, you might be
> able to remove it altogether and use cmpxchg() where nt->np_state
> transitions from enabled or disabled state.
>
> Maybe the locking scheme just needs more thought altogether?

The target_list_lock protects the list, as well as the state
transitions.  This makes iterating through the list and getting a
consistent view of the targets a lot easier when it comes time to
transmitting packets we are guaranteed that nobody is changing the
target state underneath us if nt->np_state == NETPOLL_ENABLED while we
hold the lock.
