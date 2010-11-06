Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab0KFRUB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 13:20:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:4504 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab0KFRUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 13:20:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=fornUUscLp63wWnzmoqAWWok613eB2gkGf84s3u4ll6bfu/cEluJHKuopR0eqHselo
         2s9iKt82X7VrTi5LLjxw==
MIME-Version: 1.0
In-Reply-To: <20101106010357.GD23393@cmpxchg.org>
References: <1288973333-7891-1-git-send-email-minchan.kim@gmail.com> <20101106010357.GD23393@cmpxchg.org>
From: Greg Thelen <gthelen@google.com>
Date: Sat, 6 Nov 2010 10:19:35 -0700
Message-ID: <AANLkTin9m65JVKRuStZ1-qhU5_1AY-GcbBRC0TodsfYC@mail.gmail.com>
Subject: Re: [PATCH] memcg: use do_div to divide s64 in 32 bit machine.
To: hannes@cmpxchg.org
Cc: Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Andrea Righi <arighi@develer.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 5, 2010 at 6:03 PM,  <hannes@cmpxchg.org> wrote:
> On Sat, Nov 06, 2010 at 01:08:53AM +0900, Minchan Kim wrote:
>> Use do_div to divide s64 value. Otherwise, build would be failed
>> like Dave Young reported.
>
> I thought about that too, but then I asked myself why you would want
> to represent a number of pages as signed 64bit type, even on 32 bit?

I think the reason that 64 byte type is used for page count in
memcontrol.c is because the low level res_counter primitives operate
on 64 bit counters, even on 32 bit machines.

> Isn't the much better fix to get the types right instead?
>

I agree that consistent types between mem_cgroup_dirty_info() and
global_dirty_info() is important.  There seems to be a lot of usage of
s64 for page counts in memcontrol.c, which I think is due to the
res_counter types.  I think these s64 be switched to unsigned long
rather to be consistent with the rest of mm code.  It looks like this
will be a clean patch, except for the lowest level where
res_counter_read_u64() is used, where some casting may be needed.

I'll post a patch for that change.
