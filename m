Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab0EJPQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 11:16:40 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:50075 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab0EJPQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 11:16:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type;
        b=bb4OuVbJEo2I0jy6kD64+PCgE0u3/CSzvX+0fM5tT25LIlgiOxes8pbLbmrl2oqRaL
         BLQdnV/IJAN2pNpbe+ZngbbZSb+XEMnvRDePafx/ztoFnHQrdpzsADPJ3KaUep7tz59Z
         dMqpsJg7xz+ZUvftXuqHC+7DwYiHq35MNDAZY=
MIME-Version: 1.0
In-Reply-To: <s2i9b1675091005041100l471e04c3o83551fc947ce587e@mail.gmail.com>
References: <n2i9b1675091005032052wd935041ew5d96f145309af801@mail.gmail.com>
	 <u2m58965d8a1005041034h72605714z46a1a1e06eccc86c@mail.gmail.com>
	 <s2i9b1675091005041100l471e04c3o83551fc947ce587e@mail.gmail.com>
Date: Mon, 10 May 2010 10:16:37 -0500
X-Google-Sender-Auth: _M5zsfLb43Pgo4gofSB1-iTrNl0
Message-ID: <AANLkTikv0xAB20H4K8Xqj2O5whViBk5AQsVXTKIDnamv@mail.gmail.com>
Subject: Re: Flash IO slow 1.5 MB/s
From: Paul Hartman <paul.hartman+linux@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 4, 2010 at 1:00 PM, Trenton D. Adams
<trenton.d.adams@gmail.com> wrote:
> On Tue, May 4, 2010 at 11:34 AM, Paul Hartman
> <paul.hartman+linux@gmail.com> wrote:
>> On Mon, May 3, 2010 at 10:52 PM, Trenton D. Adams
>> <trenton.d.adams@gmail.com> wrote:
>>> It really looks like there's a scheduling issue.  It seems as if the
>>> system is IO thrashing on the flash drive, and bounces all over the
>>> place in terms of performance.  Sometimes it's really low, like the
>>> 2.73M/s, and other times it's really fast, like the 28.86M/s.
>>> Although you can't see it there, there were times when rsync was
>>> registering 200kb/s.  None of them are "really" accurate, as
>>> everything is queued for writing, but the final results of 1.5M/s
>>> (calculated from the "real" time) is terrible.
>>
>> I have a similar experience (posted to this list a few months ago)
>> with mounting a flash device (mobile phone) in USB mass storage mode.
>> When I/O scheduler for that device is CFQ, write performance is really
>> terrible. When I change the scheduler to deadline, performance is
>> several times better. In 2.6.32 pdflush was replaced and CFQ
>> performance saw a 4x increase but still far too slow.
>>
>> CFQ in <=2.6.31: 450KB/sec
>> CFQ in >=2.6.32: 2MB/sec
>> Deadline in all: 17MB/sec
>>
>> I didn't try anything with dirty_bytes.
>>
>> FWIW :)
>
> Oops, my message didn't reach the LKML, sorry for the spam Paul.
>
> I switched to deadline and dirty_ratio 20 for my flash device, and I
> am seeing VERY slow performance as well.  I get a lot of freezing up
> of rsync, where the progress just stops (visually anyhow), which is
> the same as what I see with cfq.  However, it's not 14 minutes as it
> was in my original email...
>
> [11:44 trenta@tdanotebook web] $ time rsync -v --progress
> /home/share/DVD/*.avi /media/disk/
> facing-the-giants.avi
>  709911016 100%    5.49MB/s    0:02:03 (xfer#1, to-check=1/2)
> jonah.avi
>  621254748 100%   15.97MB/s    0:00:37 (xfer#2, to-check=0/2)
>
> sent 1331328404 bytes  received 50 bytes  4430377.55 bytes/sec
> total size is 1331165764  speedup is 1.00
>
> real    4m59.657s
> user    0m8.553s
> sys     0m9.501s
>
>
> with dirty_bytes 16000000, I still get twice the speed out of deadline.
>
> [11:53 trenta@tdanotebook web] $ time rsync -v --progress
> /home/share/DVD/*.avi /media/disk/
> facing-the-giants.avi
>  709911016 100%    7.62MB/s    0:01:28 (xfer#1, to-check=1/2)
> jonah.avi
>  621254748 100%    7.64MB/s    0:01:17 (xfer#2, to-check=0/2)
>
> sent 1331328404 bytes  received 50 bytes  7948229.58 bytes/sec
> total size is 1331165764  speedup is 1.00
>
> real    2m47.244s
> user    0m8.429s
> sys     0m9.377s
>
>
> So, perhaps it's a combination of the schedulers and something else in
> the kernel?  And perhaps, CFQ just amplifies something else in the
> kernel, more than deadline does?

In my case I also noticed that if I'm using CFQ and leave everything
as normal, the problem only shows up when I copy more than 1 file
before syncing. For example, with 2 test files 700M each in size:

# one file at a time with sync in-between, fast speeds:
$ sync; time sh -c "cp file1 /mnt/usb; sync; cp file2 /mnt/usb; sync"

real    1m25.697s
user    0m0.005s
sys     0m2.509s

# copy two files in a row, then sync, speed is bad:
$ sync; time sh -c "cp file1 file2 /mnt/usb; sync"

real    6m51.439s
user    0m0.007s
sys     0m2.615s

(and, like you, if I mount with "sync" option the speed is basically terrible)

I've tested on 2 machines and had the same results on both, almost
identical timings in fact. Both 64-bit (Core 2 E6600, Core i7 920).
Others who have the same device have tested and some experience the
problem, some do not. I'm not sure of their system specs.

In my case the first machine had 8GB or RAM and second had 12GB of RAM
and in both cases actual RAM use by system was around 1G, leaving the
rest to be used for disk caching etc. in case it is related to having
a large amount of RAM.
