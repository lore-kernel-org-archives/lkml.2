Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476Ab2EVP3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:29:41 -0400
Received: from relay.parallels.com ([195.214.232.42]:44181 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab2EVP3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:29:39 -0400
Message-ID: <4FBBB0DB.6050708@parallels.com>
Date: Tue, 22 May 2012 19:29:31 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH] NFS: init client before declaration
References: <20120522124018.338.20817.stgit@localhost.localdomain>  <1337696984.4269.4.camel@lade.trondhjem.org> <1337698816.4269.15.camel@lade.trondhjem.org>
In-Reply-To: <1337698816.4269.15.camel@lade.trondhjem.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.05.2012 19:00, Myklebust, Trond wrote:
> On Tue, 2012-05-22 at 10:29 -0400, Trond Myklebust wrote:
>> On Tue, 2012-05-22 at 16:40 +0400, Stanislav Kinsbursky wrote:
>>> Client have to be initialized prior to adding it to per-net clients list,
>>> because otherwise there are races, shown below:
>>>
>>> CPU#0					CPU#1
>>> _____					_____
>>>
>>> nfs_get_client
>>> nfs_alloc_client
>>> list_add(..., nfs_client_list)
>>> 					rpc_fill_super
>>> 					rpc_pipefs_event
>>> 					nfs_get_client_for_event
>>> 					__rpc_pipefs_event
>>> 					(clp->cl_rpcclient is uninitialized)
>>> 					BUG()
>>> init_client
>>> clp->cl_rpcclient = ...
>>>
>>
>> Why not simply change nfs_get_client_for_event() so that it doesn't
>> touch nfs_clients that have clp->cl_cons_state!=NFS_CS_READY?
>>
>> That should ensure that it doesn't touch nfs_clients that failed to
>> initialise and/or are still in the process of being initialised.
>
> ...actually, come to think of it. Why not just add a helper function
> "bool nfs_client_active(const struct nfs_client *clp)" to
> fs/nfs/client.c that does a call to
> 	wait_event_killable(nfs_client_active_wq, clp->cl_cons_state<  NFS_CS_INITING);
> and checks the resulting value of clp->cl_cons_state?
>

Sorry, but I don't understand the idea...
Where are you proposing to call this function?
In __rpc_pipefs_event() prior to dentries creatios?


-- 
Best regards,
Stanislav Kinsbursky
