Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab1HDBzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 21:55:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64979 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755944Ab1HDBzj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 21:55:39 -0400
Message-ID: <4E39FC2F.4090501@cn.fujitsu.com>
Date: Thu, 04 Aug 2011 09:55:59 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Shaohua Li <shli@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org
Subject: Re: fio posixaio performance problem
References: <4E38C314.8070305@cn.fujitsu.com> <CANejiEViuKky1A7Xh0MQKBVNMj_fgzwayWyON7hFGfP3wa62SQ@mail.gmail.com> <4E3902C7.9050907@cn.fujitsu.com> <CANejiEVqFt4j1-qTVnxEAe75z0y010s=ST2XtCDDTqDEQT=EcQ@mail.gmail.com> <4E391986.90108@cn.fujitsu.com> <20110803154533.GB32385@redhat.com> <20110803175101.GC32385@redhat.com>
In-Reply-To: <20110803175101.GC32385@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-04 09:54:36,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-04 09:54:37
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-8-4 1:51, Vivek Goyal wrote:
> On Wed, Aug 03, 2011 at 11:45:33AM -0400, Vivek Goyal wrote:
>> On Wed, Aug 03, 2011 at 05:48:54PM +0800, Gui Jianfeng wrote:
>>> On 2011-8-3 16:22, Shaohua Li wrote:
>>>> 2011/8/3 Gui Jianfeng <guijianfeng@cn.fujitsu.com>:
>>>>> On 2011-8-3 15:38, Shaohua Li wrote:
>>>>>> 2011/8/3 Gui Jianfeng <guijianfeng@cn.fujitsu.com>:
>>>>>>> Hi,
>>>>>>>
>>>>>>> I ran a fio test to simulate qemu-kvm io behaviour.
>>>>>>> When job number is greater than 2, IO performance is
>>>>>>> really bad.
>>>>>>>
>>>>>>> 1 thread: aggrb=15,129KB/s
>>>>>>> 4 thread: aggrb=1,049KB/s
>>>>>>>
>>>>>>> Kernel: lastest upstream
>>>>>>>
>>>>>>> Any idea?
>>>>>>>
>>>>>>> ---
>>>>>>> [global]
>>>>>>> runtime=30
>>>>>>> time_based=1
>>>>>>> size=1G
>>>>>>> group_reporting=1
>>>>>>> ioengine=posixaio
>>>>>>> exec_prerun='echo 3 > /proc/sys/vm/drop_caches'
>>>>>>> thread=1
>>>>>>>
>>>>>>> [kvmio-1]
>>>>>>> description=kvmio-1
>>>>>>> numjobs=4
>>>>>>> rw=write
>>>>>>> bs=4k
>>>>>>> direct=1
>>>>>>> filename=/mnt/sda4/1G.img
>>>>>> Hmm, the test runs always about 15M/s at my side regardless how many threads.
>>>>>
>>>>> CFQ？
>>>> yes.
>>>>
>>>>> what's the slice_idle value?
>>>> default value. I didn't change it.
>>>
>>> Hmm, I use a sata disk, and can reproduce this bug every time...
>>
>> Do you have blktrace of run with 4 jobs?
> 
> I can't reproduce it too. On my sata disk single thread is getting around
> 23-24MB/s and 4 threads get around 19-20MB/sec. Some of the throughput
> is gone into seeking so that is expected.
> 
> I think what you are trying to point out is idling issue. In your workload
> every thread is doing sync-idle IO. So idling is enabled on each thread.
> On my system I see that next thread preempts the current idle thread 
> because they all are doing IO in nearby area of file and rq_close() is
> true hence preemption is allowed.
> 
> On your system, I think somehow rq_close() is not true hence preemption
> does not take place and we continue to idle on that thread. That also
> is not necessarily too bad but it might be happening that we are waiting
> for completion of IO from some other thread before this thread (we are
> idling on) can do more writes due to some filesystem rescrition and
> that can lead to sudden throughput drop. blktrace will give some idea.

Hi Vivek,

I got the blktrace when start 4 threads. It seems preemption doesn't happen.
And we are idling on one thread for 8ms all the time... I'm also curious why
fio doesn't issue enough io at the thread whose corresponding cfqq is on idling. 
Anyway, I don't want to stop idling on my box... So, any thought?

