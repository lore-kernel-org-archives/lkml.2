Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab1LQS6b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 13:58:31 -0500
Received: from d1.icnet.pl ([212.160.220.21]:57401 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab1LQS62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 13:58:28 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH] ARM: Fix cross compilation broken by failing size command
Date: Sat, 17 Dec 2011 19:57:38 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20111214215815.GP32251@atomide.com> <201112171401.30635.jkrzyszt@tis.icnet.pl> <alpine.LFD.2.02.1112171109210.2907@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1112171109210.2907@xanadu.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112171957.38681.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 of December 2011 at 17:38:34, Nicolas Pitre wrote:
> On Sat, 17 Dec 2011, Janusz Krzysztofik wrote:
> 
> > On Saturday 17 of December 2011 at 11:57:37, Russell King - ARM Linux wrote:
> > > On Fri, Dec 16, 2011 at 11:42:26AM +0100, Janusz Krzysztofik wrote:
> > > > Unfortunately, I've already pushed that old version to the patch system
> > > > at http://www.arm.linux.org.uk/developer/patches/, which I know is not
> > > > a review system. Apparently, I was not patient enough, not waiting more
> > > > than a week with that regression fix for a single reply to my initial
> > > 
> > > I'll disagree with you there: this is not a regression fix.  A regression
> > > fix implies that it was something that worked before, a change happened
> > > to the kernel, and now it's broken.
> > > 
> > > That is not the case: a change happened to binutils
> > 
> > Not to mine, I'm still using the same version as before.
> > 
> > > which meant 'size'
> > > no longer parses foreign ELF formats. 
> > 
> > But 'size' was not there before v3.2-rc1! The problem has arised because 
> > arch/arm/boot/compress/Makefile, which belongs to the kernel sources, 
> > not to binutils you're trying to blame, was changed. The 'size' call was 
> > introduced into that Makefile, i.e. the file that belongs to the kernel 
> > sources, whithout taking care of what can happen if that command fails. 
> > And I was just lucky enough to find out it may fail in certains build 
> > environments, like mine.
> 
> OK let's stop arguing in circles please.
> 
> I introduced the call to 'size' so by definition I'm the one who broke 
> the build for you.

I don't care who broke it, this might happen to anyone, including me.

Now I see my fault was not examining the linux-arm-kernel archives a few 
months deep before submitting my patch, which was apparently a 
(independently developed) duplicate for the one already submitted by 
Thomas Weber 6 weeks earlier.

> However I don't have any problem using the native 'size' command with a 
> foreign architecture binary.  My binutils version is 2.21.51.0.6 on 
> X86-64.  And clearly I'm not alone in that situation otherwise we would 
> have been overwhelmed by complaints from a much bigger crowd by now.  So 
> your installation must be "special".

2.20.1.20100303 on X86-64 here, built with --enable-targets=all for a 
reason I'm not able to recall now.

> OTOH all cross-compiler installations I've seen had $(CROSS_COMPILE)size 
> available.  It is therefore well possible that Russell's cross compiler 
> installation is also "special".
> 
> Given that the build works for the vast majority of people now, there is 
> a risk that applying your first patch might break the build for more 
> people (currently only one known) than the number of people for whom 
> this is an improvement (currently only one known).

Tony already told me the same, and I came out with v2 as a solution.

> I suggested a simple fix for Russell's installation already:
> 
> 	ln -s size arm-linux-size
> 
> I don't know what is special about yours though, and maybe it is worth 
> investigating given that, as I said, you appear to be alone so far 
> having problems with the current Makefile which is rather intriguing.  
> If it is clear with references to facts (binutils release notes, etc.) 
> that the problem is something that will persist in the future then we 
> have a more solid basis for choosing either of your solutions.  
> Otherwise we can't call it a "regression" just yet.

After Tony's comments I changed my approach in that the core regression 
here was not calling the native 'size', but passing an additional 
argument to the linker without checking for its correctness first. The 
core problem was not a broken 'size', but a broken linker command after 
all. Broken 'size' consequences should be limited to at most making the 
change your patch was about ineffective, but not the whole compilation 
broken. That's what my v2 was about in the first place.

YMMV.

Thanks,
Janusz
