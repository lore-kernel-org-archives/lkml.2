Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab2LAJ6i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 04:58:38 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63625 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab2LAJ6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 04:58:35 -0500
Date: Sat, 1 Dec 2012 09:58:32 +0000
From: Cong Ding <dinggnu@gmail.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Vitalii Demianets <vitas@nppfactor.kiev.ua>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] uio.c: Fix warning: 'ret' might be used uninitialized
Message-ID: <20121201095831.GA18966@gmail.com>
Mail-Followup-To: "Hans J. Koch" <hjk@hansjkoch.de>,
	Vitalii Demianets <vitas@nppfactor.kiev.ua>,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <201211271348.14603.vitas@nppfactor.kiev.ua>
 <CAM3j68rrBePLoamRb1pCH+TeAfLDO-5Jd_kk7-JRCNnEBhLp2Q@mail.gmail.com>
 <201211291822.16565.vitas@nppfactor.kiev.ua>
 <201211291836.59358.vitas@nppfactor.kiev.ua>
 <20121129235822.GA2590@local>
 <CAM3j68rH8qyN8zX7TLZNvQz-1Vr6qMjS0cR7QKGAs6w54L7dag@mail.gmail.com>
 <20121130213333.GA2603@local>
 <CAM3j68qHuqeafMjfpCiuRKLsKk+ZE3f=DuTM4zmHwUZdHULBMQ@mail.gmail.com>
 <20121201035625.GC2603@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121201035625.GC2603@local>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 01, 2012 at 04:56:25AM +0100, Hans J. Koch wrote:
> On Sat, Dec 01, 2012 at 02:22:44AM +0100, Cong Ding wrote:
> > On Fri, Nov 30, 2012 at 10:33 PM, Hans J. Koch <hjk@hansjkoch.de> wrote:
> > > On Fri, Nov 30, 2012 at 12:12:46PM +0100, Tux9 wrote:
> > >> I like Vitalii's solution more. Hans's solution assign the value
> > >> -ENOMEM to ret in every round of the loop, which is a kind of wasting
> > >> CPU cycles.
> > >
> > > The difference between
> > > 1 files changed, 12 insertions(+), 4 deletions(-) and
> > > 1 files changed, 2 insertions(+), 0 deletions(-)
> > >
> > > is more important. Note that this code is not in a fast path but only
> > > called once at device creation.
> > Why do you think the size of the patch is so important? I think the
> > most important thing is the coding style and efficiency. I agree
> > efficiency is not important in this case, but what about coding style?
> 
> Most important. Short is beautiful.
> 
> > Your code is _not_ very easy to understand.
> 
> You think so?
> 
> > It's a very natural thing
> > to set the return value and then goto the error-handling codes, which
> > is exactly same as what Vitalii did, rather than setting an initial
> > value in the beginning of each round of the loop as you did.
> 
> Setting a default value at the beginning of a block is the most natural
> thing. I don't want to repeat the same code in three places.
> 
> > There are
> > also a bunch of codes in kernel in the same style with Vitalii, but I
> > cannot find anything same as your codes.
> 
> If you follow LKML closely, you'll notice that simplifying code by
> replacing unnecessary repetitions with shorter versions is always welcome.
> If we didn't go for that, the kernel source would be a few million lines
> bigger by now.
> 
> Thanks,
> Hans
If it is really necessary to save the 4 lines of codes, I would suggest to do 
in the following style. But you are more senior than me, so I may be wrong in 
this aspect. 

 drivers/uio/uio.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 5110f36..cb20168 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -263,7 +263,7 @@ static struct class uio_class = {
  */
 static int uio_dev_add_attributes(struct uio_device *idev)
 {
-	int ret;
+	int ret = 0;
 	int mi, pi;
 	int map_found = 0;
 	int portio_found = 0;
@@ -339,6 +339,8 @@ err_map:
 		kobject_put(&map->kobj);
 	}
 	kobject_put(idev->map_dir);
+	if (!ret)
+		ret = -ENOMEM;
 	dev_err(idev->dev, "error creating sysfs files (%d)\n", ret);
 	return ret;
 }

