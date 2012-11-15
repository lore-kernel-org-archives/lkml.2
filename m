Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767632Ab2KOMIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 07:08:05 -0500
Received: from mail.lang.hm ([64.81.33.126]:58309 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993257Ab2KOMID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 07:08:03 -0500
Date: Thu, 15 Nov 2012 04:07:17 -0800 (PST)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Vladislav Bolkhovitin <vst@vlnb.net>
cc: Nico Williams <nico@cryptonector.com>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Richard Hipp <drh@hwaci.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [sqlite] light weight write barriers
In-Reply-To: <50A442AF.9020407@vlnb.net>
Message-ID: <alpine.DEB.2.02.1211150353080.32408@nftneq.ynat.uz>
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com> <m2fw5mtffg.fsf_-_@firstfloor.org> <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com> <5086F5A7.9090406@vlnb.net> <20121025051445.GA9860@thunk.org>
 <508B3EED.2080003@vlnb.net> <20121027044456.GA2764@thunk.org> <5090532D.4050902@vlnb.net> <20121031095404.0ac18a4b@pyramind.ukuu.org.uk> <5092D90F.7020105@vlnb.net> <20121101212418.140e3a82@pyramind.ukuu.org.uk> <50931601.4060102@symas.com>
 <20121102123359.2479a7dc@pyramind.ukuu.org.uk> <50A1C15E.2080605@vlnb.net> <20121113174000.6457a68b@pyramind.ukuu.org.uk> <CAK3OfOgK7a9+g-KU8v5-b2d+8-vLb75kuKKQnPK-zeFV1fLmxw@mail.gmail.com> <50A442AF.9020407@vlnb.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012, Vladislav Bolkhovitin wrote:

> Nico Williams, on 11/13/2012 02:13 PM wrote:
>> declaring groups of internally-unordered writes where the groups are
>> ordered with respect to each other... is practically the same as
>> barriers.
>
> Which barriers? Barriers meaning cache flush or barriers meaning commands 
> order, or barriers meaning both?
>
> There's no such thing as "barrier". It is fully artificial abstraction. After 
> all, at the bottom of your stack, you will have to translate it either to 
> cache flush, or commands order enforcement, or both.

When people talk about barriers, they are talking about order enforcement.

> Your mistake is that you are considering barriers as something real, which 
> can do something real for you, while it is just a artificial abstraction 
> apparently invented by people with limited knowledge how storage works, hence 
> having very foggy vision how barriers supposed to be processed by it. A 
> simple wrong answer.
>
> Generally, you can invent any abstraction convenient for you, but farther 
> your abstractions from reality of your hardware => less you will get from it 
> with bigger effort.
>
> There are no barriers in Linux and not going to be. Accept it. And start 
> instead thinking about offload capabilities your storage can offer to you.

the hardware capabilities are not directly accessable from userspace (and they 
probably shouldn't be)

barriers keep getting mentioned because they are a easy concept to understand. 
"do this set of stuff before doing any of this other set of stuff, but I don't 
care when any of this gets done" and they fit well with the requirements of the 
users.

Users readily accept that if the system crashes, they will loose the most recent 
stuff that they did, but they get annoyed when things get corrupted to the point 
that they loose the entire file.

this includes things like modifying one option and a crash resulting in the 
config file being blank. Yes, you can do the 'write to temp file, sync file, 
sync directory, rename file" dance, but the fact that to do so the user must sit 
and wait for the syncs to take place can be a problem. It would be far better to 
be able to say "write to temp file, and after it's on disk, rename the file" and 
not have the user wait. The user doesn't really care if the changes hit disk 
immediately, or several seconds (or even 10s of seconds) later, as long as there 
is not any possibility of the rename hitting disk before the file contents.

The fact that this could be implemented in multiple ways in the existing 
hardware does not mean that there need to be multiple ways exposed to userspace, 
it just means that the cost of doing the operation will vary depending on the 
hardware that you have. This also means that if new hardware introduces a new 
way of implementing this, that improvement can be passed on to the users without 
needing application changes.

David Lang
