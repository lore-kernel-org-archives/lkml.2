Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab0C3Jnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 05:43:55 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41909 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106Ab0C3Jnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 05:43:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=i/8Z47Bn/f8Vfkf/QWPeR46HRKgjiJMAx5DEG7QLq8bg/wobAy0SSHrsCmyOGlG6CA
         6s287GJ4K877xBgE16oIR78GnXtjmU50vVy/k37mKAeGNNj9d/jxS/pKvfOp+3ZhUhQ/
         DGRUaLiM5MK7+bRTcQF1KBrx9XIkutGm5lkpc=
Date: Tue, 30 Mar 2010 12:43:42 +0300
From: Dan Carpenter <error27@gmail.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       Hans-Joachim Picht <hans@linux.vnet.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sebastian Ott <sebott@linux.vnet.ibm.com>, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] s390: potential buffer overflow
Message-ID: <20100330094342.GJ5069@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
	Hans-Joachim Picht <hans@linux.vnet.ibm.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Sebastian Ott <sebott@linux.vnet.ibm.com>,
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"len" hasn't been properly range checked so we shouldn't use it as an
array offset.  This can only be written to by root but it would still be
annoying to accidentally write more than 3 characters and corrupt your
memory.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
I don't have a cross compile environment to compile this.  Sorry.  :/

diff --git a/drivers/s390/char/sclp_async.c b/drivers/s390/char/sclp_async.c
index f449c69..72c2e90 100644
--- a/drivers/s390/char/sclp_async.c
+++ b/drivers/s390/char/sclp_async.c
@@ -84,7 +84,7 @@ static int proc_handler_callhome(struct ctl_table *ctl, int write,
 		rc = copy_from_user(buf, buffer, sizeof(buf));
 		if (rc != 0)
 			return -EFAULT;
-		buf[len - 1] = '\0';
+		buf[sizeof(buf) - 1] = '\0';
 		if (strict_strtoul(buf, 0, &val) != 0)
 			return -EINVAL;
 		if (val != 0 && val != 1)
@@ -99,6 +99,7 @@ static int proc_handler_callhome(struct ctl_table *ctl, int write,
 static struct ctl_table callhome_table[] = {
 	{
 		.procname	= "callhome",
+		.maxlen		= 3,
 		.mode		= 0644,
 		.proc_handler	= proc_handler_callhome,
 	},
