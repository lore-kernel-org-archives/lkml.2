Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab1GYFNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 01:13:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41672 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab1GYFMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 01:12:52 -0400
Date: Mon, 25 Jul 2011 06:12:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: kdevtmpfs oops since yesterdays vfs merge
Message-ID: <20110725051251.GQ24703@ZenIV.linux.org.uk>
References: <20110724231701.GA1707@redhat.com>
 <20110724232812.GN24703@ZenIV.linux.org.uk>
 <20110724234029.GA4881@redhat.com>
 <20110724235154.GO24703@ZenIV.linux.org.uk>
 <20110725015324.GA7603@redhat.com>
 <20110725015612.GB7603@redhat.com>
 <20110725024444.GP24703@ZenIV.linux.org.uk>
 <20110725045851.GA11267@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725045851.GA11267@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 12:58:52AM -0400, Dave Jones wrote:
> On Mon, Jul 25, 2011 at 03:44:44AM +0100, Al Viro wrote:
> 
>  > > when it triggers the bug_on(), it's that second nodename that is garbage.
>  > 
>  > Interesting...  The next experiment would be to stick BUG_ON(!req.dev)
>  > into devtmpfs_create_node() right after the assigment to that field.
> 
> couldn't get that to trigger.

Interesting...

>  > We couldn't be hit by the lack of barriers here, could we?  Store to
>  > req.dev happens before spin_unlock(&req_lock), so by the time when
>  > that request is seen by loop in devtmpfsd() and passed to handle() it
>  > should be seen - we have grabbed req_lock, found a pointer to req, dropped
>  > req_lock and called handle().  Should've been enough...
>  > 
>  > Might be interesting to print &req from devtmpfs_create_node(), both on
>  > entry and on exit, and print req right before the call of handle()...
> 
> Here's latest..
> 
> https://s3.amazonaws.com/twitpic/photos/full/355219312.jpg?AWSAccessKeyId=AKIAJF3XCCKACR3QDMOA&Expires=1311570683&Signature=xr3tusulMiV2bIsxux9YNrawUDA%3D
>  
> apologies for crappy picture, but it's legible at fullsize..
> 
> interesting thing here is that the req that causes the oops, I couldn't
> find any call to create_handle for that address, so where devtmpfsd got it
> is a mystery.  The address is curious too, in that it's way off from all the
> reqs created around that time.

Arrgh...  OK, I see what's going on.

                                req->err = handle(req->name, req->mode, req->dev);
                                complete(&req->done);
                                req = req->next;
is letting the request creator to continue; if it leaves the scope, guess
what is left in *req?  That's right, garbage...  Including req->next.
All right, try this and let's see if it fixes the problem:

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 3644dd4..49b6cba 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -406,9 +406,10 @@ static int devtmpfsd(void *p)
 			requests = NULL;
 			spin_unlock(&req_lock);
 			while (req) {
+				struct req *next = req->next;
 				req->err = handle(req->name, req->mode, req->dev);
 				complete(&req->done);
-				req = req->next;
+				req = next;
 			}
 			spin_lock(&req_lock);
 		}
