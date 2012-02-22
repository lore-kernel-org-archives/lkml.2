Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab2BVVw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 16:52:26 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50774 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754823Ab2BVVwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 16:52:24 -0500
Message-ID: <4F45638B.30305@fb.com>
Date: Wed, 22 Feb 2012 13:52:11 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Julian Anastasov <ja@ssi.bg>
CC: <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: route add default fails with ESRCH?
References: <4F3F0158.2020406@fb.com> <4F4541E5.5040700@fb.com> <alpine.LFD.2.00.1202222319150.1603@ja.ssi.bg>
In-Reply-To: <alpine.LFD.2.00.1202222319150.1603@ja.ssi.bg>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7361,1.0.260,0.0.0000
 definitions=2012-02-22_06:2012-02-21,2012-02-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/12 1:27 PM, Julian Anastasov wrote:

> 	Why the subnet is deleted from table main (254) in
> the same second ?

The machine was in single user mode. All I did was execute

# service network start

dhclient is the only user process I see running on the system.

>
> 	First default route is removed:
>
> [   44.351839] Deleting 00000000/0 tos=0 t=ffff880212b846a0
> [   44.351843] entering trie_leaf_remove(ffff880213d120e0)
> [   44.351846] In tnode_resize ffff880213d0a5a0 inflate_threshold=50
> threshold=25
>
> 	Then link route 10.47.46.0/24:
>
> [   44.351852] Deleting 0a2f2e00/24 tos=0 t=ffff880212b846a0
> [   44.351855] entering trie_leaf_remove(ffff880211585150)
>
> 	Insert tries to find if GW 10.47.46.1 is reachable,
> there must be 10.47.46.0/24 in table main but it was
> deleted just before adding the IP.
>
> [   69.189627] Insert table=254 00000000/0
>

All of this was done by my network startup scripts. These scripts should 
be fairly standard and used by lots of other people. The only thing 
that's special about my setup is:

# grep LINKDELAY /etc/sysconfig/network
LINKDELAY=20

Without this my eth0 driver complains about link not being ready.

>> # cat /proc/net/fib_trie
>
> 	Where is "Main:" here?

I think answering this is key.

This is the main difference between systems that work and the ones that 
don't. Systems that work have a non-empty Main table:

# cat /proc/net/fib_trie
Main:
   +-- 0.0.0.0/0 4 3 10
      +-- 0.0.0.0/4 1 0 0
         |-- 0.0.0.0
            /0 universe THROW

I'll try to figure out why my RT_TABLE_MAIN was empty after my network 
startup scripts finished. But given my experience with 2.6.38, fib_hash 
handled this case just fine and fib_trie broke it :(

  -Arun
