Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab1GCIiW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 04:38:22 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40361 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab1GCIiT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 04:38:19 -0400
MIME-Version: 1.0
In-Reply-To: <1309244992-2305-11-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com> <1309244992-2305-11-git-send-email-jim.cromie@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Sun, 3 Jul 2011 10:37:59 +0200
X-Google-Sender-Auth: aKaOPI1bIYlIU_YTNc98NpEkJyQ
Message-ID: <CAO+b5-q_9-U8s+RnZ2JudC0=i_J56E9mZE8RbezNCe+9BueOrg@mail.gmail.com>
Subject: Re: [PATCH 10/11] dynamic_debug: call apply_pending_queries from ddebug_add_module
To: Jim Cromie <jim.cromie@gmail.com>
Cc: linux-kernel@vger.kernel.org, gnb@fmeh.org, jbaron@redhat.com,
        gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 9:09 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
> +/* apply matching queries in pending-queries list */
> +static void apply_pending_queries(struct ddebug_table *dt)
> +{
> +       struct pending_query *pq, *pqnext;
> +       int nfound;
> +
> +       if (verbose)
> +               pr_info("pending_ct: %d\n", pending_ct);
> +
> +       list_for_each_entry_safe(pq, pqnext, &pending_queries, link) {
> +
> +               if (verbose)
> +                       pr_info("check: %s <-> %s\n",
> +                               dt->mod_name, show_pending_query(pq));
> +
> +               nfound = ddebug_change(&pq->query, pq->flags, pq->mask);
> +
> +               if (nfound) {
> +                       mutex_lock(&ddebug_lock);
> +                       list_del(&pq->link);
> +                       mutex_unlock(&ddebug_lock);
> +                       kfree(pq);
> +                       pending_ct--;
> +               }
> +               else if (verbose)
> +                       pr_info("no-match: %s\n", show_pending_query(pq));
> +       }

The above code doesn't look thread-safe to me. List walking, list
deletion and pending_ct manipulation all should be protected by the
ddebug_lock mutex instead of only list deletion.

Also, why to remove pending entries once a match has been found ? The
resulting behavior will be that when unloading and reloading a kernel
module repeatedly that only the first time a kernel module is loaded
the matching dynamic debug statements in the loaded module will be
enabled.

Bart.
