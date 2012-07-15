Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab2GOHKK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 03:10:10 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38804 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2GOHKG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 03:10:06 -0400
Content-Type: text/plain; charset=gbk; format=flowed; delsp=yes
To: "Corrado Zoccolo" <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: question about IO-sched
References: <op.whbsn0qvn27o5l@gaoqiang-d1.corp.qihoo.net>
 <CADX3swpSAt9gdSgYihOJKs1=geQkmB04rCVTSgh=DEXQx7QPmQ@mail.gmail.com>
Date: Sun, 15 Jul 2012 15:08:12 +0800
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: gaoqiang <gaoqiangscut@gmail.com>
Organization: qihoo
Message-ID: <op.whg7fy00n27o5l@gaoqiang-d1.corp.qihoo.net>
In-Reply-To: <CADX3swpSAt9gdSgYihOJKs1=geQkmB04rCVTSgh=DEXQx7QPmQ@mail.gmail.com>
User-Agent: Opera Mail/12.00 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

many thanks. but why the sys_read operation hangs on sync_page ? there are  
still
many free memory.I mean ,the actually free memory,excluding the various  
kinds of
caches or buffers.


在 Fri, 13 Jul 2012 22:15:31 +0800，Corrado Zoccolo <czoccolo@gmail.com>  
写道:

> Hi,
> the catch is that writes are "fire and forget", so they keep accumulating
> in the I/O sched, and there is always plenty of them to schedule (unless
> you explicitly make sync writes).
>
> The reader, instead, waits for the result of each read operation before
> scheduling a new read, so there is at most one outstanding read, and some
> time nothing.
>
> The deadline scheduler is work conserving, meaning that it never leaves  
> the
> disk idle when there is work queued, and most of the time after an
> operation completes, there is only write work queued, so you see much  
> more
> writes being sent to the device.
>
> Only schedulers that delay writes waiting for reads (as Anticipatory in  
> old
> kernels, and now CFQ) can achieve higher read to write ratios.
>
> Cheers
> Corrado
>
> On Thu, Jul 12, 2012 at 11:01 AM, gaoqiang <gaoqiangscut@gmail.com>  
> wrote:
>
>> Hi,all
>>
>>         I have long known that deadline is read-prefered. but a simple
>> test gives the opposite result.
>>
>>         with two processes running at the same time,one for read and one
>> for write.actually,they did nothing bug IO operation.
>>         while(true)
>>         {
>>                 read();
>>         }
>>         the other:
>>         while(true)
>>         {
>>                 write();
>>         }
>>
>>         with deadline IO-sched  and ext4 filesystem.as a result, read
>> ratio was about below 3M/s.and write about 100M/s. I have tested both
>> kernel-2.6.18 and kernel-2.6.32,getting the same result.
>>
>>         I add some debug information in the kernel and recompile,found
>> that,it has little to do with IO-sched layer because read request  
>> dropped
>> into deadline was 5% of write request .from /proc/<pid>/stack,the read
>> process hands on sync_page most of the time.
>>         what is the matter ? anyone help me ?
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"  
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at   
>> http://vger.kernel.org/**majordomo-info.html<http://vger.kernel.org/majordomo-info.html>
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
>
>


-- 
使用 Opera 革命性的电子邮件客户程序: http://www.opera.com/mail/
