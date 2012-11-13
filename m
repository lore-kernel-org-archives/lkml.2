Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab2KMDl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 22:41:26 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57613 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2KMDlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 22:41:25 -0500
Message-ID: <50A1C15E.2080605@vlnb.net>
Date: Mon, 12 Nov 2012 22:41:18 -0500
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Howard Chu <hyc@symas.com>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        Vladislav Bolkhovitin <vst@vlnb.net>, "Theodore Ts'o" <tytso@mit.edu>,
        drh@hwaci.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [sqlite] light weight write barriers
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>	<m2fw5mtffg.fsf_-_@firstfloor.org>	<CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>	<5086F5A7.9090406@vlnb.net>	<20121025051445.GA9860@thunk.org>	<508B3EED.2080003@vlnb.net>	<20121027044456.GA2764@thunk.org>	<5090532D.4050902@vlnb.net>	<20121031095404.0ac18a4b@pyramind.ukuu.org.uk>	<5092D90F.7020105@vlnb.net>	<20121101212418.140e3a82@pyramind.ukuu.org.uk>	<50931601.4060102@symas.com> <20121102123359.2479a7dc@pyramind.ukuu.org.uk>
In-Reply-To: <20121102123359.2479a7dc@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:Pwtxbw38h/cNoBenDxBgJBNn/ofqNTFPM6PGFGoiuT6
 9NRdzhq7eLoYzD4kdhjHLlEZO8QLWs6HIc1v1HNGhAlqT6D8fx
 iDUR6nBywSzoO2XH52AXrmB0uNEMrTHZgZRZJM64DMCjcWa/jn
 6aInywd1cTsEJLeM1MTxUhg7KSuQypIXGVkakKGz5j+LT9mCYo
 sx51TJ3KKxs9D4bHR7jKNeViGpXeZvQJ2+o4BEMy31zDe/AxcP
 9DO+q/nWx/oW7GpDZGjvvcoHE6Y4/cKzUZZC3935wRu0bt4NfP
 YXx/f07ZjjgWd+sdS1BVOEqQLkfnyvxurufUnb3pgR5fPOdKEy
 TSefRahMmCRzxX1AQqGg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alan Cox, on 11/02/2012 08:33 AM wrote:
>>     b) most drives will internally re-order requests anyway
>
> They will but only as permitted by the commands queued, so you have some
> control depending upon the interface capabilities.
>
>>     c) cheap drives won't support barriers
>
> Barriers are pretty much universal as you need them for power off !

I'm afraid, no storage (drives, if you like this term more) at the moment supports 
barriers and, as far as I know the storage history, has never supported.

Instead, what storage does support in this area are:

1. Cache flushing facilities: FUA, SYNCHRONIZE CACHE, etc.

2. Commands ordering facilities: commands attributes (ORDERED, SIMPLE, etc.), ACA, 
etc.

3. Atomic commands, e.g. scattered writes, which allow to write data in several 
separate not adjacent  blocks in an atomic manner, i.e. guarantee that either all 
blocks are written or none at all. This is a relatively new functionality, natural 
for flash storage with its COW internals.

Obviously, using such atomic write commands, an application or a file system don't 
need any journaling anymore. FusionIO reported that after they modified MySQL to 
use them, they had 50% performance increase.


Note, that those 3 facilities are ORTHOGONAL, i.e. can be used independently, 
including on the same request. That is the root cause why barrier concept is so 
evil. If you specify a barrier, how can you say what kind actual action you really 
want from the storage: cache flush? Or ordered write? Or both?

This is why relatively recent removal of barriers from the Linux kernel 
(http://lwn.net/Articles/400541/) was a big step ahead. The next logical step 
should be to allow ORDERED attribute for requests be accelerated by ORDERED 
commands of the storage, if it supports them. If not, fall back to the existing 
queue draining.

Actually, I'm wondering, why barriers concept is so sticky in the Linux world? A 
simple Google search shows that only Linux uses this concept for storage. And 2 
years passed, since they were removed from the kernel, but people still discuss 
barriers as if they are here.

Vlad
