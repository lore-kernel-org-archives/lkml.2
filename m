Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab1GOOOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 10:14:39 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.65.40]:33706 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab1GOOOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 10:14:37 -0400
X-Greylist: delayed 955 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jul 2011 10:14:36 EDT
Subject: Re: [kernel-hardening] Re: [PATCH] move RLIMIT_NPROC check from
 set_user() to do_execve_common()
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: NeilBrown <neilb@suse.de>, kernel-hardening@lists.openwall.com,
        Solar Designer <solar@openwall.com>, James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Eric Paris <eparis@redhat.com>, Willy Tarreau <w@1wt.eu>,
        Sebastian Krahmer <krahmer@suse.de>
In-Reply-To: <20110715073823.GA3821@albatros>
References: <20110713091408.0d456352@notabene.brown>
	 <20110713063142.GA19976@openwall.com>
	 <20110713170657.59dae548@notabene.brown>
	 <CA+55aFwQKqvNvzTMYXVW_yKkFtNsyv8uuBiWiwYLof-nPqPu9w@mail.gmail.com>
	 <alpine.LRH.2.00.1107141009510.17067@tundra.namei.org>
	 <20110714112751.1bfd998f@notabene.brown>
	 <20110714150602.GA30019@openwall.com>
	 <20110715133013.4fa38d19@notabene.brown> <20110715063113.GA3166@albatros>
	 <20110715170650.585f1dad@notabene.brown>  <20110715073823.GA3821@albatros>
Content-Type: text/plain; charset="UTF-8"
Organization: National Security Agency
Date: Fri, 15 Jul 2011 09:58:33 -0400
Message-ID: <1310738313.30257.27.camel@moss-pluto>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 11:38 +0400, Vasiliy Kulikov wrote:
> Neil,
> 
> On Fri, Jul 15, 2011 at 17:06 +1000, NeilBrown wrote:
> > How about this then?
> 
> AFAIU, with this patch:
> 
> 1) setuid() doesn't fail in NPROC exceed case.
> 2) NPROC is forced on execve() after setuid().
> 3) execve() fails only if NPROC was exceeded during setuid() execution.
> 4) Other processes of the same user doesn't suffer from "occasional"
> execve() failures.
> 
> If it is correct, then I like the patch :)  It does RLIMIT_NPROC
> enforcement without mixing other execve() calls like -ow patch did.

Does this have implications for Android's zygote model?  There you have
a long running uid 0 / all caps process (the zygote), which forks itself
upon receiving a request to spawn an app and then calls setgroups();
setrlimit(); setgid(); setuid(); assuming the limits and credentials of
the app but never does an exec at all, as it is just loading the app's
class and executing it from memory.

Also, can't setuid() fail under other conditions, e.g. ENOMEM upon
prepare_creds() allocation failure?  Is it ever reasonable for a program
to not check setuid() for failure?  Certainly there are plenty of
examples of programs not doing that, but it isn't clear that this is a
bug in the kernel.

-- 
Stephen Smalley
National Security Agency

