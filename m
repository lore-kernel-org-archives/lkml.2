Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab2ILGEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 02:04:31 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58325 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab2ILGEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 02:04:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAKYAXd9pa9sXOLv+2vwb3pprp0B=dvPcG5JZsmDNm-hFT1DMUw@mail.gmail.com>
References: <1346083274-3510-1-git-send-email-linkinjeon@gmail.com>
	<20120911014025.GA22077@localhost>
	<CAKYAXd_VucTrf=TeezrU28+Ja+41TAFCY3zfuBGvoMO9FXNB1A@mail.gmail.com>
	<CAKYAXd_Zdb_3rqwgf03To+DPw-wFXUGW-5km7KVaiJSymEuGMg@mail.gmail.com>
	<20120911232537.GA13210@localhost>
	<CAKYAXd9pa9sXOLv+2vwb3pprp0B=dvPcG5JZsmDNm-hFT1DMUw@mail.gmail.com>
Date: Wed, 12 Sep 2012 15:04:29 +0900
Message-ID: <CAKYAXd_CGjnsUPTdfPN54SeZkGLtxkA_6T7MFqUi-9da7UDRtw@mail.gmail.com>
Subject: Re: [PATCH 1/2] writeback: add dirty_background_time per bdi variable
From: Namjae Jeon <linkinjeon@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Vivek Trivedi <t.vivek@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/12, Namjae Jeon <linkinjeon@gmail.com>:
> 2012/9/12, Fengguang Wu <fengguang.wu@intel.com>:
>> On Wed, Sep 12, 2012 at 08:12:40AM +0900, Namjae Jeon wrote:
>>> >>
>>> >> To be frank, no realistic NFS servers will use USB disk as backing
>>> >> storage. So that rational for reducing "initial" delays is weak.
>>> >> Continuous write performance to HDD is much more important. Do you
>>> >> have numbers for that?
>>> >
>>> > Actually, we use USB HDD and USB Flash devices at NFS server.
>>> > There can be other similar users as well. So it might be useful to
>>> > provide this tuning feature other.
>>> > As default value is zero, it is disabled by default and it should not
>>> > impact normal writeback.
>>> >
>>> > I will share large file writes test result on NFS client on USB HDD
>>> > with/without tuning with patch.
>>> Hi. Wu.
>>> I share 1GB continous write test result.
>>>
>>> -> create a 1000 MB file
>>> For continuous write - create 1 GB file
>>>
>>>  RecSize   WriteSpeed
>>> 10485760   10.47MB/sec
>>>  1048576   10.35MB/sec
>>>   524288   10.48MB/sec
>>>   262144   10.48MB/sec
>>>   131072   10.52MB/sec
>>>    65536   10.56MB/sec
>>>    32768   10.64MB/sec
>>>    16384   10.31MB/sec
>>>     8192   10.52MB/sec
>>>     4096   10.45MB/sec
>>>
>>> I will update changelog in patch.
>>
>> Thanks! What's the server side setting
> I missed server side setting.. I set dirty_background_centisecs to 1 sec.
>> and can you give a comparison of different background writeback
>> thresholds?
> Okay, I will measure peformance per setting value of
> dirty_background_centisecs in nfs server.
>
> This is this patch's
>> target use cases, after all.
> Sure.
> Thanks.

Hi. Wu.

I shared write performance result as your suggestion.

-----------------------------------------------------------
dirty_background_centisecs = 0, default value
-----------------------------------------------------------
[NFS Server]
$ cat /sys/block/sda/bdi/dirty_background_centisecs
0
[NFS Client]
$ ./performancetest_arm 1GB_file
WRT_SZ = 1000 MB
 RecSize    WriteSpeed
10485760    8.44MB/sec
 1048576    8.48MB/sec
  524288    8.37MB/sec
  262144    8.16MB/sec
  131072    8.48MB/sec
   65536    8.38MB/sec
   32768    8.65MB/sec
   16384    8.27MB/sec
    8192    8.52MB/sec
    4096    8.20MB/sec

-----------------------------------------------------------
dirty_background_centisecs = 300, i.e. 3 seconds
-----------------------------------------------------------
 [NFS Server]
$ echo 300 > /sys/block/sda/bdi/dirty_background_centisecs
$ cat /sys/block/sda/bdi/dirty_background_centisecs
300
[NFS Client]
$ ./performancetest_arm 1GB_file
RecSize      WriteSpeed
10485760    8.60MB/sec
 1048576    8.87MB/sec
  524288    8.42MB/sec
  262144    8.51MB/sec
  131072    8.81MB/sec
   65536    9.09MB/sec
   32768    9.00MB/sec
   16384    8.80MB/sec
    8192    8.70MB/sec
    4096    8.63MB/sec

-----------------------------------------------------------
dirty_background_centisecs = 200, i.e. 2 seconds
-----------------------------------------------------------
[NFS Server]
$ echo 200 > /sys/block/sda/bdi/dirty_background_centisecs
$ cat /sys/block/sda/bdi/dirty_background_centisecs
200
[NFS Client]
$ ./performancetest_arm 1GB_file
RecSize    WriteSpeed
10485760    9.30MB/sec
 1048576    9.31MB/sec
  524288    9.84MB/sec
  262144    9.52MB/sec
  131072    9.42MB/sec
   65536    9.76MB/sec
   32768    9.57MB/sec
   16384    9.39MB/sec
    8192    9.40MB/sec
    4096    9.80MB/sec

-----------------------------------------------------------
dirty_background_centisecs = 100, i.e. 1 second
-----------------------------------------------------------
[NFS Server]
$ echo 100 > /sys/block/sda/bdi/dirty_background_centisecs
$ cat /sys/block/sda/bdi/dirty_background_centisecs
100
[NFS Client]
$ ./performancetest_arm 1GB_file
RecSize    WriteSpeed
10485760   10.27MB/sec
 1048576   10.34MB/sec
  524288   10.47MB/sec
  262144   10.62MB/sec
  131072   10.55MB/sec
   65536   10.53MB/sec
   32768   10.54MB/sec
   16384   10.43MB/sec
    8192   10.50MB/sec
    4096   10.35MB/sec

I will update simple table for this result in changelog in patch.

Thanks.

>>
>> Thanks,
>> Fengguang
>>
>
