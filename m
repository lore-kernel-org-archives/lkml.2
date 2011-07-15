Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab1GOXqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 19:46:34 -0400
Received: from mail.perches.com ([173.55.12.10]:4046 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab1GOXqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 19:46:33 -0400
Subject: Re: [PATCH 11/11 re-post] dynamic_debug: use a single printk() to
 emit msgs
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>, gregkh@suse.de, jim.cromie@gmail.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110715195903.GA7470@redhat.com>
References: <cover.1310657068.git.jbaron@redhat.com>
	 <3667c0a87dd8fd64fdf1b1e8107b130a9b41096e.1310657068.git.jbaron@redhat.com>
	 <CAO+b5-qA3s92YX2izXzvzt3MOrzRaPcZtDtK0cDte0ZXnRWxhA@mail.gmail.com>
	 <1310744914.7582.36.camel@Joe-Laptop>
	 <CAO+b5-p2B74+oVQRGcGxMp5ULZy8ZmF215Lz4qhbU=C4RnG8dw@mail.gmail.com>
	 <20110715160417.GB2493@redhat.com>
	 <CAO+b5-qgrV=gfZAczxfPbGqVtv4ZD_zZHOn-BMVY9wnJytbrtw@mail.gmail.com>
	 <1310746580.7582.50.camel@Joe-Laptop>  <20110715195903.GA7470@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 16:46:31 -0700
Message-ID: <1310773591.10603.9.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 15:59 -0400, Jason Baron wrote:
> here's Bart's suggestion as re-post. It looks much cleaner to
> me...
[]
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
[]
> @@ -422,52 +422,46 @@ static int ddebug_exec_query(char *query_string)
>  	return 0;
>  }
>  
> -static int dynamic_emit_prefix(const struct _ddebug *descriptor)
> +#define PREFIX_SIZE 64
> +#define LEFT(wrote) ((PREFIX_SIZE - wrote) > 0) ? (PREFIX_SIZE - wrote) : 0
> +
> +static char *dynamic_emit_prefix(const struct _ddebug *desc, char *buf)
>  {
> -	char tid[sizeof(int) + sizeof(int)/2 + 4];
> -	char lineno[sizeof(int) + sizeof(int)/2];
> +	int pos = 0;
>  
> -	if (descriptor->flags & _DPRINTK_FLAGS_INCL_TID) {
> +	pos += snprintf(buf + pos, LEFT(pos), "%s", KERN_DEBUG);
> +	if (desc->flags & _DPRINTK_FLAGS_INCL_TID) {
>  		if (in_interrupt())
> -			snprintf(tid, sizeof(tid), "%s", "<intr> ");
> +			pos += snprintf(buf + pos, LEFT(pos), "%s ",
> +						"<intr>");

scnprintf works without using LEFT.
snprintf does as well.

http://lkml.org/lkml/2010/7/23/375


