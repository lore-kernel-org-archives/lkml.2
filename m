Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab0KHAHh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 19:07:37 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47507 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab0KHAHg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 19:07:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xnj7YPSTXe3Bu/5iM8tCpD+9oBxQnGwuFSw2Xh75x9QaXgtrVJgPaePfCsvN3rL3Hg
         fFwxbV2O0cEmXgbBzZGug+aTKlsbnqXd5lhEFKf/062+I2pWNzj3xS7axW/92p2u7UXu
         YMPuPbwidZDa1mLfDYscd0YnFoi5nBSWoY5HU=
MIME-Version: 1.0
In-Reply-To: <20101107220353.964566018@cmpxchg.org>
References: <1288973333-7891-1-git-send-email-minchan.kim@gmail.com>
	<20101106010357.GD23393@cmpxchg.org>
	<AANLkTin9m65JVKRuStZ1-qhU5_1AY-GcbBRC0TodsfYC@mail.gmail.com>
	<20101107215030.007259800@cmpxchg.org>
	<20101107220353.964566018@cmpxchg.org>
Date: Mon, 8 Nov 2010 09:07:35 +0900
Message-ID: <AANLkTinh+LEQYGe9dDOKBwNnVVXMiFYpDqkqvvpNe9H8@mail.gmail.com>
Subject: Re: [patch 4/4] memcg: use native word page statistics counters
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Andrea Righi <arighi@develer.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 8, 2010 at 7:14 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> The statistic counters are in units of pages, there is no reason to
> make them 64-bit wide on 32-bit machines.
>
> Make them native words.  Since they are signed, this leaves 31 bit on
> 32-bit machines, which can represent roughly 8TB assuming a page size
> of 4k.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  include/linux/memcontrol.h |    2 +-
>  mm/memcontrol.c            |   43 +++++++++++++++++++++----------------------
>  mm/page-writeback.c        |    4 ++--
>  3 files changed, 24 insertions(+), 25 deletions(-)
>

<snip>

>
>  static unsigned long dirty_writeback_pages(void)
>  {
> -       s64 ret;
> +       unsigned long ret;
>
>        ret = mem_cgroup_page_stat(MEMCG_NR_DIRTY_WRITEBACK_PAGES);
> -       if (ret < 0)
> +       if ((long)ret < 0)
>                ret = global_page_state(NR_UNSTABLE_NFS) +
>                        global_page_state(NR_WRITEBACK);

BTW, let me ask a question.
dirty_writeback_pages seems to be depends on mem_cgroup_page_stat's
result(ie, negative) for separate global and memcg.
But mem_cgroup_page_stat could return negative value by per-cpu as
well as root cgroup.
If I understand right, Isn't it a problem?

-- 
Kind regards,
Minchan Kim
