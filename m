Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab1GHM6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 08:58:55 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:38721 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab1GHM6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 08:58:51 -0400
Subject: Re: [PATCH 1/3] uml: drivers/net_user.c memory leak fix
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: Jeff Dike <jdike@addtoit.com>, user-mode-linux-devel@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <201107081244.53433.richard@nod.at>
References: <1310056562.3528.49.camel@vivanov>
	 <201107071927.16237.richard@nod.at>
	 <CAGTPOqfe8JxMsOru=pydy6ofEi0Ax-N=W_2UZwq5y=grrTemhQ@mail.gmail.com>
	 <201107081244.53433.richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jul 2011 16:00:44 +0300
Message-ID: <1310130044.26209.3.camel@vivanov>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > This control logic is a bit strange.
> > > When change_tramp() fails we should not printk() the output variable.
> > > 
> > > if (pid < 0){
> > >  free(output);
> > >  return;
> > > }
> > > 
> > > Would be much cleaner.
> > 
> > I just didn't want to clone this free-return stuff. So, what you
> > proposing is like this:
> > ------------
> > ...
> >         output = uml_kmalloc(output_len, UM_GFP_KERNEL);
> >         if (output == NULL)
> >                 printk(UM_KERN_ERR "change : failed to allocate output "
> >                        "buffer\n");
> > 
> >         pid = change_tramp(argv, output, output_len);
> >         if (pid < 0) {
> >                 free(output);               <---------- I'm not sure but 'output' can be NULL here.
> >                 return;
> >         }
> > 
> >         if (output != NULL) {
> >                 printk("%s", output);
> >                 kfree(output);
> >         }
> > }
> > ------------
> > 
> > I was trying to print 'output' only in case change_tramp is
> > successful. That's the old logic. And at the same time perform free
> > only in case output is not NULL.
> 
> Why?
> Freeing a NULL pointer is perfectly fine.

I should agree that something that you propose has better readability.

So, here is updated patch.

Thanks
---
>From b0c5ca0336cc94b2fda251e0da7918394e59c5cd Mon Sep 17 00:00:00 2001
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Date: Fri, 8 Jul 2011 14:54:29 +0300
Subject: [PATCH] uml: drivers/net_user.c memory leak fix

Perform memory cleanup on exit.
On receiving invalid 'pid' we still should clean 'output' variable.

Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/drivers/net_user.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/um/drivers/net_user.c b/arch/um/drivers/net_user.c
index 9415dd9..5201188 100644
--- a/arch/um/drivers/net_user.c
+++ b/arch/um/drivers/net_user.c
@@ -228,7 +228,10 @@ static void change(char *dev, char *what, unsigned char *addr,
 		       "buffer\n");
 
 	pid = change_tramp(argv, output, output_len);
-	if (pid < 0) return;
+	if (pid < 0) {
+		kfree(output);
+		return;
+	}
 
 	if (output != NULL) {
 		printk("%s", output);
-- 
1.7.0.4



