Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab1DHPIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 11:08:53 -0400
Received: from mx2.parallels.com ([64.131.90.16]:36506 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757438Ab1DHPIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 11:08:51 -0400
Message-ID: <4D9F24F2.9020603@parallels.com>
Date: Fri, 8 Apr 2011 10:08:34 -0500
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: <linux-kernel@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
        <containers@lists.linux-foundation.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Tim Spriggs <tims@uahirise.org>, Kir Kolyshkin <kir@parallels.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH 3/3] Compare namespaces when comparing addresses in auth_unix
 cache.
References: <4D9431B3.2070305@parallels.com> <20110405034641.GC6764@hallyn.com>
In-Reply-To: <20110405034641.GC6764@hallyn.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [208.54.86.208]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2011 10:46 PM, Serge E. Hallyn wrote:
> Quoting Rob Landley (rlandley@parallels.com):
>> From: Rob Landley <rlandley@parallels.com>
>>
>> The auth_unix cache needs to check network namespace when comparing
>> addresses. Add field to struct ip_map and extra argument to
>> __ip_map_lookup() so it has the information to do so, and add test.
>>
>> Signed-off-by: Rob Landley <rlandley@parallels.com>
>> ---
>>
>>  net/sunrpc/svcauth_unix.c |   21 ++++++++++++++-------
>>  1 file changed, 14 insertions(+), 7 deletions(-)
>>
>> diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
>> index 30916b0..63a2fa7 100644
>> --- a/net/sunrpc/svcauth_unix.c
>> +++ b/net/sunrpc/svcauth_unix.c

code code code

>> @@ -142,6 +145,7 @@ static void ip_map_init(struct cache_head *cnew, struct cache_head *citem)
>>  	struct ip_map *item = container_of(citem, struct ip_map, h);
>>  
>>  	strcpy(new->m_class, item->m_class);
>> +	new->m_net = item->m_net;
> 
> Does this need to take a reference?  Or is there no way for an
> entry to outlive its netns?  It sort of looks like
> svcauth_unix_info_release will ensure that doesn't happen, but
> I'm not convinced because other parts of the kernel can get
> to ip_map_init through the struct cache_detail.

When I wrote this I thought the transport's get_net() and put_net()
would pin it, but after re-reading, the sunrpc code is disgustingly
convoluted enough that I can't easily reconstruct my earlier reasoning.
 I'll add a get_net() and put_net() just to not have to worry about it.

Thanks,

Rob
