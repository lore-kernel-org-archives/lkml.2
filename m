Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab0CYI4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 04:56:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55402 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab0CYI42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 04:56:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 02/11] mm,migration: Do not try to migrate unmapped anonymous pages
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20100325083235.GF2024@csn.ul.ie>
References: <20100325095349.944E.A69D9226@jp.fujitsu.com> <20100325083235.GF2024@csn.ul.ie>
Message-Id: <20100325175034.6C86.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 25 Mar 2010 17:56:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Mar 25, 2010 at 11:49:23AM +0900, KOSAKI Motohiro wrote:
> > > On Fri, Mar 19, 2010 at 03:21:41PM +0900, KOSAKI Motohiro wrote:
> > > > > > then, this logic depend on SLAB_DESTROY_BY_RCU, not refcount.
> > > > > > So, I think we don't need your [1/11] patch.
> > > > > > 
> > > > > > Am I missing something?
> > > > > > 
> > > > > 
> > > > > The refcount is still needed. The anon_vma might be valid, but the
> > > > > refcount is what ensures that the anon_vma is not freed and reused.
> > > > 
> > > > please please why do we need both mechanism. now cristoph is very busy and I am
> > > > de fact reviewer of page migration and mempolicy code. I really hope to understand
> > > > your patch.
> > > 
> > > As in, why not drop the RCU protection of anon_vma altogeter? Mainly, because I
> > > think it would be reaching too far for this patchset and it should be done as
> > > a follow-up. Putting the ref-count everywhere will change the cache-behaviour
> > > of anon_vma more than I'd like to slip into a patchset like this. Secondly,
> > > Christoph mentions that SLAB_DESTROY_BY_RCU is used to keep anon_vma cache-hot.
> > > For these reasons, removing RCU from these paths and adding the refcount
> > > in others is a patch that should stand on its own.
> > 
> > Hmmm...
> > I haven't understand your mention because I guess I was wrong.
> > 
> > probably my last question was unclear. I mean,
> > 
> > 1) If we still need SLAB_DESTROY_BY_RCU, why do we need to add refcount?
> >     Which difference is exist between normal page migration and compaction?
> 
> The processes typically calling migration today own the page they are moving
> and is not going to exit unexpectedly during migration.
> 
> > 2) If we added refcount, which race will solve?
> > 
> 
> The process exiting and the last anon_vma being dropped while compaction
> is running. This can be reliably triggered with compaction.
> 
> > IOW, Is this patch fix old issue or compaction specific issue?
> 
> Strictly speaking, it's an old issue but in practice it's impossible to
> trigger because the process migrating always owns the page. Compaction
> moves pages belonging to arbitrary processes.

Do you mean current memroy hotplug code is broken???
I think compaction need refcount, hotplug also need it. both they migrate another
task's page.

but , I haven't seen hotplug failure. Am I  missing something? or the compaction
have its specific race situation?


