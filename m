Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935537Ab0HFK4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 06:56:17 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:33408 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935480Ab0HFK4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 06:56:13 -0400
Message-ID: <4C5BEA4E.4070107@kernel.dk>
Date: Fri, 06 Aug 2010 12:56:14 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Dmitry Monakhov <dmonakhov@openvz.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Resend: [PATCH] blkdev: fix blkdev_issue_zeroout return value
References: <87vd7o2f9z.fsf@dmon-lap.sw.ru>
In-Reply-To: <87vd7o2f9z.fsf@dmon-lap.sw.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-06 12:42, Dmitry Monakhov wrote:
> Hi Jens,
> Seems that my first mail was missed somewhere.  
> I've found couple of trivial issues in blkdev_issue_zeroout()
> implementation. Unfortunately I've miss during initial testing phase
> because always called it with BARRIER|WAIT flags.

BTW, this:

@@ -218,15 +222,18 @@ submit:
 		/* One of bios in the batch was completed with error.*/
 		ret = -EIO;
 
-	if (ret)
+	if (ret && ret != -ENOMEM)
 		goto out;
 
 	if (test_bit(BIO_EOPNOTSUPP, &bb.flags)) {
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
-	if (nr_sects != 0)
+	if (nr_sects != 0) {
+		if (ret == -ENOMEM)
+			io_schedule();
 		goto submit;
+	}
 out:
 	return ret;
 }

is broken. Either the caller sets __GFP_WAIT and then bio_alloc() will
not fail, or GFP_ATOMIC is used knowing that the call can fail and
return ENOMEM. Don't code in retry logic like this.

-- 
Jens Axboe

