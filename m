Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933712Ab1JaKgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 06:36:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932598Ab1JaKgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 06:36:04 -0400
Date: Mon, 31 Oct 2011 03:39:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: holzheu@linux.vnet.ibm.com
Cc: heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, schwidefsky@de.ibm.com,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] kdump: Fix crash_kexec - smp_send_stop race in panic
Message-Id: <20111031033948.a0edb7f3.akpm@linux-foundation.org>
In-Reply-To: <1320055036.2796.8.camel@br98xy6r>
References: <1319639649.3321.11.camel@br98xy6r>
	<20111028161143.e5ebf617.akpm@linux-foundation.org>
	<1320055036.2796.8.camel@br98xy6r>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Oct 2011 10:57:16 +0100 Michael Holzheu <holzheu@linux.vnet.ibm.com> wrote:

> > Should this be done earlier in the function?  As it stands we'll have
> > multiple CPUs scribbling on buf[] at the same time and all trying to
> > print the same thing at the same time, dumping their stacks, etc. 
> > Perhaps it would be better to single-thread all that stuff
> 
> My fist patch took the spinlock at the beginning of panic(). But then
> Eric asked, if it wouldn't be better to get both panic printk's and I
> agreed.

Hm, why?  It will make a big mess.

> > Also...  this patch affects all CPU architectures, all configs, etc. 
> > So we're expecting that every architecture's smp_send_stop() is able to
> > stop a CPU which is spinning in spin_lock(), possibly with local
> > interrupts disabled.  Will this work?
> 
> At least on s390 it will work. If there are architectures that can't
> stop disabled CPUs then this problem is already there without this
> patch.
> 
> Example:
> 
> 1. 1st CPU gets lock X and panics
> 2. 2nd CPU is disabled and gets lock X

(irq-disabled)

> 3. 1st CPU calls smp_send_stop()
>    -> 2nd CPU loops disabled and can't be stopped

Well OK.  Maybe some architectures do have this problem - who would
notice?  If that is the case, we just made the failure cases much more
common.  Could you check, please?

