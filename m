Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab2KTBYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 20:24:00 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55925 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab2KTBX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 20:23:58 -0500
Message-ID: <50AADBA8.4090507@vlnb.net>
Date: Mon, 19 Nov 2012 20:23:52 -0500
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: Chris Friesen <chris.friesen@genband.com>
CC: Ryan Johnson <ryan.johnson@cs.utoronto.ca>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        Nico Williams <nico@cryptonector.com>, linux-fsdevel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Richard Hipp <drh@hwaci.com>
Subject: Re: [sqlite] light weight write barriers
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>	<m2fw5mtffg.fsf_-_@firstfloor.org>	<CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>	<5086F5A7.9090406@vlnb.net>	<20121025051445.GA9860@thunk.org>	<508B3EED.2080003@vlnb.net>	<20121027044456.GA2764@thunk.org>	<5090532D.4050902@vlnb.net>	<20121031095404.0ac18a4b@pyramind.ukuu.org.uk>	<5092D90F.7020105@vlnb.net>	<20121101212418.140e3a82@pyramind.ukuu.org.uk>	<50931601.4060102@symas.com>	<20121102123359.2479a7dc@pyramind.ukuu.org.uk>	<50A1C15E.2080605@vlnb.net>	<20121113174000.6457a68b@pyramind.ukuu.org.uk> <CAK3OfOgK7a9+g-KU8v5-b2d+8-vLb75kuKKQnPK-zeFV1fLmxw@mail.gmail.com> <50A442AF.9020407@vlnb.net> <50A52133.9050204@cs.utoronto.ca> <50A56E43.3040805@genband.com> <50A71A7B.3040407@vlnb.net>
In-Reply-To: <50A71A7B.3040407@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:VcMVmIowIEoxJbuobj0G4e2wcEua80B+RqBcCoT02qW
 RtgdUrIqjd6Phq9FG6TKG3+5Yenp6lQBGj4YIMI1DcUa3wvzwN
 LEyN7yHQ27or55VSymLtwpBlJiLz9RBZ98duPd5DMpYpaKV7Vn
 P5JtpLxqGzWdCSVS4V5JtaVJ1oLmOf8BHVE+XEGq5z15jCmTIN
 Yk+DpAjJbiwuf7xJknAHUbn1Gu/i8dJIW0k3xVHhddRIc34JIU
 d4qj06n+svm3+baPQCKIjKYdgSM69HXqfW3eSAgzrJzZg563Jx
 ZcjN+WGBI1sZpXmaa1lziA1k9BiuBM21kV8sj8svufOcQlTP44
 +FXmhI1UF3RSbhJtSveU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vladislav Bolkhovitin, on 11/17/2012 12:02 AM wrote:
>>> The easiest way to implement this fsync would involve three things:
>>> 1. Schedule writes for all dirty pages in the fs cache that belong to
>>> the affected file, wait for the device to report success, issue a cache
>>> flush to the device (or request ordering commands, if available) to make
>>> it tell the truth, and wait for the device to report success. AFAIK this
>>> already happens, but without taking advantage of any request ordering
>>> commands.
>>> 2. The requesting thread returns as soon as the kernel has identified
>>> all data that will be written back. This is new, but pretty similar to
>>> what AIO already does.
>>> 3. No write is allowed to enqueue any requests at the device that
>>> involve the same file, until all outstanding fsync complete [3]. This is
>>> new.
>>
>> This sounds interesting as a way to expose some useful semantics to userspace.
>>
>> I assume we'd need to come up with a new syscall or something since it doesn't
>> match the behaviour of posix fsync().
>
> This is how I would export cache sync and requests ordering abstractions to the
> user space:
>
> For async IO (io_submit() and friends) I would extend struct iocb by flags, which
> would allow to set the required capabilities, i.e. if this request is FUA, or full
> cache sync, immediate [1] or not, ORDERED or not, or all at the same time, per
> each iocb.
>
> For the regular read()/write() I would add to "flags" parameter of
> sync_file_range() one more flag: if this sync is immediate or not.
>
> To enforce ordering rules I would add one more command to fcntl(). It would make
> the latest submitted write in this fd ORDERED.

Correction. To avoid possible races better that the new fcntl() command would 
specify that N subsequent read()/write()/sync() calls as ORDERED.

For instance, in the simplest case of N=1, one next after fcntl() write() would be 
handled as ORDERED.

(Unfortunately, it doesn't look like this old read()/write() interface has space 
for a more elegant solution)

Vlad
