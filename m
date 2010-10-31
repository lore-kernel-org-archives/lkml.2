Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab0JaWhG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 18:37:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38251 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab0JaWhC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 18:37:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JS876t2CBq3TViDtcqMrcox2ekPsmElD04KserWV1D4lObtiDF2KWzHsVdo6llZ522
         Ce0PNAPvjHMG1SEAeZ2I82l5UkJ2DfS2be2BPZ8ZNQZWZfldMiMnEmJPCkshdMTEvnh1
         yW18EBp9l3/3Gh7GJN6/LTF7p9InORjtx9j/Y=
MIME-Version: 1.0
In-Reply-To: <AANLkTikNywvthaU-+s5HXvh3RX=HxiFWmADW--Ln_Gga@mail.gmail.com>
References: <AANLkTinWT9OyicLfdeY+AvWs=5vb5z8skZ3t6keYjk9j@mail.gmail.com>
	<AANLkTikNywvthaU-+s5HXvh3RX=HxiFWmADW--Ln_Gga@mail.gmail.com>
Date: Mon, 1 Nov 2010 00:36:58 +0200
Message-ID: <AANLkTimgCU1tM9VJv8RJ-dim+bRsT7cbZ9ZidbT5sco-@mail.gmail.com>
Subject: Re: Horrible btrfs performance due to fragmentation
From: Felipe Contreras <felipe.contreras@gmail.com>
To: cwillu <cwillu@cwillu.com>
Cc: Calvin Walton <calvin.walton@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 12:25 AM, cwillu <cwillu@cwillu.com> wrote:
> On Sun, Oct 31, 2010 at 1:58 PM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>> On Mon, Oct 11, 2010 at 6:46 PM, Calvin Walton <calvin.walton@gmail.com> wrote:
>>> On Mon, 2010-10-11 at 03:30 +0300, Felipe Contreras wrote:
>>>> I use btrfs on most of my volumes on my laptop, and I've always felt
>>>> booting was very slow, but definitely sure is slow, is starting up
>>>> Google Chrome:
>>>>
>>>> encrypted ext4: ~20s
>>>> btrfs: ~2:11s
>>>>
>>>> I have tried different things to find out exactly what is the issue,
>>>> but haven't quite found it yet.
>>>
>>> If you've been using this volume for a while, it could just have become
>>> badly fragmented. You could try btrfs's fancy online defragmentation
>>> abilities to see if that'll give you an improvement:
>>>
>>> # btrfs filesystem defragment /mountpoint/of/volume
>>>
>>> Let us know if that helps, of course :)
>>
>> I finally managed to track down this issue. Indeed the fragmentation
>> is horrible, and 'btrfs filesystem defragment' doesn't help:
>>
>> % cat History-old > History
>> % btrfs filesystem defragment /home
>> % echo 3 > /proc/sys/vm/drop_caches
>>
>> % time dd if=History of=/dev/null && time dd if=History-old of=/dev/null
>> 109664+0 records in
>> 109664+0 records out
>> 56147968 bytes (56 MB) copied, 1.90015 s, 29.5 MB/s
>> dd if=History of=/dev/null  0.08s user 0.29s system 15% cpu 2.458 total
>> 109664+0 records in
>> 109664+0 records out
>> 56147968 bytes (56 MB) copied, 97.772 s, 574 kB/s
>> dd if=History-old of=/dev/null  0.07s user 0.80s system 0% cpu 1:37.79 total
>>
>> I think this is a serious issue that *must* be fixed for 1.0. I filed
>> a bug for this:
>> https://bugzilla.kernel.org/show_bug.cgi?id=21562
>
> btrfs fi defrag isn't recursive.  "btrfs filesystem defrag /home" will
> defragment the space used to store the folder, without touching the
> space used to store files in that folder.

Yes, that came up on the IRC, but:

1) It doesn't make sense: "btrfs filesystem" doesn't allow a fileystem
as argument? Why would anyone want it to be _non_ recursive?

2) The filesystem should not degrade performance so horribly no matter
how long the it has been used. Even git has automatic garbage
collection.

-- 
Felipe Contreras
