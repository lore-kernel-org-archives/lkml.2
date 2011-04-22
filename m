Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab1DVAvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 20:51:00 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46544 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab1DVAu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 20:50:58 -0400
Date: Thu, 21 Apr 2011 17:50:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 14 (Call-traces: RCU/ACPI/WQ
 related?)
Message-ID: <20110422005046.GQ2235@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <BANLkTinq=mC9rs5R3U8FPLCp-GgCJris_g@mail.gmail.com>
 <BANLkTimT9OhHLL5NaPOP30MdiMfmmmEcyQ@mail.gmail.com>
 <BANLkTikVW9Z=WxD7=w9c=Z6kHO-Za2ru8A@mail.gmail.com>
 <20110414224411.GF2141@linux.vnet.ibm.com>
 <20110421050823.GA4487@linux.vnet.ibm.com>
 <BANLkTinFmG5GVq6D8+wq_89OPF8snsQ=Jw@mail.gmail.com>
 <BANLkTi=c=+JnU9dQsVhgjZbOtArhHQz+EQ@mail.gmail.com>
 <BANLkTimEWqBVdq8MWbjAAfXCLPQdiHkuNg@mail.gmail.com>
 <20110421142853.GA2235@linux.vnet.ibm.com>
 <BANLkTineNYTXffcNT59STsk5nkLhi=o-kA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTineNYTXffcNT59STsk5nkLhi=o-kA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Apr 21, 2011 at 04:47:31PM +0200, Sedat Dilek wrote:
> On Thu, Apr 21, 2011 at 4:28 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Thu, Apr 21, 2011 at 02:49:37PM +0200, Sedat Dilek wrote:
> >> On Thu, Apr 21, 2011 at 12:24 PM, Sedat Dilek
> >> <sedat.dilek@googlemail.com> wrote:

[ . . . ]

> >> Here the results from the 2nd-run (PREEMPT_RCU enabled).
> >
> > OK, and the grace periods clearly stopped advancing early on.
> >
> > Beyond that point, the per-CPU kthread is blocked, but RCU has some
> > work for it to do.  So someone has called invoke_rcu_cpu_kthread(),
> > but rcu_cpu_kthread() is still blocked.  I don't see a bug right
> > off-hand, but it is early in the morning for me, so I might easily
> > be missing something.
> >
> > Hmmm...
> >
> > The synchronization between these two assumes that the per-CPU
> > kthread is always bound to the respective CPU, so if was somehow
> > being migrated off, that might explain these results.
> >
> > I will add some more diagnostics, test them locally, then push
> > out an update.  Seem reasonable?
> >
> > And thank you again for the testing!!!
> 
> Ping me when you have new stuff for testing.
> Tomorrow (friday), here is public holiday and monday, too.
> So a looong weekend.

;-)

OK, I have a new sedat.2011.04.21a branch in the -rcu git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git

This is against 2.6.39-rc3, as before.  (Yes, I do need to rebase to
2.6.39-rc4, but didn't want to change any more than I had to.)

I also have an updated script, which is attached.  The output is similar
to the earlier one, and it operated is pretty much the same way.

Have a great weekend, and I look forward to seeing what shows up on
this round.  I confess to still being quite puzzled!

							Thanx, Paul

--Kj7319i9nmIyA2yE
Content-Type: application/x-sh
Content-Description: collectdebugfs.sh
Content-Disposition: attachment; filename="collectdebugfs.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/sh=0A#=0A# Collect RCU-related debugfs data.  Set DEBUGFS_MP to the =
debugfs=0A# mount point, defaults to /sys/kernel/debug.=0A#=0A# This progra=
m is free software; you can redistribute it and/or modify=0A# it under the =
terms of the GNU General Public License as published by=0A# the Free Softwa=
re Foundation; either version 2 of the License, or=0A# (at your option) any=
 later version.=0A#=0A# This program is distributed in the hope that it wil=
l be useful,=0A# but WITHOUT ANY WARRANTY; without even the implied warrant=
y of=0A# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the=0A# =
GNU General Public License for more details.=0A#=0A# You should have receiv=
ed a copy of the GNU General Public License=0A# along with this program; if=
 not, write to the Free Software=0A# Foundation, Inc., 59 Temple Place - Su=
ite 330, Boston, MA 02111-1307, USA.=0A#=0A# Copyright (C) IBM Corporation,=
 2010=0A#=0A# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>=0A=0AD=
EBUGFS_MP=3D/sys/kernel/debug=0ADRCU=3D$DEBUGFS_MP/rcu=0A=0Awhile :=0Ado=0A=
	date=0A	echo $DRCU/rcugp:=0A	cat $DRCU/rcugp || echo no $DRCU/rcugp=0A	ech=
o $DRCU/rcuhier:=0A	cat $DRCU/rcuhier || echo no $DRCU/rcuhier=0A	echo $DRC=
U/rcudata:=0A	cat $DRCU/rcudata || echo no $DRCU/rcudata=0A	echo $DRCU/rcu_=
pending:=0A	cat $DRCU/rcu_pending || echo no $DRCU/rcu_pending=0A	echo $DRC=
U/rcutorture:=0A	cat $DRCU/rcutorture || echo no $DRCU/rcutorture=0A	echo $=
DRCU/rcuboost:=0A	cat $DRCU/rcuboost || echo no $DRCU/rcuboost=0A	ps -eo cl=
ass,sched,rtprio,stat,state,sgi_p,cmd | grep '\[rcuc[0-9]'=0A	ps -eo class,=
sched,rtprio,stat,state,sgi_p,cmd | grep '\[rcun[0-9]'=0A	ps -eo class,sche=
d,rtprio,stat,state,sgi_p,cmd | grep '\[rcub[0-9]'=0A	echo=0A	sleep 15=0Ado=
ne=0A
--Kj7319i9nmIyA2yE--
