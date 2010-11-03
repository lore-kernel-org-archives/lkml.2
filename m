Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384Ab0KCVTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 17:19:01 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:50470 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750883Ab0KCVS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 17:18:59 -0400
Date: Wed, 3 Nov 2010 22:18:55 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [GIT PULL] One more power management fix for 2.6.37
Message-ID: <20101103211855.GA29721@isilmar-3.linta.de>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <201010292358.27975.rjw@sisk.pl> <AANLkTikF+8VsxyjmXUc_6Epd923g5DCxneNArFNTGrZ_@mail.gmail.com> <201011030356.13878.rjw@sisk.pl> <AANLkTikHRGkTGjBHQPt7-__XEWLYKLcSZgeXgicwOv8H@mail.gmail.com> <AANLkTikrDoKDWPMtSjJ0EjKXO7ddQZPkZ5ZvwoivkbnZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikrDoKDWPMtSjJ0EjKXO7ddQZPkZ5ZvwoivkbnZ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There's apparently an ordering problem with dpm_list_mtx and
> socket->skt_mutex. Lockdep details appended.
> 
> Dominik, Rafael? What's the proper locking order here, and
> how do we fix this?

Thanks for noting this; let's see:

- We add a PCMCIA device holding skt_mutex, therefore we have the ordering
  (1) skt_mutex -> (2) dpm_list_mtx

- If we're suspending, dpm_list_mtx is held, but we need to acquire
  skt_mutex as we modify some data being protected by skt_mutex
  (1) dpm_list_mtx -> (2) skt_mutex

Rafael, any idea on how to solve this? How do other subsystems handle such
an issue? Do they call device_add() with no locks held at all?

Best,
	Dominik
