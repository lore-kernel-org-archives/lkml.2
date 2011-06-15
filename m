Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1FOUt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 16:49:59 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45897 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab1FOUt6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:49:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gemQdQOTbUWh3N04qUedm4DmdzA5duWHP/D++XEjcGaSF6M46uLLB6Gum0+GEfQcXD
         Q+/Y7y+Dw0Aqo+oIOyPb699ntR+3oLlkvJyYI/d7Svjv2FlSuptb9ov7DbFm4ts15rVN
         nCQQRjASMM+4m2qMJrcUsy3x6v8pNSXRaHP7k=
MIME-Version: 1.0
In-Reply-To: <1308169421.14175.19.camel@lappy>
References: <1308153214.7566.6.camel@jaguar>
	<4DF8DE26.1070301@redhat.com>
	<BANLkTi=SHENDBHdtFY_7_qtfqJb_+qKJSw@mail.gmail.com>
	<BANLkTinMDz-sqaX0cyWEoLXt70dowxofvg@mail.gmail.com>
	<1308169421.14175.19.camel@lappy>
Date: Wed, 15 Jun 2011 21:49:55 +0100
Message-ID: <BANLkTinkJBeXJFJBbx+G2GbAbHsKt6VsfA@mail.gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Asias He <asias.hejun@gmail.com>, Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 9:23 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> On Wed, 2011-06-15 at 21:13 +0100, Prasad Joshi wrote:
>> On Wed, Jun 15, 2011 at 6:10 PM, Pekka Enberg <penberg@kernel.org> wrote:
>> > On Wed, Jun 15, 2011 at 7:30 PM, Avi Kivity <avi@redhat.com> wrote:
>> >> On 06/15/2011 06:53 PM, Pekka Enberg wrote:
>> >>>
>> >>> - Fast QCOW2 image read-write support beating Qemu in fio benchmarks. See
>> >>> the
>> >>>   following URL for test result details: https://gist.github.com/1026888
>> >>
>> >> This is surprising.  How is qemu invoked?
>> >
>> > Prasad will have the details. Please note that the above are with Qemu
>> > defaults which doesn't use virtio. The results with virtio are little
>> > better but still in favor of tools/kvm.
>> >
>>
>> The qcow2 image used for testing was copied on to /dev/shm to avoid
>> the disk delays in performance measurement.
>>
>> QEMU was invoked with following parameters
>>
>> $ qemu-system-x86_64 -hda <disk image on hard disk> -hdb
>> /dev/shm/test.qcow2 -m 1024M
>>
>
> Prasad, Could you please run this test with '-drive
> file=/dev/shm/test.qcow2,if=virtio' instead of the '-hdb' thing?
>

Infact I have already tried that. Like Pekka mentioned, the results
are still in favour of KVM tools.

I machine that I work on is not with me at the moment, I will be able
to mail the exact numbers tomorrow.

Thanks and Regards,
Prasad

