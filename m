Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab0IIFbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 01:31:33 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57240 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab0IIFb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 01:31:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Brad Spengler <spender@grsecurity.net>
Subject: Re: [PATCH 1/3] setup_arg_pages: diagnose excessive argument size
Cc: kosaki.motohiro@jp.fujitsu.com, Roland McGrath <roland@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        linux-fsdevel@vger.kernel.org, pageexec@freemail.hu,
        "Brad Spengler <spender@grsecurity.net> Eugene Teo" 
	<eugene@redhat.com>
In-Reply-To: <20100908115728.GB11762@grsecurity.net>
References: <20100908023549.BFFA8401AF@magilla.sf.frob.com> <20100908115728.GB11762@grsecurity.net>
Message-Id: <20100909141534.C948.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  9 Sep 2010 14:31:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I still don't think this addresses the whole problem.  Without question,
> the rlimit / 4 check is bogus.  If nobody agrees with the intent of that 
> check, then it should be removed, but I think the better solution is to 
> fix the check so that it matches its original intent: let the initial 
> stack setup be up to 1/Xth of the min(rlimit, TASK_SIZE dependent upon 
> personality), which allows space for additional stack setup in the ELF 
> loader and then further growth once the process is live.  If that 
> amount is overstepped, then the exec will return an error to the calling 
> process instead of being terminated.
> 
> It might be useful to consult with the people who introduced/approved 
> the check in the first place, as they seemed to have reasons for 
> implementing it.

Brad, sorry, I have bad news. glibc sysconf(_SC_ARG_MAX) is implemented
by hard coded RLIMIT_STACK/4 heuristics. That said, at least _now_, we
can't change this even though you disliked. That said, we can't break
userland even though userland library is very crazy.

I don't dislike your "1/Xth of the min(rlimit, TASK_SIZE dependent upon 
> personality)" idea. however I think You and Roland haven't agreed this
point yet. he seems to want "unlimited" works as "unlimited". then, now
I don't make such patch. Instead, I would propose to insert 
__vm_enough_memory() check in execve() pass. It prevent almost argv attack.



