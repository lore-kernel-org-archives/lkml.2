Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296Ab0CPQ3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 12:29:45 -0400
Received: from cifronik.21th.com ([62.16.86.116]:32833 "EHLO cifronik.21th.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759112Ab0CPQ3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 12:29:43 -0400
From: =?utf-8?b?0KHQtdGA0LPQtdC5INCi0LXQvNC10YDRhdCw0L3QvtCy?= 
	<temerkhanov@cifronik.ru>
Organization: =?utf-8?b?0JfQkNCe?= "=?utf-8?b?0KbQuNGE0YDQvtC90LjQug==?="
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resubmit 2/3] AIO: Fix reference counting in io_cancel and aio_cancel_all
Date: Tue, 16 Mar 2010 19:26:04 +0300
User-Agent: KMail/1.12.4 (Linux/2.6.31-gentoo-r6; KDE/4.3.5; x86_64; ; )
References: <201003161418.16959.temerkhanov@cifronik.ru> <x494okguxxp.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x494okguxxp.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_cE7nL+Ahviv78y7"
Message-Id: <201003161926.04434.temerkhanov@cifronik.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_cE7nL+Ahviv78y7
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On Tuesday 16 March 2010 17:46:10 Jeff Moyer wrote:
> Sergey Temerkhanov <temerkhanov@cifronik.ru> writes:
> > io_cancel() and aio_cancel_all() have inconsistent reference counting
> > (ki_users field of struct kiocb) which leads to unkillable processes upon
> > io_cancel() or io_destroy() syscalls. This patch fixes the undesired
> > behavior.
> 
> Hi, Sergey,
> 
> Thanks for the patch.  Would you mind resubmitting it to make it a bit
> easier to review?  The way you've done things, it is difficult to tell
> if you just moved the aio_cancel_all function or if you moved it and
> made changes.  Please have the patch that moves it separated out from
> other changes, or at least mention in the changelog that the function
> was unchanged.  Next, if you could tell what sorts of testing you've
> performed, that would be great.  Finally, it would be a good idea to CC
> linux-aio@kvack.org on aio patches.
> 
> Thanks!
> Jeff
> 

This patch fixes reference counting in io_cancel() and aio_cancel_all()

Regards, Sergey Temerkhanov, Cifronic ZAO

--Boundary-00=_cE7nL+Ahviv78y7
Content-Type: text/x-patch;
  charset="UTF-8";
  name="aio-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="aio-fix.patch"

diff -r 74c172a99cdb fs/aio.c
--- a/fs/aio.c	Tue Mar 16 18:55:59 2010 +0300
+++ b/fs/aio.c	Tue Mar 16 19:08:49 2010 +0300
@@ -1035,7 +1035,9 @@
 			spin_unlock_irq(&ctx->ctx_lock);
 			cancel(iocb, &res);
 			spin_lock_irq(&ctx->ctx_lock);
+			__aio_put_req(req);
 		}
+		__aio_put_req(req);
 	}
 	spin_unlock_irq(&ctx->ctx_lock);
 }
@@ -1789,9 +1791,11 @@
 			if (copy_to_user(result, &tmp, sizeof(tmp)))
 				ret = -EFAULT;
 		}
+		aio_put_req(req);
 	} else
 		ret = -EINVAL;
 
+	aio_put_req(req);
 	put_ioctx(ctx);
 
 	return ret;

--Boundary-00=_cE7nL+Ahviv78y7--
