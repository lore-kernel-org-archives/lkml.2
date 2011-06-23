Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510Ab1FWPpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 11:45:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:55905 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab1FWPpb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 11:45:31 -0400
Subject: Re: [RFC PATCH] futex: replace get_user_pages() with
 get_user_pages_fast()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Darren Hart <dvhart@linux.intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <4E035785.6050504@linux.intel.com>
References: <4E02DB80.10303@jp.fujitsu.com>
	 <4E035785.6050504@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 23 Jun 2011 17:44:44 +0200
Message-ID: <1308843884.1022.142.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-23 at 08:11 -0700, Darren Hart wrote:
> 
> On 06/22/2011 11:21 PM, KOSAKI Motohiro wrote:
> > Hello,
> > 
> > Is there any reason to take mmap_sem explicitly here?
> > Should we change gup_fast() to allow NULL argument (ie for avoid get_page)?
> > 
> > ============================
> >   down_read(&mm->mmap_sem);
> >   get_user_pages(current, current->mm)
> >   up_read(&mm->mmap_sem);
> > 
> > and
> > 
> >   get_user_pages_fast()
> > 
> > make an equivalent result, And latter would be better when mamp_sem
> > highly contended case, because it can avoid to take mmap_sem if
> > the target page doesn't need a page fault.
> 
> 
> I can't speak authoritatively here, but it seems to me that
> get_user_pages_fast falls back to get_user_pages with mmap_sem anyway,
> so this seems like a reasonable optimization for the best case, with a
> minor overhead for the slow case.
> 
> Peter, am I missing something? 

Right, its much cheaper on the fast-path where the page is found present
and writable, if we have to take the fault, the extra cost in the slow
path is neglectable.

> Is there a reason you left this as is
> during your fast gup futex update?

I probably completely missed this gup() user.

The proposed change looks good to me.
