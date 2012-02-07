Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab2BGOMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:12:24 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:25731 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140Ab2BGOMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:12:21 -0500
Date: Tue, 7 Feb 2012 17:11:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: integer overflows in kernel/relay.c
Message-ID: <20120207141155.GA16184@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F313142.000C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My static checker is warning about integer overflows in kernel/relay.c

relay_create_buf()
   170  
   171          buf->padding = kmalloc(chan->n_subbufs * sizeof(size_t *), GFP_KERNEL);
                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This can only overflow on 32bit systems.

   172          if (!buf->padding)
   173                  goto free_buf;
   174  

relay_open()
   582          chan->version = RELAYFS_CHANNEL_VERSION;
   583          chan->n_subbufs = n_subbufs;
   584          chan->subbuf_size = subbuf_size;
   585          chan->alloc_size = FIX_SIZE(subbuf_size * n_subbufs);
                                            ^^^^^^^^^^^^^^^^^^^^^^^
   586          chan->parent = parent;

These come from the user in blk_trace_setup() and they aren't capped.
I'm not sure what the maximum size to use is.

regards,
dan carpenter