I extract a piece of blktrace output here.
----
  8,0    1     1218     0.894717976  2781  U   N [iotop] 2
  8,0    1     1219     0.929193602     0  C   R 197622056 + 8 [0]
  8,0    1        0     0.929206942     0  m   N cfq2781S / complete rqnoidle 0
  8,0    1        0     0.929211272     0  m   N cfq2781S / arm_idle: 8 group_idle: 0
  8,0    1        0     0.929212320     0  m   N cfq schedule dispatch
  8,0    1        0     0.936962634     0  m   N cfq idle timer fired
  8,0    1        0     0.936965847     0  m   N cfq2781S / slice expired t=0
  8,0    1        0     0.936968361     0  m   N / served: vt=1151069872 min_vt=1150946992
  8,0    1        0     0.936971295     0  m   N cfq2781S / sl_used=60 disp=5 charge=60 iops=0 sect=288
  8,0    1        0     0.936972831     0  m   N cfq2781S / del_from_rr
  8,0    1        0     0.936974298     0  m   N cfq schedule dispatch
  8,0    1        0     0.936996787     0  m   N cfq workload slice:100
  8,0    1        0     0.936998812     0  m   N cfq12700S / set_active wl_prio:0 wl_type:2
  8,0    1        0     0.937000908     0  m   N cfq12700S / fifo=(null)
  8,0    1        0     0.937002374     0  m   N cfq12700S / dispatch_insert
  8,0    1        0     0.937004679     0  m   N cfq12700S / dispatched a request
  8,0    1        0     0.937006216     0  m   N cfq12700S / activate rq, drv=1
  8,0    1     1220     0.937008171    35  D   W 514703416 + 8 [kblockd/1]
  8,0    1     1221     0.937242492     0  C   W 514703416 + 8 [0]
  8,0    1        0     0.937252269     0  m   N cfq12700S / complete rqnoidle 0
  8,0    1        0     0.937254365     0  m   N cfq12700S / set_slice=100
  8,0    1        0     0.937258136     0  m   N cfq12700S / arm_idle: 8 group_idle: 0
  8,0    1        0     0.937259254     0  m   N cfq schedule dispatch
  8,0    0     2032     0.937429948 12702  A  WS 514703464 + 8 <- (8,4) 91175016
  8,0    0     2033     0.937432532 12702  Q  WS 514703464 + 8 [fio]
  8,0    0     2034     0.937436164 12702  G  WS 514703464 + 8 [fio]
  8,0    0     2035     0.937439516 12702  P   N [fio]
  8,0    0     2036     0.937441542 12702  I   W 514703464 + 8 [fio]
  8,0    0        0     0.937445034     0  m   N cfq12702S / insert_request
  8,0    0        0     0.937446640     0  m   N cfq12702S / add_to_rr
  8,0    0     2037     0.937450272 12702  U   N [fio] 1
  8,0    1        0     0.944890139     0  m   N cfq idle timer fired
  8,0    1        0     0.944893352     0  m   N cfq12700S / slice expired t=0
  8,0    1        0     0.944895936     0  m   N / served: vt=1151086256 min_vt=1151069872
  8,0    1        0     0.944898590     0  m   N cfq12700S / sl_used=8 disp=1 charge=8 iops=0 sect=8
  8,0    1        0     0.944900196     0  m   N cfq12700S / del_from_rr
  8,0    1        0     0.944901593     0  m   N cfq schedule dispatch
  8,0    1        0     0.944932324     0  m   N cfq workload slice:100
  8,0    1        0     0.944934349     0  m   N cfq12702S / set_active wl_prio:0 wl_type:1
  8,0    1        0     0.944936444     0  m   N cfq12702S / fifo=(null)
  8,0    1        0     0.944937911     0  m   N cfq12702S / dispatch_insert
  8,0    1        0     0.944940286     0  m   N cfq12702S / dispatched a request
  8,0    1        0     0.944941822     0  m   N cfq12702S / activate rq, drv=1
  8,0    1     1222     0.944943638    35  D   W 514703464 + 8 [kblockd/1]
  8,0    1     1223     0.945166504     0  C   W 514703464 + 8 [0]
  8,0    1        0     0.945175863     0  m   N cfq12702S / complete rqnoidle 0
  8,0    1        0     0.945177958     0  m   N cfq12702S / set_slice=100
  8,0    1        0     0.945181660     0  m   N cfq12702S / arm_idle: 8 group_idle: 0


Thanks,
Gui

> 
> Thanks
> Vivek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


