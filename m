Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab0JaWZr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 18:25:47 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63483 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab0JaWZo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 18:25:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BeBKvx9sc4c2EbudrrAxq3m3bZkDPLxKDqgPFvbHillGfvYhQHwrLoFdY5sIXumTsE
         /OpmSUTlnSvqJvyCBwsERN2cpwjvIs0Ljp31BRrE1pUCUt1+RT5xhjuriaEu+ZKhZw/o
         vhBl5M4nlw/sY9+RX2qS2LFCC7UF+z0rhxBbg=
MIME-Version: 1.0
In-Reply-To: <AANLkTinWT9OyicLfdeY+AvWs=5vb5z8skZ3t6keYjk9j@mail.gmail.com>
References: <AANLkTinWT9OyicLfdeY+AvWs=5vb5z8skZ3t6keYjk9j@mail.gmail.com>
Date: Sun, 31 Oct 2010 16:25:41 -0600
X-Google-Sender-Auth: MqH9dNx6bEYlH8NClim8W9ou-ss
Message-ID: <AANLkTikNywvthaU-+s5HXvh3RX=HxiFWmADW--Ln_Gga@mail.gmail.com>
Subject: Re: Horrible btrfs performance due to fragmentation
From: cwillu <cwillu@cwillu.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Calvin Walton <calvin.walton@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 31, 2010 at 1:58 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> On Mon, Oct 11, 2010 at 6:46 PM, Calvin Walton <calvin.walton@gmail.com> wrote:
>> On Mon, 2010-10-11 at 03:30 +0300, Felipe Contreras wrote:
>>> I use btrfs on most of my volumes on my laptop, and I've always felt
>>> booting was very slow, but definitely sure is slow, is starting up
>>> Google Chrome:
>>>
>>> encrypted ext4: ~20s
>>> btrfs: ~2:11s
>>>
>>> I have tried different things to find out exactly what is the issue,
>>> but haven't quite found it yet.
>>
>> If you've been using this volume for a while, it could just have become
>> badly fragmented. You could try btrfs's fancy online defragmentation
>> abilities to see if that'll give you an improvement:
>>
>> # btrfs filesystem defragment /mountpoint/of/volume
>>
>> Let us know if that helps, of course :)
>
> I finally managed to track down this issue. Indeed the fragmentation
> is horrible, and 'btrfs filesystem defragment' doesn't help:
>
> % cat History-old > History
> % btrfs filesystem defragment /home
> % echo 3 > /proc/sys/vm/drop_caches
>
> % time dd if=History of=/dev/null && time dd if=History-old of=/dev/null
> 109664+0 records in
> 109664+0 records out
> 56147968 bytes (56 MB) copied, 1.90015 s, 29.5 MB/s
> dd if=History of=/dev/null  0.08s user 0.29s system 15% cpu 2.458 total
> 109664+0 records in
> 109664+0 records out
> 56147968 bytes (56 MB) copied, 97.772 s, 574 kB/s
> dd if=History-old of=/dev/null  0.07s user 0.80s system 0% cpu 1:37.79 total
>
> I think this is a serious issue that *must* be fixed for 1.0. I filed
> a bug for this:
> https://bugzilla.kernel.org/show_bug.cgi?id=21562

btrfs fi defrag isn't recursive.  "btrfs filesystem defrag /home" will
defragment the space used to store the folder, without touching the
space used to store files in that folder.
