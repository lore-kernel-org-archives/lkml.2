Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab0FWUHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 16:07:47 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:56439 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751520Ab0FWUHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 16:07:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Xe8UctdCeOLBS7OE5tkuExK/OV71li9QHltVzjJ+OWSelm6vlBcN6BcgdH1kYrmqQeRAzFnshcAo9FMc2IWbe1Bpx7w7+2KADQjMgaIPJZh4xKfm53uSbz2oucATtx1O;
Date: Wed, 23 Jun 2010 13:05:47 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Airlie <airlied@gmail.com>, linux-fbdev@vger.kernel.org,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt/console: try harder to print output when panicing
Message-ID: <20100623130547.296e00a7@virtuousgeek.org>
In-Reply-To: <20100623125605.5f56f6ba.akpm@linux-foundation.org>
References: <1277262779-19338-1-git-send-email-airlied@gmail.com>
	<20100623125605.5f56f6ba.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jun 2010 12:56:05 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 23 Jun 2010 13:12:59 +1000
> Dave Airlie <airlied@gmail.com> wrote:
> 
> > Jesse's initial patch commit said:
> > 
> > "At panic time (i.e. when oops_in_progress is set) we should try a bit
> > harder to update the screen and make sure output gets to the VT, since
> > some drivers are capable of flipping back to it.
> > 
> > So make sure we try to unblank and update the display if called from a
> > panic context."
> > 
> > I've enhanced this to add a flag to the vc that console layer can set
> > to indicate they want this behaviour to occur. This also adds support
> > to fbcon for that flag and adds an fb flag for drivers to indicate
> > they want to use the support. It enables this for KMS drivers.
> 
> Interesting.  Getting real oops traces from machines running X will
> make Rusty happy, and that's what we're all here for.
> 
> How well does this all work?  How reliable is it?  What's the success rate?
> 
> 
> 
> What's the downside here?  After all, not all oopses are catastrophic -
> sometimes the machine will go blurt and keep running so the user can
> take a look in the logs then perform an orderly reboot, etc.  As I
> understand it, those non-catastrophic oopses will now flip the machine
> from X and into the vt display, yes?  Can the user get it back to X
> mode?

No, we'll only flip from the panic notifier chain.  However if
oops_in_progress is set (as it is whenever bust_spinlocks(1) is called,
i.e. from panic() and oops_begin()) we'll try to print into the fbcon
buffer.  In the oops case this should still be safe since the buffer is
pinned, at least in the KMS world.

> Worse, there's also a risk that doing all this new work within the
> oopsing context will screw the machine up, so the user will be
> _deprived_ of an oops report which he otherwise would have been able to
> get from the logs.  This is particularly the case when it's the DRI
> stuff which oopsed, which is not exactly an uncommon occurrence lately ;)
> 
> Oh well, the best way to tell is to ship-it-and-see.

To avoid the oops part (which as I said should still be safe) we could
add a new panic_in_progress flag, that would make sure things were no
worse than they are currently.

-- 
Jesse Barnes, Intel Open Source Technology Center
