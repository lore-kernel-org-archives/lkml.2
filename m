Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab1GLF4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 01:56:22 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62413 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab1GLF4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 01:56:19 -0400
MIME-Version: 1.0
In-Reply-To: <1310370416-6322-10-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com> <1310370416-6322-10-git-send-email-jim.cromie@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 12 Jul 2011 07:55:58 +0200
X-Google-Sender-Auth: mMZkVpg0UfTFMH_ulsv-V1xuxzs
Message-ID: <CAO+b5-qyh6Eqj2dbYoNdQrYERdAZt0vL-3H=1cptWQP-vMUp7w@mail.gmail.com>
Subject: Re: [PATCH 09/21] dynamic_debug: save_pending() saves non-matching
 queries for later.
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 9:46 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
> +/* copy query off stack, save flags & mask, and store in pending-list */
> +static int ddebug_save_pending(struct ddebug_query *query,
> +                               unsigned int flags, unsigned int mask)
> +{
> +       struct pending_query *pq;
> +
> +       if (verbose)
> +               pr_info("add to pending: %s\n", show_ddebug_query(query));
> +
> +       pending_ct++;
> +       pq = kzalloc(sizeof(struct pending_query), GFP_KERNEL);
> +       if (pq == NULL)
> +               return -ENOMEM;
> +
> +       /* copy non-null match-specs into allocd mem, update pointers */
> +       if (query->module)
> +               pq->query.module = strcpy(pq->module, query->module);
> +       if (query->function)
> +               pq->query.function = strcpy(pq->function, query->function);
> +       if (query->filename)
> +               pq->query.filename = strcpy(pq->filename, query->filename);
> +       if (query->format)
> +               pq->query.format = strcpy(pq->format, query->format);
> +
> +       pq->flags = flags;
> +       pq->mask = mask;
> +
> +       mutex_lock(&ddebug_lock);
> +       list_add(&pq->link, &pending_queries);
> +       mutex_unlock(&ddebug_lock);
> +
> +       if (verbose)
> +               pr_info("query saved as pending %d\n", pending_ct);
> +       return 0;
> +}

As I wrote before, manipulating pending_ct without protecting it by
any kind of locking is racy.

Bart.
