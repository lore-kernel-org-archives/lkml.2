Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375Ab0HMIpd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 04:45:33 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:8112 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755902Ab0HMIpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 04:45:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19557.1573.852727.108838@pilspetsen.it.uu.se>
Date: Fri, 13 Aug 2010 10:45:25 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        John Stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem with commit deda2e81961e96be4f2c09328baca4710a2fd1a0
In-Reply-To: <4C645C7D.1050903@lwfinger.net>
References: <4C64571F.6000606@lwfinger.net>
	<AANLkTi==5umTtLWSoLfLPjHYAVpnPNHN-uzq7q2t-nfr@mail.gmail.com>
	<4C645C7D.1050903@lwfinger.net>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger writes:
 > On 08/12/2010 03:26 PM, Linus Torvalds wrote:
 > > On Thu, Aug 12, 2010 at 1:18 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
 > >>
 > >> With the above commit, building an i386 version of the kernel results in the
 > >> following from the build:
 > >>
 > >> kernel/built-in.o: In function `logarithmic_accumulation':
 > >> /home/finger/linux-realtek/kernel/time/timekeeping.c:715: undefined reference to
 > >> `__umoddi3'
 > >> /home/finger/linux-realtek/kernel/time/timekeeping.c:715: undefined reference to
 > >> `__udivdi3'
 > >> make: *** [.tmp_vmlinux1] Error 1
 > >>
 > >> Reverting the patch allows the system to build correctly.
 > > 
 > > Damn. It's your compiler turning a while-loop into a divide. Which
 > > likely isn't even an optimization, but whatever.
 > > 
 > > John: I think that while-loop needs to be something like
 > > 
 > >    if (raw_nsecs >= NSEC_PER_SEC) {
 > >       u64 raw_secs = raw_nsecs;
 > >       raw_nsecs = do_div(raw_secs, NSEC_PER_SEC);
 > >       raw_time.tv_sec += taw_secs;
 > >   }
 > >   raw_time.tc_nsec = raw_nsecs;
 > > 
 > > which is sad and overly complicated, but the simple thing seems to get
 > > messed up by the compiler.
 > > 
 > > Untested. Maybe I got the complex do_div() semantics wrong. Somebody
 > > needs to check.
 > 
 > I'll try it. The system with the problem has gcc (SUSE Linux) 4.3.2
 > [gcc-4_3-branch revision 141291]. That is on a 64-bit system cross compiling
 > with ARCH=i386.
 > 
 > The real 32-bit system with gcc (SUSE Linux) 4.5.0 20100604 [gcc-4_5-branch
 > revision 160292] builds OK. It just wasn't finished when I wrote the first message.

The loops-turns-into-div is a known bug in early gcc-4.3 releases,
possibly only with -Os.  It's fixed in 4.4 and 4.3.latest.  I can
probably dig up the gcc PR number if needed.

/Mikael
