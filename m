Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030593Ab2HHT3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 15:29:47 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33464 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab2HHT3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 15:29:45 -0400
Subject: Re: NULL pointer dereference in selinux_ip_postroute_compat
From: Eric Dumazet <eric.dumazet@gmail.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Paul Moore <paul@paul-moore.com>,
        lkml <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov,
        Eric Dumazet <edumazet@google.com>, john.johansen@canonical.com
In-Reply-To: <5022BAA2.90606@us.ibm.com>
References: <50215A7E.8000701@linaro.org>
	 <CAHC9VhTSS8+-OcX9uK0xqnYC3-y0axVGs1m+kuC6+M6HvmSmgg@mail.gmail.com>
	 <50218F7E.1060004@linaro.org>
	 <CAHC9VhTd-d9NgWoU6_o9qw0bq4ZbuTEj8E_jRYyDXPWQaLLdog@mail.gmail.com>
	 <20120807221731.GA25441@mail.hallyn.com> <502198B4.8040503@linaro.org>
	 <5022BAA2.90606@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Aug 2012 21:29:40 +0200
Message-ID: <1344454180.28967.231.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-08 at 12:14 -0700, John Stultz wrote:
> On 08/07/2012 03:37 PM, John Stultz wrote:
> > On 08/07/2012 03:17 PM, Serge E. Hallyn wrote:
> >> Quoting Paul Moore (paul@paul-moore.com):
> >>> On Tue, Aug 7, 2012 at 5:58 PM, John Stultz <john.stultz@linaro.org> 
> >>> wrote:
> >>>> On 08/07/2012 02:50 PM, Paul Moore wrote:
> >>>>> On Tue, Aug 7, 2012 at 2:12 PM, John Stultz <john.stultz@linaro.org>
> >>>>> wrote:
> >>>>>> Hi,
> >>>>>>       With my kvm environment using 3.6-rc1+, I'm seeing NULL 
> >>>>>> pointer
> >>>>>> dereferences in selinux_ip_postroute_compat(). It looks like the 
> >>>>>> sksec
> >>>>>> value
> >>>>>> is null and we die in the following line:
> >>>>>>
> >>>>>>       if (selinux_xfrm_postroute_last(sksec->sid, skb, &ad, proto))
> >>>>>>
> >>>>>> This triggers every time I shutdown the machine, but has also 
> >>>>>> triggered
> >>>>>> randomly after a few hours.
> [snip]
> >> The problem seems to be that selinux_nf_ip_init() was called, which
> >> registers the selinux_ipv4_ops (and ipv6).  Those should not get 
> >> registered
> >> if selinux ends up not being loaded (as in, if apparmor is loaded 
> >> first),
> >> since as you've found here the selinux lsm hooks won't be called to set
> >> call selinux_sk_alloc_security().
> > This sounds about right:
> > root@testvm:~# dmesg | grep SELinux
> > [    0.004578] SELinux:  Initializing.
> > [    0.005704] SELinux:  Starting in permissive mode
> > [    2.235034] SELinux:  Registering netfilter hooks
> >
> >> I assume what's happening is that 
> >> CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE was
> >> set to 1, but selinux ended up being set to disabled after the
> >> __initcall(selinux_nf_ip_init) ran?  Weird.
> > This looks right as well:
> >
> > # zcat config.gz | grep SELINUX
> > CONFIG_SECURITY_SELINUX=y
> > CONFIG_SECURITY_SELINUX_BOOTPARAM=y
> > CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
> > CONFIG_SECURITY_SELINUX_DISABLE=y
> > CONFIG_SECURITY_SELINUX_DEVELOP=y
> > CONFIG_SECURITY_SELINUX_AVC_STATS=y
> > CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
> > # CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
> > CONFIG_DEFAULT_SECURITY_SELINUX=y
> >
> >
> > Since the problem isn't completely obvious, I'm starting a bisection 
> > to narrow this down some more.
> 
> So I bisected this down and it seems to be the following commit:
> 
> commit be9f4a44e7d41cee50ddb5f038fc2391cbbb4046
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Thu Jul 19 07:34:03 2012 +0000
> 
>      ipv4: tcp: remove per net tcp_sock
> 
> 
> It doesn't revert totally cleanly, but after fixing up the rejections 
> and booting with this patch removed on top of Linus' head the oops on 
> shutdown goes away.

Thanks for doing this.

So sk_security is NULL and selinux crashes on it.

I guess I need to call security_sk_alloc().



