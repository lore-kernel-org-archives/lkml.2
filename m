Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465Ab0KZUZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 15:25:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33077 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab0KZUZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 15:25:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hugh Dickins <hughd@google.com>
Subject: Re: 2.6.35.5: hibernation broken... AGAIN
Date: Fri, 26 Nov 2010 21:24:22 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc3+; KDE/4.4.4; x86_64; ; )
Cc: Ondrej Zary <linux@rainbow-software.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@in.ibm.com>
References: <201011171139.33398.linux@rainbow-software.org> <201011172218.42053.linux@rainbow-software.org> <alpine.LSU.2.00.1011171531310.15942@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.1011171531310.15942@sister.anvils>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011262124.23029.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 18, 2010, Hugh Dickins wrote:
> On Wed, 17 Nov 2010, Ondrej Zary wrote:
> > On Wednesday 17 November 2010 22:12:01 Rafael J. Wysocki wrote:
> > > On Wednesday, November 17, 2010, Andrew Morton wrote:
> > > > On Wed, 17 Nov 2010 21:53:52 +0100
> > > > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > > > On Wednesday, November 17, 2010, Ondrej Zary wrote:
> > > > > > Hello,
> > > > > > the nasty memory-corrupting hibernation bug
> > > > > > https://bugzilla.kernel.org/show_bug.cgi?id=15753 is back since
> > > > > > 2.6.35.5. 2.6.35.4 works fine, 2.6.35.5 crashes after two days.
> 
> That's distressing, for both and all of us: I'm sorry.
> 
> > > > > >
> > > > > > It seems to be caused by b77c254d8d66e5e9aa81239fedba9f3d568097d9.
> > >
> > > > commit b77c254d8d66e5e9aa81239fedba9f3d568097d9
> > > > Author: Hugh Dickins <hughd@google.com>
> > > > Date:   Thu Sep 9 16:38:09 2010 -0700
> > > >
> > > >     swap: prevent reuse during hibernation
> 
> Embarrassing: I suspect that I've been confused, not for the first
> time, by the fork-like nature of hibernation and its images.
> I wonder if this patch below fixes it, Ondrej?
> 
> (And is it kernel swsusp or user swsusp that you're using?  May not
> matter at all, but will help us to think more clearly about it,
> if the corruption remains after this patch.)
> 
> Rafael, do you agree that this patch was actually required even for
> your original commit 452aa6999e6703ffbddd7f6ea124d3968915f3e3
> mm/pm: force GFP_NOIO during suspend/hibernation and resume?

(Sorry for the late response).

Well, not exactly.

First, IMO set_gfp_allowed_mask(saved_mask) should not be called before
dpm_resume_end(), because IO allocations may try to use suspended devices in
theory (although that's not likely due to the swsusp_free() before).  So the
right thing to do appears to be:

if (error || !in_suspend) {
  		swsusp_free();

dpm_resume_end(in_suspend ?
  		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);

if (error || !in_suspend)
  		set_gfp_allowed_mask(saved_mask);

resume_console();

Second, since we don't call set_gfp_allowed_mask(saved_mask) in the
(in_suspend && !error) case, hibernation_platform_enter() also should be
updated (I think we don't need to use set_gfp_allowed_mask() in it at all).

There's one more subtlety.  Namely, the saving of an image by s2disk
may be aborted and in that case we need to restore the original
gfp_allowed_mask too, but I need to look deeper into the code to see how to do
it cleanly.

Thanks,
Rafael
