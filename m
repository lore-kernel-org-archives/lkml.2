Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab1AaLnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 06:43:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48975 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab1AaLnS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:43:18 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH] mlock: revert the optimization for dirtying pages and triggering writeback.
Cc: kosaki.motohiro@jp.fujitsu.com, Tao Ma <tm@tao.ma>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <AANLkTik1dt1Q9TA+JmdvkuOqmt5LB2iZ1X2B5GbBFx1+@mail.gmail.com>
References: <1296371720-4176-1-git-send-email-tm@tao.ma> <AANLkTik1dt1Q9TA+JmdvkuOqmt5LB2iZ1X2B5GbBFx1+@mail.gmail.com>
Message-Id: <20110131203943.4C77.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 31 Jan 2011 20:43:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, Jan 29, 2011 at 11:15 PM, Tao Ma <tm@tao.ma> wrote:
> >        buf = mmap(NULL, file_len, PROT_WRITE, MAP_SHARED, fd, 0);
> >        if (buf == MAP_FAILED) {
> >                perror("mmap");
> >                goto out;
> >        }
> >
> >        if (mlock(buf, file_len) < 0) {
> >                perror("mlock");
> >                goto out;
> >        }
> 
> Thanks Tao for tracing this to an individual change. I can reproduce
> this on my system. The issue is that the file is mapped without the
> PROT_READ permission, so mlock can't fault in the pages. Up to 2.6.37
> this worked because mlock was using a write.
> 
> The test case does show there was a behavior change; however it's not
> clear to me that the tested behavior is valid.
> 
> I can see two possible resolutions:

Please don't ignore bug port anytime.


> 1- do nothing, if we can agree that the test case is invalid
> 
> 2- restore the previous behavior for writable, non-readable, shared
> mappings while preserving the optimization for read/write shared
> mappings. The test would then look like:
>         if ((vma->vm_flags & VM_WRITE) && (vma->vm_flags & (VM_READ |
> VM_SHARED)) != VM_SHARED)
>                 gup_flags |= FOLL_WRITE;

Maybe two separate conditiions are cleaner more. Like this,

	/*
	 * We want to touch writable mappings with a write fault in order
	 * to break COW, except for shared mappings because these don't COW
	 * and we would not want to dirty them for nothing.
	 */
	if ((vma->vm_flags & (VM_WRITE | VM_SHARED)) == VM_WRITE)
 		gup_flags |= FOLL_WRITE;

	/*
	* We don't have writable permission. Therefore we can't use read operation
	*  even though it's faster.
	*/
	if ((vma->vm_flags & (VM_READ|VM_WRITE)) == VM_WRITE)
 		gup_flags |= FOLL_WRITE;


Thanks.


