Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab1K2SMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 13:12:41 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:25394 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192Ab1K2SMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 13:12:40 -0500
Message-ID: <4ED52083.8090605@parallels.com>
Date: Tue, 29 Nov 2011 22:12:19 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH] sysctl: Add the kernel.ns_last_pid control
References: <4ED3A6F5.6070606@parallels.com> <20111129174741.GA32209@redhat.com>
In-Reply-To: <20111129174741.GA32209@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2011 09:47 PM, Oleg Nesterov wrote:
> On 11/28, Pavel Emelyanov wrote:
>>
>> --- a/kernel/pid_namespace.c
>> +++ b/kernel/pid_namespace.c
>> @@ -191,9 +191,40 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
>>  	return;
>>  }
>>
>> +static int pid_ns_ctl_handler(struct ctl_table *table, int write,
>> +		void __user *buffer, size_t *lenp, loff_t *ppos)
>> +{
>> +	struct ctl_table tmp = *table;
>> +
>> +	if (write && !capable(CAP_SYS_ADMIN))
>> +		return -EPERM;
>> +
>> +	/*
>> +	 * Writing directly to ns' last_pid field is OK, since this field
>> +	 * is volatile in a living namespace anyway and a code writing to
>> +	 * it should synchronize its usage with external means.
>> +	 */
>> +
>> +	tmp.data = &current->nsproxy->pid_ns->last_pid;
>> +	return proc_dointvec(&tmp, write, buffer, lenp, ppos);
>> +}
>> +
>> +static struct ctl_table pid_ns_ctl_table[] = {
>> +	{
>> +		.procname = "ns_last_pid",
>> +		.maxlen = sizeof(int),
>> +		.mode = 0666, /* permissions are checked in the handler */
>> +		.proc_handler = pid_ns_ctl_handler,
>> +	},
>> +	{ }
>> +};
>> +
>> +static struct ctl_path kern_path[] = { { .procname = "kernel", }, { } };
>> +
>>  static __init int pid_namespaces_init(void)
>>  {
>>  	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC);
>> +	register_sysctl_paths(kern_path, pid_ns_ctl_table);
>>  	return 0;
>>  }
> 
> Hmm. This way it depends on CONFIG_PID_NS.

Yes, since this _is_ for namespaces. As we've found out this is close to completely
unusable in the initial namespace in which tasks are just forking without caring
much about what CAP_SYS_ADMIN-s think about this.

> Can't we simply add an entry into kern_table[] ?

And store the .proc_handler function dealing with somewhat which is pid namespace
specific in the same generic file?

> And without ns_, just /proc/sys/kernel/last_pid.

But that's the namespace's last pid, not just some system-wide last pid.

> Oleg.
> 
> .
> 