>> FIO job file used for measuring the numbers was
>>
>> prasad@prasad-vm:~$ cat fio-mixed.job
>> ; fio-mixed.job for autotest
>>
>> [global]
>> name=fio-sync
>> directory=/mnt
>> rw=randrw
>> rwmixread=67
>> rwmixwrite=33
>> bsrange=16K-256K
>> direct=0
>> end_fsync=1
>> verify=crc32
>> ;ioscheduler=x
>> numjobs=4
>>
>> [file1]
>> size=50M
>> ioengine=sync
>> mem=malloc
>>
>> [file2]
>> stonewall
>> size=50M
>> ioengine=aio
>> mem=shm
>> iodepth=4
>>
>> [file3]
>> stonewall
>> size=50M
>> ioengine=mmap
>> mem=mmap
>> direct=1
>>
>> [file4]
>> stonewall
>> size=50M
>> ioengine=splice
>> mem=malloc
>> direct=1
>>
>> - The test generates 16 file each of ~50MB, so in total ~800MB data was written.
>> - The test.qcow2 was newly created before it was used with QEMU or KVM tool
>> - The size of the QCOW2 image was 1.5GB.
>> - The host machine had 2GB RAM.
>> - The guest machine in both the cases was started with 1GB memory.
>>
>> Thanks and Regards,
>> Prasad
>>
>> >> btw the dump above is a little hard to interpret.
>> >
>> > It's what fio reports. The relevant bits are:
>> >
>> >
>> > Qemu:
>> >
>> > Run status group 0 (all jobs):
>> >  READ: io=204800KB, aggrb=61152KB/s, minb=15655KB/s, maxb=17845KB/s,
>> > mint=2938msec, maxt=3349msec
>> >  WRITE: io=68544KB, aggrb=28045KB/s, minb=6831KB/s, maxb=7858KB/s,
>> > mint=2292msec, maxt=2444msec
>> >
>> > Run status group 1 (all jobs):
>> >  READ: io=204800KB, aggrb=61779KB/s, minb=15815KB/s, maxb=17189KB/s,
>> > mint=3050msec, maxt=3315msec
>> >  WRITE: io=66576KB, aggrb=24165KB/s, minb=6205KB/s, maxb=7166KB/s,
>> > mint=2485msec, maxt=2755msec
>> >
>> > Run status group 2 (all jobs):
>> >  READ: io=204800KB, aggrb=6722KB/s, minb=1720KB/s, maxb=1737KB/s,
>> > mint=30178msec, maxt=30467msec
>> >  WRITE: io=65424KB, aggrb=2156KB/s, minb=550KB/s, maxb=573KB/s,
>> > mint=29682msec, maxt=30342msec
>> >
>> > Run status group 3 (all jobs):
>> >  READ: io=204800KB, aggrb=6994KB/s, minb=1790KB/s, maxb=1834KB/s,
>> > mint=28574msec, maxt=29279msec
>> >  WRITE: io=68192KB, aggrb=2382KB/s, minb=548KB/s, maxb=740KB/s,
>> > mint=27121msec, maxt=28625msec
>> >
>> > Disk stats (read/write):
>> >  sdb: ios=60583/6652, merge=0/164, ticks=156340/672030,
>> > in_queue=828230, util=82.71%
>> >
>> > tools/kvm:
>> >
>> > Run status group 0 (all jobs):
>> >   READ: io=204800KB, aggrb=149162KB/s, minb=38185KB/s,
>> > maxb=46030KB/s, mint=1139msec, maxt=1373msec
>> >  WRITE: io=70528KB, aggrb=79156KB/s, minb=18903KB/s, maxb=23726KB/s,
>> > mint=804msec, maxt=891msec
>> >
>> > Run status group 1 (all jobs):
>> >   READ: io=204800KB, aggrb=188235KB/s, minb=48188KB/s,
>> > maxb=57932KB/s, mint=905msec, maxt=1088msec
>> >  WRITE: io=64464KB, aggrb=84821KB/s, minb=21751KB/s, maxb=27392KB/s,
>> > mint=570msec, maxt=760msec
>> >
>> > Run status group 2 (all jobs):
>> >   READ: io=204800KB, aggrb=20005KB/s, minb=5121KB/s, maxb=5333KB/s,
>> > mint=9830msec, maxt=10237msec
>> >  WRITE: io=66624KB, aggrb=6615KB/s, minb=1671KB/s, maxb=1781KB/s,
>> > mint=9558msec, maxt=10071msec
>> >
>> > Run status group 3 (all jobs):
>> >   READ: io=204800KB, aggrb=66149KB/s, minb=16934KB/s, maxb=17936KB/s,
>> > mint=2923msec, maxt=3096msec
>> >  WRITE: io=69600KB, aggrb=26717KB/s, minb=6595KB/s, maxb=7342KB/s,
>> > mint=2530msec, maxt=2605msec
>> >
>> > Disk stats (read/write):
>> >  vdb: ios=61002/6654, merge=0/183, ticks=27270/205780,
>> > in_queue=232220, util=69.46%
>> >
>
> --
>
> Sasha.
>
>
