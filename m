Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab2A3Nj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 08:39:28 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:16737 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab2A3Nj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 08:39:27 -0500
Date: Mon, 30 Jan 2012 16:39:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org
Subject: re: sysctl: register only tables of sysctl files
Message-ID: <20120130133933.GA5926@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4F269D8E.011A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

The patch f728019bb72e: "sysctl: register only tables of sysctl 
files" from Jan 22, 2012, has a weird thing going on and I don't know
how to fix it:

+       if (nr_dirs && nr_files) {
+               struct ctl_table *new;
+               files = kzalloc(sizeof(struct ctl_table) * (nr_files + 1),
+                               GFP_KERNEL);
+               if (!files)
+                       goto out;
+
+               ctl_table_arg = files;
+               for (new = files, entry = table; entry->procname; entry++) {
+                       if (entry->child)
+                               continue;
+                       *new = *entry;
+                       new++;
+               }
+       }
+
+       /* Register everything except a directory full of subdirectories */
+       if (nr_files || !nr_dirs) {
+               struct ctl_table_header *header;
+               header = __register_sysctl_table(root, namespaces, path, files);
+               if (!header) {
+                       kfree(ctl_table_arg);
                              ^^^^^^^^^^^^^
+                       goto out;
+               }
+
+               /* Remember if we need to free the file table */
+               header->ctl_table_arg = ctl_table_arg;
                                        ^^^^^^^^^^^^^
These are NULL unless "nr_dirs" is non-zero (so it's always NULL here).

+               **subheader = header;
+               (*subheader)++;
+       }

regards,
dan carpenter

