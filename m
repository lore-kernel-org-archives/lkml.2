Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab1ANEoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 23:44:16 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60403 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab1ANEoM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 23:44:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=A67osK6gnMFEjN1zmElQDQLuJ9dCsfdq8ozw9sPYcVklzKFKkGscO6MLIZDNd8LFBU
         JpUVWrXJpEUY98JPvTcBv1iBBNqPmQ8+a19pX8W6g5YNcM1X+OxjAMEvRWhTWJtdUTR8
         rzNKe3OAUPjzX+6DhSNc/ahX1vuC3OGDWdIxw=
MIME-Version: 1.0
In-Reply-To: <20110112023026.GA26525@sli10-conroe.sh.intel.com>
References: <1294735916.1949.637.camel@sli10-conroe>
	<AANLkTim72yNM1svGbFTKW8pSnFP9W+YgvGs4moXq+pyo@mail.gmail.com>
	<20110112023026.GA26525@sli10-conroe.sh.intel.com>
Date: Fri, 14 Jan 2011 12:44:09 +0800
X-Google-Sender-Auth: NVioQRUr4oyrpDopQRlBkxxtwOI
Message-ID: <AANLkTim=eCQ4AuipHXK=M-2ox4KZ8jntjcDbg+J6kfFb@mail.gmail.com>
Subject: Re: [PATCH 1/2]block cfq: make queue preempt work for queues from
 different workload
From: Shaohua Li <shli@kernel.org>
To: Corrado Zoccolo <czoccolo@gmail.com>, Jens Axboe <jaxboe@fusionio.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/12 Shaohua Li <shaohua.li@intel.com>:
> Hi,
> On Wed, Jan 12, 2011 at 05:07:47AM +0800, Corrado Zoccolo wrote:
>> Hi Shaohua,
>> On Tue, Jan 11, 2011 at 9:51 AM, Shaohua Li <shaohua.li@intel.com> wrote:
>> > I got this:
>> >             fio-874   [007]  2157.724514:   8,32   m   N cfq874 preempt
>> >             fio-874   [007]  2157.724519:   8,32   m   N cfq830 slice expired t=1
>> >             fio-874   [007]  2157.724520:   8,32   m   N cfq830 sl_used=1 disp=0 charge=1 iops=0 sect=0
>> >             fio-874   [007]  2157.724521:   8,32   m   N cfq830 set_active wl_prio:0 wl_type:0
>> >             fio-874   [007]  2157.724522:   8,32   m   N cfq830 Not idling. st->count:1
>> > cfq830 is an async queue, and preempted by a sync queue cfq874. But since we
>> > have cfqg->saved_workload_slice mechanism, the preempt is a nop.
>> > Looks currently our preempt is totally broken if the two queues are not from
>> > the same workload type.
>> > Below patch fixes it. This will might make async queue starvation, but it's
>> > what our old code does before cgroup is added.
>> have you measured latency improvements by un-breaking preemption?
>> AFAIK, preemption behaviour changed since 2.6.33, before cgroups were
>> added, and the latency before the changes that weakened preemption in
>> 2.6.33 was far worse.
> Yes. I'm testing a SD card for MeeGo. The random write is very slow (~12k/s) but
> random read is relatively fast > 1M/s.
>
> Without patch:
> write: (groupid=0, jobs=1): err= 0: pid=3876
>  write: io=966656 B, bw=8054 B/s, iops=1 , runt=120008msec
>    clat (usec): min=5 , max=1716.3K, avg=88637.38, stdev=207100.44
>     lat (usec): min=5 , max=1716.3K, avg=88637.69, stdev=207100.41
>    bw (KB/s) : min=    0, max=   52, per=168.17%, avg=11.77, stdev= 8.85
> read: (groupid=0, jobs=1): err= 0: pid=3877
>  read : io=52516KB, bw=448084 B/s, iops=109 , runt=120014msec
>    slat (usec): min=7 , max=1918.5K, avg=519.78, stdev=25777.85
>    clat (msec): min=1 , max=2728 , avg=71.17, stdev=216.92
>     lat (msec): min=1 , max=2756 , avg=71.69, stdev=219.52
>    bw (KB/s) : min=    1, max= 1413, per=66.42%, avg=567.22, stdev=461.50
>
> With patch:
> write: (groupid=0, jobs=1): err= 0: pid=4884
>  write: io=81920 B, bw=677 B/s, iops=0 , runt=120983msec
>    clat (usec): min=13 , max=742976 , avg=155694.10, stdev=244610.02
>     lat (usec): min=13 , max=742976 , avg=155694.50, stdev=244609.89
>    bw (KB/s) : min=    0, max=   31, per=inf%, avg= 8.40, stdev=12.78
> read: (groupid=0, jobs=1): err= 0: pid=4885
>  read : io=133008KB, bw=1108.3KB/s, iops=277 , runt=120022msec
>    slat (usec): min=8 , max=1159.1K, avg=164.24, stdev=9116.65
>    clat (msec): min=1 , max=1988 , avg=28.34, stdev=55.81
>     lat (msec): min=1 , max=1989 , avg=28.51, stdev=57.51
>    bw (KB/s) : min=    2, max= 1808, per=51.10%, avg=1133.42, stdev=275.59
>
> Both read latency/throughput has big difference with the patch, but write
> gets starvation.
Hi Jens and others,
How do you think about the patch?

Thanks,
Shaohua
