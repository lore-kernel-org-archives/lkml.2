Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab2G0UDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 16:03:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:56568 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab2G0UDF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 16:03:05 -0400
Message-ID: <1343419375.32120.48.camel@twins>
Subject: Re: [PATCH 5/6] rbtree: faster augmented erase
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: riel@redhat.com, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Fri, 27 Jul 2012 22:02:55 +0200
In-Reply-To: <1342787467-5493-6-git-send-email-walken@google.com>
References: <1342787467-5493-1-git-send-email-walken@google.com>
	 <1342787467-5493-6-git-send-email-walken@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-20 at 05:31 -0700, Michel Lespinasse wrote:
> +static inline void
> +rb_erase_augmented(struct rb_node *node, struct rb_root *root,
> +                  rb_augment_propagate *augment_propagate,
> +                  rb_augment_rotate *augment_rotate) 

So why put all this in a static inline in a header? As it stands
rb_erase() isn't inlined and its rather big, why would you want to
inline it for augmented callers? 

You could at least pull out the initial erase stuff into a separate
function, that way the rb_erase_augmented thing would shrink to
something like:

rb_erase_augmented(node, root)
{
	struct rb_node *parent, *child;
	bool black;

	__rb_erase(node, root, &parent, &child, &black);
	augmented_propagate(parent);
	if (black)
		__rb_erase_color(child, parent, root, augment_rotate);
}


