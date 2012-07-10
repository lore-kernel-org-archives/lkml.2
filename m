Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab2GJLBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:01:21 -0400
Received: from nm30.access.bullet.mail.sp2.yahoo.com ([98.139.44.157]:30066
	"HELO nm30.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753544Ab2GJK7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 06:59:15 -0400
X-Yahoo-Newman-Id: 380001.26824.bm@omp1022.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 5gpTrs4VM1mBPDZzlxumORZDqz_.V7MPGMMpvl50zqcFVap
 TQ9nnA27F.NpwpI1Aw2u4tDSwNuT2aCp0mvwvFwaOxQCrfGtxdgrUkcapm6c
 jHyVRF6ReMgkvdlA4Ec81WZ7EY_uI0KIayZh3t3rSsfsNIGpD1ksTR7MxekT
 kWM34jCYOj516cioq.XCZUjdBJyNJ_hlkYZLM.BZ_2mT5GpCNqBoPj3q0wfa
 Pb5wO97JU8NtnHHzeMzg1b0emjS3oUzoaJ8l5JkPhFm44x9qISrLD8ZZUWjR
 1K91jm9h2xZn2AeKq8fgg5zWxfcYItERqjmFx3ZmZb8LrzNto9u.XnVJm6p2
 HbTcM5MDdzmqpPt455skL1pLjF.rgLlpm50oD7rO2lPaeI0FnHvqz4UBxvQF
 j8oqzkw--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FFC0B0E.8070600@att.net>
Date: Tue, 10 Jul 2012 05:59:26 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        peterz@infradead.org, axboe@kernel.dk, ebiederm@xmission.com,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 02/13] rbtree: empty nodes have no color
References: <1341876923-12469-1-git-send-email-walken@google.com> <1341876923-12469-3-git-send-email-walken@google.com>
In-Reply-To: <1341876923-12469-3-git-send-email-walken@google.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2012 06:35 PM, Michel Lespinasse wrote:
> Empty nodes have no color.  We can make use of this property to
> simplify the code emitted by the RB_EMPTY_NODE and RB_CLEAR_NODE
> macros.  Also, we can get rid of the rb_init_node function which had
> been introduced by commit 88d19cf37952a7e1e38b2bf87a00f0e857e63180
> to avoid some issue with the empty node's color not being initialized.
Oh sweet, very glad to see this.  I'm addressing a fairly large scope of
things in my patches and I didn't want to address this yet, so I'm glad
somebody has. :)  I *hoped* that gcc would figure out some of the
excesses of rb_init_node and and just set rb_parent_color directly to
the node address, but better to have actually fixed.  As far as
RB_EMPTY_NODE, I am using that in my test code (which I haven't posted
yet) since I'm testing the actual integrity of a tree and a set of
objects after performing insertions & such on it.  I'm also using it in
some new CONFIG_RBTREE_DEBUG-enabled code.
> I'm not sure what the RB_EMPTY_NODE checks in rb_prev() / rb_next()
> are doing there, though. axboe introduced them in commit 10fd48f2376d.
> The way I see it, the 'empty node' abstraction is only used by rbtree
> users to flag nodes that they haven't inserted in any rbtree, so asking
> the predecessor or successor of such nodes doesn't make any sense.
>
> One final rb_init_node() caller was recently added in sysctl code
> to implement faster sysctl name lookups. This code doesn't make use
> of RB_EMPTY_NODE at all, and from what I could see it only called
> rb_init_node() under the mistaken assumption that such initialization
> was required before node insertion.
That was one of the problems with rb_init_node().  Not being documented,
one would assume it's needed unless you study the code more closely.

BTW, the current revision of my patches adds some doc comments to struct
rb_node since the actual function of rb_parent_color isn't very clear
without a lot of study.

/**
 * struct rb_node
 * @rb_parent_color: Contains the color in the lower 2 bits (although
only bit
 *              zero is currently used) and the address of the parent in
 *              the rest (lower 2 bits of address should always be zero on
 *              any arch supported).  If the node is initialized and not a
 *              member of any tree, the parent point to its self.  If the
 *              node belongs to a tree, but is the root element, the
 *              parent will be NULL.  Otherwise, parent will always
 *              point to the parent node in the tree.
 * @rb_right:        Pointer to the right element.
 * @rb_left:         Pointer to the left element.
 */

That said, there's an extra bit in the rb_parent_color that can be used
for some future purpose.

Daniel
