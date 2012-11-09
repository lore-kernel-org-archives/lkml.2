Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab2KIEWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 23:22:15 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:45118 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2KIEWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 23:22:14 -0500
Message-ID: <509C84ED.8090605@linux.vnet.ibm.com>
Date: Thu, 08 Nov 2012 22:22:05 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Mel Gorman <mgorman@suse.de>, Zdenek Kabelac <zkabelac@redhat.com>,
        Valdis.Kletnieks@vt.edu, Jiri Slaby <jirislaby@gmail.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: kswapd0: excessive CPU usage
References: <507688CC.9000104@suse.cz> <106695.1349963080@turing-police.cc.vt.edu> <5076E700.2030909@suse.cz> <118079.1349978211@turing-police.cc.vt.edu> <50770905.5070904@suse.cz> <119175.1349979570@turing-police.cc.vt.edu> <5077434D.7080008@suse.cz> <50780F26.7070007@suse.cz> <20121012135726.GY29125@suse.de> <507BDD45.1070705@suse.cz> <20121015110937.GE29125@suse.de> <5093A3F4.8090108@redhat.com> <5093A631.5020209@suse.cz> <509422C3.1000803@suse.cz>
In-Reply-To: <509422C3.1000803@suse.cz>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110904-4834-0000-0000-00000043D38E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2012 02:45 PM, Jiri Slaby wrote:
> On 11/02/2012 11:53 AM, Jiri Slaby wrote:
>> On 11/02/2012 11:44 AM, Zdenek Kabelac wrote:
>>>>> Yes, applying this instead of the revert fixes the issue as well.
>>>
>>> I've applied this patch on 3.7.0-rc3 kernel - and I still see excessive
>>> CPU usage - mainly  after  suspend/resume
>>>
>>> Here is just simple  kswapd backtrace from running kernel:
>>
>> Yup, this is what we were seeing with the former patch only too. Try to
>> apply the other one too:
>> https://patchwork.kernel.org/patch/1673231/
>>
>> For me I would say, it is fixed by the two patches now. I won't be able
>> to report later, since I'm leaving to a conference tomorrow.
> 
> Damn it. It recurred right now, with both patches applied. After I
> started a java program which consumed some more memory. Though there are
> still 2 gigs free, kswap is spinning:
> [<ffffffff810b00da>] __cond_resched+0x2a/0x40
> [<ffffffff811318a0>] shrink_slab+0x1c0/0x2d0
> [<ffffffff8113478d>] kswapd+0x66d/0xb60
> [<ffffffff810a25d0>] kthread+0xc0/0xd0
> [<ffffffff816aa29c>] ret_from_fork+0x7c/0xb0
> [<ffffffffffffffff>] 0xffffffffffffffff

I'm also hitting this issue in v3.7-rc4.  It appears that the last
release not effected by this issue was v3.3.  Bisecting the changes
included for v3.4-rc1 showed that this commit introduced the issue:

fe2c2a106663130a5ab45cb0e3414b52df2fff0c is the first bad commit
commit fe2c2a106663130a5ab45cb0e3414b52df2fff0c
Author: Rik van Riel <riel@redhat.com>
Date:   Wed Mar 21 16:33:51 2012 -0700

    vmscan: reclaim at order 0 when compaction is enabled
...

This is plausible since the issue seems to be in the kswapd + compaction
realm.  I've yet to figure out exactly what about this commit results in
kswapd spinning.

I would be interested if someone can confirm this finding.

--
Seth

