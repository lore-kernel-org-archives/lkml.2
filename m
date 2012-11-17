Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442Ab2KQFCs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 00:02:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57006 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab2KQFCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 00:02:47 -0500
Message-ID: <50A71A70.5050007@vlnb.net>
Date: Sat, 17 Nov 2012 00:02:40 -0500
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: David Lang <david@lang.hm>
CC: Nico Williams <nico@cryptonector.com>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Richard Hipp <drh@hwaci.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [sqlite] light weight write barriers
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com> <m2fw5mtffg.fsf_-_@firstfloor.org> <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com> <5086F5A7.9090406@vlnb.net> <20121025051445.GA9860@thunk.org> <508B3EED.2080003@vlnb.net> <20121027044456.GA2764@thunk.org> <5090532D.4050902@vlnb.net> <20121031095404.0ac18a4b@pyramind.ukuu.org.uk> <5092D90F.7020105@vlnb.net> <20121101212418.140e3a82@pyramind.ukuu.org.uk> <50931601.4060102@symas.com> <20121102123359.2479a7dc@pyramind.ukuu.org.uk> <50A1C15E.2080605@vlnb.net> <20121113174000.6457a68b@pyramind.ukuu.org.uk> <CAK3OfOgK7a9+g-KU8v5-b2d+8-vLb75kuKKQnPK-zeFV1fLmxw@mail.gmail.com> <50A442AF.9020407@vlnb.net> <alpine.DEB.2.02.1211150353080.32408@nftneq.ynat.uz>
In-Reply-To: <alpine.DEB.2.02.1211150353080.32408@nftneq.ynat.uz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:ZEMpMgELOxK81tGYfFr4Fo2t4qQKdy6260lTXWYAhO1
 OlvCSKHQXb5pzvwMIqf/da0odXI5u79LNV7AxaVky3S6QCvay3
 wexC0en1GyKFtTynnx+qlP4shXndfXnIr8CZlPU8/ZseNyCC72
 h1zgI4phF0lxARd/bxnP5ohdNQbi0GMgXNP1XLEbvsZBGVHHbi
 LWSseY7CiLutDq6XPfK8YHWBIjBu1+ONOALfXXri5H5xwsUPhh
 vec+wn57gOGI7yLEGHE3WlN3vTkIeDxkQOj/ZDHBrH+Qt1e9SK
 LLLEMJ5vN0N7+CZCkWSiaMc1JohtO3fP5b/T4tRfHpWFJTjfQc
 PgPpgKR3egYL6FFBZ2NA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Lang, on 11/15/2012 07:07 AM wrote:
>> There's no such thing as "barrier". It is fully artificial abstraction. After
>> all, at the bottom of your stack, you will have to translate it either to cache
>> flush, or commands order enforcement, or both.
>
> When people talk about barriers, they are talking about order enforcement.

Not correct. When people are talking about barriers, they are meaning different 
things. For instance, Alan Cox few e-mails ago was meaning cache flush.

That's the problem with the barriers concept: barriers are ambiguous. There's no 
barrier which can fit all requirements.

> the hardware capabilities are not directly accessable from userspace (and they
> probably shouldn't be)

The discussion is not about to directly provide storage hardware capabilities to 
the user space. The discussion is to replace fully inadequate barriers 
abstractions to a set of other, adequate abstractions.

For instance:

1. Cache flush primitives:

1.1. FUA

1.2. Non-immediate cache flush, i.e. don't return until all data hit non-volatile 
media

1.3. Immediate cache flush, i.e. return ASAP after the cache sync started, 
possibly before all data hit non-volatile media.

2. ORDERED attribute for requests. It provides the following behavior rules:

A.  All requests without this attribute can be executed in parallel and be freely 
reordered.

B. No ORDERED command can be completed before any previous not-ORDERED or ORDERED 
command completed.

Those abstractions can naturally fit all storage capabilities. For instance:

  - On simple WT cache hardware not supporting ordering commands, (1) translates 
to NOP and (2) to queue draining.

  - On full features HW, both (1) and (2) translates to the appropriate storage 
capabilities.

On FTL storage (B) can be further optimized by doing data transfers for ORDERED 
commands in parallel, but commit them in the requested order.

> barriers keep getting mentioned because they are a easy concept to understand.

Well, concept of flat Earth and Sun rotating around it is also easy to understand. 
So, why isn't it used?

Vlad
