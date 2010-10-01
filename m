Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab0JAPHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 11:07:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757262Ab0JAPHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 11:07:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <WC20101001143139.810346@digidescorp.com>
References: <WC20101001143139.810346@digidescorp.com> <1285929315-2856-1-git-send-email-steve@digidescorp.com> <5206.1285943095@redhat.com>
To: "Steve Magnani" <steve@digidescorp.com>
Cc: dhowells@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH][RESEND] nommu: add anonymous page memcg accounting
Date: Fri, 01 Oct 2010 16:07:01 +0100
Message-ID: <5867.1285945621@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Magnani <steve@digidescorp.com> wrote:

> If anything I think nommu is one of the better applications of memcg. Since
> nommu typically embedded, being able to put potential memory pigs in a
> sandbox so they can't destabilize the system is a Good Thing. That was my
> motivation for doing this in the first place and it works quite well.

I suspect it's not useful for a few reasons:

 (1) You don't normally run many applications on a NOMMU system.  Typically,
     you'll run just one, probably threaded app, I think.

 (2) In general, you won't be able to cull processes to make space.  If the OOM
     killer runs your application has a bug in it.

 (3) memcg has a huge overhead.  20 bytes per page!  On a 4K page 32-bit
     system, that's nearly 5% of your RAM, assuming I understand the
     CGROUP_MEM_RES_CTLR config help text correctly.

 (4) There's no swapping, no page faults, no migration and little shareable
     memory.  Being able to allocate large blocks of contiguous memory is much
     more important and much more of a bottleneck than this.  The 5% of RAM
     lost makes that just that little bit harder.

If it's memory sandboxing you require, ulimit might be sufficient for NOMMU
mode.

However, I suppose there's little harm in letting the patch in.  I would guess
the additions all optimise away if memcg isn't enabled.

A question for you: why does struct page_cgroup need a page pointer?  If an
array of page_cgroup structs is allocated per array of page structs, then you
should be able to use the array index to map between them.

David
