Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab1HBNva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 09:51:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36983 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab1HBNvX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 09:51:23 -0400
Subject: Re: [PATCH RFCv2 3/8] sched: Handle on_list ancestor in
 list_add_leaf_cfs_rq()
From: Peter Zijlstra <peterz@infradead.org>
To: "Jan H." =?ISO-8859-1?Q?Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1311793825-31933-4-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1311793825-31933-1-git-send-email-schnhrr@cs.tu-berlin.de>
	 <1311793825-31933-4-git-send-email-schnhrr@cs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 02 Aug 2011 15:50:37 +0200
Message-ID: <1312293037.1147.181.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-27 at 21:10 +0200, Jan H. Schönherr wrote:
> +       /*
> +        * Carefully collect leaf-cfs entries.
> +        *
> +        * There are basically two cases:
> +        * 1. cfs_rq has not yet been on the leaf-list.
> +        * 2. cfs_rq has been deleted previously from the leaf_list.
> +        *
> +        * In case 2, we might still have concurrent readers.
> +        *
> +        * Therefore, the requirements of list_add_tail_nobackref() are
> +        * fulfilled:
> +        *
> +        * a) If there are concurrent readers, ->next must lead back to the
> +        *    list.
> +        *
> +        *    We can only have readers after case 2. After case 2, only case 2
> +        *    can follow. The next pointers of case 2 nodes always lead back to
> +        *    the list.
> +        *
> +        * b) If there are concurrent readers, ->next must not lead to any
> +        *    already collected node.
> +        *
> +        *    As we collect nodes always bottom-up, all already collected nodes
> +        *    must be below this node in the task group hierarchy.  The
> +        *    ordering constraint of the leaf list guarantees that next
> +        *    pointers only lead to nodes further up in the hierarchy (or to
> +        *    unrelated nodes). Neither deleting nodes nor the manipulations
> +        *    done here change that. Thus, we cannot reach an already collected
> +        *    node.
> +        *
> +        * c) If there are concurrent readers, they must already know this
> +        *    node.
> +        *
> +        *    If we have to add case 1 nodes, they are collected in the
> +        *    beginning and cannot be reached by readers until they are
> +        *    spliced. Furthermore, after they are spliced, we will not
> +        *    encounter more case 1 nodes higher up in the task group
> +        *    hierarchy. For this reason any reader on an earlier collected
> +        *    case 2 node must know all nodes that we collect later.
> +        */
> +       list_add_tail_nobackref(&cfs_rq->leaf_cfs_rq_list, leaf_cfs_rqs); 

I think there's an argument for not adding _nobackref and simply
open-coding the operation here. Could there possibly be another user
that wants this? 

Furthermore, since its tricky like hell every site would want a comment
like the above explaining exactly what and why, and when you put in that
much effort, you might as well write the list-op itself too.

Bit of a barrier to shooting your foot off or so..
