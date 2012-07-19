Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab2GSO3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 10:29:07 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:44852 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab2GSO3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 10:29:05 -0400
Date: Thu, 19 Jul 2012 17:28:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: anton.vorontsov@linaro.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: re: pstore/ram: Add ftrace messages handling
Message-ID: <20120719142856.GA25184@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Anton Vorontsov,

This is a semi-automatic email about new static checker warnings.

The patch a694d1b5916a: "pstore/ram: Add ftrace messages handling" 
from Jul 9, 2012, leads to the following Smatch complaint:

fs/pstore/ram.c:423 ramoops_probe()
	 error: we previously assumed 'cxt->cprz' could be null (see line 408)

fs/pstore/ram.c
   407	
   408		if (!cxt->przs && !cxt->cprz && !cxt->fprz) {
                                  ^^^^^^^^^^

Checked here.

   409			pr_err("memory size too small, minimum is %lu\n",
   410				cxt->console_size + cxt->record_size +
   411				cxt->ftrace_size);
   412			goto fail_cnt;
   413		}
   414	
   415		cxt->pstore.data = cxt;
   416		/*
   417		 * Console can handle any buffer size, so prefer dumps buffer
   418		 * size since usually it is smaller.
   419		 */
   420		if (cxt->przs)
   421			cxt->pstore.bufsize = cxt->przs[0]->buffer_size;
   422		else
   423			cxt->pstore.bufsize = cxt->cprz->buffer_size;
                                              ^^^^^^^^^
Dereferenced here.  What about if only "cxt->fprz" is non-NULL?

Also these are crap variable names, "przs" and "cprz" look so similar.
It makes my head hurt to keep them appart.

   424		cxt->pstore.buf = kmalloc(cxt->pstore.bufsize, GFP_KERNEL);
   425		spin_lock_init(&cxt->pstore.buf_lock);

regards,
dan carpenter

