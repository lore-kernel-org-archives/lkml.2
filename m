Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab1EKVeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:34:46 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:33957 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab1EKVeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:34:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nathan Lynch <ntl@pobox.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jamal <hadi@cyberus.ca>, Daniel Lezcano <daniel.lezcano@free.fr>,
        Linux Containers <containers@lists.osdl.org>,
        Renato Westphal <renatowestphal@gmail.com>
Subject: Re: [PATCH 3/7] ns proc: Add support for the network namespace.
References: <m1tyd7p7tq.fsf@fess.ebiederm.org>
	<1304735101-1824-1-git-send-email-ebiederm@xmission.com>
	<1304735101-1824-3-git-send-email-ebiederm@xmission.com>
	<1305141705.1236.49.camel@orca.stoopid.dyndns.org>
Date: Wed, 11 May 2011 14:34:37 -0700
In-Reply-To: <1305141705.1236.49.camel@orca.stoopid.dyndns.org> (Nathan
	Lynch's message of "Wed, 11 May 2011 14:21:34 -0500")
Message-ID: <m139kkncpe.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19iuZ24CnBwiuXpEgubd8b42JcB6+cPeZ4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Lynch <ntl@pobox.com> writes:

> On Fri, 2011-05-06 at 19:24 -0700, Eric W. Biederman wrote:
>> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
>> index 3f86026..bf7707e 100644
>> --- a/net/core/net_namespace.c
>> +++ b/net/core/net_namespace.c
>> @@ -573,3 +573,34 @@ void unregister_pernet_device(struct pernet_operations *ops)
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
> This should use task_nsproxy() and check the result before grabbing the
> net_ns, but I think you fix that in a later patch.
>
> Regardless, it looks as if all the proc_ns_ops->get() implementations
> really just want the nsproxy, so maybe the get() methods should take
> that instead of the task_struct, and proc_ns_instantiate() should do
> something like:
>
> struct nsproxy *nsproxy;
> ...
>
> ei->ns_ops = ns_ops;
> error = -ESRCH;
> rcu_read_lock();
> nsproxy = task_nsproxy(task);
> rcu_read_unlock();
> if (!nsproxy)
> 	got out;
> ei->ns = ns_ops->get(nsproxy);
>
>
> So then the zombie check is consolidated in one place instead of having
> to do it in every get() method.

For the pid namespace at least I want the task not the nsproxy,
so I can use task_active_pid_namespace().

I admit that is a little asymmetrical with the install, but at
least until the details of getting the pid namespace working in
this context are worked out I don't want to reconsider the
current design.

There is also the user namespace that does not even exist in
nsproxy to consider.  I will worry about that namespace when
it happens.

Ultimately nsproxy is an space/time optimization that not all
namespaces use so forcing it in the design is probably not
what we want.

>> +	rcu_read_unlock();
>> +	return net;
>> +}
>> +
>> +static void netns_put(void *ns)
>> +{
>> +	put_net(ns);
>> +}
>> +
>> +static int netns_install(struct nsproxy *nsproxy, void *ns)
>> +{
>> +	put_net(nsproxy->net_ns);
>> +	nsproxy->net_ns = get_net(ns);
>> +	return 0;
>> +}
>
> This introduces a window where, potentially, nsproxy->net_ns is stale
> before it is updated with the namespace which is being attached, no? 
> (Same concern applies to other install methods in the patch set).  It
> seems possible to oops the kernel in this window by looking up
> /proc/$PID/ns/net while $PID is in the midst of setns().

Except the nsproxy being referred to is a brand new nsproxy, with an
extra reference count on every namespace.  current->nsproxy still
contains the reference counts of the current process.

Eric

