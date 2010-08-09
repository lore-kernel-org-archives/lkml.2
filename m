Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab0HIMrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 08:47:53 -0400
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:35470 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab0HIMrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 08:47:51 -0400
Date: Mon, 9 Aug 2010 14:47:41 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, john stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Joonwoo Park <joonwpark81@gmail.com>
Message-ID: <20100809124741.GC20272@gundam.enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
	john stultz <johnstul@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>, Joonwoo Park <joonwpark81@gmail.com>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su> <244e91439eeb1c835b6fa82999fcd65a8a282183.1280952801.git.lasaine@lvk.cs.msu.su> <20100805093236.GI26615@gundam.enneenne.com> <20100805154231.52555130@desktopvm.lvknet> <20100805123147.GA19407@gundam.enneenne.com> <20100809115343.122c4f2c@desktopvm.lvknet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100809115343.122c4f2c@desktopvm.lvknet>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCHv3 05/16] pps: access pps device by direct pointer
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 11:53:43AM +0400, Alexander Gordeev wrote:
> 
> Hmm, yes, I see...
> But this is custom problem of only one client. I think it should be
> fixed in place instead of trying to fix it in the subsystem.

I agree with you but I had no luck in doing it in the past... :'(

Maybe you can ask some help to the serial port maintainers or you can
try in pushing the PPS_IRQ_EVENTS solution (see my repository) into
main tree, in fact that solution could resolve two problems at once:

* this one, since we simply read PPS data into an array in RAM, and
* the weak PPS resolution in recording PPS timestamps into normal IRQ
* handlers.

However, the big issue on this solution is about the call of
gettimeofday() for each IRQs into the system (see old mails into this
list about this topic) which slows down the machine's performance.

A workaround (as suggested by Alan Cox if I well remember) could be
adding a flag for each IRQs in order to know if the timestamp must be
recorded or not (testing a flag is not a bit issue for the machine's
performance).

> Are you 100% sure dcd_change can be called before open or after close?
> Then I'll try to deal with this.

Before the open there are no problems since the line discipline is
off, the problem is during the close.

> > > affects performance. So we have to choose what is the priority:
> > > security or performance. My guru told me I shouldn't bother too much
> > > about broken kernel-space code which my code interacts with. If it's
> > > broken it should be fixed. Some assertions enabled by DEBUG define are
> > > enough. For me it makes sense but I don't know what should I check here?
> > 
> > I'm sorry but I disagree with you. Kernel code can't allow userland
> > programs to corrupt it!
> > 
> > We are not discussing about security or performance but about
> > reliability.
> 
> Sure, now I see the problem (in the pps-ldisc).

Yes, the problem is there (and globally in all drivers whose not
directly take care off PPS issues). Unluckely the pps-ldisc is the
most currently used by PPS users...

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
