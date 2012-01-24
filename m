Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab2AXIix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 03:38:53 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:34322 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab2AXIiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 03:38:51 -0500
Message-ID: <4F1E6E09.9060509@parallels.com>
Date: Tue, 24 Jan 2012 12:38:33 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (nfs
 tree related)
References: <20120123135942.3e991094b91d9087d2ba81ae@canb.auug.org.au> <1327342224.2628.3.camel@lade.trondhjem.org>
In-Reply-To: <1327342224.2628.3.camel@lade.trondhjem.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

23.01.2012 22:10, Trond Myklebust пишет:
> On Mon, 2012-01-23 at 13:59 +1100, Stephen Rothwell wrote:
>> Hi all,
>>
>> After merging the final tree, today's linux-next build (powerpc
>> ppc44x_defconfig) failed like this:
>>
>> net/sunrpc/svcsock.c: In function 'svc_setup_socket':
>> net/sunrpc/svcsock.c:1412:40: error: 'struct sock_common' has no member named 'skc_net'
>>
>> This build has CONFIG_NET_NS unset.
>>
>> Caused by commit eff9c3383687 ("SUNRPC: pass network namespace to service
>> registering routines").
>>
>> I applied this (suboptimal) patch for today:
>>
>> From: Stephen Rothwell<sfr@canb.auug.org.au>
>> Date: Mon, 23 Jan 2012 13:55:01 +1100
>> Subject: [PATCH] SUNRPC: fixup for namespace changes
>>
>> Fixes this build error when CONFIG_NET_NS is not set:
>>
>> net/sunrpc/svcsock.c: In function 'svc_setup_socket':
>> net/sunrpc/svcsock.c:1412:40: error: 'struct sock_common' has no member named 'skc_net'
>>
>> Signed-off-by: Stephen Rothwell<sfr@canb.auug.org.au>
>> ---
>>   net/sunrpc/svcsock.c |    9 ++++++++-
>>   1 files changed, 8 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
>> index e8af0c9..4d02d1a 100644
>> --- a/net/sunrpc/svcsock.c
>> +++ b/net/sunrpc/svcsock.c
>> @@ -41,6 +41,7 @@
>>   #include<net/ipv6.h>
>>   #include<net/tcp.h>
>>   #include<net/tcp_states.h>
>> +#include<net/net_namespace.h>
>>   #include<asm/uaccess.h>
>>   #include<asm/ioctls.h>
>>
>> @@ -1409,7 +1410,13 @@ static struct svc_sock *svc_setup_socket(struct svc_serv *serv,
>>
>>   	/* Register socket with portmapper */
>>   	if (*errp>= 0&&  pmap_register)
>> -		*errp = svc_register(serv, sock->sk->sk_net, inet->sk_family,
>> +		*errp = svc_register(serv,
>> +#ifdef CONFIG_NET_NS
>> +				     sock->sk->sk_net,
>> +#else
>> +				&init_net,
>> +#endif
>> +				     inet->sk_family,
>>   				     inet->sk_protocol,
>>   				     ntohs(inet_sk(inet)->inet_sport));
>>
>> --
>> 1.7.9.rc0.23.g7e521
>
> Stanislav,
>
> Shouldn't we just be using a 'sock_net(sock->sk)'?
>

Yes, you right, Trond.
Should I fix it with a new patch?

-- 
Best regards,
Stanislav Kinsbursky
