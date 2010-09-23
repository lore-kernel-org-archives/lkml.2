Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab0IWQAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 12:00:47 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59139 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab0IWQAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 12:00:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: linux-kernel@vger.kernel.org
Cc: Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jamal <hadi@cyberus.ca>, Daniel Lezcano <daniel.lezcano@free.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        David Miller <davem@davemloft.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Ben Greear <greearb@candelatech.com>,
        Matt Helsley <matthltc@us.ibm.com>, Jonathan Corbet <corbet@lwn.net>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jan Engelhardt <jengelh@medozas.de>, Patrick McHardy <kaber@trash.net>
References: <m1ocborgq7.fsf@fess.ebiederm.org>
	<m17hicrglt.fsf@fess.ebiederm.org>
	<20100923112739.GD2211@hawkmoon.kerlabs.com>
Date: Thu, 23 Sep 2010 09:00:31 -0700
In-Reply-To: <20100923112739.GD2211@hawkmoon.kerlabs.com> (Louis Rilling's
	message of "Thu, 23 Sep 2010 13:27:39 +0200")
Message-ID: <m1pqw4h2lc.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;linux-kernel@vger.kernel.org
X-Spam-Relay-Country: 
Subject: Re: [PATCH 3/8] ns proc: Add support for the network namespace.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Louis Rilling <Louis.Rilling@kerlabs.com> writes:

> On 23/09/10  1:47 -0700, Eric W. Biederman wrote:
>> 
>> Implementing file descriptors for the network namespace is simple and
>> straight forward.
>> 
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>
> [...]
>
>> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
>> index c988e68..581a088 100644
>> --- a/net/core/net_namespace.c
>> +++ b/net/core/net_namespace.c
>> @@ -571,3 +571,33 @@ void unregister_pernet_device(struct pernet_operations *ops)
>>  	mutex_unlock(&net_mutex);
>>  }
>>  EXPORT_SYMBOL_GPL(unregister_pernet_device);
>> +
>> +#ifdef CONFIG_NET_NS
>> +static void *netns_get(struct task_struct *task)
>> +{
>> +	struct net *net;
>> +	rcu_read_lock();
>> +	net = get_net(task->nsproxy->net_ns);
>
> task could be exiting, so task->nsproxy could be NULL, right?
> Maybe make proc_ns_instantiate() rcu_dereference task->nsproxy, check for it
> being not NULL, and pass task->nsproxy to ns_ops->get()?

Ugh.  Thanks. fixed.

Somehow I forgot /proc shows zombies which means nsproxy
will definitely be NULL in those cases.  It is easy enough to handle
once my brain gets out of park.

I don't hold any locks at that point so I don't think I want to do
anything in proc_ns_instantiate() except handle a NULL return when
the ns_ops->get() fails.

> That could be an issue for the user namespace since it is not in nsproxy, but
> maybe no reasonable usage of ns_ops with user namespaces is
> envisioned.

It is also a issue for the pid namespace.  

> Otherwise, checking that task is alive with RCU locked in proc_ns_instantiate() should be enough to be
> rely on task->cred when calling ns_ops->get().

That sounds about right.  I keep conveniently forgetting the user
namespace.  It doesn't support unshare right now so there isn't anything
I can reasonably do with it at the moment.  It wouldn't surprise me if I
don't wind up handling the user namespace like the pid namespace, where
unsharing it changes the properties for the children and not the parent.
Bleh.

Eric
