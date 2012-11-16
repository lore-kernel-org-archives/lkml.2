Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab2KPPzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:55:06 -0500
Received: from lirone.symas.net ([64.71.152.235]:43290 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514Ab2KPPzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:55:05 -0500
Message-ID: <50A661D0.4030200@symas.com>
Date: Fri, 16 Nov 2012 07:54:56 -0800
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/19.0 Firefox/19.0 SeaMonkey/2.16a1
MIME-Version: 1.0
To: Ric Wheeler <rwheeler@redhat.com>
CC: General Discussion of SQLite Database <sqlite-users@sqlite.org>,
        David Lang <david@lang.hm>, Vladislav Bolkhovitin <vst@vlnb.net>,
        "Theodore Ts'o" <tytso@mit.edu>, Richard Hipp <drh@hwaci.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [sqlite] light weight write barriers
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com> <m2fw5mtffg.fsf_-_@firstfloor.org> <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com> <5086F5A7.9090406@vlnb.net> <20121025051445.GA9860@thunk.org> <508B3EED.2080003@vlnb.net> <20121027044456.GA2764@thunk.org> <5090532D.4050902@vlnb.net> <20121031095404.0ac18a4b@pyramind.ukuu.org.uk> <5092D90F.7020105@vlnb.net> <20121101212418.140e3a82@pyramind.ukuu.org.uk> <50931601.4060102@symas.com> <20121102123359.2479a7dc@pyramind.ukuu.org.uk> <50A1C15E.2080605@vlnb.net> <20121113174000.6457a68b@pyramind.ukuu.org.uk> <CAK3OfOgK7a9+g-KU8v5-b2d+8-vLb75kuKKQnPK-zeFV1fLmxw@mail.gmail.com> <50A442AF.9020407@vlnb.net> <alpine.DEB.2.02.1211150353080.32408@nftneq.ynat.uz> <50A65681.8000204@symas.com> <50A65C68.6080001@redhat.com>
In-Reply-To: <50A65C68.6080001@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ric Wheeler wrote:
> On 11/16/2012 10:06 AM, Howard Chu wrote:
>> David Lang wrote:
>>> barriers keep getting mentioned because they are a easy concept to understand.
>>> "do this set of stuff before doing any of this other set of stuff, but I don't
>>> care when any of this gets done" and they fit well with the requirements of the
>>> users.
>>>
>>> Users readily accept that if the system crashes, they will loose the most recent
>>> stuff that they did,
>>
>> *some* users may accept that. *None* should.
>>
>>> but they get annoyed when things get corrupted to the point
>>> that they loose the entire file.
>>>
>>> this includes things like modifying one option and a crash resulting in the
>>> config file being blank. Yes, you can do the 'write to temp file, sync file,
>>> sync directory, rename file" dance, but the fact that to do so the user must sit
>>> and wait for the syncs to take place can be a problem. It would be far better to
>>> be able to say "write to temp file, and after it's on disk, rename the file" and
>>> not have the user wait. The user doesn't really care if the changes hit disk
>>> immediately, or several seconds (or even 10s of seconds) later, as long as there
>>> is not any possibility of the rename hitting disk before the file contents.
>>>
>>> The fact that this could be implemented in multiple ways in the existing
>>> hardware does not mean that there need to be multiple ways exposed to userspace,
>>> it just means that the cost of doing the operation will vary depending on the
>>> hardware that you have. This also means that if new hardware introduces a new
>>> way of implementing this, that improvement can be passed on to the users without
>>> needing application changes.
>>
>> There are a couple industry failures here:
>>
>> 1) the drive manufacturers sell drives that lie, and consumers accept it
>> because they don't know better. We programmers, who know better, have failed
>> to raise a stink and demand that this be fixed.
>>    A) Drives should not lose data on power failure. If a drive accepts a write
>> request and says "OK, done" then that data should get written to stable
>> storage, period. Whether it requires capacitors or some other onboard power
>> supply, or whatever, they should just do it. Keep in mind that today, most of
>> the difference between enterprise drives and consumer desktop drives is just a
>> firmware change, that hardware is already identical. Nobody should accept a
>> product that doesn't offer this guarantee. It's inexcusable.
>>    B) it should go without saying - drives should reliably report back to the
>> host, when something goes wrong. E.g., if a write request has been accepted,
>> cached, and reported complete, but then during the actual write an ECC failure
>> is detected in the cacheline, the drive needs to tell the host "oh by the way,
>> block XXX didn't actually make it to disk like I told you it did 10ms ago."
>>
>> If the entire software industry were to simply state "your shit stinks and
>> we're not going to take it any more" the hard drive industry would have no
>> choice but to fix it. And in most cases it would be a zero-cost fix for them.
>>
>> Once you have drives that are actually trustworthy, actually reliable (which
>> doesn't mean they never fail, it only means they tell the truth about
>> successes or failures), most of these other issues disappear. Most of the need
>> for barriers disappear.
>>
>
> I think that you are arguing a fairly silly point.

Seems to me that you're arguing that we should accept inferior technology. 
Who's really being silly?

> If you want that behaviour, you have had it for more than a decade - simply
> disable the write cache on your drive and you are done.

You seem to believe it's nonsensical for someone to want both fast and 
reliable writes, or that it's unreasonable for a storage device to offer the 
same, cheaply. And yet it is clearly trivial to provide all of the above.

> If you - as a user - want to run faster and use applications that are coded to
> handle data integrity properly (fsync, fdatasync, etc), leave the write cache
> enabled and use file system barriers.

Applications aren't supposed to need to worry about such details, that's why 
we have operating systems.

Drives should tell the truth. In event of an error detected after the fact, 
the drive should report the error back to the host. There's nothing 
nonsensical there.

When a drive's cache is enabled, the host should maintain a queue of written 
pages, of a length equal to the size of the drive's cache. If a drive says 
"hey, block XXX failed" the OS can reissue the write from its own queue. No 
muss, no fuss, no performance bottlenecks. This is what Real Computers did 
before the age of VAX Unix.

> Everyone has to trade off cost versus something else and this is a very, very
> long standing trade off that drive manufacturers have made.

With the cost of storage falling as rapidly as it has in recent years, this is 
a stupid tradeoff.

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
