Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab2B0Qz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 11:55:28 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:44976 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004Ab2B0Qz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 11:55:28 -0500
Message-ID: <4F4BB570.60105@parallels.com>
Date: Mon, 27 Feb 2012 20:55:12 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Lightning/1.0b2 Thunderbird/3.1.19
MIME-Version: 1.0
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>, "neilb@suse.de" <neilb@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH v2 1/4] SUNRPC: release per-net clients lock before calling
 PipeFS dentries creation
References: <20120227154713.7941.17963.stgit@localhost6.localdomain6>	 <20120227155055.7941.18741.stgit@localhost6.localdomain6> <1330359695.5541.45.camel@lade.trondhjem.org>
In-Reply-To: <1330359695.5541.45.camel@lade.trondhjem.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

27.02.2012 20:21, Myklebust, Trond пишет:
> On Mon, 2012-02-27 at 19:50 +0400, Stanislav Kinsbursky wrote:
>> Lockdep is sad otherwise, because inode mutex is taken on PipeFS dentry
>> creation, which can be called on mount notification, where this per-net client
>> lock is taken on clients list walk.
>>
>> Signed-off-by: Stanislav Kinsbursky<skinsbursky@parallels.com>
>>
>> ---
>>   net/sunrpc/clnt.c |   10 +++++++---
>>   1 files changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
>> index bb7ed2f3..ddb5741 100644
>> --- a/net/sunrpc/clnt.c
>> +++ b/net/sunrpc/clnt.c
>> @@ -84,7 +84,7 @@ static void rpc_register_client(struct rpc_clnt *clnt)
>>   	struct sunrpc_net *sn = net_generic(clnt->cl_xprt->xprt_net, sunrpc_net_id);
>>
>>   	spin_lock(&sn->rpc_client_lock);
>> -	list_add(&clnt->cl_clients,&sn->all_clients);
>> +	list_add_tail(&clnt->cl_clients,&sn->all_clients);
>>   	spin_unlock(&sn->rpc_client_lock);
>>   }
>>
>> @@ -208,15 +208,19 @@ static int rpc_pipefs_event(struct notifier_block *nb, unsigned long event,
>>   			    void *ptr)
>>   {
>>   	struct super_block *sb = ptr;
>> -	struct rpc_clnt *clnt;
>> +	struct rpc_clnt *clnt, *tmp;
>>   	int error = 0;
>>   	struct sunrpc_net *sn = net_generic(sb->s_fs_info, sunrpc_net_id);
>>
>>   	spin_lock(&sn->rpc_client_lock);
>> -	list_for_each_entry(clnt,&sn->all_clients, cl_clients) {
>> +	list_for_each_entry_safe(clnt, tmp,&sn->all_clients, cl_clients) {
>> +		atomic_inc(&clnt->cl_count);
>> +		spin_unlock(&sn->rpc_client_lock);
>>   		error = __rpc_pipefs_event(clnt, event, sb);
>> +		rpc_release_client(clnt);
>>   		if (error)
>>   			break;
>> +		spin_lock(&sn->rpc_client_lock);
>>   	}
>>   	spin_unlock(&sn->rpc_client_lock);
>>   	return error;
>>
>
> This won't be safe. Nothing guarantees that 'tmp' remains valid after
> you drop the spin_lock.
>
> I think you rather need to add a check for whether clnt->cl_dentry is in
> the right state (NULL if RPC_PIPEFS_UMOUNT or non-NULL if
> RPC_PIPEFS_MOUNT) before deciding whether or not to atomic_inc() and
> drop the lock, so that you can restart the loop after calling
> __rpc_pipefs_event().
>

Gmmm.
Please, correct me, if I'm wrong, that you are proposing something like this:

   	spin_lock(&sn->rpc_client_lock);
again:
	list_for_each_entry(clnt,&sn->all_clients, cl_clients) {
		if ((event == RPC_PIPEFS_MOUNT) && clnt->cl_dentry) ||
		    (event == RPC_PIPEFS_UMOUNT) && !clnt->cl_dentry))
			continue;
		atomic_inc(&clnt->cl_count);
		spin_unlock(&sn->rpc_client_lock);
    		error = __rpc_pipefs_event(clnt, event, sb);
		rpc_release_client(clnt);
		spin_lock(&sn->rpc_client_lock);
    		if (error)
    			break;
		goto again;
    	}
    	spin_unlock(&sn->rpc_client_lock);


-- 
Best regards,
Stanislav Kinsbursky
