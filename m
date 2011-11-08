Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280Ab1KHUTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 15:19:39 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:40009 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753400Ab1KHUTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 15:19:37 -0500
X-IronPort-AV: E=Sophos;i="4.69,478,1315173600"; 
   d="scan'208";a="129256651"
Date: Tue, 8 Nov 2011 21:19:30 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Julia Lawall <julia@diku.dk>, "J. Bruce Fields" <bfields@fieldses.org>,
        kernel-janitors@vger.kernel.org, Neil Brown <neilb@suse.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        "David S. Miller" <davem@davemloft.net>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] net/sunrpc: use kstrtoul, etc
In-Reply-To: <20111108193817.GA3453@p183.telecom.by>
Message-ID: <alpine.DEB.2.02.1111082113380.1880@hadrien>
References: <1320586010-21931-1-git-send-email-julia@diku.dk> <1320586010-21931-3-git-send-email-julia@diku.dk> <20111108193817.GA3453@p183.telecom.by>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Nov 2011, Alexey Dobriyan wrote:

> On Sun, Nov 06, 2011 at 02:26:47PM +0100, Julia Lawall wrote:
>> @@
>> expression a,b;
>> {int,long} *c;
>> @@
>>
>> -strict_strtoul
>> +kstrtoul
>
> No, no, no!

Sorry, this was not the real rule I used for the strtoul case.  Instead I 
used the following:

@@
typedef ulong;
expression a,b;
{ulong,unsigned long,unsigned int,size_t} *c;
@@

-strict_strtoul
+kstrtoul
  (a,b,c)

But now I have seen that there is a separate function for integers, so I 
have made a rule to use that function when the type is unsigned int.

> In every case see the type or real data and use appropriate function.
> kstrtou8() for ports.

The type of the destination variable in all of these cases is unsigned 
long.  But maybe that is not enough information to make the 
transformation in the right way.

julia

> This program creates lots of bogus patches in this case.
>
>> --- a/net/sunrpc/addr.c
>> +++ b/net/sunrpc/addr.c
>> @@ -322,7 +322,7 @@ size_t rpc_uaddr2sockaddr(const char *ua
>>  	c = strrchr(buf, '.');
>>  	if (unlikely(c == NULL))
>>  		return 0;
>> -	if (unlikely(strict_strtoul(c + 1, 10, &portlo) != 0))
>> +	if (unlikely(kstrtoul(c + 1, 10, &portlo) != 0))
>>  		return 0;
>>  	if (unlikely(portlo > 255))
>>  		return 0;
>> @@ -331,7 +331,7 @@ size_t rpc_uaddr2sockaddr(const char *ua
>>  	c = strrchr(buf, '.');
>>  	if (unlikely(c == NULL))
>>  		return 0;
>> -	if (unlikely(strict_strtoul(c + 1, 10, &porthi) != 0))
>> +	if (unlikely(kstrtoul(c + 1, 10, &porthi) != 0))
>>  		return 0;
>>  	if (unlikely(porthi > 255))
>>  		return 0;
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
