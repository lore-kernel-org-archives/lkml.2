Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab2KPTPD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:15:03 -0500
Received: from mail.lang.hm ([64.81.33.126]:58946 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193Ab2KPTPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:15:00 -0500
Date: Fri, 16 Nov 2012 11:14:08 -0800 (PST)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Howard Chu <hyc@symas.com>
cc: General Discussion of SQLite Database <sqlite-users@sqlite.org>,
        Vladislav Bolkhovitin <vst@vlnb.net>, "Theodore Ts'o" <tytso@mit.edu>,
        Richard Hipp <drh@hwaci.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [sqlite] light weight write barriers
In-Reply-To: <50A65681.8000204@symas.com>
Message-ID: <alpine.DEB.2.02.1211161100260.25984@nftneq.ynat.uz>
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com> <m2fw5mtffg.fsf_-_@firstfloor.org> <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com> <5086F5A7.9090406@vlnb.net> <20121025051445.GA9860@thunk.org>
 <508B3EED.2080003@vlnb.net> <20121027044456.GA2764@thunk.org> <5090532D.4050902@vlnb.net> <20121031095404.0ac18a4b@pyramind.ukuu.org.uk> <5092D90F.7020105@vlnb.net> <20121101212418.140e3a82@pyramind.ukuu.org.uk> <50931601.4060102@symas.com>
 <20121102123359.2479a7dc@pyramind.ukuu.org.uk> <50A1C15E.2080605@vlnb.net> <20121113174000.6457a68b@pyramind.ukuu.org.uk> <CAK3OfOgK7a9+g-KU8v5-b2d+8-vLb75kuKKQnPK-zeFV1fLmxw@mail.gmail.com> <50A442AF.9020407@vlnb.net> <alpine.DEB.2.02.1211150353080.32408@nftneq.ynat.uz>
 <50A65681.8000204@symas.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2012, Howard Chu wrote:

> David Lang wrote:
>> barriers keep getting mentioned because they are a easy concept to 
>> understand.
>> "do this set of stuff before doing any of this other set of stuff, but I 
>> don't
>> care when any of this gets done" and they fit well with the requirements of 
>> the
>> users.
>> 
>> Users readily accept that if the system crashes, they will loose the most 
>> recent
>> stuff that they did,
>
> *some* users may accept that. *None* should.

when users are given a choice of having all their work be very slow, or have it 
be fast, but in the unlikely event of a crash they loose their mose recent 
changes, they are willing to loose their most recent changes.

If you think about it, this is not much different from the fact that you loose 
all changes since the last time you saved the thing you are working on. Many 
programs save state periodically so that if the application crashes the user 
hasn't lost everything, but any application that tried to save after every 
single change would be so slow that nobody would use it.

There is always going to be a window after a user hits 'save' where the data can 
be lost, because it's not yet on disk.

> There are a couple industry failures here:
>
> 1) the drive manufacturers sell drives that lie, and consumers accept it 
> because they don't know better. We programmers, who know better, have failed 
> to raise a stink and demand that this be fixed.
>  A) Drives should not lose data on power failure. If a drive accepts a write 
> request and says "OK, done" then that data should get written to stable 
> storage, period. Whether it requires capacitors or some other onboard power 
> supply, or whatever, they should just do it. Keep in mind that today, most of 
> the difference between enterprise drives and consumer desktop drives is just 
> a firmware change, that hardware is already identical. Nobody should accept a 
> product that doesn't offer this guarantee. It's inexcusable.

This is an option to you. However if you have enabled write caching and 
reordering, you have explicitly told the system to be faster at the expense of 
loosing data under some conditions. The fact that you then loose data under 
those conditions should not surprise you.

The idea that you must have enough power to write all the pending data to disk 
is problematic as that then severely limits the amount of cache that you have.

>  B) it should go without saying - drives should reliably report back to the 
> host, when something goes wrong. E.g., if a write request has been accepted, 
> cached, and reported complete, but then during the actual write an ECC 
> failure is detected in the cacheline, the drive needs to tell the host "oh by 
> the way, block XXX didn't actually make it to disk like I told you it did 
> 10ms ago."

The issue isn't a drive having a write error, it's the system shutting down 
(or crashing) before the data is written, no OS level tricks will help you here.


The real problem here isn't the drive claiming the data has been written when it 
hasn't, the real problem is that the application has said 'write this data' to 
the OS, and the OS has not done so yet.

The OS delays the writes for many legitimate reasons (the disk may be busy, it 
can get things done more efficently by combining and reordering the writes, etc)

Unless the system crashes, this is not a problem, the data will eventually be 
written out, and on system shutdown everthing is good.

But if the system crashes, some of this postphoned work doesn't get done, and 
that can be a problem.

Applications can do fsync if they want to be sure that their data is safe on 
disk NOW, but they currently have no way of saying "I want to make sure that A 
happens before B, but I don't care if A happens now or 10 seconds from now"

That is the gap that it would be useful to provide a mechanism to deal with, and 
it doesn't matter what your disk system does in terms of lieing ot not, there 
still isn't a way to deal with this today.

David Lang
