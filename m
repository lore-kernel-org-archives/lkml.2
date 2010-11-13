Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab0KMKCb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 05:02:31 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57742 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab0KMKC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 05:02:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Xdlrpn3MIB+cEJZBuc16JFcsPJZuzknmEnsqyXXvahnOOJrVCKMl0hQWeIxjPLHqZi
         ndt1K6SJxMvQOeIURusBz8DXnm3eTddW7KDyhNbMErePNdc5FA4WhnrM9xDOry2u/gTE
         ZSSfQn1dSrsDBHafhKrO387ws++MO7LsRa0eo=
Date: Sat, 13 Nov 2010 18:05:27 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 03/20] x86/ticketlock: Use C for __ticket_spin_unlock
Message-ID: <20101113100527.GG3837@hack>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com> <20092775a9df07a5a75820ac250194b535279d51.1288794124.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20092775a9df07a5a75820ac250194b535279d51.1288794124.git.jeremy.fitzhardinge@citrix.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 10:59:44AM -0400, Jeremy Fitzhardinge wrote:
>  * On PPro SMP or if we are using OOSTORE, we use a locked operation to unlock
>  * (PPro errata 66, 92)
>  */
>-# define UNLOCK_LOCK_PREFIX LOCK_PREFIX
>+static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
>+{
>+	if (sizeof(lock->tickets.head) == sizeof(u8))
>+		asm (LOCK_PREFIX "incb %0"
>+		     : "+m" (lock->tickets.head) : : "memory");
>+	else
>+		asm (LOCK_PREFIX "incw %0"
>+		     : "+m" (lock->tickets.head) : : "memory");

This 'if/else' really should be done with #ifdef, even though
the compiler may be smart enough to remove it.

>+
>+}
> #else
>-# define UNLOCK_LOCK_PREFIX
>+static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
>+{
>+	barrier();
>+	lock->tickets.head++;
>+	barrier();

The second barrier() is not needed.

Thanks.
