Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800Ab2IKSgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 14:36:32 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39254 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758262Ab2IKSga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 14:36:30 -0400
MIME-Version: 1.0
In-Reply-To: <20120910215633.GA19739@google.com>
References: <1347055973-11581-1-git-send-email-koverstreet@google.com>
	<1347055973-11581-3-git-send-email-koverstreet@google.com>
	<20120908193641.GB12773@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120910002810.GA23241@moria.home.lan>
	<20120910172210.GC14103@google.com>
	<20120910202435.GG16360@google.com>
	<20120910204010.GA32310@google.com>
	<20120910213349.GH16360@google.com>
	<20120910213710.GA7677@google.com>
	<20120910215633.GA19739@google.com>
Date: Tue, 11 Sep 2012 11:36:28 -0700
Message-ID: <CAFR8ued=Le4B4i_Rf4eECXsVgKvce9J7bO9sDSS91PFzBZ6j5w@mail.gmail.com>
Subject: Re: [PATCH 2/2] block: Avoid deadlocks with bio allocation by
 stacking drivers
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk,
        Vivek Goyal <vgoyal@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
        bharrosh@panasas.com, david@fromorbit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kent,

On Mon, Sep 10, 2012 at 2:56 PM, Kent Overstreet <koverstreet@google.com> wrote:
..
<snip>
..

>
> +static void bio_alloc_rescue(struct work_struct *work)
> +{
> +       struct bio_set *bs = container_of(work, struct bio_set, rescue_work);
> +       struct bio *bio;
> +
> +       while (1) {
> +               spin_lock(&bs->rescue_lock);
> +               bio = bio_list_pop(&bs->rescue_list);
> +               spin_unlock(&bs->rescue_lock);
> +
> +               if (!bio)
> +                       break;
> +
> +               generic_make_request(bio);
> +       }
> +}
> +
> +static void punt_bios_to_rescuer(struct bio_set *bs)
> +{
> +       struct bio_list punt, nopunt;
> +       struct bio *bio;
> +
> +       /*
> +        * In order to guarantee forward progress we must punt only bios that
> +        * were allocated from this bio_set; otherwise, if there was a bio on
> +        * there for a stacking driver higher up in the stack, processing it
> +        * could require allocating bios from this bio_set, and doing that from
> +        * our own rescuer would be bad.
> +        *
> +        * Since bio lists are singly linked, pop them all instead of trying to
> +        * remove from the middle of the list:
> +        */
> +
> +       bio_list_init(&punt);
> +       bio_list_init(&nopunt);
> +
> +       while ((bio = bio_list_pop(current->bio_list)))
> +               bio_list_add(bio->bi_pool == bs ? &punt : &nopunt, bio);
> +
> +       *current->bio_list = nopunt;
> +
> +       spin_lock(&bs->rescue_lock);
> +       bio_list_merge(&bs->rescue_list, &punt);
> +       spin_unlock(&bs->rescue_lock);
> +
> +       queue_work(bs->rescue_workqueue, &bs->rescue_work);
> +}


Does this preserve the CPU from which the bio was submitted
originally. Not familiar with cmwq, may be Tejun can clarify.

Tejun - the question is, do we honor the rq_affinity with the above
rescue worker implementation?

Regards,
Muthu
