Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab0KKXPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 18:15:42 -0500
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:55274 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755924Ab0KKXPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 18:15:41 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-02.arcor-online.net EE0A43039C
Message-Id: <E1PGgMk-0001AW-OD@be1.7eggert.dyndns.org>
From: Bodo Eggert <7eggert@web.de>
Subject: Re: [PATCH] oom: create a resource limit for oom_adj
To: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Ying Han <yinghan@google.com>,
        linux-kernel@vger.kernel.org, gspencer@chromium.org,
        piman@chromium.org, wad@chromium.org, olofj@chromium.org
Reply-To: 7eggert@gmx.de
Date: Fri, 12 Nov 2010 00:15:38 +0100
References: <fNx73-1cI-1@gated-at.bofh.it> <fNzVf-5UY-3@gated-at.bofh.it> <fNKdY-6FU-11@gated-at.bofh.it> <fNMps-1S1-21@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes <rientjes@google.com> wrote:
> On Thu, 11 Nov 2010, Mandeep Singh Baines wrote:

>> > What is the anticipated use case for this?  We know that you want to lower
>> > oom_adj without CAP_SYS_RESOURCE, but what's the expected behavior when an
>> > app moves from foreground to background?  I assume it's something like
>> 
>> The focus here is the web browser's tabs. In our case, each is a process. If
>> OOM is going to kill a process, you'd rather it kill the tab you looked at
>> hours ago instead of the one you're looking at now. So you'd like to have a
>> policy where the LRU tab gets killed first. We'd like to use oom_score_adj
>> as the mechanism to implement an LRU policy like this.
>> 
> 
> Hmm, at first glance that seems potentially dangerous if the current tab
> generates a burt of memory allocations and it ends up killing all other
> tabs before finally targeting the culprit whereas currently the heuristic
> should do a good job of finding this problematic tab and killing it
> instantly.

The original oom_adj design would e.g. adjust all background tabs to seem
twice as bad as the current tab, so a ever-growing current tab would
only be able to get one or two tabs killed in the worst case:

System is near OOM while the current tab starts using a normal amount of
mem and grows beyond limits. After it easily killed the first bg tab by
allocating one byte, it needs to grow to twice the normal tab memsize to
start the OOM killer again. By then, it's score will be equal to normal
background tabs (half size, double score), and killing the second tab will
be luck. Killing the third tab should be impossible.

(If you adjust the bg tabs to be four times as killable, you'll get what
 you asked for.)


I don't know the current oom_score_adj, it should be able to do something
similar? Or should there be a oom_score_mul?

>> > What do you anticipate will be writing to oom_score_adj with this patch,
>> > the app itself?
>> 
>> A process in the browser session will do the adusting. We'd rather not give
>> it CAP_SYS_RESOURCE. It should only be allowed to change oom_score_adj up
>> and down within the bounds set by the administrator. Analagous to renice()
>> which we also do using a similar policy.
>> 
> 
> So as more and more tabs get used, the least recently used tab gets its
> oom_score_adj raised higher and higher until it is reused itself and then
> it gets reset back to 0 for the current tab?

As far as I understand, a background tab should get a higher score if it
rests untouched for some time, and if it gets used again, it will jump to
neutral oom_adj.

> Is there a reason you don't want to give the underlying browser session
> process CAP_SYS_RESOURCE?

I should not have control over a CAP_SYS_RESOURCE process while being a user,
but I should be able to tell the system which process to kill. When I designed
the oom_adj, I did not think about one-process-per-tab, so I did not suggest
a soft/hard limit.

I think the concept of using an rlimit is the right thing to do, I did not yet
look/think about the mapping. Glancing at oom_score_adj does suggest a different
range ...

