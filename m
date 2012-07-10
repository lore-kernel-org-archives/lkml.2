Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab2GJM1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 08:27:37 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33423 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab2GJM1f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 08:27:35 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        peterz@infradead.org, daniel.santos@pobox.com, axboe@kernel.dk,
        ebiederm@xmission.com, "Michel Lespinasse" <walken@google.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 05/13] rbtree: performance and correctness test
References: <1341876923-12469-1-git-send-email-walken@google.com>
 <1341876923-12469-6-git-send-email-walken@google.com>
Date: Tue, 10 Jul 2012 14:27:32 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.wg8cv6x53l0zgt@mpn-glaptop>
In-Reply-To: <1341876923-12469-6-git-send-email-walken@google.com>
User-Agent: Opera Mail/12.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2012 01:35:15 +0200, Michel Lespinasse <walken@google.com> wrote:

> This small module helps measure the performance of rbtree insert and erase.
>
> Additionally, we run a few correctness tests to check that the rbtrees have
> all desired properties:
> - contains the right number of nodes in the order desired,
> - never two consecutive red nodes on any path,
> - all paths to leaf nodes have the same number of black nodes,
> - root node is black
>
> Signed-off-by: Michel Lespinasse <walken@google.com>
> ---
>  tests/rbtree_test.c |  135 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 135 insertions(+), 0 deletions(-)
>  create mode 100644 tests/rbtree_test.c
>
> diff --git a/tests/rbtree_test.c b/tests/rbtree_test.c
> new file mode 100644
> index 0000000..2e3944d
> --- /dev/null
> +++ b/tests/rbtree_test.c
> @@ -0,0 +1,135 @@
> +#include <linux/module.h>
> +#include <linux/rbtree.h>
> +#include <linux/random.h>
> +#include <asm/timex.h>
> +
> +#define NODES       100
> +#define PERF_LOOPS  100000
> +#define CHECK_LOOPS 100
> +
> +struct test_node {
> +	struct rb_node rb;
> +	u32 key;
> +};
> +
> +static struct rb_root root = RB_ROOT;
> +static struct test_node nodes[NODES];
> +
> +static struct rnd_state rnd;
> +
> +static void insert(struct test_node *node, struct rb_root *root)
> +{
> +	struct rb_node **new = &root->rb_node, *parent = NULL;
> +
> +	while (*new) {
> +		parent = *new;
> +		if (node->key < rb_entry(parent, struct test_node, rb)->key)
> +			new = &parent->rb_left;
> +		else
> +			new = &parent->rb_right;
> +	}
> +
> +	rb_link_node(&node->rb, parent, new);
> +	rb_insert_color(&node->rb, root);
> +}
> +
> +static inline void erase(struct test_node *node, struct rb_root *root)
> +{
> +	rb_erase(&node->rb, root);
> +}
> +
> +static void init(void)
> +{
> +	int i;
> +	for (i = 0; i < NODES; i++)

s/NODES/ARRAY_SIZE(nodes)/ perhaps?  Same goes for the rest of the code.

> +		nodes[i].key = prandom32(&rnd);
> +}
> +
> +static bool is_red(struct rb_node *rb)
> +{
> +	return rb->rb_parent_color == (unsigned long)rb_parent(rb);

Why not !(rb->rb_parent_color & 1) which to me seems more intuitive.

> +}
> +
> +static int black_path_count(struct rb_node *rb)
> +{
> +	int count;
> +	for (count = 0; rb; rb = rb_parent(rb))
> +		count += !is_red(rb);
> +	return count;
> +}
> +
> +static void check(int nr_nodes)
> +{
> +	struct rb_node *rb;
> +	int count = 0;
> +	int blacks;
> +	u32 prev_key = 0;
> +
> +	for (rb = rb_first(&root); rb; rb = rb_next(rb)) {
> +		struct test_node *node = rb_entry(rb, struct test_node, rb);
> +		WARN_ON_ONCE(node->key < prev_key);

What if for some reason we generate node with key equal zero or two keys
with the same value?  It may not be the case for current code, but someone
might change it in the future.  I think <= is safer here.

> +		WARN_ON_ONCE(is_red(rb) &&
> +			     (!rb_parent(rb) || is_red(rb_parent(rb))));
> +		if (!count)
> +			blacks = black_path_count(rb);
> +		else
> +			WARN_ON_ONCE((!rb->rb_left || !rb->rb_right) &&
> +				     blacks != black_path_count(rb));
> +		prev_key = node->key;
> +		count++;
> +	}
> +	WARN_ON_ONCE(count != nr_nodes);
> +}
> +
> +static int rbtree_test_init(void)
> +{
> +	int i, j;
> +	cycles_t time1, time2, time;
> +
> +	printk(KERN_ALERT "rbtree testing");
> +
> +	prandom32_seed(&rnd, 3141592653589793238);
> +	init();
> +
> +	time1 = get_cycles();
> +
> +	for (i = 0; i < PERF_LOOPS; i++) {
> +		for (j = 0; j < NODES; j++)
> +			insert(nodes + j, &root);
> +		for (j = 0; j < NODES; j++)
> +			erase(nodes + j, &root);
> +	}
> +
> +	time2 = get_cycles();
> +	time = time2 - time1;
> +
> +	time = div_u64(time, PERF_LOOPS);
> +	printk(" -> %llu cycles\n", time);
> +
> +	for (i = 0; i < CHECK_LOOPS; i++) {
> +		init();

Is this init() needed?

> +		for (j = 0; j < NODES; j++) {
> +			check(j);
> +			insert(nodes + j, &root);
> +		}
> +		for (j = 0; j < NODES; j++) {
> +			check(NODES - j);
> +			erase(nodes + j, &root);
> +		}
> +		check(0);
> +	}
> +
> +	return -EAGAIN; /* Fail will directly unload the module */
> +}

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
