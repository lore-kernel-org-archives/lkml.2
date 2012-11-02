Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab2KBHdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 03:33:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3499 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab2KBHda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 03:33:30 -0400
X-IronPort-AV: E=Sophos;i="4.80,698,1344182400"; 
   d="scan'208";a="6123662"
Message-ID: <5093773B.5010706@cn.fujitsu.com>
Date: Fri, 02 Nov 2012 15:33:15 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH] namespace:unmount pid_namespace's proc_mnt when copy_net_ns
 failed
References: <1351816703-8805-1-git-send-email-gaofeng@cn.fujitsu.com> <87ehkcij1a.fsf@xmission.com>
In-Reply-To: <87ehkcij1a.fsf@xmission.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/02 15:32:40,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/02 15:32:41
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年11月02日 15:02, Eric W. Biederman 写道:
> Gao feng <gaofeng@cn.fujitsu.com> writes:
> 
>> we should call pid_ns_release_proc to unmount pid_namespace's
>> proc_mnt when copy_net_ns failed in function create_new_namespaces.
>>
>> otherwise,the proc_mnt will not be freed and because the super_block
>> of proc_mnt also add the reference of the pid_namespace,so this
>> pid_namespace will never be released too.
> 
> Ouch!
> 
> Have you encountered this failure in practice or is this just from
> review?

I add some printk in pid_ns_release_proc,it's not called in above case.
when copy_net_ns failed,this pid_namespace is not used by any task,
so proc_flush_task can't call pid_ns_release_proc to umount this pidns->proc_mnt.
it's the only chance we can unmount this pindns->proc_mnt.

With this patch,everything runs well.

Thanks
Gao

> 
> I'm trying to gauge the severity of this leak.
> 
> Eric
> 
> 
>> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
>> ---
>>  kernel/nsproxy.c |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
>> index b576f7f..d536480 100644
>> --- a/kernel/nsproxy.c
>> +++ b/kernel/nsproxy.c
>> @@ -99,8 +99,11 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
>>  	return new_nsp;
>>  
>>  out_net:
>> -	if (new_nsp->pid_ns)
>> +	if (new_nsp->pid_ns) {
>> +		if (flags & CLONE_NEWPID)
>> +			pid_ns_release_proc(new_nsp->pid_ns);
>>  		put_pid_ns(new_nsp->pid_ns);
>> +	}
>>  out_pid:
>>  	if (new_nsp->ipc_ns)
>>  		put_ipc_ns(new_nsp->ipc_ns);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

