Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751193Ab0DJFPP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 01:15:15 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47190 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab0DJFPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 01:15:12 -0400
Date: Fri, 9 Apr 2010 22:15:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-04-05 - another RCU whinge (not network this time)
Message-ID: <20100410051504.GA2414@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <201004052336.o35NaeSE015814@imap1.linux-foundation.org>
 <6417.1270771048@localhost>
 <20100409231614.GE2421@linux.vnet.ibm.com>
 <10875.1270869752@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10875.1270869752@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 11:22:32PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 09 Apr 2010 16:16:14 PDT, "Paul E. McKenney" said:
> > On Thu, Apr 08, 2010 at 07:57:28PM -0400, Valdis.Kletnieks@vt.edu wrote:
> > > On Mon, 05 Apr 2010 16:09:45 PDT, akpm@linux-foundation.org said:
> > > > The mm-of-the-moment snapshot 2010-04-05-16-09 has been uploaded to
> > > > 
> > > >    http://userweb.kernel.org/~akpm/mmotm/
> > > 
> > > Hit another one.  I seem to be on a roll...
> > > 
> > > Seen in dmesg, happened near end of the initrd..
> > > 
> > > [   26.756864] 
> > > [   26.756866] ===================================================
> > > [   26.756869] [ INFO: suspicious rcu_dereference_check() usage. ]
> > > [   26.756871] ---------------------------------------------------
> > > [   26.756874] fs/proc/array.c:241 invoked rcu_dereference_check() without protection!
> > 
> > Color me confused.  I cloned James Toy's git repository at
> > git://zen-kernel.org/kernel/mmotm.git, and gitk claims that I am on tag
> > 2010-04-05-16-09, which matches the string above.  But when I look at
> > fs/proc/array.c near line 241, I see:
> 
> Andrew's -mm tree has 3 patches from Oleg Nesterov that hit that file, so the
> code is different from what you show. Color *me* confused why your clone of
> mmotm.git doesn't seem to contain them - I'm not sure how James Toy builds
> that git tree.  Perhaps the tag is applied before those patches are - the
> 'mm.patch' that updates the Makefile with the version is usually in the
> *middle* of the 'series' file.  What does HEAD of that tree look like?

Good point...  The last commit is branch "master" and tagged
2010-04-05-16-09, but the commit line is "Linux 2.6.34-rc3", which seems
unlikely to me.

> My tree has:
> 
> /* needs ->siglock or rcu_read_lock() */
> static void collect_sigign_sigcatch(struct task_struct *p, sigset_t *ign,
>                                     sigset_t *catch)
> {
>         struct sighand_struct *sighand = rcu_dereference(p->sighand);
> 
> And that rcu_dereference() does it.

Thank you!!!

> Oleg, looks like proc-make-collect_sigign_sigcatch-rcu-safe.patch is the
> offender here, it added the line that causes the whinge.

If collect_sigign_sigcatch() is OK to call by updaters as well as
readers, we need something like:

	struct sighand_struct *sighand;
	
	sighand = rcu_dereference_check(p->sighand,
					rcu_read_lock_held() ||
					lockdep_is_held(&???));

Where the "???" is replaced with whichever of the two locks is protecting
updates.  My guess would be the sighand lock, but I would not rely on
my guesses in this case.  ;-)

							Thanx, Paul
