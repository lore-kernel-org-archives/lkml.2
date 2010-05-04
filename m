Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935Ab0EDSAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 14:00:49 -0400
Received: from mail-pz0-f186.google.com ([209.85.222.186]:34217 "EHLO
	mail-pz0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243Ab0EDSAs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 14:00:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xxQZhdSwW5Rufp2ji6Y1PYIrgWkOCMvNWx6JGc6uFuCAV3SJQT5W5R3Yy3DVve03Z3
         +aptb7kOX6CxZL5/YXPXzhbSqzEFtSR0ZA/G5IApRsLxXh7osmZRUy/2fhk9eeMJxVsM
         y6xkgs0W76/ti5YQa7d7nt8yzmyvyjOR6jiB0=
MIME-Version: 1.0
In-Reply-To: <u2m58965d8a1005041034h72605714z46a1a1e06eccc86c@mail.gmail.com>
References: <n2i9b1675091005032052wd935041ew5d96f145309af801@mail.gmail.com>
	 <u2m58965d8a1005041034h72605714z46a1a1e06eccc86c@mail.gmail.com>
Date: Tue, 4 May 2010 12:00:46 -0600
Message-ID: <s2i9b1675091005041100l471e04c3o83551fc947ce587e@mail.gmail.com>
Subject: Re: Flash IO slow 1.5 MB/s
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Paul Hartman <paul.hartman+linux@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 4, 2010 at 11:34 AM, Paul Hartman
<paul.hartman+linux@gmail.com> wrote:
> On Mon, May 3, 2010 at 10:52 PM, Trenton D. Adams
> <trenton.d.adams@gmail.com> wrote:
>> It really looks like there's a scheduling issue.  It seems as if the
>> system is IO thrashing on the flash drive, and bounces all over the
>> place in terms of performance.  Sometimes it's really low, like the
>> 2.73M/s, and other times it's really fast, like the 28.86M/s.
>> Although you can't see it there, there were times when rsync was
>> registering 200kb/s.  None of them are "really" accurate, as
>> everything is queued for writing, but the final results of 1.5M/s
>> (calculated from the "real" time) is terrible.
>
> I have a similar experience (posted to this list a few months ago)
> with mounting a flash device (mobile phone) in USB mass storage mode.
> When I/O scheduler for that device is CFQ, write performance is really
> terrible. When I change the scheduler to deadline, performance is
> several times better. In 2.6.32 pdflush was replaced and CFQ
> performance saw a 4x increase but still far too slow.
>
> CFQ in <=2.6.31: 450KB/sec
> CFQ in >=2.6.32: 2MB/sec
> Deadline in all: 17MB/sec
>
> I didn't try anything with dirty_bytes.
>
> FWIW :)

Oops, my message didn't reach the LKML, sorry for the spam Paul.

I switched to deadline and dirty_ratio 20 for my flash device, and I
am seeing VERY slow performance as well.  I get a lot of freezing up
of rsync, where the progress just stops (visually anyhow), which is
the same as what I see with cfq.  However, it's not 14 minutes as it
was in my original email...

[11:44 trenta@tdanotebook web] $ time rsync -v --progress
/home/share/DVD/*.avi /media/disk/
facing-the-giants.avi
  709911016 100%    5.49MB/s    0:02:03 (xfer#1, to-check=1/2)
jonah.avi
  621254748 100%   15.97MB/s    0:00:37 (xfer#2, to-check=0/2)

sent 1331328404 bytes  received 50 bytes  4430377.55 bytes/sec
total size is 1331165764  speedup is 1.00

real    4m59.657s
user    0m8.553s
sys     0m9.501s


with dirty_bytes 16000000, I still get twice the speed out of deadline.

[11:53 trenta@tdanotebook web] $ time rsync -v --progress
/home/share/DVD/*.avi /media/disk/
facing-the-giants.avi
  709911016 100%    7.62MB/s    0:01:28 (xfer#1, to-check=1/2)
jonah.avi
  621254748 100%    7.64MB/s    0:01:17 (xfer#2, to-check=0/2)

sent 1331328404 bytes  received 50 bytes  7948229.58 bytes/sec
total size is 1331165764  speedup is 1.00

real    2m47.244s
user    0m8.429s
sys     0m9.377s


So, perhaps it's a combination of the schedulers and something else in
the kernel?  And perhaps, CFQ just amplifies something else in the
kernel, more than deadline does?
