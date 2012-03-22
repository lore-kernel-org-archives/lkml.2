Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab2CVO5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 10:57:51 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35060 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab2CVO5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 10:57:47 -0400
Subject: Re: [PATCH v3 10/12] ima: defer calling __fput()
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Matt Helsley <matt.helsley@gmail.com>, Mimi Zohar <zohar@us.ibm.com>
Date: Thu, 22 Mar 2012 10:53:04 -0400
In-Reply-To: <20120322142212.GV6589@ZenIV.linux.org.uk>
References: <1332356057-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1332356057-3356-11-git-send-email-zohar@linux.vnet.ibm.com>
	 <20120322142212.GV6589@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1332427986.2218.53.camel@falcor>
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032214-6148-0000-0000-00000475F0FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 14:22 +0000, Al Viro wrote:
> On Wed, Mar 21, 2012 at 02:54:15PM -0400, Mimi Zohar wrote:
> > If a file is closed before it is munmapped, __fput() is called with
> > the mmap_sem taken.  With IMA-appraisal enabled, this results in an
> > mmap_sem/i_mutex lockdep.  ima_defer_fput() increments the f_count
> > to defer __fput() being called until after the mmap_sem is released.
> 
> NAK.  It's far too heavy-weight for what's a very common path.  Worse,
> it causes different locking conditions on IMA and non-IMA kernels and makes
> bugs harder to spot.  Rejected with extreme prejudice; please, fix your
> locking instead.

Al, thanks for replying!  I realize you are very prejudiced against IMA,
but have you taken a look at IMA-appraisal?  It probably would have been
better if we used another name in order to avoid this prejudice, but
unfortunately we didn't.  :(  IMA-appraisal is about enforcing file
integrity.

> BTW, you've missed several other places in mm/* doing fput(), so it wouldn't
> be enough to paper over your problem anyway.
> 
> Final fput() *can* happen under mmap_sem.  Period.

I think I got that loud and clear; otherwise we wouldn't have come up
with deferring the __fput().  We have a very real problem here - writing
extended attributes requires taking the i_mutex.  I'm open to any
suggestions.

thanks,

Mimi

