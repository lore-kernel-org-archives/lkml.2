Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab0KDG1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 02:27:15 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:45668 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755104Ab0KDG1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 02:27:13 -0400
Date: Thu, 4 Nov 2010 07:27:09 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [GIT PULL] One more power management fix for 2.6.37
Message-ID: <20101104062709.GA3118@isilmar-3.linta.de>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <201010292358.27975.rjw@sisk.pl> <AANLkTikrDoKDWPMtSjJ0EjKXO7ddQZPkZ5ZvwoivkbnZ@mail.gmail.com> <20101103211855.GA29721@isilmar-3.linta.de> <201011040604.05183.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011040604.05183.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 06:04:05AM +0100, Rafael J. Wysocki wrote:
> On Wednesday, November 03, 2010, Dominik Brodowski wrote:
> > > There's apparently an ordering problem with dpm_list_mtx and
> > > socket->skt_mutex. Lockdep details appended.
> > > 
> > > Dominik, Rafael? What's the proper locking order here, and
> > > how do we fix this?
> > 
> > Thanks for noting this; let's see:
> > 
> > - We add a PCMCIA device holding skt_mutex, therefore we have the ordering
> >   (1) skt_mutex -> (2) dpm_list_mtx
> > 
> > - If we're suspending, dpm_list_mtx is held, but we need to acquire
> >   skt_mutex as we modify some data being protected by skt_mutex
> >   (1) dpm_list_mtx -> (2) skt_mutex
> > 
> > Rafael, any idea on how to solve this? How do other subsystems handle such
> > an issue? Do they call device_add() with no locks held at all?
> 
> They usually do from what I can tell.
> 
> Also only a few of them implement the ->suspend_noirq() callback, which is the
> one executed under dpm_list_mtx.
> 
> What exactly is protected by skt_mutex ?

e.g.
struct pcmcia_socket {
	...
        u_int                   suspended_state;
        int                     resume_status;
	...
}

Furthermore, one has to acquire skt_mutex first before obtaining ops_mutex,
which protects many more fields (and asserts exclusion for some code paths),
see Documentation/pcmcia/locking.txt for details.

Best,
	Dominik
