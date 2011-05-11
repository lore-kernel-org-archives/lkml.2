Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab1EKTV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 15:21:57 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:50878 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab1EKTVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 15:21:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:from:to
	:cc:date:in-reply-to:references:content-type
	:content-transfer-encoding:message-id:mime-version; q=dns; s=
	sasl; b=T/Ejp0qpoBnwhCK3efRvx/YgKsR2xTaE1FP2RMJmmPzG6LV5y69hFD4Z
	Ld31NbsineiMPK2Xje01zX3PI7TzZxUp9YcLl3BVNLY7aA6xgWtpxDGSUKE7E2sk
	eDuKhEirWv+7ah3EG5g699wo3plqbMonC0rQFJgHcu7P49j2Cts=
Subject: Re: [PATCH 3/7] ns proc: Add support for the network namespace.
From: Nathan Lynch <ntl@pobox.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jamal <hadi@cyberus.ca>, Daniel Lezcano <daniel.lezcano@free.fr>,
        Linux Containers <containers@lists.osdl.org>,
        Renato Westphal <renatowestphal@gmail.com>
Date: Wed, 11 May 2011 14:21:34 -0500
In-Reply-To: <1304735101-1824-3-git-send-email-ebiederm@xmission.com>
References: <m1tyd7p7tq.fsf@fess.ebiederm.org>
 <1304735101-1824-1-git-send-email-ebiederm@xmission.com>
 <1304735101-1824-3-git-send-email-ebiederm@xmission.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1305141705.1236.49.camel@orca.stoopid.dyndns.org>
Mime-Version: 1.0
X-Pobox-Relay-ID: 3389159E-7C04-11E0-84BB-BBB7F5B2FB1A-04752483!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-06 at 19:24 -0700, Eric W. Biederman wrote:
> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
> index 3f86026..bf7707e 100644
> --- a/net/core/net_namespace.c
> +++ b/net/core/net_namespace.c
> @@ -573,3 +573,34 @@ void unregister_pernet_device(struct pernet_operations *ops)
>  	mutex_unlock(&net_mutex);
>  }
>  EXPORT_SYMBOL_GPL(unregister_pernet_device);
> +
> +#ifdef CONFIG_NET_NS
> +static void *netns_get(struct task_struct *task)
> +{
> +	struct net *net;
> +	rcu_read_lock();
> +	net = get_net(task->nsproxy->net_ns);

This should use task_nsproxy() and check the result before grabbing the
net_ns, but I think you fix that in a later patch.

Regardless, it looks as if all the proc_ns_ops->get() implementations
really just want the nsproxy, so maybe the get() methods should take
that instead of the task_struct, and proc_ns_instantiate() should do
something like:

struct nsproxy *nsproxy;
...

ei->ns_ops = ns_ops;
error = -ESRCH;
rcu_read_lock();
nsproxy = task_nsproxy(task);
rcu_read_unlock();
if (!nsproxy)
	got out;
ei->ns = ns_ops->get(nsproxy);


So then the zombie check is consolidated in one place instead of having
to do it in every get() method.



> +	rcu_read_unlock();
> +	return net;
> +}
> +
> +static void netns_put(void *ns)
> +{
> +	put_net(ns);
> +}
> +
> +static int netns_install(struct nsproxy *nsproxy, void *ns)
> +{
> +	put_net(nsproxy->net_ns);
> +	nsproxy->net_ns = get_net(ns);
> +	return 0;
> +}

This introduces a window where, potentially, nsproxy->net_ns is stale
before it is updated with the namespace which is being attached, no? 
(Same concern applies to other install methods in the patch set).  It
seems possible to oops the kernel in this window by looking up
/proc/$PID/ns/net while $PID is in the midst of setns().


