Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab2DJAfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 20:35:55 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39947 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab2DJAfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 20:35:53 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F837FE2.7010805@jp.fujitsu.com>
Date: Tue, 10 Apr 2012 09:33:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH] mm: sync rss-counters at the end of exit_mm()
References: <20120409200336.8368.63793.stgit@zurg> <CAHGf_=oWj-hz-E5ht8-hUbQKdsZ1bzP80n987kGYnFm8BpXBVQ@mail.gmail.com> <alpine.LSU.2.00.1204091433380.1859@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1204091433380.1859@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/10 7:03), Hugh Dickins wrote:

> On Mon, 9 Apr 2012, KOSAKI Motohiro wrote:
>> On Mon, Apr 9, 2012 at 4:03 PM, Konstantin Khlebnikov
>> <khlebnikov@openvz.org> wrote:
>>> On task's exit do_exit() calls sync_mm_rss() but this is not enough,
>>> there can be page-faults after this point, for example exit_mm() ->
>>> mm_release() -> put_user() (for processing tsk->clear_child_tid).
>>> Thus there may be some rss-counters delta in current->rss_stat.
>>
>> Seems reasonable.
> 
> Yes, I think Konstantin has probably caught it;
> but I'd like to hear confirmation from Markus.
> 
>> but I have another question. Do we have any reason to
>> keep sync_mm_rss() in do_exit()? I havn't seen any reason that thread exiting
>> makes rss consistency.
> 
> IIRC it's all about the hiwater_rss/maxrss stuff: we want to sync the
> maximum rss into mm->hiwater_rss before it's transferred to signal->maxrss,
> and later made visible to the user though getrusage(RUSAGE_CHILDREN,) -
> does your reading confirm that?
> 


IIRC, sync_mm_rss() in do_exit() is for synchronizing rsscounter for taskacct.
mm->maxrss is sent to listener by xacct_add_tsk(). It's needed to be
synchronized before taskstat_exit()..

Hm, but, exit_mm() is placed after taskstat_exit().

Thanks,
-Kame

