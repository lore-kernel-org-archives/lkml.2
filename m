Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab1B1J3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 04:29:15 -0500
Received: from isrv.corpit.ru ([86.62.121.231]:38094 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab1B1J3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 04:29:13 -0500
Message-ID: <4D6B6AE7.2050202@msgid.tls.msk.ru>
Date: Mon, 28 Feb 2011 12:29:11 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>, segoon@openwall.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, eric.dumazet@gmail.com,
        therbert@google.com, xiaosuo@gmail.com, jesse@nicira.com,
        kees.cook@canonical.com, eugene@redhat.com, dan.j.rosenberg@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH] don't allow CAP_NET_ADMIN to load non-netdev kernel modules
References: <1298660879.2554.23.camel@bwh-desktop> <1298666310.2554.47.camel@bwh-desktop> <AANLkTikmtKksP6o1hecf0=ZnRv0j4+_Q326UEG8ss16k@mail.gmail.com> <201102272122.52643.arnd@arndb.de>
In-Reply-To: <201102272122.52643.arnd@arndb.de>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

27.02.2011 23:22, Arnd Bergmann wrote:
> On Friday 25 February 2011, Micha³ Miros³aw wrote:
>>> diff --git a/net/core/dev.c b/net/core/dev.c
>>> index 54aaca6..0d09baa 100644
>>> --- a/net/core/dev.c
>>> +++ b/net/core/dev.c
>>> @@ -1120,8 +1120,20 @@ void dev_load(struct net *net, const char *name)
>>>        dev = dev_get_by_name_rcu(net, name);
>>>        rcu_read_unlock();
>>>
>>> -       if (!dev && capable(CAP_NET_ADMIN))
>>> -               request_module("%s", name);
>>> +       if (!dev && capable(CAP_NET_ADMIN)) {
>>> +               /* Check whether the name looks like one that a net
>>> +                * driver will generate initially.  If not, require a
>>> +                * module alias with a suitable prefix, so that this
>>> +                * can't be used to load arbitrary modules.
>>> +                */
>>> +               if ((strncmp(name, "eth", 3) == 0 &&
>>> +                    isdigit((unsigned char)name[3])) ||
>>> +                   (strncmp(name, "wlan", 4) == 0 &&
>>> +                    isdigit((unsigned char)name[4])))
>>> +                       request_module("%s", name);
>>> +               else
>>> +                       request_module("netdev-%s", name);
>>> +       }
>>>  }
>>>  EXPORT_SYMBOL(dev_load);
>>>
>>
>> This might be better as:
>>
>> if (request_module("netdev-%s", name))
>>     ... fallback
>>
>> Then after some years the fallback could be removed if announced properly.
> 
> The backwards compatibility should mostly be for systems that today don't
> use split capabilities, right?
> 
> The fallback could therefore rely on CAP_SYS_MODULE as well:
> 
> 	if (request_module("netdev-%s", name)) {
> 		if (capable(CAP_SYS_MODULE))
> 			request_module("%s", name);
> 	}
> 
> Not 100% solution, but should solve the capability escalation nicely without
> causing much pain.

To me this looks like the best solution so far - trivial and
compatible.

Thanks!

/mjt
