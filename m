Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab1FHFOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 01:14:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50883 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab1FHFOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 01:14:06 -0400
Message-ID: <4DEF0597.9030101@cn.fujitsu.com>
Date: Wed, 08 Jun 2011 13:16:07 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/15] KVM: optimize for MMIO handled
References: <4DEE205E.8000601@cn.fujitsu.com>	<20110608121128.2caecdb3.yoshikawa.takuya@oss.ntt.co.jp>	<4DEEEBB6.5090805@cn.fujitsu.com>	<4DEEED3C.3070302@cn.fujitsu.com> <20110608124740.14c807f7.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20110608124740.14c807f7.yoshikawa.takuya@oss.ntt.co.jp>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-08 13:13:51,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-08 13:13:52,
	Serialize complete at 2011-06-08 13:13:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2011 11:47 AM, Takuya Yoshikawa wrote:

>>> Sure, KVM guest is the client, and it uses e1000 NIC, and uses NAT
>>> network connect to the netperf server, the bandwidth of our network
>>> is 100M.
>>>
> 
> I see the reason, thank you!
> 
> I used virtio-net and you used e1000.
> You are using e1000 to see the MMIO performance change, right?
> 

Hi Takuya,

Please applied my fix path when you test it again, thanks! :-)
(http://www.spinics.net/lists/kvm/msg56017.html)

Just then, in order to affirm the performance result, i tested it again,
and do not use our office network(since such many boxes in this network),
just boot two guests, one runs netperf server, one runs netperf client,
both use e1000 and NAT network.

I'll test the performance of virtio-net!

This is the result:

ept = 1:
============================
Before patch:
--------------
TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.122.247 (192.168.122.247) port 0 AF_INET
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

16384  87380  1        1       60.00    1182.27   
16384  87380 

TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.122.247 (192.168.122.247) port 0 AF_INET
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

16384  87380  1        1       60.00    1185.84   
16384  87380 

TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.122.247 (192.168.122.247) port 0 AF_INET
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

16384  87380  1        1       60.00    1181.58   
16384  87380 

After patch:
--------------
TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.122.247 (192.168.122.247) port 0 AF_INET
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

16384  87380  1        1       60.00    1205.65   
16384  87380 

TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.122.247 (192.168.122.247) port 0 AF_INET
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

16384  87380  1        1       60.00    1216.06   
16384  87380

TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.122.247 (192.168.122.247) port 0 AF_INET
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

16384  87380  1        1       60.00    1215.70   
16384  87380 


ept = 0, bypass_guest_pf=0:
============================
Before patch:
--------------
TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.122.247 (192.168.122.247) port 0 AF_INET
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

16384  87380  1        1       60.00    1169.70   
16384  87380 

TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.122.247 (192.168.122.247) port 0 AF_INET
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

16384  87380  1        1       60.00    1160.82   
16384  87380 

TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.122.247 (192.168.122.247) port 0 AF_INET
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

16384  87380  1        1       60.00    1168.01   
16384  87380 

After patch:
--------------
TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.122.247 (192.168.122.247) port 0 AF_INET
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

16384  87380  1        1       60.00    1266.28   
16384  87380 

TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.122.247 (192.168.122.247) port 0 AF_INET
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

16384  87380  1        1       60.00    1268.16  

TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.122.247 (192.168.122.247) port 0 AF_INET
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

16384  87380  1        1       60.00    1267.18   
16384  87380 


To my surprise is: after patch, the performance of ept = 0, bypass_guest_pf=0 is better than
the performance of ept = 1, maybe it is because MMIO is too much in network guests :-) 
