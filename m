Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231Ab2E1XfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 19:35:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44824 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab2E1XfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 19:35:17 -0400
Date: Tue, 29 May 2012 08:35:10 +0900
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        axboe@kernel.dk, paul.gortmaker@windriver.com
Subject: Re: [PATCH 1/3] rbtree: Add rb_insert(), rb_search(), etc.
Message-ID: <20120528233510.GD20954@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1337979461-19654-1-git-send-email-koverstreet@google.com>
 <1337979461-19654-2-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337979461-19654-2-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

Please cc akpm.

On Fri, May 25, 2012 at 01:57:39PM -0700, Kent Overstreet wrote:
> Change-Id: I072d94a42b75454aa62be849c724980d27523b08
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>

Same complaints.

And function comments please.

> +static inline int _rb_insert(struct rb_root *root,
> +			     struct rb_node *new,
> +			     rb_cmp_t cmp)
> +{
> +	struct rb_node **n = &root->rb_node, *parent = NULL;
> +	int res;
> +
> +	while (*n) {
> +		parent = *n;
> +		res = cmp(new, *n);
> +		if (!res)
> +			return -1;

-EINVAL?

> +		n = res < 0
> +			? &(*n)->rb_left
> +			: &(*n)->rb_right;

I don't know.  I'm finding this formatting rather weird.  If ?: has to
be used and line has to break, how about the following?

		n = res < 0 ? A
			    : B;

Or how about using good'ol if else?

	if (res < 0)
		n = A;
	else if (res > 0)
		n = B;
	else
		return -EINVAL;

> +	}
> +
> +	rb_link_node(new, parent, n);
> +	rb_insert_color(new, root);
> +	return 0;
> +}
> +
> +static inline void _rb_insert_allow_dup(struct rb_root *root,
> +				       struct rb_node *new,
> +				       rb_cmp_t cmp)
> +{
> +	struct rb_node **n = &root->rb_node, *parent = NULL;
> +
> +	while (*n) {
> +		parent = *n;
> +		n = cmp(new, *n) < 0
> +			? &(*n)->rb_left
> +			: &(*n)->rb_right;

Ditto.

> +	}
> +
> +	rb_link_node(new, parent, n);
> +	rb_insert_color(new, root);
> +}
> +
> +static inline struct rb_node *_rb_search(struct rb_root *root,
> +					 struct rb_node *search,
> +					 rb_cmp_t cmp)
> +{
> +	struct rb_node *n = root->rb_node;
> +
> +	while (n) {
> +		int res = cmp(search, n);
> +		if (!res)
> +			return n;
> +
> +		n = res < 0
> +			? n->rb_left
> +			: n->rb_right;
> +	}
> +
> +	return NULL;
> +}
> +
> +static inline struct rb_node *_rb_greater(struct rb_root *root,
> +					  struct rb_node *search,
> +					  rb_cmp_t cmp)
> +{
> +	struct rb_node *n = root->rb_node;
> +	struct rb_node *ret = NULL;
> +
> +	while (n) {
> +		int res = cmp(search, n);
> +
> +		if (res < 0) {
> +			ret = n;
> +			n = n->rb_left;
> +		} else {
> +			n = n->rb_right;
> +		}
> +	}
> +
> +	return ret;
> +}

What does _rb_greater() do?  If these are gonna be inlined, can't we
mostly just have single lookup function which returns either the found
node or insertion position and let each wrapper deal with the
specifics?

Thanks.

-- 
tejun
