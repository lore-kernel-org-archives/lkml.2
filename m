Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab0FXRq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 13:46:27 -0400
Received: from cifronik.21th.com ([62.16.86.116]:33128 "EHLO cifronik.21th.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285Ab0FXRq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 13:46:26 -0400
X-Greylist: delayed 897 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jun 2010 13:46:26 EDT
From: Sergey Temerkhanov <temerkhanov@cifronik.ru>
To: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH][RFC] AIO: always reinitialize iocb->ki_run_list at the end of aio_run_iocb()
Date: Thu, 24 Jun 2010 21:31:21 +0400
User-Agent: KMail/1.12.4 (Linux/2.6.34-41-desktop; KDE/4.3.5; x86_64; ; )
Cc: Sergey Temerkhanov <temerkhanov@yandex.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-aio" <linux-aio@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Benjamin LaHaise <bcrl@kvack.org>, Zach Brown <zach.brown@oracle.com>,
       Suparna Bhattacharya <suparna@in.ibm.com>
References: <201004280251.43430.temerkhanov@yandex.ru> <201005271406.36489.temerkhanov@yandex.ru> <x49iq62lak7.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49iq62lak7.fsf@segfault.boston.devel.redhat.com>
Organization: Cifronic ZAO
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006242131.21463.temerkhanov@cifronik.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 June 2010 01:14:48 Jeff Moyer wrote:
> Sergey Temerkhanov <temerkhanov@yandex.ru> writes:
> > On Wednesday 26 May 2010 23:38:35 Jeff Moyer wrote:
> > ...
> OK, you tried two aio_put_req() calls, and it worked, but you thought
> 
> maybe it wasn't the right approach.  So:
> > So, I've tried another approach (hack) - requeue the kiocb with
> > kick_iocb() before calling aio_put_req() in the ki_cancel() callback
> > (that's because aio_run_iocb() takes some special actions for the
> > canceled kiocbs). And I've found out that kick_iocb() fails because
> > aio_run_iocb() does this:
> > 	iocb->ki_run_list.next = iocb->ki_run_list.prev = NULL;
> > and only reinitializes iocb->ki_run_list when iocb->ki_retry() returns
> > -EIOCBRETRY but kick_iocb() is exported and looks like intended for usage
> > (though not recommended).
> 
> You implemented this other hack, and ran into troubles, so you're
> modifying the aio core to fix it.  Am I wrong in concluding that if you
> keep your first solution above, you no longer need this second?

Well, let's forget the reference counting for now since failing kick_iocb() is 
generally not related to it. I've just described how I've run into it 
- I could run into it somehow else.

The problem with kick_iocb() is exactly as this: If retry() method 
returns -EIOCBQUEUED to aio_run_iocb() then any subsequent call to 
kick_iocb() results in failure. Is it expected behavior?

> 
> You may also find the following an interesting read:
> 
> http://permalink.gmane.org/gmane.linux.kernel.aio.general/2571
> 
> Cheers,
> Jeff
> 


-- 
Regards, Sergey Temerkhanov,
Cifronic ZAO
