Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab2KQFD0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 00:03:26 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61384 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab2KQFDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 00:03:24 -0500
Message-ID: <50A71A7B.3040407@vlnb.net>
Date: Sat, 17 Nov 2012 00:02:51 -0500
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: Chris Friesen <chris.friesen@genband.com>
CC: Ryan Johnson <ryan.johnson@cs.utoronto.ca>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        Vladislav Bolkhovitin <vst@vlnb.net>,
        Nico Williams <nico@cryptonector.com>, linux-fsdevel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Richard Hipp <drh@hwaci.com>
Subject: Re: [sqlite] light weight write barriers
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>	<m2fw5mtffg.fsf_-_@firstfloor.org>	<CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>	<5086F5A7.9090406@vlnb.net>	<20121025051445.GA9860@thunk.org>	<508B3EED.2080003@vlnb.net>	<20121027044456.GA2764@thunk.org>	<5090532D.4050902@vlnb.net>	<20121031095404.0ac18a4b@pyramind.ukuu.org.uk>	<5092D90F.7020105@vlnb.net>	<20121101212418.140e3a82@pyramind.ukuu.org.uk>	<50931601.4060102@symas.com>	<20121102123359.2479a7dc@pyramind.ukuu.org.uk>	<50A1C15E.2080605@vlnb.net>	<20121113174000.6457a68b@pyramind.ukuu.org.uk> <CAK3OfOgK7a9+g-KU8v5-b2d+8-vLb75kuKKQnPK-zeFV1fLmxw@mail.gmail.com> <50A442AF.9020407@vlnb.net> <50A52133.9050204@cs.utoronto.ca> <50A56E43.3040805@genband.com>
In-Reply-To: <50A56E43.3040805@genband.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:vleKnTR5GIBd+BJspZBzohyskXu1gG1G8LwpDGf0AuB
 ceijm+XRrnWD999m/j0pIFMnP8D6XaBrYKNV+U2CNlXaOyFxvi
 96HKDLP0A+/+IcD5sdXtWjHPtpHi8lQklnqCVZYtwG58YRx2xM
 nfoRo8E5j6YTCyipmiL+N3QKs/BuhudTbZXd8h5KJOHt82SWl/
 3Lm5itldwpBu3J2VGHUHcDfYomTgHLoCKdBej+Nf4EAfU2KfK8
 k9JMg63vlji8/2K0pNQekN94ULwmLNSSUgUcUcGFsLGmDxB69L
 Hr1ba64dT81r0NzdwKdMEeZ0R+WsOM+KuUJ/MbowD6BNRdCgGj
 aGamgHO87f3Tgum+8zYM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Chris Friesen, on 11/15/2012 05:35 PM wrote:
>> The easiest way to implement this fsync would involve three things:
>> 1. Schedule writes for all dirty pages in the fs cache that belong to
>> the affected file, wait for the device to report success, issue a cache
>> flush to the device (or request ordering commands, if available) to make
>> it tell the truth, and wait for the device to report success. AFAIK this
>> already happens, but without taking advantage of any request ordering
>> commands.
>> 2. The requesting thread returns as soon as the kernel has identified
>> all data that will be written back. This is new, but pretty similar to
>> what AIO already does.
>> 3. No write is allowed to enqueue any requests at the device that
>> involve the same file, until all outstanding fsync complete [3]. This is
>> new.
>
> This sounds interesting as a way to expose some useful semantics to userspace.
>
> I assume we'd need to come up with a new syscall or something since it doesn't
> match the behaviour of posix fsync().

This is how I would export cache sync and requests ordering abstractions to the 
user space:

For async IO (io_submit() and friends) I would extend struct iocb by flags, which 
would allow to set the required capabilities, i.e. if this request is FUA, or full 
cache sync, immediate [1] or not, ORDERED or not, or all at the same time, per 
each iocb.

For the regular read()/write() I would add to "flags" parameter of 
sync_file_range() one more flag: if this sync is immediate or not.

To enforce ordering rules I would add one more command to fcntl(). It would make 
the latest submitted write in this fd ORDERED.

All together those should provide the requested functionality in a simple, 
effective, unambiguous and backward compatible manner.

Vlad

1. See my other today's e-mail about what is immediate cache sync.
