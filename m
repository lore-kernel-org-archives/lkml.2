Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab0EET4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 15:56:53 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:42436 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab0EET4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 15:56:50 -0400
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>
References: <m1fx3hk6gw.fsf@fess.ebiederm.org>
	<1273019809-16472-2-git-send-email-ebiederm@xmission.com>
	<20100505151746.GA15654@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 05 May 2010 12:56:41 -0700
In-Reply-To: <20100505151746.GA15654@us.ibm.com> (Serge E. Hallyn's message of "Wed\, 5 May 2010 10\:17\:46 -0500")
Message-ID: <m14oim2kcm.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: serue@us.ibm.com, davem@davemloft.net, netdev@vger.kernel.org, bcrl@lhnet.ca, eric.dumazet@gmail.com, cornelia.huck@de.ibm.com, tj@kernel.org, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, gregkh@suse.de
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serue@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 2/6] netns: Teach network device kobjects which namespace they are in.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> diff --git a/net/Kconfig b/net/Kconfig
>> index 041c35e..265e33b 100644
>> --- a/net/Kconfig
>> +++ b/net/Kconfig
>> @@ -45,6 +45,14 @@ config COMPAT_NETLINK_MESSAGES
>> 
>>  menu "Networking options"
>> 
>> +config NET_NS
>> +	bool "Network namespace support"
>> +	default n
>> +	depends on EXPERIMENTAL && NAMESPACES
>> +	help
>> +	  Allow user space to create what appear to be multiple instances
>> +	  of the network stack.
>> +
>
> Hi Eric,
>
> I'm confused - NET_NS is defined in init/Kconfig right now.  Is the tree
> you're working from very different from mine, or is this the unfortunate
> rekult of the patches sitting so long?

Old patches, nothing that complains when you make a mistake like this,
and apparently I have a blind spot in my personal code review.

At one point it was not possible to enable the network namespace until
the sysfs stuff was enabled, but things have been going on long enough
that we worked around that restriction.

>>  source "net/packet/Kconfig"
>>  source "net/unix/Kconfig"
>>  source "net/xfrm/Kconfig"
>> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
>> index 099c753..1b98e36 100644
>> --- a/net/core/net-sysfs.c
>> +++ b/net/core/net-sysfs.c
>> @@ -13,7 +13,9 @@
>>  #include <linux/kernel.h>
>>  #include <linux/netdevice.h>
>>  #include <linux/if_arp.h>
>> +#include <linux/nsproxy.h>
>>  #include <net/sock.h>
>> +#include <net/net_namespace.h>
>>  #include <linux/rtnetlink.h>
>>  #include <linux/wireless.h>
>>  #include <net/wext.h>
>> @@ -466,6 +468,37 @@ static struct attribute_group wireless_group = {
>>  };
>>  #endif
>> 
>> +static const void *net_current_ns(void)
>> +{
>> +	return current->nsproxy->net_ns;
>> +}
>> +
>> +static const void *net_initial_ns(void)
>> +{
>> +	return &init_net;
>> +}
>> +
>> +static const void *net_netlink_ns(struct sock *sk)
>> +{
>> +	return sock_net(sk);
>> +}
>> +
>> +static struct kobj_ns_type_operations net_ns_type_operations = {
>> +	.type = KOBJ_NS_TYPE_NET,
>> +	.current_ns = net_current_ns,
>> +	.netlink_ns = net_netlink_ns,
>> +	.initial_ns = net_initial_ns,
>> +};
>> +
>> +static void net_kobj_ns_exit(struct net *net)
>> +{
>> +	kobj_ns_exit(KOBJ_NS_TYPE_NET, net);
>> +}
>> +
>> +static struct pernet_operations sysfs_net_ops = {
>> +	.exit = net_kobj_ns_exit,
>> +};
>> +
>>  #endif /* CONFIG_SYSFS */
>
> ...
>
>>  int netdev_kobject_init(void)
>>  {
>> +	kobj_ns_type_register(&net_ns_type_operations);
>> +#ifdef CONFIG_SYSFS
>> +	register_pernet_subsys(&sysfs_net_ops);
>> +#endif
>>  	return class_register(&net_class);
>
> I think the kobj_ns_type_register() needs to be under
> ifdef CONFIG_SYSFS as well, bc net_ns_type_operations is defined
> under ifdef CONFIG_SYSFS.

kobj_ns_type_register should not be under CONFIG_SYSFS.  Which means
that kobj_ns_type_operations needs not to be under CONFIG_SYSFS as
well.  That you for spotting that bug.

Grr.

Eric
