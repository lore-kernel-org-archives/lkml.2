Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab2LaP1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 10:27:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab2LaP1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 10:27:05 -0500
Message-ID: <1356967247.31923.14.camel@localhost>
Subject: Re: [PATCH] prctl: fix validation of an address
From: Eric Paris <eparis@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Vagin <avagin@parallels.com>, Andrey Vagin <avagin@openvz.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        James Morris <jmorris@namei.org>
Date: Mon, 31 Dec 2012 10:20:47 -0500
In-Reply-To: <20121231151356.GA11118@moon>
References: <1356778810-20879-1-git-send-email-avagin@openvz.org>
	 <1356904987.9725.10.camel@localhost>
	 <20121231101414.GA27119@paralelels.com>
	 <1356964034.31923.12.camel@localhost> <20121231151356.GA11118@moon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-31 at 19:13 +0400, Cyrill Gorcunov wrote:
> On Mon, Dec 31, 2012 at 09:27:14AM -0500, Eric Paris wrote:
> > On Mon, 2012-12-31 at 14:14 +0400, Andrew Vagin wrote:
> > > On Sun, Dec 30, 2012 at 05:03:07PM -0500, Eric Paris wrote:
> > > > On Sat, 2012-12-29 at 15:00 +0400, Andrey Vagin wrote:
> > > > > The address should be bigger than dac_mmap_min_addr, because
> > > > > a process with CAP_RAWIO can map a vma bellow mmap_min_addr.
> > > > 
> > > > NAK
> > > 
> > > Currently prctl(PR_SET_MM_*, addr, ) returns EINVAL for valid addresses.
> > > I think it's a bug. Are you agree?
> > 
> > Can you help me understand how prctl(PR_SET_MM_*, relates to
> > checkpoint/restore?  My worry here is that somehow this interface could
> 
> Here how we use it (from userspace code)
> 
> 	ret |= sys_prctl_safe(PR_SET_MM, PR_SET_MM_START_CODE, (long)args->mm.mm_start_code, 0);
> 	ret |= sys_prctl_safe(PR_SET_MM, PR_SET_MM_END_CODE, (long)args->mm.mm_end_code, 0);
> 	...
> 
> the values of mm.mm_start_code and such are saved in image file and obtained
> during checkpoint stage. Note the prctl_set_mm requires the caller to have
> CAP_SYS_RESOURCE privilege granted.

Is there anything which prevents an unpriv application from changing
mm.mm_start_code and mm.mm_end_code in the image, thus taking advantage
of the privileged restore code to bypass the mmap_min_addr
restrictions? 

