Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031320Ab2CVWYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 18:24:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57156 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab2CVWYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 18:24:35 -0400
Message-ID: <4F6BA69F.1040707@openvz.org>
Date: Fri, 23 Mar 2012 02:24:31 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 00/16] mm: prepare for converting vm->vm_flags to 64-bit
References: <20120321065140.13852.52315.stgit@zurg> <20120321100602.GA5522@barrios>	<4F69D496.2040509@openvz.org> <20120322142647.42395398.akpm@linux-foundation.org> <20120322212810.GE6589@ZenIV.linux.org.uk> <20120322144122.59d12051.akpm@linux-foundation.org> <4F6BA221.8020602@openvz.org>
In-Reply-To: <4F6BA221.8020602@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Khlebnikov wrote:
> Andrew Morton wrote:
>> On Thu, 22 Mar 2012 21:28:11 +0000
>> Al Viro<viro@ZenIV.linux.org.uk>   wrote:
>>
>>> On Thu, Mar 22, 2012 at 02:26:47PM -0700, Andrew Morton wrote:
>>>> It would be nice to find some way of triggering compiler warnings or
>>>> sparse warnings if someone mixes a 32-bit type with a vm_flags_t.  Any
>>>> thoughts on this?
>>>>
>>>> (Maybe that's what __nocast does, but Documentation/sparse.txt doesn't
>>>> describe it)
>>>
>>> Use __bitwise for that - check how gfp_t is handled.
>>
>> So what does __nocast do?
>
> Actually it forbid any non-forced casts, but its implementation in sparse seems buggy:
> __nocast generates some strange false positives. For example it sometimes forgot about
> type attributes in function arguments, I saw this for vm_flags argument in ksm_madvise().
> I can reproduce this bug, if somebody interested.
>

1.c:

# define __nocast	__attribute__((nocast))

typedef long __nocast long_t;

static void f(long_t *x)
{
}

static void g(void)
{
	long_t x;

	f(&x);
}

$ sparse 1.c
1.c:13:12: warning: incorrect type in argument 1 (different modifiers)
1.c:13:12:    expected int [nocast] [usertype] *x
1.c:13:12:    got int *<noident>
1.c:13:12: warning: implicit cast to nocast type

Is this ok?

