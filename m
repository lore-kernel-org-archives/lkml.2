Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab2DRSIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:08:22 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55215 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab2DRSIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:08:20 -0400
Subject: Re: [PULL REQUEST] : ima-appraisal patches
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Date: Wed, 18 Apr 2012 14:07:52 -0400
In-Reply-To: <alpine.LRH.2.02.1204190101380.30151@tundra.namei.org>
References: <1334754302.2137.8.camel@falcor>
	 <alpine.LRH.2.02.1204190101380.30151@tundra.namei.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1334772473.2137.22.camel@falcor>
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041818-5806-0000-0000-00001464D556
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-19 at 01:02 +1000, James Morris wrote:
> On Wed, 18 Apr 2012, Mimi Zohar wrote:
> 
> > Hi James,
> > 
> > As the last IMA-appraisal posting on 3/29 addressed Al's
> > performance/maintenance concerns of deferring the __fput() and there
> > hasn't been any additional comments, please consider pulling the
> > IMA-appraisal patches.
> 
> I thought Dmitry was still waiting on comments from Al for this.

Al NAK'ed the original 'ima: defer calling __fput()' patch from 3/22,
but we addressed both of Al's performance and maintaince concerns in the
last posting on 3/29, which was three weeks ago.  We haven't heard
back ...

>From the 'ima: defer calling __fput()' patch description:

ima_file_free(), which is called on __fput(), updates the file data
hash stored as an extended attribute to reflect file changes.  If a
file is closed before it is munmapped, __fput() is called with the
mmap_sem taken.  With IMA-appraisal enabled, this results in an
mmap_sem/i_mutex lockdep.  ima_defer_fput() increments the f_count to
defer the __fput() being called until after the mmap_sem is released.

The number of __fput() calls needing to be deferred is minimal.  Only
those files in policy, that were closed prior to the munmap and were
mmapped write, need to defer the __fput().

With this patch, on a clean F16 install, from boot to login, only
5 out of ~100,000 mmap_sem held fput() calls were deferred.

Changelog v4:
- ima_defer_fput() performance improvements
- move ima_defer_fput() call from remove_vma() to __fput()
- only defer mmapped files opened for write
- remove unnecessary ima_fput_mempool_destroy()

Mimi

