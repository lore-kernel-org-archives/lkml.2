Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab0GFEvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 00:51:10 -0400
Received: from caiajhbdcagg.dreamhost.com ([208.97.132.66]:53770 "EHLO
	homiemail-a1.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751296Ab0GFEvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 00:51:08 -0400
Subject: Re: [linux-karma-devel] [PATCH] omfs: fix memory leak
From: Davidlohr Bueso <dave.bueso@gmail.com>
Reply-To: dave.bueso@gmail.com
To: me@bobcopeland.com
Cc: linux-fsdevel@vger.kernel.org, linux-karma-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100705140008.GA3378@hash.localnet>
References: <1278210828.27014.2.camel@cowboy>
	 <20100704113711.GA15067@hash.localnet> <1278306759.3811.24.camel@cowboy>
	 <20100705140008.GA3378@hash.localnet>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Jul 2010 00:50:58 -0400
Message-ID: <1278391858.30082.3.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-05 at 10:00 -0400, me@bobcopeland.com wrote:
> On Mon, Jul 05, 2010 at 01:12:39AM -0400, Davidlohr Bueso wrote:
> > Isn't put_super() called to free data when things run "normally", like
> > for unmounting? So this function does two things:
> 
> Ok, I checked it out and you are right, FS put_super is only called
> after successful mount so there is a leak.  I'll take your patch,
> but please:
> 
>  - remove the /* success */ comment, IMO it's just noise
>  - write the if conditional as the more usual:

>         if (ret)
> 


Ok, resending that patch with the corrections. Thanks.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>

---
 fs/omfs/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index 089839a..b5d6380 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -529,6 +529,8 @@ out_brelse_bh2:
 out_brelse_bh:
 	brelse(bh);
 end:
+	if (ret)
+		kfree(sbi);
 	return ret;
 }
 
-- 
1.7.0.4




> > kfree(sbi->s_imap)
> > kfree(sbi)
> > 
> > However, in omfs_get_imap() 'sbi->s_imap' is freed upon failure, so
> > wouldn't this also crash on the first kfree in omfs_put_super()?
> 
> This is ok, since sbi->s_imap is set to null in that case and
> kfree(NULL) is fine.
> 
> Thanks for the review!
>  


