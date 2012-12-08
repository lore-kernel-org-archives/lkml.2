Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab2LHVWP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 16:22:15 -0500
Received: from mxout2.iskon.hr ([213.191.128.81]:59832 "EHLO mxout2.iskon.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab2LHVWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 16:22:14 -0500
X-Remote-IP: 213.191.128.133
Date: Sat, 08 Dec 2012 22:22:08 +0100
From: Zlatko Calusic <zlatko.calusic@iskon.hr>
Organization: Iskon Internet d.d.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Icedove/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20121128145215.d23aeb1b.akpm@linux-foundation.org> <20121128235412.GW8218@suse.de> <50B77F84.1030907@leemhuis.info> <20121129170512.GI2301@cmpxchg.org> <50B8A8E7.4030108@leemhuis.info> <20121201004520.GK2301@cmpxchg.org> <50BC6314.7060106@leemhuis.info> <20121203194208.GZ24381@cmpxchg.org> <20121204214210.GB20253@cmpxchg.org> <20121205030133.GA17438@wolff.to> <20121206173742.GA27297@wolff.to> <CA+55aFzZsCUk6snrsopWQJQTXLO__G7=SjrGNyK3ePCEtZo7Sw@mail.gmail.com> <50C32D32.6040800@iskon.hr>
In-Reply-To: <50C32D32.6040800@iskon.hr>
Message-ID: <50C3AF80.8040700@iskon.hr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: kswapd craziness in 3.7
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45/RELEASE,
	 bases: 20121208 #8655652, check: 20121208 clean
X-SpamTest-Envelope-From: zlatko.calusic@iskon.hr
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 40039 [Dec 09 2012]
X-SpamTest-Method: none
X-SpamTest-Rate: 0
X-SpamTest-SPF: none
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.12.2012 13:06, Zlatko Calusic wrote:
> On 06.12.2012 20:31, Linus Torvalds wrote:
>> Ok, people seem to be reporting success.
>>
>> I've applied Johannes' last patch with the new tested-by tags.
>>
>
> I've been testing this patch since it was applied, and it certainly
> fixes the kswapd craziness issue, good work Johannes!
>
> But, it's still not perfect yet, because I see that the system keeps
> lots of memory unused (free), where it previously used it all for the
> page cache (there's enough fs activity to warrant it).
>
> I'm now testing the last piece of Johannes' changes (still not in git
> tree), and can report results in 24-48 hours.
>
> Regards,

Or sooner... in short: nothing's changed!

On a 4GB RAM system, where applications use close to 2GB, kswapd likes 
to keep around 1GB free (unused), leaving only 1GB for page/buffer 
cache. If I force bigger page cache by reading a big file and thus use 
the unused 1GB of RAM, kswapd will soon (in a matter of minutes) evict 
those (or other) pages out and once again keep unused memory close to 1GB.

I guess it's not a showstopper, but it still counts as a very bad memory 
management, wasting lots of RAM.

As an additional data point, if memory pressure is slightly higher (say 
backup kicks in, keeping page cache mostly full) kswapd gets in D 
(uninterruptible sleep) state (function: congestion_wait) and load 
average goes up by 1. It recovers only when it successfully throws out 
half of page cache again.

Hope it helps.
-- 
Zlatko
