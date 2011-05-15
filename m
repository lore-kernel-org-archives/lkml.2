Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab1EOTxh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 15:53:37 -0400
Received: from smtp-out.google.com ([74.125.121.67]:63464 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab1EOTxf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 15:53:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=S4yK5PuKIrZrJ924mlciqHhlWoIQayapfH5A50P2fLhthqGF55v3Lwth7Bi1s+4oUy
         E7xj5omhVgq1MYVpxIwg==
MIME-Version: 1.0
In-Reply-To: <20110513184120.0f9444bc.kamezawa.hiroyu@jp.fujitsu.com>
References: <1305276473-14780-1-git-send-email-gthelen@google.com>
 <1305276473-14780-9-git-send-email-gthelen@google.com> <20110513184120.0f9444bc.kamezawa.hiroyu@jp.fujitsu.com>
From: Greg Thelen <gthelen@google.com>
Date: Sun, 15 May 2011 12:53:08 -0700
Message-ID: <BANLkTi=t+Wn5GWR49f++be_AeZ9fjGACTA@mail.gmail.com>
Subject: Re: [RFC][PATCH v7 08/14] writeback: add memcg fields to writeback_control
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 2:41 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Fri, 13 May 2011 01:47:47 -0700
> Greg Thelen <gthelen@google.com> wrote:
>
>> Add writeback_control fields to differentiate between bdi-wide and
>> per-cgroup writeback.  Cgroup writeback is also able to differentiate
>> between writing inodes isolated to a particular cgroup and inodes shared
>> by multiple cgroups.
>>
>> Signed-off-by: Greg Thelen <gthelen@google.com>
>
> Personally, I want to see new flags with their usage in a patch...

Ok.  Next version will merge the flag definition with first usage of the flag.

>> ---
>>  include/linux/writeback.h |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
>> index d10d133..4f5c0d2 100644
>> --- a/include/linux/writeback.h
>> +++ b/include/linux/writeback.h
>> @@ -47,6 +47,8 @@ struct writeback_control {
>>       unsigned for_reclaim:1;         /* Invoked from the page allocator */
>>       unsigned range_cyclic:1;        /* range_start is cyclic */
>>       unsigned more_io:1;             /* more io to be dispatched */
>> +     unsigned for_cgroup:1;          /* enable cgroup writeback */
>> +     unsigned shared_inodes:1;       /* write inodes spanning cgroups */
>>  };
>
>
> If shared_inode is really rare case...we don't need to have this shared_inodes
> flag and do writeback shared_inode always.....No ?
>
> Thanks,
> -Kame

The shared_inodes field is present to avoid punishing cgroups that are
not sharing, if they are run on a system that also includes sharing.

This issue is being debated in another thread: "[RFC][PATCH v7 00/14]
memcg: per cgroup dirty page accounting".  Depending on the decision,
we may be able to delete the shared_inode fields if we choose to
always write shared inodes in both cgroup foreground and cgroup
background writeback.
