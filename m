Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab0DJDXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 23:23:10 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57063 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab0DJDXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 23:23:05 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: paulmck@linux.vnet.ibm.com, Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-04-05 - another RCU whinge (not network this time)
In-Reply-To: Your message of "Fri, 09 Apr 2010 16:16:14 PDT."
             <20100409231614.GE2421@linux.vnet.ibm.com>
From: Valdis.Kletnieks@vt.edu
References: <201004052336.o35NaeSE015814@imap1.linux-foundation.org> <6417.1270771048@localhost>
            <20100409231614.GE2421@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1270869752_5034P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 09 Apr 2010 23:22:32 -0400
Message-ID: <10875.1270869752@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020206.4BBFEEF9.0080,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1270869752_5034P
Content-Type: text/plain; charset=us-ascii

On Fri, 09 Apr 2010 16:16:14 PDT, "Paul E. McKenney" said:
> On Thu, Apr 08, 2010 at 07:57:28PM -0400, Valdis.Kletnieks@vt.edu wrote:
> > On Mon, 05 Apr 2010 16:09:45 PDT, akpm@linux-foundation.org said:
> > > The mm-of-the-moment snapshot 2010-04-05-16-09 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > Hit another one.  I seem to be on a roll...
> > 
> > Seen in dmesg, happened near end of the initrd..
> > 
> > [   26.756864] 
> > [   26.756866] ===================================================
> > [   26.756869] [ INFO: suspicious rcu_dereference_check() usage. ]
> > [   26.756871] ---------------------------------------------------
> > [   26.756874] fs/proc/array.c:241 invoked rcu_dereference_check() without protection!
> 
> Color me confused.  I cloned James Toy's git repository at
> git://zen-kernel.org/kernel/mmotm.git, and gitk claims that I am on tag
> 2010-04-05-16-09, which matches the string above.  But when I look at
> fs/proc/array.c near line 241, I see:

Andrew's -mm tree has 3 patches from Oleg Nesterov that hit that file, so the
code is different from what you show. Color *me* confused why your clone of
mmotm.git doesn't seem to contain them - I'm not sure how James Toy builds
that git tree.  Perhaps the tag is applied before those patches are - the
'mm.patch' that updates the Makefile with the version is usually in the
*middle* of the 'series' file.  What does HEAD of that tree look like?

My tree has:

/* needs ->siglock or rcu_read_lock() */
static void collect_sigign_sigcatch(struct task_struct *p, sigset_t *ign,
                                    sigset_t *catch)
{
        struct sighand_struct *sighand = rcu_dereference(p->sighand);

And that rcu_dereference() does it.

Oleg, looks like proc-make-collect_sigign_sigcatch-rcu-safe.patch is the
offender here, it added the line that causes the whinge.



--==_Exmh_1270869752_5034P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLv+74cC3lWbTT17ARAqh/AKCW1uK+E0KtLcwU4lVX5ShDOxioEQCeKQJ/
RloJ1ISGi6Z4AKWjJtr4c6o=
=dP2w
-----END PGP SIGNATURE-----

--==_Exmh_1270869752_5034P--

