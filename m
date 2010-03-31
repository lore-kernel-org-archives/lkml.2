Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab0CaWLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 18:11:10 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:33786 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab0CaWLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 18:11:07 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANpks0urRN+J/2dsb2JhbACbOXGhUpkfhQAEgyM
X-IronPort-AV: E=Sophos;i="4.51,343,1267401600"; 
   d="scan'208";a="506323349"
From: Roland Dreier <rdreier@cisco.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
       jblunck@suse.de, Alan Cox <alan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
References: <201003242240.54907.arnd@arndb.de>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 31 Mar 2010 15:11:03 -0700
In-Reply-To: <201003242240.54907.arnd@arndb.de> (Arnd Bergmann's message of
	"Wed, 24 Mar 2010 22:40:54 +0100")
Message-ID: <adazl1ogn0o.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Looking at your tree, I see you have commit 753dd249 ("perf_event: use
nonseekable_open") that does:

 > --- a/kernel/perf_event.c
 > +++ b/kernel/perf_event.c
 > @@ -2515,6 +2515,8 @@ static int perf_fasync(int fd, struct file *filp, int on)
 >  }
 >  
 >  static const struct file_operations perf_fops = {
 > +       .open                   = nonseekable_open,
 > +       .llseek                 = no_llseek,
 >         .release                = perf_release,
 >         .read                   = perf_read,
 >         .poll                   = perf_poll,

But if I understand this correctly, the assignment to .open is at best
useless -- these file_operations are only used via anon_inode_getfd()
and so there is no possible path that can call the .open method.  Or am
I missing something?

(The same applies to the kvm_main.c changes too)
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
