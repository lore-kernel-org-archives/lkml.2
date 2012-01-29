Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab2A2QBv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 11:01:51 -0500
Received: from mail2.vodafone.ie ([213.233.128.44]:16892 "EHLO
	mail2.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab2A2QBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 11:01:50 -0500
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Jan 2012 11:01:50 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAIJqJU9tTEVT/2dsb2JhbAAMNoULpxqFKQEBAQQjDwFGEAsNCwICBRYLAgIJAwIBAgFFBg0BBwEBrm+QYoEvhw4BBAMECQEDDAQDBAsKgycdAgoWWAIKGwIBBoIpgRYEmxKMWQ
Message-ID: <4F256B26.3060309@draigBrady.com>
Date: Sun, 29 Jan 2012 15:52:06 +0000
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Wu Fengguang <wfg@linux.intel.com>, Herbert Poetzl <herbert@13thfloor.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Bad SSD performance with recent kernels
References: <20120127060034.GG29272@MAIL.13thfloor.at>  <20120128125108.GA9661@localhost> <1327757611.7199.6.camel@edumazet-laptop>  <20120129055917.GB8513@localhost>  <1327831380.14602.6.camel@edumazet-laptop>  <20120129111645.GA5839@localhost> <1327842831.2718.2.camel@edumazet-laptop>
In-Reply-To: <1327842831.2718.2.camel@edumazet-laptop>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2012 01:13 PM, Eric Dumazet wrote:
> Le dimanche 29 janvier 2012 à 19:16 +0800, Wu Fengguang a écrit :
> 
> 
>> Note that as long as buffered read(2) is used, it makes almost no
>> difference (well, at least for now) to do "dd bs=128k" or "dd bs=2MB":
>> the 128kb readahead size will be used underneath to submit read IO.
>>
> 
> Hmm...
> 
> # echo 3 >/proc/sys/vm/drop_caches ;dd if=/dev/sda of=/dev/null bs=128k count=32768
> 32768+0 enregistrements lus
> 32768+0 enregistrements écrits
> 4294967296 octets (4,3 GB) copiés, 20,7718 s, 207 MB/s
> 
> 
> # echo 3 >/proc/sys/vm/drop_caches ;dd if=/dev/sda of=/dev/null bs=2M count=2048
> 2048+0 enregistrements lus
> 2048+0 enregistrements écrits
> 4294967296 octets (4,3 GB) copiés, 27,7824 s, 155 MB/s

Same here on 2.6.40.4-5.fc15.x86_64
Note the SSD is rated for 500MB/s but is on a SATA II port,
and so limited by that. So the 128k result below is
close to the limit on this system.

Hmm, I previously tested this SSD with kernel-2.6.38.6-26.rc1.fc15.src.rpm
and got 270MB/s. Testing now gives variable and lower results:

# echo 3 >/proc/sys/vm/drop_caches; hdparm -tT /dev/sdb
/dev/sdb:
 Timing cached reads:   8388 MB in  2.00 seconds = 4200.73 MB/sec
 Timing buffered disk reads: 550 MB in  3.00 seconds = 183.19 MB/sec
# echo 3 >/proc/sys/vm/drop_caches; hdparm -tT /dev/sdb
/dev/sdb:
 Timing cached reads:   8260 MB in  2.00 seconds = 4134.30 MB/sec
 Timing buffered disk reads: 680 MB in  3.00 seconds = 226.63 MB/sec
# echo 3 >/proc/sys/vm/drop_caches; hdparm -tT /dev/sdb
/dev/sdb:
 Timing cached reads:   8426 MB in  2.00 seconds = 4217.87 MB/sec
 Timing buffered disk reads: 588 MB in  3.00 seconds = 195.96 MB/sec

Anyway testing different block sizes with dd:

# echo 3 >/proc/sys/vm/drop_caches; timeout -sINT 5 dd if=/dev/sdb of=/dev/null bs=2M
966787072 bytes (967 MB) copied, 5.00525 s, 193 MB/s
# echo 3 >/proc/sys/vm/drop_caches; timeout -sINT 5 dd if=/dev/sdb of=/dev/null bs=128k
1246494720 bytes (1.2 GB) copied, 4.99563 s, 250 MB/s

On a probably unrelated note, I've always noticed dd getting slower,
independent of disks, when the buffer size increases beyond 2M.

for i in $(seq 0 15); do
  size=$((16*1024**3)) #ensure this is big enough
  bs=$((1024*2**$i))
  printf "%8s=" $bs
  dd bs=$bs if=/dev/zero of=/dev/null count=$(($size/$bs)) 2>&1 |
  sed -n 's/.* \([0-9.]* [GM]B\/s\)/\1/p'
done

    1024=1.4 GB/s
    2048=2.6 GB/s
    4096=4.5 GB/s
    8192=6.7 GB/s
   16384=8.8 GB/s
   32768=9.4 GB/s
   65536=10.8 GB/s
  131072=11.5 GB/s
  262144=11.5 GB/s
  524288=11.3 GB/s
 1048576=11.3 GB/s
 2097152=10.6 GB/s
 4194304=6.5 GB/s
 8388608=5.9 GB/s
16777216=6.6 GB/s
33554432=6.6 GB/s

cheers,
Pádraig.
