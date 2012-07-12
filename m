Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908Ab2GLONI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:13:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42980 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab2GLONG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:13:06 -0400
Message-ID: <1342102376.28010.7.camel@twins>
Subject: Re: [PATCH 00/13] rbtree updates
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        daniel.santos@pobox.com, axboe@kernel.dk, ebiederm@xmission.com,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Thu, 12 Jul 2012 16:12:56 +0200
In-Reply-To: <20120712011208.GA1152@google.com>
References: <1341876923-12469-1-git-send-email-walken@google.com>
	 <1342012996.3462.154.camel@twins> <20120712011208.GA1152@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 18:12 -0700, Michel Lespinasse wrote:
> 
> In __rb_erase_color(), some of the cases are more complicated than you drew however, because some node colors aren't known.

Right, the wikipedia article draws them blank, I couldn't come up with a
3rd case, although maybe we can annotate them like (P) to mean blank..


> This is what I ended up with:
> 
>   *  5), then the longest possible path due to 4 is 2B.
>   *
>   *  We shall indicate color with case, where black nodes are uppercase and red
> - *  nodes will be lowercase.
> + *  nodes will be lowercase. Unknown color nodes shall be drawn as red with
> + *  some accompanying text comment.
>   */
> 
> +                                       /*
> +                                        * Case 2 - sibling color flip
> +                                        * (p could be either color here)
> +                                        *
> +                                        *     p             p
> +                                        *    / \           / \
> +                                        *   N   S    -->  N   s
> +                                        *      / \           / \
> +                                        *     Sl  Sr        Sl  Sr
> +                                        *
> +                                        * This leaves us violating 5), so
> +                                        * recurse at p. If p is red, the
> +                                        * recursion will just flip it to black
> +                                        * and exit. If coming from Case 1,
> +                                        * p is known to be red.
> +                                        */
> 
> +                               /*
> +                                * Case 3 - right rotate at sibling
> +                                * (p could be either color here)
> +                                *
> +                                *    p             p
> +                                *   / \           / \
> +                                *  N   S    -->  N   Sl
> +                                *     / \             \
> +                                *    sl  Sr            s
> +                                *                       \
> +                                *                        Sr
> +                                */
> 
> +                       /*
> +                        * Case 4 - left rotate at parent + color flips
> +                        * (p and sl could be either color here.
> +                        *  After rotation, p becomes black, s acquires
> +                        *  p's color, and sl keeps its color)
> +                        *
> +                        *       p               s
> +                        *      / \             / \
> +                        *     N   S     -->   P   Sr
> +                        *        / \         / \
> +                        *       sl  sr      N   sl
> +                        */ 


Yes, very nice.. someday when I'm bored I might expand the comments with
the reason why we're doing the given operation.

Also, I was sorely tempted to rename your tmp1,tmp2 variables to sl and
sr.
