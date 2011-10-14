Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab1JNRdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:33:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53001 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab1JNRdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:33:10 -0400
Date: Fri, 14 Oct 2011 10:33:04 -0700
From: Tejun Heo <tj@kernel.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Andrew Vagin <avagin@parallels.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [patch 5/5] elf: Add support for loading ET_CKPT files
Message-ID: <20111014173304.GD4294@google.com>
References: <20111014110416.552685686@openvz.org>
 <20111014110511.670174429@openvz.org>
 <20111014171033.GC4294@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111014171033.GC4294@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Fri, Oct 14, 2011 at 10:10:33AM -0700, Tejun Heo wrote:
> I see that you removed zapping to allow restoring multi-threaded
> process, which seems quite scary to me.  It might be okay, I don't
> know, but IMHO it just isn't a very good idea to introduce such
> variation to basic exec behavior for this rather narrow use case.

* It's still calling exec_mmap(), so the exec'ing thread will be on
  the new mm while other threads would still be on the old one.

* There are operations which assume that the calling task is
  de-threaded and thus has exclusive access to data structures which
  can be shared among the thread group (e.g. signal struct).  How are
  accesses to them synchronized?

* What about properties which should be reset and then shared by
  threads by inheriting (credentials, comm, self_exec_id and so on)?
  e.g. new thread follows exec-time imposed rules but old ones keep
  their original credentials.

So, no, it really doesn't look good.

Thanks.

-- 
tejun
