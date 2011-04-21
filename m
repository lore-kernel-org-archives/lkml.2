Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab1DUVZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 17:25:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55644 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab1DUVZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 17:25:40 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=XYJHFtupD_QA:10 a=ZFNFh-pPGIMA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=aXVuY0ei1haJT1g6vp0A:9 a=1_3TpKKw-1K76L_uvfcA:7 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 21 Apr 2011 17:25:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, autofs@linux.kernel.org,
        Ian Kent <raven@themaw.net>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: Lockdep splat in autofs with 2.6.39-rc2
Message-ID: <20110421212537.GC24898@home.goodmis.org>
References: <20110407194403.GA29404@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110407194403.GA29404@elliptictech.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 03:44:03PM -0400, Nick Bowler wrote:
> Just saw this on 2.6.39-rc2 after half a day or so of uptime.  I've
> never seen it before today so it may be a regression from 2.6.38.
> Nothing seems have failed as a result.  Please let me know if you
> need any more info.
>

Could you try this patch. I know it may be hard to reproduce, but the
issue is that we are recursing down the locks in a tree/list and we changed a
lock from being nested to being a parent. This patch tells lockdep about
what we did.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 450f529..1feb68e 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -124,6 +124,7 @@ start:
 	/* Negative dentry - try next */
 	if (!simple_positive(q)) {
 		spin_unlock(&p->d_lock);
+		lock_set_subclass(&q->d_lock.dep_map, 0, _RET_IP_);
 		p = q;
 		goto again;
 	}
@@ -186,6 +187,7 @@ again:
 	/* Negative dentry - try next */
 	if (!simple_positive(ret)) {
 		spin_unlock(&p->d_lock);
+		lock_set_subclass(&ret->d_lock.dep_map, 0, _RET_IP_);
 		p = ret;
 		goto again;
 	}
