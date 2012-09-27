Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2I0Ijw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:39:52 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:40204 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab2I0Ijs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:39:48 -0400
Date: Thu, 27 Sep 2012 10:39:32 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] sta2x11-mfd : add apb-soc regs driver and factor out common code
Message-ID: <20120927083932.GA6799@mail.gnudd.com>
References: <1347445374-32140-1-git-send-email-ciminaghi@gnudd.com> <1347445374-32140-2-git-send-email-ciminaghi@gnudd.com> <20120925192048.GA17038@sirena.org.uk> <20120926145615.GJ10147@mail.gnudd.com> <20120926150429.GQ4428@opensource.wolfsonmicro.com> <20120926163145.GK10147@mail.gnudd.com> <20120926164932.GS4428@opensource.wolfsonmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120926164932.GS4428@opensource.wolfsonmicro.com>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M
	>ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 05:49:33PM +0100, Mark Brown wrote:
> On Wed, Sep 26, 2012 at 06:31:45PM +0200, Davide Ciminaghi wrote:
> 
> > Oh, and there's another problem (I'm looking at the code right now, I had
> > forgotten about this): the clock framework also asks for a spinlock_t *.
> > Regmap has its own spinlock (or mutex), and I don't think it would be a
> > good idea trying to export it.
> 
> Why is this a problem?  Nested spinlocks are perfectly fine.

sorry, maybe my understanding of regmap is poor, but the problem I see is
that the regmap spinlock belongs to struct regmap, which is defined in
drivers/regmap/internal.h, so it is not visible to the caller(s)
(sta2x11-mfd in this case). My interpretation is that the reason for hiding
struct regmap (and the spinlock as a consequence) has to do with what
object-oriented people call "information hiding", so exporting the spinlock
address would somehow break the design.
We could add some regmap_get_lock_address() and read the spinlock
address from sta2x11-mfd, but then to be generic we should keep into account
that a mutex could be used by some bus, so the function prototype could for
example look like this:

void regmap_get_lock_address(struct regmap *, spinlock_t *s, struct mutex *m);

so, if a spinlock is used s would be filled with the spinlock's address (and
m set to NULL), while if a mutex is used, m would be set to the address of
the mutex (and s set to NULL). My personal opinion is that introducing 
such a function would expose too many implementation details to regmap
users, but if you think it is ok, this solution would of course be very simple.


Thanks
Davide
