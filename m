Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab2JQAC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 20:02:57 -0400
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:41396 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab2JQAC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 20:02:56 -0400
Message-ID: <507DF58E.8060804@ce.jp.nec.com>
Date: Wed, 17 Oct 2012 09:02:22 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix use-after-free of q->root_blkg and q->root_rl.blkg
References: <50750367.2070508@ce.jp.nec.com> <20121010155929.GA18733@redhat.com> <50762182.5090806@ce.jp.nec.com> <20121016232040.GH16166@google.com>
In-Reply-To: <20121016232040.GH16166@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/12 08:20, Tejun Heo wrote:
>>>> -	if (ent == &q->root_blkg->q_node)
>>>> +	if (q->root_blkg && ent == &q->root_blkg->q_node)
>>>
>>> Can we fix it little differently. Little earlier in the code, we check for
>>> if q->blkg_list is empty, then all the groups are gone, and there are
>>> no more request lists hence and return NULL.
>>>
>>> Current code:
>>>         if (rl == &q->root_rl) {
>>>                 ent = &q->blkg_list;
>>>
>>> Modified code:
>>>         if (rl == &q->root_rl) {
>>>                 ent = &q->blkg_list;
>>> 		/* There are no more block groups, hence no request lists */
>>> 		if (list_empty(ent))
>>> 			return NULL;
>>> 	}
> 
> Do we need this at all?  q->root_blkg being NULL is completely fine
> there and the comparison would work as expected, no?

Hmm?

If list_empty(ent) and q->root_blkg == NULL,

>         /* walk to the next list_head, skip root blkcg */
>         ent = ent->next;

ent is &q->blkg_list again.

>         if (ent == &q->root_blkg->q_node)

So ent is not &q->root_blkg->q_node.

>                 ent = ent->next;
>         if (ent == &q->blkg_list)
>                 return NULL;

And we return NULL here.

Ah, yes. You are correct.
We can do without the above hunk.

-- 
Jun'ichi Nomura, NEC Corporation

