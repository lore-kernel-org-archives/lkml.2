Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab2H2PCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 11:02:37 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41043 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab2H2PCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 11:02:36 -0400
Message-ID: <503E2F27.5060904@gmail.com>
Date: Wed, 29 Aug 2012 17:03:03 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120826 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] virtio-ring: Allocate indirect buffers from cache
 when possible
References: <1346159043-16446-1-git-send-email-levinsasha928@gmail.com> <1346159043-16446-2-git-send-email-levinsasha928@gmail.com> <20120828132032.GB2039@redhat.com> <503CC904.3050207@gmail.com> <20120829110748.GB5970@redhat.com>
In-Reply-To: <20120829110748.GB5970@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2012 01:07 PM, Michael S. Tsirkin wrote:
> On Tue, Aug 28, 2012 at 03:35:00PM +0200, Sasha Levin wrote:
>> On 08/28/2012 03:20 PM, Michael S. Tsirkin wrote:
>>> On Tue, Aug 28, 2012 at 03:04:03PM +0200, Sasha Levin wrote:
>>>> Currently if VIRTIO_RING_F_INDIRECT_DESC is enabled we will
>>>> use indirect descriptors and allocate them using a simple
>>>> kmalloc().
>>>>
>>>> This patch adds a cache which will allow indirect buffers under
>>>> a configurable size to be allocated from that cache instead.
>>>>
>>>> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
>>>
>>> I imagine this helps performance? Any numbers?
>>
>> I ran benchmarks on the original RFC, I've re-tested it now and got similar
>> numbers to the original ones (virtio-net using vhost-net, thresh=16):
>>
>> Before:
>> 	Recv   Send    Send
>> 	Socket Socket  Message  Elapsed
>> 	Size   Size    Size     Time     Throughput
>> 	bytes  bytes   bytes    secs.    10^6bits/sec
>>
>> 	 87380  16384  16384    10.00    4512.12
>>
>> After:
>> 	Recv   Send    Send
>> 	Socket Socket  Message  Elapsed
>> 	Size   Size    Size     Time     Throughput
>> 	bytes  bytes   bytes    secs.    10^6bits/sec
>>
>> 	 87380  16384  16384    10.00    5399.18
>>
>>
>> Thanks,
>> Sasha
> 
> This is with both patches 1 + 2?
> Sorry could you please also test what happens if you apply
> - just patch 1
> - just patch 2
> 
> Thanks!

Sure thing!

I've also re-ran it on a IBM server type host instead of my laptop. Here are the
results:

Vanilla kernel:

MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.33.1
() port 0 AF_INET
enable_enobufs failed: getprotobyname
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

 87380  16384  16384    10.00    7922.72

Patch 1, with threshold=16:

MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.33.1
() port 0 AF_INET
enable_enobufs failed: getprotobyname
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

 87380  16384  16384    10.00    8415.07

Patch 2:

MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.33.1
() port 0 AF_INET
enable_enobufs failed: getprotobyname
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

 87380  16384  16384    10.00    8931.05


Note that these are simple tests with netperf listening on one end and a simple
'netperf -H [host]' within the guest. If there are other tests which may be
interesting please let me know.


Thanks,
Sasha

