Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab2K0LDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 06:03:05 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13899 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab2K0LDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 06:03:03 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 27 Nov 2012 03:02:58 -0800
Date: Tue, 27 Nov 2012 13:02:59 +0200
From: Sivaram Nair <sivaramn@nvidia.com>
To: Terje Bergstrom <tbergstrom@nvidia.com>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 2/8] video: tegra: Add syncpoint wait and interrupts
Message-ID: <20121127110259.GE10090@sivaramn-lnx>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
 <1353935954-13763-3-git-send-email-tbergstrom@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <1353935954-13763-3-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 02:19:08PM +0100, Terje Bergstrom wrote:
> +void nvhost_intr_stop(struct nvhost_intr *intr)
> +{
> +       unsigned int id;
> +       struct nvhost_intr_syncpt *syncpt;
> +       u32 nb_pts = nvhost_syncpt_nb_pts(&intr_to_dev(intr)->syncpt);
> +
> +       mutex_lock(&intr->mutex);
> +
> +       intr_op().disable_all_syncpt_intrs(intr);
> +
> +       for (id = 0, syncpt = intr->syncpt;
> +            id < nb_pts;
> +            ++id, ++syncpt) {
> +               struct nvhost_waitlist *waiter, *next;
> +               list_for_each_entry_safe(waiter, next,
> +                               &syncpt->wait_head, list) {
> +                       if (atomic_cmpxchg(&waiter->state,
> +                                               WLS_CANCELLED, WLS_HANDLED)
> +                               == WLS_CANCELLED) {
> +                               list_del(&waiter->list);
> +                               kref_put(&waiter->refcount, waiter_release);
> +                       }
> +               }
> +
> +               if (!list_empty(&syncpt->wait_head)) {  /* output diagnostics */
> +                       pr_warn("%s cannot stop syncpt intr id=%d\n",
> +                                       __func__, id);
> +                       return;

mutex_unlock() missing before return.

-Sivaram
