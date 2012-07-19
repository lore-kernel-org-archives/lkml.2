Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab2GSJMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 05:12:52 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:49539 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab2GSJMu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 05:12:50 -0400
Content-Type: text/plain; charset=gbk; format=flowed; delsp=yes
To: "Corrado Zoccolo" <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: question about IO-sched
References: <op.whbsn0qvn27o5l@gaoqiang-d1.corp.qihoo.net>
 <CADX3swpSAt9gdSgYihOJKs1=geQkmB04rCVTSgh=DEXQx7QPmQ@mail.gmail.com>
 <op.whg7fy00n27o5l@gaoqiang-d1.corp.qihoo.net>
 <CADX3swq9cfPtd3a1ibYWjQBiTMGzqYbS=KNTkdo1eW4LFxsJJA@mail.gmail.com>
Date: Thu, 19 Jul 2012 17:12:42 +0800
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: gaoqiang <gaoqiangscut@gmail.com>
Organization: qihoo
Message-ID: <op.whorvghdn27o5l@gaoqiang-d1.corp.qihoo.net>
In-Reply-To: <CADX3swq9cfPtd3a1ibYWjQBiTMGzqYbS=KNTkdo1eW4LFxsJJA@mail.gmail.com>
User-Agent: Opera Mail/12.00 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks very much.

在 Wed, 18 Jul 2012 14:51:09 +0800，Corrado Zoccolo <czoccolo@gmail.com>  
写道:

> On Sun, Jul 15, 2012 at 9:08 AM, gaoqiang <gaoqiangscut@gmail.com> wrote:
>>
>> many thanks. but why the sys_read operation hangs on sync_page ? there  
>> are
>> still
>> many free memory.I mean ,the actually free memory,excluding the various
>> kinds of
>> caches or buffers.
> http://kerneltrap.org/node/4941 explains sync_page:
>>
>> ->sync_page() is an awful misnomer. Usually, when page IO operation is
>> requested by calling ->writepage() or ->readpage(), file-system queues
>> IO request (e.g., disk-based file system may do this my calling
>> submit_bio()), but underlying device driver does not proceed with this
>> IO immediately, because IO scheduling is more efficient when there are
>> multiple requests in the queue.
>> Only when something really wants to wait for IO completion
>> (wait_on_page_{locked,writeback}() are used to wait for read and write
>> completion respectively) IO queue is processed. To do this
>> wait_on_page_bit() calls ->sync_page() (see block_sync_page()---standard
>> implementation of ->sync_page() for disk-based file systems).
>> So, semantics of ->sync_page() are roughly "kick underlying storage
>> driver to actually perform all IO queued for this page, and, maybe, for
>> other pages on this device too".
>
> It is expected that sys_read will wait until the data is available for
> the process.
> If you don't want to wait (because you can do other stuff in the mean
> time, including queuing other I/O operations), you can use aio_read.
> The kernel will notify your process when the operation completes and
> the data is available in memory.
>
> Thanks,
> Corrado
>
>>
>>
>> 在 Fri, 13 Jul 2012 22:15:31 +0800，Corrado Zoccolo  
>> <czoccolo@gmail.com> 写道:
>>
>>> Hi,
>>> the catch is that writes are "fire and forget", so they keep  
>>> accumulating
>>> in the I/O sched, and there is always plenty of them to schedule  
>>> (unless
>>> you explicitly make sync writes).
>>>
>>> The reader, instead, waits for the result of each read operation before
>>> scheduling a new read, so there is at most one outstanding read, and  
>>> some
>>> time nothing.
>>>
>>> The deadline scheduler is work conserving, meaning that it never leaves
>>> the
>>> disk idle when there is work queued, and most of the time after an
>>> operation completes, there is only write work queued, so you see much
>>> more
>>> writes being sent to the device.
>>>
>>> Only schedulers that delay writes waiting for reads (as Anticipatory in
>>> old
>>> kernels, and now CFQ) can achieve higher read to write ratios.
>>>
>>> Cheers
>>> Corrado
>>>
>>> On Thu, Jul 12, 2012 at 11:01 AM, gaoqiang <gaoqiangscut@gmail.com>
>>> wrote:
>>>
>>>> Hi,all
>>>>
>>>>         I have long known that deadline is read-prefered. but a simple
>>>> test gives the opposite result.
>>>>
>>>>         with two processes running at the same time,one for read and  
>>>> one
>>>> for write.actually,they did nothing bug IO operation.
>>>>         while(true)
>>>>         {
>>>>                 read();
>>>>         }
>>>>         the other:
>>>>         while(true)
>>>>         {
>>>>                 write();
>>>>         }
>>>>
>>>>         with deadline IO-sched  and ext4 filesystem.as a result, read
>>>> ratio was about below 3M/s.and write about 100M/s. I have tested both
>>>> kernel-2.6.18 and kernel-2.6.32,getting the same result.
>>>>
>>>>         I add some debug information in the kernel and recompile,found
>>>> that,it has little to do with IO-sched layer because read request
>>>> dropped
>>>> into deadline was 5% of write request .from /proc/<pid>/stack,the read
>>>> process hands on sync_page most of the time.
>>>>         what is the matter ? anyone help me ?
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe  
>>>> linux-kernel"
>>>> in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at
>>>> http://vger.kernel.org/**majordomo-info.html<http://vger.kernel.org/majordomo-info.html>
>>>>
>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>>
>>>
>>>
>>>
>>
>>
>> --
>> 使用 Opera 革命性的电子邮件客户程序: http://www.opera.com/mail/
>
>
>
>
> --
> __________________________________________________________________________
>
> dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
> PhD - Department of Computer Science - University of Pisa, Italy
> --------------------------------------------------------------------------
> The self-confidence of a warrior is not the self-confidence of the  
> average
> man. The average man seeks certainty in the eyes of the onlooker and  
> calls
> that self-confidence. The warrior seeks impeccability in his own eyes and
> calls that humbleness.
>                                Tales of Power - C. Castaneda


-- 
使用 Opera 革命性的电子邮件客户程序: http://www.opera.com/mail/
