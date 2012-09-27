Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab2I0Nl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 09:41:27 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:50186 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab2I0NlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 09:41:25 -0400
Date: Thu, 27 Sep 2012 15:41:10 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] sta2x11-mfd : add apb-soc regs driver and factor out common code
Message-ID: <20120927134110.GD6799@mail.gnudd.com>
References: <1347445374-32140-1-git-send-email-ciminaghi@gnudd.com> <1347445374-32140-2-git-send-email-ciminaghi@gnudd.com> <20120925192048.GA17038@sirena.org.uk> <20120926145615.GJ10147@mail.gnudd.com> <20120926150429.GQ4428@opensource.wolfsonmicro.com> <20120926163145.GK10147@mail.gnudd.com> <20120926164932.GS4428@opensource.wolfsonmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120926164932.GS4428@opensource.wolfsonmicro.com>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M >ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
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

after some cups of coffee, I tried thinking about this subject again, and
here's what I found:

as far as I know, nested locks are fine provided that you always take them in
the same order and release them in the opposite order (lock A, lock B,
unlock B, unlock A). So my conclusion is that nested spinlocks require
potential regmap users of sta2x11 registers to take the sta2x11-mfd spinlock
first. The pattern would be (sctl registers for instance):

spinlock_t *mfd_lock;
void *addr;

/* 
   Read sta2x11-mfd spinlock address for sctl registers and put it into
   mfd_lock
*/
sta2x11_mfd_get_regs_data(pdev, sta2x11_sctl, &addr, &mfd_lock);

......

/* Take the outer lock */
spin_lock(mfd_lock);
/* 
   Take the inner lock, do whatever you need to do and release the inner lock
*/
regmap_...();
/* Release the outer lock */
spin_unlock(mfd_lock);

The other way around (taking the regmap spinlock as the "outer" one)
would imply at least exporting the regmap spinlock/mutex address or making the
regmap.lock/unlock function pointers public somehow, not
to mention the fact that, for instance, the clock framework helpers should be
modified to deal with nested locking.

If the above is correct, I'm not sure we'd gain a lot from regmap,
because we'd still need some sta2x11 extra code around regmap calls.

Maybe there's another solution: what about adding a couple of function
pointers (lock, unlock) to struct regmap_config ? If they're set to NULL,
everything works as usual. If they're not NULL, regmap uses such functions
to do locking and unlocking instead of the usual ones (and regmap_bus.fast_io
is ignored). I think this wouldn't hurt existing regmap users and allow
sta2x11-mfd to have just one spinlock for everything, no need for nested
locking this way.

Thanks and regards
Davide
