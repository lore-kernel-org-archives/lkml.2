Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab0JSBR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 21:17:58 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39738 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab0JSBR4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 21:17:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dtYlzS47lWh8k9VXa/Y/yN4lZUQSXwSuBjw36hAWmyKE0d2kSC+3iJmoPhexz9s/CF
         8nLjlM5KDJON9JR50LY9yYAUYgcD7nkBeLn7Q6dSJPNYn/3d3Zn6YUKF0Ry5lWXKllAa
         WfMffz2HuEZmyBhLwIMEl7fq84mnFcXciR4tY=
MIME-Version: 1.0
In-Reply-To: <1287448784-25684-5-git-send-email-gthelen@google.com>
References: <1287448784-25684-1-git-send-email-gthelen@google.com>
	<1287448784-25684-5-git-send-email-gthelen@google.com>
Date: Tue, 19 Oct 2010 10:17:55 +0900
Message-ID: <AANLkTikoV=ximPhT+XsKQahNYQBOpW5Tji5bme6pqZST@mail.gmail.com>
Subject: Re: [PATCH v3 04/11] memcg: add lock to synchronize page accounting
 and migration
From: Minchan Kim <minchan.kim@gmail.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 9:39 AM, Greg Thelen <gthelen@google.com> wrote:
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> Introduce a new bit spin lock, PCG_MOVE_LOCK, to synchronize
> the page accounting and migration code.  This reworks the
> locking scheme of _update_stat() and _move_account() by
> adding new lock bit PCG_MOVE_LOCK, which is always taken
> under IRQ disable.
>
> 1. If pages are being migrated from a memcg, then updates to
>   that memcg page statistics are protected by grabbing
>   PCG_MOVE_LOCK using move_lock_page_cgroup().  In an
>   upcoming commit, memcg dirty page accounting will be
>   updating memcg page accounting (specifically: num
>   writeback pages) from IRQ context (softirq).  Avoid a
>   deadlocking nested spin lock attempt by disabling irq on
>   the local processor when grabbing the PCG_MOVE_LOCK.
>
> 2. lock for update_page_stat is used only for avoiding race
>   with move_account().  So, IRQ awareness of
>   lock_page_cgroup() itself is not a problem.  The problem
>   is between mem_cgroup_update_page_stat() and
>   mem_cgroup_move_account_page().
>
> Trade-off:
>  * Changing lock_page_cgroup() to always disable IRQ (or
>    local_bh) has some impacts on performance and I think
>    it's bad to disable IRQ when it's not necessary.
>  * adding a new lock makes move_account() slower.  Score is
>    here.
>
> Performance Impact: moving a 8G anon process.
>
> Before:
>        real    0m0.792s
>        user    0m0.000s
>        sys     0m0.780s
>
> After:
>        real    0m0.854s
>        user    0m0.000s
>        sys     0m0.842s
>
> This score is bad but planned patches for optimization can reduce
> this impact.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Greg Thelen <gthelen@google.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim
