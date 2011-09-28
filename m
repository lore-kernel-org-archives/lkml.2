Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab1I1Xsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:48:54 -0400
Received: from smtp-out.google.com ([74.125.121.67]:1083 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab1I1Xsv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 19:48:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=hafIqqom/T7L/a3qVefBX0zhXuOnH6x3ThF+C5+LvyrZt8FQwuxqmRMSsquyEvzYb
	BBnImmT0Er2IiSlx0u1zw==
MIME-Version: 1.0
In-Reply-To: <20110928155302.ca394980.kamezawa.hiroyu@jp.fujitsu.com>
References: <1317170947-17074-1-git-send-email-walken@google.com>
	<1317170947-17074-3-git-send-email-walken@google.com>
	<20110928155302.ca394980.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 28 Sep 2011 16:48:44 -0700
Message-ID: <CANN689G_ZT+M4XU+R-d+imDghO4DnvYsS3+=2G2B_5ioh=U7=w@mail.gmail.com>
Subject: Re: [PATCH 2/9] kstaled: documentation and config option.
From: Michel Lespinasse <walken@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Michael Wolf <mjwolf@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 11:53 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 27 Sep 2011 17:49:00 -0700
> Michel Lespinasse <walken@google.com> wrote:
>> +* idle_2_clean, idle_2_dirty_file, idle_2_dirty_swap: same definitions as
>> +  above, but for pages that have been untouched for at least two scan cycles.
>> +* these fields repeat up to idle_240_clean, idle_240_dirty_file and
>> +  idle_240_dirty_swap, allowing one to observe idle pages over a variety
>> +  of idle interval lengths. Note that the accounting is cumulative:
>> +  pages counted as idle for a given interval length are also counted
>> +  as idle for smaller interval lengths.
>
> I'm sorry if you've answered already.
>
> Why 240 ? and above means we have idle_xxx_clean/dirty/ xxx is 'seq 2 240' ?
> Isn't it messy ? Anyway, idle_1_clean etc should be provided.

We don't have all values - we export values for 1, 2, 5, 15, 30, 60,
120 and 240 idle scan intervals.
In our production setup, the scan interval is set at 120 seconds.
The exported histogram values are chosen so that each is approximately
double as the previous, and they align with human units i.e. 30 scan
intervals == 1 hour.
We use one byte per page to track the number of idle cycles, which is
why we don't export anything over 255 scan intervals

> Hmm, I don't like the idea very much...
>
> IIUC, there is no kernel interface which shows histgram rather than load_avg[].
> Is there any other interface and what histgram is provided ?
> And why histgram by kernel is required ?

I don't think exporting per-page statistics is very useful given that
userspace doesn't have a way to select individual pages to reclaim
(and if it did, we would have to expose LRU lists to userspace for it
to make good choices, and I don't think we want to go there). So, we
want to expose summary statistics instead. Histograms are a good way
to do that.

I don't think averages would work well for this application - the
distribution of idle page ages varies a lot between applications and
can't be assumed to be even close to a gaussian.

> BTW, can't this information be exported by /proc/<pid>/smaps or somewhere ?
> I guess per-proc will be wanted finally.

The problem with per-proc is that it only works for things that are
mapped in at the time you look at the report. It does not take into
consideration ephemeral mappings (i.e. if there is this thing you run
every 5 minutes and it needs 1G of memory) or files you access with
read() instead of mmap().

> Hm, do you use params other than idle_clean for your scheduling ?

The management software currently looks at only one bin of the
histogram - for each job, we can configure which bin it will look at.
Humans look at the complete picture when looking into performance
issues, and we're always thinking about teaching the management
software to do that as well :)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
