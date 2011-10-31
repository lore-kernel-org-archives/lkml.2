Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128Ab1JaJ5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 05:57:20 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:41693 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab1JaJ5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 05:57:19 -0400
Message-ID: <1320055036.2796.8.camel@br98xy6r>
Subject: Re: [PATCH] kdump: Fix crash_kexec - smp_send_stop race in panic
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, schwidefsky@de.ibm.com,
        Vivek Goyal <vgoyal@redhat.com>
Date: Mon, 31 Oct 2011 10:57:16 +0100
In-Reply-To: <20111028161143.e5ebf617.akpm@linux-foundation.org>
References: <1319639649.3321.11.camel@br98xy6r>
	 <20111028161143.e5ebf617.akpm@linux-foundation.org>
Organization: IBM
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

On Fri, 2011-10-28 at 16:11 -0700, Andrew Morton wrote:

[snip]

> Should this be done earlier in the function?  As it stands we'll have
> multiple CPUs scribbling on buf[] at the same time and all trying to
> print the same thing at the same time, dumping their stacks, etc. 
> Perhaps it would be better to single-thread all that stuff

My fist patch took the spinlock at the beginning of panic(). But then
Eric asked, if it wouldn't be better to get both panic printk's and I
agreed.

> Also...  this patch affects all CPU architectures, all configs, etc. 
> So we're expecting that every architecture's smp_send_stop() is able to
> stop a CPU which is spinning in spin_lock(), possibly with local
> interrupts disabled.  Will this work?

At least on s390 it will work. If there are architectures that can't
stop disabled CPUs then this problem is already there without this
patch.

Example:

1. 1st CPU gets lock X and panics
2. 2nd CPU is disabled and gets lock X
3. 1st CPU calls smp_send_stop()
   -> 2nd CPU loops disabled and can't be stopped

Michael


