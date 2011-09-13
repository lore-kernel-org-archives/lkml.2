Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab1IMUwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 16:52:43 -0400
Received: from smtp-out.google.com ([74.125.121.67]:45925 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446Ab1IMUwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 16:52:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=V3gsWBuGUB2GrMHzwvAaTIgdEcea+fHk3VgoCsMu0EIBzqm7qliP1m7fMMAzkzcqo
	wh+OhWECfrppf2FVau51w==
Date: Tue, 13 Sep 2011 13:51:07 -0700
From: Andrew Morton <akpm@google.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, jeremy@goop.org, hughd@google.com,
        ngupta@vflare.org, konrad.wilk@oracle.com, JBeulich@novell.com,
        kurt.hackel@oracle.com, npiggin@kernel.dk, riel@redhat.com,
        hannes@cmpxchg.org, matthew@wil.cx, chris.mason@oracle.com,
        kamezawa.hiroyu@jp.fujitsu.com, jackdachef@gmail.com,
        cyclonusj@gmail.com, levinsasha928@gmail.com
Subject: Re: [PATCH V9 3/6] mm: frontswap: core frontswap functionality
Message-Id: <20110913135107.295aecfe.akpm@google.com>
In-Reply-To: <4E6FBFC4.1080901@linux.vnet.ibm.com>
References: <20110913174026.GA11298@ca-server1.us.oracle.com>
	<4E6FBFC4.1080901@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Sep 2011 15:40:36 -0500
Seth Jennings <sjenning@linux.vnet.ibm.com> wrote:

> Hey Dan,
> 
> I get the following compile warnings:
> 
> mm/frontswap.c: In function ‘init_frontswap’:
> mm/frontswap.c:264:5: warning: passing argument 4 of ‘debugfs_create_size_t’ from incompatible pointer type
> include/linux/debugfs.h:68:16: note: expected ‘size_t *’ but argument is of type ‘long unsigned int *’
> mm/frontswap.c:266:5: warning: passing argument 4 of ‘debugfs_create_size_t’ from incompatible pointer type
> include/linux/debugfs.h:68:16: note: expected ‘size_t *’ but argument is of type ‘long unsigned int *’
> mm/frontswap.c:268:5: warning: passing argument 4 of ‘debugfs_create_size_t’ from incompatible pointer type
> include/linux/debugfs.h:68:16: note: expected ‘size_t *’ but argument is of type ‘long unsigned int *’
> mm/frontswap.c:270:5: warning: passing argument 4 of ‘debugfs_create_size_t’ from incompatible pointer type
> include/linux/debugfs.h:68:16: note: expected ‘size_t *’ but argument is of type ‘long unsigned int *’
> 
> size_t is platform dependent but is generally "unsigned int"
> for 32-bit and "unsigned long" for 64-bit.
> 
> I think just typecasting these to size_t * would fix it.

That's very risky.

> On 09/13/2011 12:40 PM, Dan Magenheimer wrote:
> > +#ifdef CONFIG_DEBUG_FS
> > +	struct dentry *root = debugfs_create_dir("frontswap", NULL);
> > +	if (root == NULL)
> > +		return -ENXIO;
> > +	debugfs_create_size_t("gets", S_IRUGO,
> > +				root, &frontswap_gets);
> > +	debugfs_create_size_t("succ_puts", S_IRUGO,
> > +				root, &frontswap_succ_puts);
> > +	debugfs_create_size_t("puts", S_IRUGO,
> > +				root, &frontswap_failed_puts);
> > +	debugfs_create_size_t("invalidates", S_IRUGO,
> > +				root, &frontswap_invalidates);
> > +#endif

Make them u32 and use debugfs_create_x32(), perhaps.  Or create
debugfs_create_ulong().
