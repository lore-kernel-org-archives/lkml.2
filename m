Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab1IWXSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 19:18:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47382 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1IWXSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 19:18:12 -0400
Date: Fri, 23 Sep 2011 17:18:08 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Valdis.Kletnieks@vt.edu
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Dilan Lee <dilee@nvidia.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC PATCH v3] drivercore: Add driver probe deferral mechanism
Message-ID: <20110923231808.GF24631@ponder.secretlab.ca>
References: <20110922184614.25419.84606.stgit@ponder>
 <20110922212909.49966cf4@lxorguk.ukuu.org.uk>
 <CACxGe6vAQ+_SKc-zH434bdd3akM5S1jB0N7+AFEjgZfX1uNrZQ@mail.gmail.com>
 <7790.1316800223@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7790.1316800223@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 01:50:23PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 22 Sep 2011 15:19:01 MDT, Grant Likely said:
> > On Thu, Sep 22, 2011 at 2:29 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > Definitely what is needed for some of the x86 SoC stuff and would let us
> > > rip out some of the special case magic for the SCU discovery.
> > >
> > > First thing that strikes me is driver_bound kicks the processing queue
> > > again. That seems odd - surely this isn't needed because any driver that
> > > does initialise this time and may allow something else to get going will
> > > queue the kick itself. Thus this seems to just add overhead.
> > >
> > > It all looks a bit O(N²) if we don't expect the drivers that might
> > > trigger something else binding to just say 'hey I'm one of the
> > > troublemakers'
> > 
> > The way I read it, absolute worst case is when every device but one
> > depends on another device.  In that case I believe it will be
> > O(Nlog(N)).  (Every device gets probed on the first pass, but only the
> > last one gets probed.  Then it goes through N-1 devices to the result
> > of only 1 more device getting probed, then N-2, etc.). 
> 
> That is indeed O(N**2) not Nlog(N).  The total number of probes is (N+1)(N)/2
> To get it to O(Nlog(N)), you'd have to probe N devices the first pass, N/2 devices
> on the second pass, N/4 on the third, and so on.
> 

Ah, indeed, you are correct.  It's been too long since my engineering
CS class.

Still, I'm not even remotely worried about this algorithm for the
kernel.  The complexity is bounded by the number of levels of
dependencies, not the number of devices requesting deferral.  I'd be
very surprised if the nested dependencies ever get to half a dozen.

Note: these are only dependencies outside of the existing
parent-child dependencies in the Linux device model, which further
reduces the number of sources of nesting.

g.
