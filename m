Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab2BBOzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 09:55:46 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:52578 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab2BBOzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 09:55:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 1/2] lkdtm: use atomic_t to replace count_lock
Date: Thu, 2 Feb 2012 14:55:38 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Prarit Bhargava <prarit@redhat.com>,
        "Greg Kroah-Hartman" <greg@kroah.com>, Dave Young <dyoung@redhat.com>
References: <1328079501-24746-1-git-send-email-xiyou.wangcong@gmail.com> <201202021344.19455.arnd@arndb.de> <4F2A9D56.3080102@gmail.com>
In-Reply-To: <4F2A9D56.3080102@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201202021455.38966.arnd@arndb.de>
X-Provags-ID: V02:K0:jR73DVt3zi6YboRK/vWM4ZZ4lF5/8EOIcBHMbN2uHn5
 93AFskQgJDPULRfZfGqDn79wF3rH4yazVI94UbjiFBmgy0829b
 LvzAzEYXixaZiaLlTm3cv/jTullO0suBhb/QuvFk3pFVNCxxBu
 IUcVrr2yTz4OVdeybusXZbIdWelAjygK1KF14xb+YckyQHQA3a
 CLbU66u61heIFsAlDCIRzIKaRiBGgT8zKVfG7Vk60AEdsZQ/Oo
 fuoZhZISmb6gk4kGztAiDk+KGPeOd3MfPuus5kPkBSGHwLq1S1
 9vwdfwNmnbFLXlI9vQ+mByrMp4zG2HjaJZ3DNWEl+0Sxyo9H8X
 UddGDjNO28C1DWW9ZtOk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 February 2012, Cong Wang wrote:
> On 02/02/2012 09:44 PM, Arnd Bergmann wrote:
> > On Thursday 02 February 2012, Cong Wang wrote:
> >>> In order to have an atomic here, you have to use a loop around
> >>> atomic_cmpxchg, like
> >>>
> >>>
> >>>        int old, new;
> >>>        old = atomic_read(&count);
> >>>        do {
> >>>                new = old ? old - 1 : cpoint_count;
> >>>                old = cmpxchg(&count, old, new);

		    ^^^^^^^
I guess I meant "new = cmpxchg(...)" here, sorry.

> >>>        } while (old != new);
> >>>
> >>> I suppose you could also just keep the spinlock and move lkdtm_do_action()
> >>> outside of it?
> >>
> >> If we still need spinlock, I think we don't need to bother atomic_t at all.
> >
> > Yes, it's one or the other: If you use the cmpxchg loop, you don't need a
> > spinlock and vice versa.
> >
> 
> The cmpxchg loop is for comparing and assigning to 'count', but still 
> there is a printk() above that needs to read 'count'. Combining these 
> two operations means we have to use a spinlock, correct? Because there 
> is a chance that another process could change 'count' in between.

No, you can just print the value of "old" in the above example,
which was atomically read.

	Arnd
