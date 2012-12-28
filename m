Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab2L1N3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 08:29:22 -0500
Received: from mxout2.iskon.hr ([213.191.128.81]:51327 "EHLO mxout2.iskon.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab2L1N3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 08:29:19 -0500
X-Remote-IP: 213.191.128.133
Date: Fri, 28 Dec 2012 14:29:11 +0100
From: Zlatko Calusic <zlatko.calusic@iskon.hr>
Organization: Iskon Internet d.d.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Icedove/17.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhouping Liu <zliu@redhat.com>, Sedat Dilek <sedat.dilek@gmail.com>
References: <50D24AF3.1050809@iskon.hr> <20121220111208.GD10819@suse.de> <20121220125802.23e9b22d.akpm@linux-foundation.org> <50D601C9.9060803@iskon.hr> <50D71166.6030608@iskon.hr> <50DB129E.7010000@iskon.hr> <50DD0106.7040001@iskon.hr> <20121228024928.GA19720@blaptop>
In-Reply-To: <20121228024928.GA19720@blaptop>
X-Spam-Score: ##
Message-ID: <50DD9EA7.6050309@iskon.hr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm: fix null pointer dereference in wait_iff_congested()
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45/RELEASE,
	 bases: 20121228 #8908331, check: 20121228 clean
X-SpamTest-Envelope-From: zlatko.calusic@iskon.hr
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 40824 [Dec 28 2012]
X-SpamTest-Method: none
X-SpamTest-Rate: 0
X-SpamTest-SPF: none
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.12.2012 03:49, Minchan Kim wrote:
> Hello Zlatko,
>
> On Fri, Dec 28, 2012 at 03:16:38AM +0100, Zlatko Calusic wrote:
>> From: Zlatko Calusic <zlatko.calusic@iskon.hr>
>>
>> The unintended consequence of commit 4ae0a48b is that
>> wait_iff_congested() can now be called with NULL struct zone*
>> producing kernel oops like this:
>
> For good description, it would be better to write simple pseudo code
> flow to show how NULL-zone pass into wait_iff_congested because
> kswapd code flow is too complex.
>
> As I see the code, we have following line above wait_iff_congested.
>
> if (!unbalanced_zone || blah blah)
>          break;
>
> How can NULL unbalanced_zone reach wait_iff_congested?
>

Hello Minchan, and thanks for the comment.

That line was there before commit 4ae0a48b got in, and you're right, 
it's what was protecting wait_iff_congested() from being called with 
NULL zone*. But then all that logic got colapsed to a simple 
pgdat_balanced() call and that's when I introduced the bug, I lost the 
protection.

What I _think_ is happening (pseudo code following...) is that after 
scanning the zone in the dma->highmem direction, and concluding that all 
zones are balanced (unbalanced_zone remains NULL!), 
wake_up(&pgdat->pfmemalloc_wait) wakes up a lot of memory hungry 
processes (especially true in various aggressive test/benchmarks) that 
immediately drain and unbalance one or more zones. Then pgdat_balanced() 
call which immediately follows will be false, but we still have 
unbalanced_zone = NULL, rememeber? Oops...

But, all that is a speculation that I can't prove atm. Of course, if 
anybody thinks that's a credible explanation, I could add it as a commit 
comment, or even as a code comment, but I didn't want to be overly 
imaginative. The fix itself is simple and real.

Regards,
-- 
Zlatko
