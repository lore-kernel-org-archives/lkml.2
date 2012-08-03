Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab2HCVgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 17:36:24 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50126 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab2HCVgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 17:36:22 -0400
Message-ID: <501C4471.4090706@gmail.com>
Date: Fri, 03 Aug 2012 23:36:49 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120730 Thunderbird/14.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@elte.hu, ebiederm@xmission.com, aarcange@redhat.com,
        ericvh@gmail.com, netdev@vger.kernel.org
Subject: Re: [RFC v2 1/7] hashtable: introduce a small and naive hashtable
References: <1344003788-1417-1-git-send-email-levinsasha928@gmail.com> <1344003788-1417-2-git-send-email-levinsasha928@gmail.com> <20120803171515.GH15477@google.com> <501C407D.9080900@gmail.com> <20120803213017.GK15477@google.com>
In-Reply-To: <20120803213017.GK15477@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 11:30 PM, Tejun Heo wrote:
>> I think hash_for_for_each_possible() is useful if the comparison
>> > condition is more complex than a simple comparison of one of the
>> > object members with the key - there's no need to force it on all the
>> > users.
> I don't know.  What's the difference?  In terms of LOC, it might even
> not save any thanks to the extra function definition, right?  I don't
> think it's saving enough complexity to justify a separate rather
> unusual interface.

The function definition itself is just a macro, for example:

	#define MM_SLOTS_HASH_CMP(mm_slot, obj) ((mm_slot)->mm == (obj))

As an alternative, what do you think about simplifying that to be just a 'cond' instead of a function? Something like:

	hash_get(&mm_slots_hash, mm, struct mm_slot, hash, mm);

In that case, the last param ("mm") will get unrolled to a condition like this:

	if ((obj)->mm == key)

Which will be simple and easy for the user.


The only reason I want to keep this interface is that most cases I've stumbled so far were easy short comparisons of a struct member with the key, and I don't want to make them more complex than they need to be. I probably will switch hash_get() to use hash_for_each_possible() as well, which will cut down on how hash_get() is a separate case.
