Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938Ab2HHQ6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 12:58:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34464 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758508Ab2HHQ6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 12:58:43 -0400
Message-ID: <50229ABC.1030102@canonical.com>
Date: Wed, 08 Aug 2012 09:58:36 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120724 Thunderbird/15.0
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Paul Moore <paul@paul-moore.com>, John Stultz <john.stultz@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov
Subject: Re: NULL pointer dereference in selinux_ip_postroute_compat
References: <50215A7E.8000701@linaro.org> <CAHC9VhTSS8+-OcX9uK0xqnYC3-y0axVGs1m+kuC6+M6HvmSmgg@mail.gmail.com> <50218F7E.1060004@linaro.org> <CAHC9VhTd-d9NgWoU6_o9qw0bq4ZbuTEj8E_jRYyDXPWQaLLdog@mail.gmail.com> <20120807221731.GA25441@mail.hallyn.com>
In-Reply-To: <20120807221731.GA25441@mail.hallyn.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 03:17 PM, Serge E. Hallyn wrote:
> Quoting Paul Moore (paul@paul-moore.com):
>> On Tue, Aug 7, 2012 at 5:58 PM, John Stultz <john.stultz@linaro.org> wrote:
>>> On 08/07/2012 02:50 PM, Paul Moore wrote:
>>>>
>>>> On Tue, Aug 7, 2012 at 2:12 PM, John Stultz <john.stultz@linaro.org>
>>>> wrote:
>>>>>
>>>>> Hi,
>>>>>      With my kvm environment using 3.6-rc1+, I'm seeing NULL pointer
>>>>> dereferences in selinux_ip_postroute_compat(). It looks like the sksec
>>>>> value
>>>>> is null and we die in the following line:
>>>>>
>>>>>      if (selinux_xfrm_postroute_last(sksec->sid, skb, &ad, proto))
>>>>>
>>>>> This triggers every time I shutdown the machine, but has also triggered
>>>>> randomly after a few hours.
>>>>>
>>>>> This is on an ubuntu 12.04 image, not using selinux.
>>>>
>>>> NOTE: Adding the SELinux list to the CC line
>>>
>>> Thanks!
>>>
>>>> Hi,
>>>>
>>>> I'm trying to understand this and I was hoping you could you clarify a
>>>> few things for me:
>>>>
>>>> * Is the panic in the Ubuntu 12.04 guest, or the host?  If the host,
>>>> could you share what distribution you are using?
>>>
>>> Sorry, its a 12.04 guest.  I think the host is Ubuntu 12.04 as well.
>>>
>>>
>>>> * When you say you are not using SELinux, could you be more specific?
>>>> It seems odd that you are not using SELinux but the panic is happening
>>>> in a SELinux hook.
>>>
>>> I just mean that, being Ubuntu,  the system (userland) isn't configured to
>>> use selinux.  SELinux is just enabled in the kernel config.
>>
>> Thanks for the quick response, I'll setup an Ubuntu guest and see if I
>> can reproduce this ... something is odd.  Anything non-standard about
>> your guest install or anything else you think might be helpful?
> 
> The problem seems to be that selinux_nf_ip_init() was called, which
> registers the selinux_ipv4_ops (and ipv6).  Those should not get registered
> if selinux ends up not being loaded (as in, if apparmor is loaded first),
> since as you've found here the selinux lsm hooks won't be called to set
> call selinux_sk_alloc_security().
> 
> I assume what's happening is that CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE was
> set to 1, but selinux ended up being set to disabled after the
> __initcall(selinux_nf_ip_init) ran?  Weird.
> 
Its not an Ubuntu kernel. The config has selinux set as the only LSM and
it is configured to be on by default

