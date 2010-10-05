Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab0JEFwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 01:52:00 -0400
Received: from smtp-out.google.com ([74.125.121.35]:40734 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab0JEFv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 01:51:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:references:date:in-reply-to:message-id:
	user-agent:mime-version:content-type;
	b=XgX/WMGT+bb/GvJR+ATPGCsFXNyleqdKblhCpICi5xfwI/J8RAVnZiO+0qnHBx7i7
	bsp5O/Eow6JaKRh6qD0xw==
From: Greg Thelen <gthelen@google.com>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 00/10] memcg: per cgroup dirty page accounting
References: <1286175485-30643-1-git-send-email-gthelen@google.com>
	<20101005045023.GS7896@balbir.in.ibm.com>
Date: Mon, 04 Oct 2010 22:50:32 -0700
In-Reply-To: <20101005045023.GS7896@balbir.in.ibm.com> (Balbir Singh's message
	of "Tue, 5 Oct 2010 10:20:23 +0530")
Message-ID: <xr93pqvpxk5z.fsf@ninji.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh <balbir@linux.vnet.ibm.com> writes:
>
> * Greg Thelen <gthelen@google.com> [2010-10-03 23:57:55]:
>
>> This patch set provides the ability for each cgroup to have independent dirty
>> page limits.
>> 
>> Limiting dirty memory is like fixing the max amount of dirty (hard to reclaim)
>> page cache used by a cgroup.  So, in case of multiple cgroup writers, they will
>> not be able to consume more than their designated share of dirty pages and will
>> be forced to perform write-out if they cross that limit.
>> 
>> These patches were developed and tested on mmotm 2010-09-28-16-13.  The patches
>> are based on a series proposed by Andrea Righi in Mar 2010.
>
> Hi, Greg,
>
> I see a problem with "    memcg: add dirty page accounting infrastructure".
>
> The reject is
>
>  enum mem_cgroup_write_page_stat_item {
>         MEMCG_NR_FILE_MAPPED, /* # of pages charged as file rss */
> +       MEMCG_NR_FILE_DIRTY, /* # of dirty pages in page cache */
> +       MEMCG_NR_FILE_WRITEBACK, /* # of pages under writeback */
> +       MEMCG_NR_FILE_UNSTABLE_NFS, /* # of NFS unstable pages */
>  };
>
> I don't see mem_cgroup_write_page_stat_item in memcontrol.h. Is this
> based on top of Kame's cleanup.
>
> I am working off of mmotm 28 sept 2010 16:13.

Balbir,

All of the 10 memcg dirty limits patches should apply directly to mmotm
28 sept 2010 16:13 without any other patches.  Any of Kame's cleanup
patches that are not in mmotm are not needed by this memcg dirty limit
series.

The patch you refer to, "[PATCH 05/10] memcg: add dirty page accounting
infrastructure" depends on a change from an earlier patch in the series.
Specifically, "[PATCH 03/10] memcg: create extensible page stat update
routines" contains the addition of mem_cgroup_write_page_stat_item:

--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -25,6 +25,11 @@ struct page_cgroup;
 struct page;
 struct mm_struct;
 
+/* Stats that can be updated by kernel. */
+enum mem_cgroup_write_page_stat_item {
+     MEMCG_NR_FILE_MAPPED, /* # of pages charged as file rss */
+};
+

Do you have trouble applying patch 5 after applying patches 1-4?
