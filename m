Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab2CIHQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 02:16:22 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36383 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab2CIHQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 02:16:21 -0500
Message-ID: <4F59AE3C.5040200@openvz.org>
Date: Fri, 09 Mar 2012 11:16:12 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7 v2] mm: rework __isolate_lru_page() file/anon filter
References: <20120229091547.29236.28230.stgit@zurg> <20120303091327.17599.80336.stgit@zurg> <alpine.LSU.2.00.1203061904570.18675@eggly.anvils> <20120308143034.f3521b1e.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LSU.2.00.1203081758490.18195@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1203081758490.18195@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Thu, 8 Mar 2012, KAMEZAWA Hiroyuki wrote:
>> On Tue, 6 Mar 2012 19:22:21 -0800 (PST)
>> Hugh Dickins<hughd@google.com>  wrote:
>>>
>>> What does the compiler say (4.5.1 here, OPTIMIZE_FOR_SIZE off)?
>>>     text	   data	    bss	    dec	    hex	filename
>>>    17723	    113	     17	  17853	   45bd	vmscan.o.0
>>>    17671	    113	     17	  17801	   4589	vmscan.o.1
>>>    17803	    113	     17	  17933	   460d	vmscan.o.2
>>>
>>> That suggests that your v2 is the worst and your v1 the best.
>>> Kame, can I persuade you to let the compiler decide on this?
>>>
>>
>> Hmm. How about Costa' proposal ? as
>>
>> int tmp_var = PageActive(page) ? ISOLATE_ACTIVE : ISOLATE_INACTIVE
>> if (!(mode&  tmp_var))
>>      ret;
>
> Yes, that would have been a good compromise (given a better name
> than "tmp_var"!), I didn't realize that one was acceptable to you.
>
> But I see that Konstantin has been inspired by our disagreement to a
> more creative solution.
>
> I like very much the look of what he's come up with, but I'm still
> puzzling over why it barely makes any improvement to __isolate_lru_page():
> seems significantly inferior (in code size terms) to his original (which
> I imagine Glauber's compromise would be equivalent to).
>
> At some point I ought to give up on niggling about this,
> but I haven't quite got there yet.

(with if())
$ ./scripts/bloat-o-meter built-in.o built-in.o-v1
add/remove: 0/0 grow/shrink: 2/1 up/down: 32/-20 (12)
function                                     old     new   delta
static.shrink_active_list                    837     853     +16
shrink_inactive_list                        1259    1275     +16
static.isolate_lru_pages                    1055    1035     -20

(with switch())
$ ./scripts/bloat-o-meter built-in.o built-in.o-v2
add/remove: 0/0 grow/shrink: 4/2 up/down: 111/-23 (88)
function                                     old     new   delta
__isolate_lru_page                           301     377     +76
static.shrink_active_list                    837     853     +16
shrink_inactive_list                        1259    1275     +16
page_evictable                               170     173      +3
__remove_mapping                             322     319      -3
static.isolate_lru_pages                    1055    1035     -20

(without __always_inline on page_lru())
$ ./scripts/bloat-o-meter built-in.o built-in.o-v5-noinline
add/remove: 0/0 grow/shrink: 5/2 up/down: 93/-23 (70)
function                                     old     new   delta
__isolate_lru_page                           301     333     +32
isolate_lru_page                             359     385     +26
static.shrink_active_list                    837     853     +16
putback_inactive_pages                       635     651     +16
page_evictable                               170     173      +3
__remove_mapping                             322     319      -3
static.isolate_lru_pages                    1055    1035     -20

$ ./scripts/bloat-o-meter built-in.o built-in.o-v5
add/remove: 0/0 grow/shrink: 3/4 up/down: 35/-67 (-32)
function                                     old     new   delta
static.shrink_active_list                    837     853     +16
__isolate_lru_page                           301     317     +16
page_evictable                               170     173      +3
__remove_mapping                             322     319      -3
mem_cgroup_lru_del                            73      65      -8
static.isolate_lru_pages                    1055    1035     -20
__mem_cgroup_commit_charge                   676     640     -36

Actually __isolate_lru_page() even little bit bigger

>
> Hugh

