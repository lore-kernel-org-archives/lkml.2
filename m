Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab2KUK4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 05:56:32 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55706
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752143Ab2KUK4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 05:56:31 -0500
Date: Wed, 21 Nov 2012 05:56:24 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
        tytso@mit.edu, rminnich@sandia.gov, viro@zeniv.linux.org.uk,
        martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
        v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/4] bdi: Track users that require stable page writes
Message-ID: <20121121105624.GA19050@infradead.org>
References: <20121121020027.10225.43206.stgit@blackbox.djwong.org>
 <20121121020034.10225.51692.stgit@blackbox.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121121020034.10225.51692.stgit@blackbox.djwong.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static inline void bdi_require_stable_pages(struct backing_dev_info *bdi)
> +{
> +	bdi->capabilities |= BDI_CAP_STABLE_WRITES;
> +}
> +
> +static inline void bdi_unrequire_stable_pages(struct backing_dev_info *bdi)
> +{
> +	bdi->capabilities &= ~BDI_CAP_STABLE_WRITES;
> +}

Any reason to provide these wrappers while other BDI_CAP_ values don't
have it/

Also what protects bdi->capabilities against concurrent updates now that
it gets modified at runtime?

> +static inline void queue_require_stable_pages(struct request_queue *q)
> +{
> +	bdi_require_stable_pages(&q->backing_dev_info);
> +}
> +
> +static inline void queue_unrequire_stable_pages(struct request_queue *q)
> +{
> +	bdi_unrequire_stable_pages(&q->backing_dev_info);
> +}
> +
> +static inline int queue_requires_stable_pages(struct request_queue *q)
> +{
> +	return bdi_cap_stable_pages_required(&q->backing_dev_info);
> +}

Independent of the above I see no point in these wrappers that just
provide a single dereference.

> +static ssize_t stable_pages_required_store(struct device *dev,
> +					   struct device_attribute *attr,
> +					   const char *buf, size_t count)

Can you add a rationale on why we'd want to allow users to change the
value?  I can't really think of any.

