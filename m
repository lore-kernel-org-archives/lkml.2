Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab0LQD2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 22:28:46 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:34072 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab0LQD2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 22:28:46 -0500
Date: Fri, 17 Dec 2010 12:27:21 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] radix_tree_destroy?
Message-ID: <20101217032721.GD20847@linux-sh.org>
References: <62b1cf2f-17ec-45c9-a980-308d9b75cdc5@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62b1cf2f-17ec-45c9-a980-308d9b75cdc5@default>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 08:27:41AM -0800, Dan Magenheimer wrote:
> +static void
> +radix_tree_node_destroy(struct radix_tree_node *node, unsigned int height,
> +			void (*slot_free)(void *))
> +{
> +	int i;
> +
> +	if (height == 0)
> +		return;
> +	for (i = 0; i < RADIX_TREE_MAP_SIZE; i++) {
> +		if (node->slots[i]) {
> +			if (height > 1) {
> +				radix_tree_node_destroy(node->slots[i],
> +					height-1, slot_free);
> +				radix_tree_node_free(node->slots[i]);
> +				node->slots[i] = NULL;
> +			} else
> +				slot_free(node->slots[i]);
> +		}
> +	}
> +}
> +
> +void radix_tree_destroy(struct radix_tree_root *root, void (*slot_free)(void *))
> +{
> +	if (root->rnode == NULL)
> +		return;
> +	if (root->height == 0)
> +		slot_free(root->rnode);

Don't you want indirect_to_ptr(root->rnode) here? You probably also don't
want the callback in the !radix_tree_is_indirect_ptr() case.

> +	else {
> +		radix_tree_node_destroy(root->rnode, root->height, slot_free);
> +		radix_tree_node_free(root->rnode);
> +		root->height = 0;
> +	}
> +	root->rnode = NULL;
> +}

The above will handle the nodes, but what about the root? It looks like
you're at least going to leak tags on the root, so at the very least
you'd still want a root_tag_clear_all() here.
