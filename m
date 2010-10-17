Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab0JQFdw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 01:33:52 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55575 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab0JQFdu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 01:33:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PPqNMAlX/mvawAnxlsGcAmxHPugScy37bF3kI0FOGRmPRIREvAbWkikP3eVxdB9fRk
         iwVpwUSZITa70FO7YAbNTJecPpa84/mvPiWOtji5EMbDd0EBIGtfJIhr9CWRuGblEmHz
         kF8Q3WxYxz1k8BRG3cqHrbPcITuou1yrahKz0=
MIME-Version: 1.0
In-Reply-To: <20101015171225.70d4ca8f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20101015170627.e5033fa4.kamezawa.hiroyu@jp.fujitsu.com>
	<20101015171225.70d4ca8f.kamezawa.hiroyu@jp.fujitsu.com>
Date: Sun, 17 Oct 2010 14:33:50 +0900
Message-ID: <AANLkTimDRuE9oBpj6h13wFKazuOzOm8UbFdM+qhbc0On@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/2] memcg: new lock for mutual execution of
 account_move and file stats
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        Greg Thelen <gthelen@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 5:12 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> When we try to enhance page's status update to support other flags,
> one of problem is updating status from IRQ context.
>
> Now, mem_cgroup_update_file_stat() takes lock_page_cgroup() to avoid
> race with _account move_. IOW, there are no races with charge/uncharge
> in nature. Considering an update from IRQ context, it seems better
> to disable IRQ at lock_page_cgroup() to avoid deadlock.
>
> But lock_page_cgroup() is used too widerly and adding IRQ disable
> there makes the performance bad. To avoid the big hammer, this patch
> adds a new lock for update_stat().
>
> This lock is for mutual execustion of updating stat and accout moving.
> This adds a new lock to move_account..so, this makes move_account slow.
> But considering trade-off, I think it's acceptable.
>
> A score of moving 8GB anon pages, 8cpu Xeon(3.1GHz) is here.
>
> [before patch] (mmotm + optimization patch (#1 in this series)
> [root@bluextal kamezawa]# time echo 2257 > /cgroup/B/tasks
>
> real    0m0.694s
> user    0m0.000s
> sys     0m0.683s
>
> [After patch]
> [root@bluextal kamezawa]# time echo 2238 > /cgroup/B/tasks
>
> real    0m0.741s
> user    0m0.000s
> sys     0m0.730s
>
> This moves 8Gbytes == 2048k pages. But no bad effects to codes
> other than "move".
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

It looks good than old approach.
Just a below nitpick.

> ---
>  include/linux/page_cgroup.h |   29 +++++++++++++++++++++++++++++
>  mm/memcontrol.c             |   11 +++++++++--
>  2 files changed, 38 insertions(+), 2 deletions(-)
>
> Index: mmotm-1013/include/linux/page_cgroup.h
> ===================================================================
> --- mmotm-1013.orig/include/linux/page_cgroup.h
> +++ mmotm-1013/include/linux/page_cgroup.h
> @@ -36,6 +36,7 @@ struct page_cgroup *lookup_page_cgroup(s
>  enum {
>        /* flags for mem_cgroup */
>        PCG_LOCK,  /* page cgroup is locked */
> +       PCG_LOCK_STATS, /* page cgroup's stat accounting flags are locked */

Hmm, I think naming isn't a good. Aren't both for stat?
As I understand, Both are used for stat.
One is just used by charge/uncharge and the other is used by
pdate_file_stat/move_account.
If you guys who are expert in mcg feel it with easy, I am not against.
But at least, mcg-not-familiar people like me don't feel it comfortable.





-- 
Kind regards,
Minchan Kim
