Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab0JRQtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 12:49:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab0JRQto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 12:49:44 -0400
Subject: Re: ima: use of radix tree cache indexing == massive waste of
 memory?
From: Eric Paris <eparis@redhat.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
        kernel@lists.fedoraproject.org, Mimi Zohar <zohar@us.ibm.com>,
        warthog9@kernel.org, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Serge Hallyn <serue@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
In-Reply-To: <20101018062530.GD8332@bombadil.infradead.org>
References: <20101016065206.GO4681@dastard>
	 <20101016192027.GA6883@infradead.org>
	 <ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com>
	 <20101017004945.GE1614@infradead.org> <20101017054008.GA16383@elte.hu>
	 <20101017184652.GB28060@infradead.org>
	 <alpine.LRH.2.00.1010181127480.9476@tundra.namei.org>
	 <20101018062530.GD8332@bombadil.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 12:48:54 -0400
Message-ID: <1287420534.2530.67.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 02:25 -0400, Kyle McMartin wrote:
> If someone gives me a good reason why Fedora actually needs this
> enabled, I'm going to apply the following patch to our kernel so that
> IMA is globally an opt-in feature... Otherwise I'm inclined to just
> disable it.

I'll can address this on the fedora list, but I think this is the wrong
approach.  IMA is supposed to be of negligible impact when not 'enabled'
and I believe the right solution is to fix places where that isn't true.
At the moment 3 have been identified.

1) IMA uses radix trees which end up wasting 500 bytes per inode because
the key is too sparse.  I've got a patch which uses an rbtree instead
I'm testing and will send along shortly.  I found it funny working on
the patch to see that Documentation/rbtree.txt says "This differs from
radix trees (which are used to efficiently store sparse arrays and thus
use long integer indexes to insert/access/delete nodes)"  Which flys in
the face of this report.

2) IMA creates an entire integrity structure for every inode even when
most or all of this structure will not be needed.

3) IMA serializes bringing inodes into and out of core because it takes
a spinlock() when adding or removing the integrity structure to the
radix/rbtree.

I've got a patch for #1 and think 2 and 3 are relatively simple to fix
as well.  Certainly #2 is, and I think that will lead to a solution to
#3.


> diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
> index afba4ae..767f026 100644
> --- a/security/integrity/ima/ima_iint.c
> +++ b/security/integrity/ima/ima_iint.c

> @@ -139,6 +139,11 @@ static void init_once(void *foo)
>  
>  static int __init ima_iintcache_init(void)
>  {
> +	extern int ima_enabled;

extern in a .c file?  didn't you already expose this in the
appropriate .h file?

> +
> +	if (!ima_enabled)
> +		return 0;
> +
>  	iint_cache =
>  	    kmem_cache_create("iint_cache", sizeof(struct ima_iint_cache), 0,
>  			      SLAB_PANIC, init_once);
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index e662b89..92e084c 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -26,6 +26,7 @@
>  #include "ima.h"
>  
>  int ima_initialized;
> +int ima_enabled = 0;

initializing a global?

>  
>  char *ima_hash = "sha1";
>  static int __init hash_setup(char *str)


