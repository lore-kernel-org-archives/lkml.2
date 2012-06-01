Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965017Ab2FAPzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:55:01 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40180 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964952Ab2FAPy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:54:58 -0400
Message-ID: <1338566096.16842.6.camel@joe2Laptop>
Subject: Re: seq_file: Use larger buffer to reduce time traversing lists
From: Joe Perches <joe@perches.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        Al Viro <viro@zeniv.linux.org.uk>, nstraz@redhat.com
Date: Fri, 01 Jun 2012 08:54:56 -0700
In-Reply-To: <1338547193.2708.16.camel@menhir>
References: <1338547193.2708.16.camel@menhir>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-01 at 11:39 +0100, Steven Whitehouse wrote:
> I've just been taking a look at the seq_read() code,
[]

nice improvement.  trivial style comment:

> diff --git a/fs/seq_file.c b/fs/seq_file.c
[]
> @@ -169,6 +171,16 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
>  	 */
>  	m->version = file->f_version;
>  
> +	if ((m->size < bsize) || !m->buf) {
> +		kfree(m->buf);
> +		m->size = 0;
> +		m->buf = kmalloc(m->size = bsize, GFP_KERNEL|__GFP_NOWARN);

You can remove the m->size = 0 line and
can you please add a space around the |?
It's a bit dense and too easy to read it
as a single word.
 
> +		if (!m->buf)
> +			m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
> +		if (!m->buf)
> +			goto Enomem;

Mixed case label?

> @@ -277,6 +289,11 @@ Done:
>  		m->read_pos += copied;
>  	}
>  	file->f_version = m->version;
> +	if (m->size > PAGE_SIZE) {
> +		kfree(m->buf);
> +		m->buf = NULL;
> +		m->size = 0;
> +	}
>  	mutex_unlock(&m->lock);
>  	return copied;
>  Enomem:

Oh, it wasn't you.  nevermind...

