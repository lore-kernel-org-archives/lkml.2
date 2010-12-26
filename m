Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab0LZXF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 18:05:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56710 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab0LZXF0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 18:05:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=NedzqGVehVaxSl1JvHbFAy+OJlup9XmiMUbInc8O7r+4drKvWzValmabEnbfHP0XKI
         FDyVRN+KBp9NdLHN4f0hysCpoMvEmGIBFjQAV5SHnukUiTI9nXPXSmehXMenrmcnNbk+
         Mr0s4+Hmj+xFq+5h7kC2K4RHl4nGVwxSTt+B0=
MIME-Version: 1.0
In-Reply-To: <20101224114008.GL30941@bitwizard.nl>
References: <AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com>
 <20101222104306.GB30941@bitwizard.nl> <x49aajxsrh3.fsf@segfault.boston.devel.redhat.com>
 <20101222224416.GE30941@bitwizard.nl> <x494oa48scp.fsf@segfault.boston.devel.redhat.com>
 <20101223170109.GA31591@bitwizard.nl> <x49bp4c7555.fsf@segfault.boston.devel.redhat.com>
 <AANLkTikbhzopmyfbJuHUQdEBJLLP9e65n0cNBuUjhDdd@mail.gmail.com>
 <4D139EAE.9090307@jcz.nl> <AANLkTimXCb00Hj1iPG5XKdfSmvQCwtw1Oo7Qr14ZR=Ge@mail.gmail.com>
 <20101224114008.GL30941@bitwizard.nl>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Sun, 26 Dec 2010 18:05:05 -0500
Message-ID: <AANLkTi=e4aXeSSqCPRo4-t6j1GeW7Dj7hecHDK9KxhJ9@mail.gmail.com>
Subject: Re: Slow disks.
To: Rogier Wolff <R.E.Wolff@bitwizard.nl>
Cc: Jaap Crezee <jaap@jcz.nl>, Jeff Moyer <jmoyer@redhat.com>,
        =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 6:40 AM, Rogier Wolff <R.E.Wolff@bitwizard.nl> wrote:
> On Thu, Dec 23, 2010 at 05:09:43PM -0500, Greg Freemyer wrote:
>> On Thu, Dec 23, 2010 at 2:10 PM, Jaap Crezee <jaap@jcz.nl> wrote:
>> > On 12/23/10 19:51, Greg Freemyer wrote:
>> >> On Thu, Dec 23, 2010 at 12:47 PM, Jeff Moyer<jmoyer@redhat.com>  wrote:
>> >> I suspect a mailserver on a raid 5 with large chunksize could be a lot
>> >> worse than 2x slower.  But most of the blame is just raid 5.
>> >
>> > Hmmm, well if this really is so.. I use raid 5 to not "spoil" the storage
>> > space of one disk. I am using some other servers with raid 5 md's which
>> > seems to be running just fine; even under higher load than the machine we
>> > are talking about.
>> >
>> > Looking at the vmstat block io the typical load (both write and read) seems
>> > to be less than 20 blocks per second. Will this drop the performance of the
>> > array (measured by dd if=/dev/md<x> of=/dev/null bs=1M) below 3MB/secs?
>> >
>>
>> You clearly have problems more significant than your raid choice, but
>> hopefully you will find the below informative anyway.
>>
>> ====
>>
>> The above is a meaningless performance tuning test for a email server,
>> but assuming it was a useful test for you:
>>
>> With bs=1MB you should have optimum performance with a 3-disk raid5
>> and 512KB chunks.
>>
>> The reason is that a full raid stripe for that is 1MB  (512K data +
>> 512K data + 512K parity = 1024K data)
>>
>> So the raid software should see that as a full stripe update and not
>> have to read in any of the old data.
>>
>> Thus at the kernel level it is just:
>>
>> write data1 chunk
>> write data2 chunk
>> write parity chunk
>>
>> All those should happen in parallel, so a raid 5 setup for 1MB writes
>> is actually just about optimal!
>
> You are assuming that the kernel is blind and doesn't do any
> readaheads. I've done some tests and even when I run dd with a
> blocksize of 32k, the average request sizes that are hitting the disk
> are about 1000k (or 1000 sectors I don't know what units that column
> are in when I run with -k option).

dd is not a benchmark tool.

You are building a email server that does 4KB random writes.
Performance testing / tuning with dd is of very limited use.

For your load, read ahead is pretty much useless!


> So your argument that "it fits exactly when your blocksize is 1M, so
> it is obvious that 512k blocksizes are optimal" doesn't hold water.

If you were doing a real i/o benchmark, then 1MB random writes
perfectly aligned to the Raid stripes would be perfect.  Raid really
needs to be designed around the i/o pattern, not just optimizing dd.

<snip>

>> Anything smaller than a 1 stripe write is where the issues occur,
>> because then you have the read-modify-write cycles.
>
> Yes. But still they shouldn't be as heavy as we are seeing.  Besides
> doing the "big searches" on my 8T array, I also sometimes write "lots
> of small files". I'll see how many I can mange on that server....

<snip>
>
> You're repeating what WD says about their enterprise drives versus
> desktop drives. I'm pretty sure that they believe what they are saying
> to be true. And they probably have done tests to see support for their
> theory. But for Linux it simply isn't true.

What kernel are you talking about.  mdraid has seen major improvements
in this area in the last 2 o3 years or so.  Are you using a old kernel
by chance?  Or reading old reviews?

> We see MUCH too often raid arrays that lose a drive evict it from the
> RAID and everything keeps on working, so nobody wakes up. Only after a
> second drive fails, things stop working and the datarecovery company
> gets called into action. Often we have a drive with a few bad blocks
> and months-old data, and a totally failed drive which is neccesary for
> a full recovery. It's much better to keep the failed/failing drive in
> the array and up-to-date during the time that you're pushing the
> operator to get it replaced.
>
>        Roger.

The linux-raid mailing list is very helpful.  If you're seeing
problems, ask for help there.

What your describing simply sounds wrong.  (At least for mdraid, which
is what I assume you are using.)

Greg
