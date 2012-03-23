Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316Ab2CWMQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 08:16:46 -0400
Received: from mx2.netapp.com ([216.240.18.37]:35046 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756043Ab2CWMQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 08:16:45 -0400
X-IronPort-AV: E=Sophos;i="4.73,636,1325491200"; 
   d="scan'208";a="635740357"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Jim Rees <rees@umich.edu>
CC: Vivek Trivedi <vtrivedi018@gmail.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Namjae Jeon <linkinjeon@gmail.com>,
        "amit.sahrawat83@gmail.com" <amit.sahrawat83@gmail.com>
Subject: Re: NFS: low read/stat performance on small files
Thread-Topic: NFS: low read/stat performance on small files
Thread-Index: AQHNCOZ6vekmtNKt406SgqNDAE36jJZ4OXqAgAAHrgA=
Date: Fri, 23 Mar 2012 12:16:40 +0000
Message-ID: <1332505002.20500.14.camel@lade.trondhjem.org>
References: <CAKX=r8A90b25VKXC1qtAota9DqDrj37xFT511DuvrZ=1Eux6Xw@mail.gmail.com>
	 <20120323114913.GB24489@umich.edu>
In-Reply-To: <20120323114913.GB24489@umich.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <999EA4C8C47E0D4ABF9966F48D1B9478@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2NCGtIe029875

On Fri, 2012-03-23 at 07:49 -0400, Jim Rees wrote:
> Vivek Trivedi wrote:
> 
>   204800 bytes (200.0KB) copied, 0.027074 seconds, 7.2MB/s
>   Read speed for 200KB file is 7.2 MB
> 
>   104857600 bytes (100.0MB) copied, 9.351221 seconds, 10.7MB/s
>   Read speed for 100MB file is 10.7 MB
>   
>   As you see read speed for 200KB file is only 7.2MB/sec while it is
>   10.7 MB/sec when we read 100MB file.
>   Why there is so much difference in read performance ?
>   Is there any way to achieve high read speed for small files ?
> 
> That seems excellent to me.  204800 bytes at 11213252 per sec would be 18.2
> msec, so your per-file overhead is around 9 msec.  The disk latency alone
> would normally be more than that.

...and the reason why the performance is worse for the 200K file
compared to the 100M one is easily explained.

When opening the file for reading, the client has a number of
synchronous RPC calls to make: it needs to look up the file, check
access permissions and possibly revalidate its cache. All these tasks
have to be done in series (you cannot do them in parallel), and so the
latency of each task is limited by the round-trip time to the server.

On the other hand, once you get to doing READs, the client can send a
bunch of readahead requests in parallel, thus ensuring that the server
can use all the bandwidth available to the TCP connection.

So your result is basically showing that for small files, the proportion
of (readahead) tasks that can be done in parallel is smaller. This is as
expected.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
