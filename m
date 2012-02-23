Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab2BWB0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 20:26:41 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49133 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978Ab2BWB0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 20:26:40 -0500
Message-ID: <4F4595C2.8000809@fb.com>
Date: Wed, 22 Feb 2012 17:26:26 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <ja@ssi.bg>, <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <shemminger@vyatta.com>
Subject: Re: route add default fails with ESRCH?
References: <alpine.LFD.2.00.1202222319150.1603@ja.ssi.bg> <4F45638B.30305@fb.com> <4F45742F.1070605@fb.com> <20120222.185625.1452176745900047968.davem@davemloft.net>
In-Reply-To: <20120222.185625.1452176745900047968.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-02-22_06:2012-02-21,2012-02-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/12 3:56 PM, David Miller wrote:
>
> It breaks because that script sequence quoted above depends upon the
> order in which the routes are listed.  Since fib_hash and fib_trie use
> different datastructures, the order in which route entries are dumped
> will not be the same and this is completely unavoidable.

Here's a minimal repro case:

# ip route flush default
# route add default gw 192.168.143.2
SIOCADDRT: No such process

This fails for me on both 2.6.38 and 3.2.

I think the dependency we have is the actual format of the default route 
entry:

fib_hash:

# ip route
<bunch of routes>
throw default

fib_trie:

# ip route
default via 192.168.143.2 dev eth0  proto static
<bunch of routes>

when the output was piped to awk '{ print $1 }' we ended up deleting the 
default route for fib_trie case, but not the fib_hash case.

I'll just fix up our scripts. Thanks for looking into it.

  -Arun

