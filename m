Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab2FFEAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 00:00:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab2FFEAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 00:00:48 -0400
Date: Tue, 5 Jun 2012 21:01:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Rob Landley <rob@landley.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Michel Lespinasse <walken@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] remove no longer use of pdflush interface
Message-Id: <20120605210118.aa161171.akpm@linux-foundation.org>
In-Reply-To: <20120606032127.GA11121@kernel>
References: <1338888372-3555-1-git-send-email-liwp.linux@gmail.com>
	<20120605152845.8b633881.akpm@linux-foundation.org>
	<20120606032127.GA11121@kernel>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2012 11:21:27 +0800 Wanpeng Li <liwp.linux@gmail.com> wrote:

> >Secondly, this code will permit unprivileged users to flood the logs,
> >by repeatedly reading /proc/sys/vm/nr_pdflush_threads.  We try to avoid
> >this, as it is a form of denial-of-service attack.
> >
> >This is a bit hard to fix.  The typical way of addressing this is to
> >use printk_once(), so the message only appears once per boot.  But that
> >doesn't work for a generic function - we'd need to add one bit of state
> >to the ctl_table to do this.  We can of course do that, but it's not
> >obvious that it's _worth_ doing that just for handling obsolete
> >entries.
> >
> >So perhaps the solution is to give up on the generic proc_obsolete()
> >idea, and just add a handler specifically for nr_pdflush_threads, whcih
> >uses printk_once().
> 
> What about modify the generic proc_obsolete just to put the warning message into
> the buffer, then transfer to userspace, in order to users can see this warning.Do
> you think this is a better idea?

err, no.  That's deliberately corrupting the output of an existing
interface.  In response to this change userspace might crash, hand over
root privileges or tune to a porn channel.  Instead we should yield
a well-formed response such as "0" (or maybe non-zero, if a zero
response might be unexpected) and inform the system operator via
conventional means.  ie: syslog.  
