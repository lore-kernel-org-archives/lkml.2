Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966521Ab0CPPZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 11:25:54 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:47620 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966483Ab0CPPZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 11:25:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=L2uo/OIbzFZl0Ub/QUHF1eAc/Frht9JEkfevIKRA1S8H1nY6DI1U38RJlqgCUGtZvE
         LdlSnsrdd7oqtqm1qQmSAw+YEz+TBYa3M/Tp+rtEGy5G3fI7pLxfifdVGNOHtP5T/Tss
         jX845dL8CxQBZ+KHfWuvkRvIYRcWE+Bo1E2tA=
MIME-Version: 1.0
In-Reply-To: <4B9F9FD0.8040303@kernel.org>
References: <4B947393.2050002@kernel.org>
	 <1268745897.21384.14.camel@mulgrave.site>
	 <4B9F8E1A.2020608@kernel.org>
	 <201003161538.27015.vda.linux@googlemail.com>
	 <4B9F9FD0.8040303@kernel.org>
Date: Tue, 16 Mar 2010 16:25:49 +0100
Message-ID: <1158166a1003160825j16ce6573h73e64d85b58bb202@mail.gmail.com>
Subject: Re: ATA 4 KiB sector issues.
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Arnd Bergmann <arnd@arndb.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 4:12 PM, Tejun Heo <tj@kernel.org> wrote:
>> The "end of partition" is expected to be at the last head and sector.
>> Of course this heuristic fails if there are more than one primary
>> partition and they have differing last head and sector.
>>
>> But on most "sanely" partitioned disks they are the same:
>>
>> Disk /dev/sda: 255 heads, 63 sectors, 36481 cylinders
>>
>> Nr AF  Hd Sec  Cyl  Hd Sec  Cyl      Start       Size ID
>>  1 00   1   1    0 254  63  850         63   13671252 0b
>>  2 80   0   1  851 254  63 1023   13671315  572395950 05
>>  3 00   0   0    0   0   0    0          0          0 00
>>  4 00   0   0    0   0   0    0          0          0 00
>>  5 00   1   1  851 254  63  972         63    1959867 83
>>  6 00   1   1  973 254  63 1023         63   31246362 83
>>  7 00 254  63 1023 254  63 1023         63  195318207 83
>>  8 00 254  63 1023 254  63 1023         63  343871262 83
>>                    ^^^  ^^
>
> C/H/S of 1023/254/63 is a special marker indicating the value there is
> out-of-range.

You misunderstood my ^^^ markers. I was trying to highlight
the whole columns of "end head" and "end sector", not the
last partition's 1023/254/63 values.

In the partition table like shown above it is obvious
that geometry is 255/63.

>> Which suggests another idea how to align a partition: since there is
>> no requirement on the partition *start*, we don't have to start at
>> head1,sector1 or head0,sector1
>
> We don't have to align to cylinders either.

If neither the start nor the end is aligned to cylinder's end
and disk has just one partition and it's bigger than 8G,
there is not way to determine geometry.

If everybody adopts the convention of ending the partitions
at the cylinder end, geometry can be trivially determined by
looking at partition end values. Sans "no of cylinders" value,
which can be easily determined by other means.

>> In the example above, 1st partition might be modified to start at
>> head1,sector2, IOW, LBA 64, thus making it 32k aligned.
>>
>> As long as partition *ends* adhere to the convention of being
>> exactly at last_head,last_sector, nothing should break.
>
> That has almost nothing to do with compatibility.  Just let the
> cylinder alignment go.

Then (some) bootloaders will stop working.

-- 
vda
